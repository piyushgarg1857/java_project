package com.shopsphere.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailService {
    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    private static final ExecutorService ASYNC_EXECUTOR = Executors.newFixedThreadPool(3);

    private static final String SMTP_HOST = System.getenv().getOrDefault("SMTP_HOST", "smtp.gmail.com");
    private static final String SMTP_PORT = System.getenv().getOrDefault("SMTP_PORT", "587");
    private static final String SMTP_USER = System.getenv().getOrDefault("SMTP_USER", "");
    private static final String SMTP_PASS = System.getenv().getOrDefault("SMTP_PASS", "");
    private static final String FROM_EMAIL = System.getenv().getOrDefault("FROM_EMAIL", "noreply@shopsphere-online.azurewebsites.net");

    public static void sendOrderReceiptAsync(String recipientEmail, String userName, int orderId, double totalAmount) {
        ASYNC_EXECUTOR.submit(() -> {
            try {
                String subject = "Order Confirmed — ShopSphere #" + orderId;
                String htmlContent = buildOrderReceiptHtml(userName, orderId, totalAmount);
                sendEmail(recipientEmail, subject, htmlContent);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to dispatch order receipt to " + recipientEmail, e);
            }
        });
    }

    public static void sendPasswordResetOtpAsync(String recipientEmail, String otp) {
        ASYNC_EXECUTOR.submit(() -> {
            try {
                String subject = "Password Reset Security Code — ShopSphere";
                String htmlContent = buildOtpHtml(recipientEmail, otp);
                sendEmail(recipientEmail, subject, htmlContent);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to dispatch OTP email to " + recipientEmail, e);
            }
        });
    }

    private static void sendEmail(String recipientEmail, String subject, String htmlContent) throws Exception {
        if (recipientEmail == null || recipientEmail.isBlank()) {
            return;
        }

        if (SMTP_USER.isBlank() || SMTP_PASS.isBlank()) {
            LOGGER.info(String.format(
                "[SMTP SIMULATED EMAIL] To: %s | Subject: %s | App URL: https://shopsphere-online.azurewebsites.net\n(To send live emails, configure SMTP_USER & SMTP_PASS environment variables)",
                recipientEmail, subject
            ));
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "ShopSphere E-Commerce"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
        message.setSubject(subject);
        message.setContent(htmlContent, "text/html; charset=utf-8");

        Transport.send(message);
        LOGGER.info("[LIVE EMAIL SENT SUCCESSFULLY] To: " + recipientEmail + " | Subject: " + subject);
    }

    private static String buildOrderReceiptHtml(String userName, int orderId, double totalAmount) {
        return "<html><body style='font-family:Arial,sans-serif; background:#080808; color:#f3efe7; padding:30px;'>"
             + "<div style='max-width:550px; margin:0 auto; background:#121212; border:1px solid #222; padding:30px; border-radius:8px;'>"
             + "<h2 style='font-family:serif; letter-spacing:2px; text-transform:uppercase; color:#d8c8a8; margin-top:0;'>SHOPSPHERE</h2>"
             + "<p style='font-size:16px; color:#f3efe7;'>Thank you for your order, <strong>" + (userName != null ? userName : "Valued Customer") + "</strong>!</p>"
             + "<p style='color:#a6a19a;'>Your order <strong>#" + orderId + "</strong> has been confirmed and is being prepared for dispatch.</p>"
             + "<div style='background:#171717; border:1px solid #333; padding:15px; margin:20px 0; border-radius:4px;'>"
             + "<div style='display:flex; justify-content:space-between; margin-bottom:8px;'><span style='color:#a6a19a;'>Order ID:</span><strong>#" + orderId + "</strong></div>"
             + "<div style='display:flex; justify-content:space-between; margin-bottom:8px;'><span style='color:#a6a19a;'>Total Amount:</span><strong style='color:#d8c8a8;'>₹" + String.format("%.2f", totalAmount) + "</strong></div>"
             + "<div style='display:flex; justify-content:space-between;'><span style='color:#a6a19a;'>Payment Method:</span><strong>Cash on Delivery (COD)</strong></div>"
             + "</div>"
             + "<a href='https://shopsphere-online.azurewebsites.net/order-detail?orderId=" + orderId + "' style='display:inline-block; background:#d8c8a8; color:#080808; text-decoration:none; padding:12px 20px; font-size:12px; font-weight:bold; letter-spacing:1px; text-transform:uppercase; margin-top:10px;'>View Order Details</a>"
             + "<p style='color:#706b64; font-size:11px; margin-top:25px;'>© 2026 ShopSphere E-Commerce. All rights reserved.</p>"
             + "</div></body></html>";
    }

    private static String buildOtpHtml(String recipientEmail, String otp) {
        return "<html><body style='font-family:Arial,sans-serif; background:#080808; color:#f3efe7; padding:30px;'>"
             + "<div style='max-width:500px; margin:0 auto; background:#121212; border:1px solid #222; padding:30px; border-radius:8px; text-align:center;'>"
             + "<h2 style='font-family:serif; letter-spacing:2px; text-transform:uppercase; color:#d8c8a8; margin-top:0;'>SHOPSPHERE</h2>"
             + "<h3>Password Reset Code</h3>"
             + "<p style='color:#a6a19a;'>Use the verification code below to reset your ShopSphere account password:</p>"
             + "<div style='font-size:32px; font-weight:bold; letter-spacing:6px; color:#d8c8a8; background:#171717; padding:15px; margin:20px 0; border:1px dashed #444;'>" + otp + "</div>"
             + "<p style='color:#706b64; font-size:11px;'>If you did not request a password reset, please ignore this email.</p>"
             + "</div></body></html>";
    }
}
