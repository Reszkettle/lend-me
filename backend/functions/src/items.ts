import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { Item } from './models';

const firestore = admin.firestore();

export async function getItem(itemId: string): Promise<Item> {
	return (await firestore.collection('items').doc(itemId).get()).data() as Item;
}
