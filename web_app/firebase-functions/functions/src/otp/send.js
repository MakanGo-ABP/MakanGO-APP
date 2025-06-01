/* eslint-disable quotes */
/* eslint-disable object-curly-spacing */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { sendEmail } = require("../utils/mailer");

const sendOTP = functions.https.onCall(async (data, context) => {
  const { email } = data;
  if (!email) {
    throw new functions.https.HttpsError("invalid-argument", "Email required");
  }
  // Generate 6-digit OTP
  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  const expiresAt = Date.now() + 10 * 60 * 1000; // 10-minute expiry

  // Store OTP in Firestore
  await admin.firestore().collection("otps").doc(email).set({
    otp,
    expiresAt,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Send OTP email
  await sendEmail({
    to: email,
    subject: "Your MakanGO OTP Code",
    text: `Your OTP is ${otp}. It expires in 10 minutes.`,
  });

  return { success: true };
});

module.exports = { sendOTP };
