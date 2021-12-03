import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const firestore = admin.firestore();

interface Params {
  requestId: string;
}

export const accept = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;
  if (uid == undefined) {
    throw new functions.https.HttpsError("unauthenticated", "User is not authenticated");
  }

  const params: Params = data;
  const requestId = params.requestId;

  await firestore.collection("experts").doc(uid).update(expertData);
});


async function acceptBorrow(_requestId: string) {
  console.log("Accepting borrow");
}

async function acceptExtend(_requestId: string) {
  console.log("Accepting borrow");
}

async function acceptTransfer(_requestId: string) {
  console.log("Accepting borrow");
}
