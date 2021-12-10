import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Item} from "./models";

const firestore = admin.firestore();

export async function getItem(itemId: string): Promise<Item> {
  return (await firestore.collection("items").doc(itemId).get()).data() as Item;
}

export const onItemDeleteRemoveRelatedRecords = functions.firestore.document("items/{item}").onDelete( async (snapshot) => {
  const deletedItemId = snapshot.id;
  await Promise.all([removeRequestsByItemId(deletedItemId), removeRentalsByItemId(deletedItemId)]);
});

const removeRentalsByItemId = async (itemId: string): Promise<void> => {
  (await firestore.collection("rentals").where("itemId", "==", itemId).get()).docs.forEach(async (doc) => {
    await doc.ref.delete();
  });
};

const removeRequestsByItemId = async (itemId: string): Promise<void> => {
  (await firestore.collection("requests").where("itemId", "==", itemId).get()).docs.forEach(async (doc) => {
    await doc.ref.delete();
  });
};
