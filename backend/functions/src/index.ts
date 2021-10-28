import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
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
    email: user.email,
    firstName: firstName,
    lastName: lastName,
    phone: user.phoneNumber,
  };
  await firestore.collection("users").doc(user.uid).set(userDocument);
});

// It's really not so simple, temporary solution
exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  await firestore.collection("users").doc(user.uid).delete();
});
