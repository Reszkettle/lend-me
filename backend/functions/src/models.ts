import * as admin from "firebase-admin";

export interface UserUpdate {
  avatarUrl: string | null;
  createdAt: admin.firestore.Timestamp | admin.firestore.FieldValue;
  info: UserInfo;
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

export interface Item {
  createdAt: admin.firestore.Timestamp;
  description: string | null;
  imageUrl: string | null;
  lentById: string | null;
  ownerId: string;
  title: string;
}

export interface RentalUpdate {
  borrowerFullname: string | null;
  borrowerId: string;
  endDate: admin.firestore.Timestamp | admin.firestore.FieldValue;
  itemId: string;
  ownerFullname: string;
  startDate: admin.firestore.Timestamp | admin.firestore.FieldValue;
  status: string;
}

export interface Rental extends RentalUpdate {
  endDate: admin.firestore.Timestamp;
  startDate: admin.firestore.Timestamp;
}

export interface RequestUpdate {
  endDate: admin.firestore.Timestamp | admin.firestore.FieldValue;
  issuerId: string;
  itemId: string;
  requestMessage: string | null;
  responseMessage: string | null;
  status: string;
  type: string;
}

export interface Request extends RequestUpdate {
  endDate: admin.firestore.Timestamp
}
