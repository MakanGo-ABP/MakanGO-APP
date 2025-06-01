/* eslint-disable quotes */
/* eslint-disable object-curly-spacing */

require("dotenv").config();
const admin = require("firebase-admin");

admin.initializeApp({
  credential: admin.credential.cert(require("../firebase-credentials.json")),
});

const { sendOTP } = require("./otp/send");
const { verifyOTP } = require("./otp/verify");

exports.sendOTP = sendOTP;
exports.verifyOTP = verifyOTP;
