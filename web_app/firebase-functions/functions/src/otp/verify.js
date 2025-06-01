/* eslint-disable comma-dangle */
/* eslint-disable indent */
/* eslint-disable curly */
/* eslint-disable quotes */
/* eslint-disable object-curly-spacing */
const functions = require("firebase-functions");
const admin = require("firebase-admin");

const verifyOTP = functions.https.onCall(async (data, context) => {
  const { email, otp } = data;
  if (!email || !otp)
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Email and OTP required"
    );

  const otpDoc = await admin.firestore().collection("otps").doc(email).get();
  if (!otpDoc.exists)
    throw new functions.https.HttpsError("not-found", "OTP not found");

  const { otp: storedOTP, expiresAt } = otpDoc.data();
  if (Date.now() > expiresAt)
    throw new functions.https.HttpsError("deadline-exceeded", "OTP expired");
  if (otp !== storedOTP)
    throw new functions.https.HttpsError("invalid-argument", "Invalid OTP");

  // Delete OTP to prevent reuse
  await admin.firestore().collection("otps").doc(email).delete();

  return { success: true };
});

module.exports = { verifyOTP };
