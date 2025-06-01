/* eslint-disable quotes */
/* eslint-disable object-curly-spacing */
const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465,
  secure: true, // Use SSL
  auth: {
    user: process.env.EMAIL_USER, // makangoapp@gmail.com
    pass: process.env.EMAIL_PASS, // bxwkgrvhitlshajx
  },
});

const sendEmail = async ({ to, subject, text }) => {
  await transporter.sendMail({
    from: '"Makango App" <makangoapp@gmail.com>',
    to,
    subject,
    text,
  });
};

module.exports = { sendEmail };
