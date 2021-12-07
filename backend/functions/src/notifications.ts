import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Request, User} from "./models";


const firestore = admin.firestore();
const messaging = admin.messaging();


export const onRequestUpdate = functions.firestore.document("requests/{requestId}").onUpdate(async (snapshot, context) => {
  const request: Request = snapshot.after.data() as Request;
  request.receivers.forEach(async (uid) => {
    const user = (await firestore.collection("users").doc(uid).get()).data() as User;
    const token = user.token;
    console.log(token);
    if (token != null) {
      sendNotification(token);
    }
  });
});


async function sendNotification(token: string) {
  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: "Title",
      body: "Body",
      sound: "default",
    },
    data: {
      clickAction: "FLUTTER_NOTIFICATION_CLICK",
    },
  };
  await messaging.sendToDevice(token, payload);
  console.log("Notification sent");
}
