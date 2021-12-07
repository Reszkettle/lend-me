import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Item, Request, User} from "./models";


const firestore = admin.firestore();
const messaging = admin.messaging();


export const onRequestCreate = functions.firestore.document("requests/{requestId}").onCreate(async (_snapshot, context) => {
  sendNewRequestNotifications(context.params.requestId);
});


export async function sendNewRequestNotifications(requestId: string): Promise<void> {
  const request = (await firestore.collection("requests").doc(requestId).get()).data() as Request;
  const item = (await firestore.collection("items").doc(request.itemId).get()).data() as Item;

  const title = `New ${request.type} request`;
  const subtitle = `Item: "${item.title}"`;

  await sendNotification(item.ownerId, requestId, title, subtitle);
}


export async function sendStateChangeNotifications(requestId: string): Promise<void> {
  const request = (await firestore.collection("requests").doc(requestId).get()).data() as Request;

  if (request == null) {
    throw new functions.https.HttpsError("not-found", "Request with given id doesn't exist");
  }

  const item = (await firestore.collection("items").doc(request.itemId).get()).data() as Item;

  const title = `${request.title} - ${request.status}`;
  const subtitle = `Item: "${item.title}"`;

  sendNotification(request.issuerId, requestId, title, subtitle);
}


async function sendNotification(uid: string, requestId: string, title: string, body: string) {
  const user = (await firestore.collection("users").doc(uid).get()).data() as User;
  const token = user.token;

  if (token == null) {
    console.log("User without token");
    return;
  }

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title,
      body,
      sound: "default",
    },
    data: {
      clickAction: "FLUTTER_NOTIFICATION_CLICK",
      requestId: requestId,
    },
  };
  await messaging.sendToDevice(token, payload);
  console.log("Notification sent");
}
