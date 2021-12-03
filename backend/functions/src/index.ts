import * as admin from "firebase-admin";

admin.initializeApp();

// Include functions from requests.ts
import * as requests from "./requests";
import * as users from "./users";
import * as rentals from "./rentals";

exports.requests = requests;
exports.users = users;
exports.rentals = rentals;
