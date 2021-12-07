import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Request, RequestUpdate, Item, RequestOperation, RequestStatus, RentalUpdate, RequestType} from "./models";
import {getItem} from "./items";

const firestore = admin.firestore();


export const accept = functions.https.onCall(async (data, context) => {
  await acceptOrReject(data, context, "accept");
});


export const reject = functions.https.onCall(async (data, context) => {
  await acceptOrReject(data, context, "reject");
});


interface Params {
  requestId: string;
  message: string | null;
}


async function acceptOrReject(data: any, context: functions.https.CallableContext, operation: RequestOperation) {
  const uid = context.auth?.uid;
  if (uid == undefined) {
    throw new functions.https.HttpsError("unauthenticated", "User is not authenticated");
  }

  const params: Params = data;
  const requestId = params.requestId;
  const message = params.message;

  if (operation == "accept") {
    await acceptRequest(requestId, uid, message);
  } else if (operation == "reject") {
    await rejectRequest(requestId, uid, message);
  }
}


async function acceptRequest(requestId: string, uid: string, message: string | null = null) {
  const request = (await firestore.collection("requests").doc(requestId).get()).data() as Request;

  if (request == null) {
    throw new functions.https.HttpsError("not-found", "Request with given id doesn't exist");
  }

  const item = (await firestore.collection("items").doc(request.itemId).get()).data() as Item;

  if (item == null) {
    throw new functions.https.HttpsError("not-found", "Item associated with request not found");
  }

  if (item.ownerId != uid) {
    throw new functions.https.HttpsError("permission-denied", "No permission to accept request");
  }

  if (request.type == "borrow") {
    await acceptBorrow(request, item, uid);
  } else if (request.type == "extend") {
    await acceptExtend(request, uid);
  } else if (request.type == "transfer") {
    await acceptTransfer(request, item, uid);
  }

  updateStatusAndMessage(requestId, "accepted", message);
  await rejectConflictingRequests(requestId, uid);
}


async function acceptBorrow(request: Request, item: Item, _uid: string) {
  await createNewRental(request.itemId, request.issuerId, item.ownerId, request.endDate);
  console.log("Borrow request accepted");
}


async function acceptExtend(request: Request, _uid: string) {
  const pendingRentalsId = await getPendingRentalsId(request.itemId);
  if (pendingRentalsId.length > 1) {
    throw new functions.https.HttpsError(
        "internal", "Multiple pending rentals found for this item");
  }
  if (pendingRentalsId.length == 0) {
    throw new functions.https.HttpsError(
        "internal", "Unable to extend time, because no pending rental found");
  }
  const pendingRentalId = pendingRentalsId[0];

  const rentalUpdate: Partial<RentalUpdate> = {
    endDate: request.endDate,
  };
  await firestore.collection("rentals").doc(pendingRentalId).update(rentalUpdate);
  console.log("Extend request accepted");
}


async function acceptTransfer(request: Request, item: Item, _uid: string) {
  await finishPendingRentals(request.itemId);
  await createNewRental(request.itemId, request.issuerId, item.ownerId, request.endDate);
  console.log("Transfer request accepted");
}


async function getPendingRentalsId(itemId: string): Promise<Array<string>> {
  const rentalsIds = (await firestore.collection("rentals")
      .where("itemId", "==", itemId)
      .where("status", "==", "pending")
      .get()).docs.map((it)=>it.id);
  return rentalsIds;
}


async function finishPendingRentals(itemId: string) {
  const rentalsIds = await getPendingRentalsId(itemId);
  rentalsIds.forEach((rentalId) => finishRental(rentalId));
}


async function finishRental(rentalId: string) {
  const rentalUpdate: Partial<RentalUpdate> = {
    status: "finished",
  };
  await firestore.collection("rentals").doc(rentalId).update(rentalUpdate);
}


async function createNewRental(itemId: string, borrowerId: string, ownerId: string,
    endDate: admin.firestore.Timestamp) {
  const newRental: RentalUpdate = {
    itemId: itemId,
    borrowerId: borrowerId,
    ownerId: ownerId,
    startDate: admin.firestore.FieldValue.serverTimestamp(),
    endDate: endDate,
    status: "pending",
    ownerFullname: null,
    borrowerFullname: null,
  };
  await firestore.collection("rentals").add(newRental);
}


async function rejectRequest(requestId: string, uid: string, message: string | null = null) {
  const request = (await firestore.collection("requests").doc(requestId).get()).data() as Request;

  if (request == null) {
    throw new functions.https.HttpsError("not-found", "Request with given id doesn't exist");
  }

  const item = (await firestore.collection("items").doc(request.itemId).get()).data() as Item;

  if (item == null) {
    throw new functions.https.HttpsError("not-found", "Item associated with request not found");
  }

  if (item.ownerId != uid) {
    throw new functions.https.HttpsError("permission-denied", "Not permitted to reject request");
  }

  updateStatusAndMessage(requestId, "rejected", message);
}


async function rejectConflictingRequests(requestId: string, uid: string) {
  const request = (await firestore.collection("requests").doc(requestId).get()).data() as Request;

  if (request == null) {
    throw new functions.https.HttpsError("not-found", "Request with given id doesn't exist");
  }

  const itemId = request.itemId;

  const requestsIds = (await firestore.collection("requests")
      .where("itemId", "==", itemId)
      .where("status", "==", "pending")
      .get()).docs.map((it)=>it.id);
  const filteredIds = requestsIds.filter((it)=>it!=requestId);
  const rejectMessage = "The item has already been borrowed by another user";
  filteredIds.forEach((it)=>rejectRequest(it, uid, rejectMessage));
}


async function updateStatusAndMessage(requestId: string, status: RequestStatus,
    message: string | null = null) {
  const requestUpdate: Partial<RequestUpdate> = {
    status: status,
    responseMessage: message,
  };
  await firestore.collection("requests").doc(requestId).update(requestUpdate);
}


export const onWriteUpdateDisplayedTitleAndSubtitleOnTile = functions.firestore.document("requests/{request}").onWrite(async (snapshot) => {
  const request: Request = snapshot.after.data() as Request;
  const requestId = snapshot.after.id;

  const item = await getItem(request.itemId);
  const title = await getTitleFromType(request.type);
  const subtitle = `Item: ${item.title}`;

  await updateRequest(requestId, title, subtitle, [
    request.issuerId,
    item.ownerId,
  ]);
});

async function getTitleFromType(type: RequestType): Promise<string> {
  return type === "extend" ? "Time extend request" : "Borrow request";
}

async function updateRequest(requestId: string, title: string, subtitle: string, receivers: Array<string>) {
  const requestUpdate: Partial<RequestUpdate> = {
    title,
    subtitle,
    receivers,
  };

  await firestore.collection("requests").doc(requestId).update(requestUpdate);
}
