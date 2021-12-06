import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { Rental, RentalUpdate, User, ItemUpdate } from "./models";

const firestore = admin.firestore();

/**
 * Trigger on rental created used to populate borrowerFullname and ownerFullname
 */
export const onWriteUpdateFullnames = functions.firestore
	.document("rentals/{rental}")
	.onWrite(async (snapshot) => {
		const rental: Rental = snapshot.after.data() as Rental;
		const rentalId = snapshot.after.id;

		if (rental == null) {
			updateFullnames(rentalId, "Unknown name", "Unknown name");
		}

		const ownerName = await getFullname(rental.ownerId);
		const borrowerName = await getFullname(rental.borrowerId);

		updateFullnames(rentalId, borrowerName, ownerName);
	});

async function getFullname(userId: string): Promise<string> {
	const user = (
		await firestore.collection("users").doc(userId).get()
	).data() as User;
	const firstName = user?.info?.firstName;
	const lastName = user?.info?.lastName;
	if (firstName == null || lastName == null) {
		return "Unknown";
	} else {
		return firstName + " " + lastName;
	}
}

async function updateFullnames(
	rentalId: string,
	borrowerName: string,
	ownerName: string
) {
	const rentalUpdate: Partial<RentalUpdate> = {
		borrowerFullname: borrowerName,
		ownerFullname: ownerName,
	};
	await firestore.collection("rentals").doc(rentalId).update(rentalUpdate);
}

export const onWriteUpdateLentById = functions.firestore
	.document("rentals/{rental}")
	.onWrite(async (snapshot) => {
		const rental: Rental = snapshot.after.data() as Rental;
		const lentById = await getLentById(rental.itemId);
		await setLentById(rental.itemId, lentById);
	});

async function getLentById(itemId: string): Promise<string | null> {
	const pendingRentals = (
		await firestore
			.collection("rentals")
			.where("itemId", "==", itemId)
			.where("status", "==", "pending")
			.get()
	).docs.map((it) => it.data()) as Array<Rental>;

	if (pendingRentals.length == 0) {
		return null;
	}

	if (pendingRentals.length > 1) {
		throw new functions.https.HttpsError(
			"internal",
			"Multiple pending rentals for single item"
		);
	}

	const pendingRental = pendingRentals[0];
	return pendingRental.borrowerId;
}

async function setLentById(itemId: string, lentById: string | null) {
	const itemUpdate: Partial<ItemUpdate> = {
		lentById: lentById,
	};
	await firestore.collection("items").doc(itemId).update(itemUpdate);
}
