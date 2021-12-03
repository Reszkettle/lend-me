import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// Include functions from requests.ts
import * as requests from "./requests";
exports.requests = requests;

const firestore = admin.firestore();

exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
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
exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  await firestore.collection("users").doc(user.uid).delete();
});

/**
 * Trigger on rental created used to populate borrowerFullname and ownerFullname
 */
export const onRentalCreated = functions.firestore.document("rentals/{rental}").onCreate(async (snapshot) => {
  const rentalData = snapshot.data();
  const borrowerId = rentalData["borrowerId"];
  const ownerId = rentalData["ownerId"];

  const borrowerData = (
    await firestore.collection("users").doc(borrowerId).get()
  ).data();

  if (borrowerData == null) {
    return;
  }

  const ownerData = (await firestore.collection("users").doc(ownerId).get()).data();

  if (ownerData == null) {
    return;
  }

  const borrowerFullname = `${borrowerData["info"]["firstName"]} ${borrowerData["info"]["lastName"]}`;
  const ownerFullname = `${ownerData["info"]["firstName"]} ${ownerData["info"]["lastName"]}`;

  return snapshot.ref.update({borrowerFullname, ownerFullname});
});
