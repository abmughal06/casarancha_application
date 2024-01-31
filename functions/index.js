const functions = require("firebase-functions");
const admin = require('firebase-admin');

var db;
if (!admin.apps.length) {
    db = admin.initializeApp().firestore();
} else {
    db = admin.app().firestore();
}

exports.deleteUserFromAuthentication = functions.https.onCall(async(data, context) => {
    var data = JSON.parse(data).data;

    try {
        await admin
            .auth()
            .deleteUser(data.uid)
        console.log('Successfully deleted user');
        return {
            status: true,
            message: "success"
        };
    } catch (error) {
        return {
            status: false,
            message: error
        };
    }


});