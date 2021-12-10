import * as admin from "firebase-admin";

admin.initializeApp();

// Include functions from requests.ts
import * as requests from "./requests";
import * as users from "./users";
import * as rentals from "./rentals";
import * as notifications from "./notifications";
import * as items from "./items";

exports.requests = requests;
exports.users = users;
exports.rentals = rentals;
exports.notifications = notifications;
exports.items = items;
