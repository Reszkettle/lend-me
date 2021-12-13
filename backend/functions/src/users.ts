import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const firestore = admin.firestore();
const auth = admin.auth();


export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  let firstName = null;
  let lastName = null;

  if (user.displayName != null) {
    const fullName = user.displayName;
    const parts = fullName.split(" ");
    firstName = parts.slice(0, -1).join(" ");
    if (parts.length > 1) {
      lastName = parts.slice(-1).join(" ");
    }
  }

  const userDocument = {
    avatarUrl: user.photoURL,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    info: {
      email: user.email,
      firstName: firstName,
      lastName: lastName,
      phone: user.phoneNumber,
    },
  };
  await firestore.collection("users").doc(user.uid).set(userDocument);
});


// It's really not so simple, temporary solution
export const onUserDeleted = functions.auth.user().onDelete(async (user) => {
  await firestore.collection("users").doc(user.uid).delete();
});


export const deleteAccount = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;
  if (uid == undefined) {
    throw new functions.https.HttpsError("unauthenticated", "User is not authenticated");
  }

  // Unable to delete account, user must return all items
  const itemsToReturn = await firestore.collection("rentals").where("borrowerId", "==", uid).where("status", "==", "pending").get();
  if (!itemsToReturn.empty) {
    return "failure";
  }

  // Delete items
  const itemsDocs = await firestore.collection("items").where("ownerId", "==", uid).get();
  itemsDocs.forEach(async (itemDoc) => await itemDoc.ref.delete());

  // Delete rentals
  const rentalsDocs1 = await firestore.collection("rentals").where("ownerId", "==", uid).get();
  const rentalsDocs2 = await firestore.collection("rentals").where("borrowerId", "==", uid).get();
  const rentals = [...rentalsDocs1.docs, ...rentalsDocs2.docs];
  rentals.forEach(async (rental) => await rental.ref.delete());

  // Delete requests
  const requestsDocs1 = await firestore.collection("requests").where("issuerId", "==", uid).get();
  requestsDocs1.forEach(async (request) => await request.ref.delete());
  const requestsDocs2 = await firestore.collection("requests").where("receivers", "array-contains", uid).get();
  requestsDocs2.forEach(async (request) => {
    request.ref.update({receivers: admin.firestore.FieldValue.arrayRemove(uid)});
  });

  // Delete account
  await auth.deleteUser(uid);

  // Delete user
  await firestore.collection("users").doc(uid).delete();

  return "success";
});
