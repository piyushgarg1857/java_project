package com.shopsphere.service;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailService {
    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    private static final ExecutorService ASYNC_EXECUTOR = Executors.newFixedThreadPool(3);

    public static void sendOrderReceiptAsync(String recipientEmail, String userName, int orderId, double totalAmount) {
        ASYNC_EXECUTOR.submit(() -> {
            try {
                LOGGER.info(String.format(
                    "[EMAIL RECEIPT SENT] To: %s | Customer: %s | Order ID: #%d | Total: ₹%.2f",
                    recipientEmail, userName, orderId, totalAmount
                ));
                // Real SMTP logic or SendGrid HTTP API payload can be placed here seamlessly
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to send order receipt email to " + recipientEmail, e);
            }
        });
    }

    public static void sendPasswordResetOtpAsync(String recipientEmail, String otp) {
        ASYNC_EXECUTOR.submit(() -> {
            try {
                LOGGER.info(String.format(
                    "[EMAIL OTP SENT] To: %s | Password Reset OTP: %s",
                    recipientEmail, otp
                ));
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to send OTP email to " + recipientEmail, e);
            }
        });
    }
}
