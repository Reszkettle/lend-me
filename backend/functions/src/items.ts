import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Item} from "./models";

const firestore = admin.firestore();

export async function getItem(itemId: string): Promise<Item> {
  return (await firestore.collection("items").doc(itemId).get()).data() as Item;
}

export const onItemDeleteRemoveRelatedRecords = functions.firestore.document("items/{item}").onDelete( async (snapshot) => {
  const deletedItemId = snapshot.id;

  const rentalRefs = await getRentalRefsByItemId(deletedItemId);
  const requestRefs = await getRequestRefsByItemId(deletedItemId);

  const deletionBatch = firestore.batch();
  [...rentalRefs, ...requestRefs].forEach((ref) => deletionBatch.delete(ref));

  return deletionBatch.commit();
});

const getRentalRefsByItemId = async (itemId: string) => {
  return (await firestore.collection("rentals").where("itemId", "==", itemId).get()).docs.map((doc) => doc.ref);
};

const getRequestRefsByItemId = async (itemId: string) => {
  return (await firestore.collection("requests").where("itemId", "==", itemId).get()).docs.map((doc) => doc.ref);
};
