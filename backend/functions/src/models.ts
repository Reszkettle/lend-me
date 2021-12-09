import * as admin from "firebase-admin";

export type RequestOperation = "accept" | "reject";

export interface UserUpdate {
  avatarUrl: string | null;
  createdAt: admin.firestore.Timestamp | admin.firestore.FieldValue;
  info: UserInfo;
  token: string | null;
}

export interface User extends UserUpdate {
  createdAt: admin.firestore.Timestamp
}

export interface UserInfo {
  email: string | null;
  firstName: string | null;
  lastName: string | null;
  phone: string | null;
}

export interface ItemUpdate {
  createdAt: admin.firestore.Timestamp | admin.firestore.FieldValue;
  description: string | null;
  imageUrl: string | null;
  lentById: string | null;
  ownerId: string;
  title: string;
}

export interface Item extends ItemUpdate {
  createdAt: admin.firestore.Timestamp;
}

export type RentalStatus = "pending" | "finished";

export interface RentalUpdate {
  itemId: string;
  borrowerId: string;
  ownerId: string;
  ownerFullname: string | null;
  borrowerFullname: string | null;
  startDate: admin.firestore.Timestamp | admin.firestore.FieldValue;
  endDate: admin.firestore.Timestamp | admin.firestore.FieldValue;
  status: RentalStatus;
}

export interface Rental extends RentalUpdate {
  endDate: admin.firestore.Timestamp;
  startDate: admin.firestore.Timestamp;
}

export type RequestStatus = "pending" | "accepted" | "rejected";

export type RequestType = "borrow" | "extend" | "transfer";

export interface RequestUpdate {
  endDate: admin.firestore.Timestamp | admin.firestore.FieldValue;
  issuerId: string;
  itemId: string;
  requestMessage: string | null;
  responseMessage: string | null;
  status: RequestStatus;
  type: RequestType;
  receivers: Array<string>;
  title?: string;
  subtitle?: string;
}

export interface Request extends RequestUpdate {
  endDate: admin.firestore.Timestamp
}
