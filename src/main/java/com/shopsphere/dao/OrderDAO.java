package com.shopsphere.dao;

import com.shopsphere.config.DBConnection;
import com.shopsphere.model.CartItem;
import java.sql.*;
import java.util.List;

public class OrderDAO {
    public int create(int userId, int addressId, List<CartItem> items, double total) throws SQLException {
        String orderSql = "INSERT INTO orders(user_id,address_id,total_amount,payment_method,payment_status,order_status) VALUES(?,?,?,'COD','PENDING','PLACED')";
        String stockSql = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND status = TRUE AND stock >= ?";
        String itemSql = "INSERT INTO order_items(order_id,product_id,quantity,price) VALUES(?,?,?,?)";

        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                // Reserve stock first. If any product cannot satisfy the requested
                // quantity, the complete checkout transaction is rolled back.
                try (PreparedStatement stock = c.prepareStatement(stockSql)) {
                    for (CartItem x : items) {
                        stock.setInt(1, x.getQuantity());
                        stock.setInt(2, x.getProductId());
                        stock.setInt(3, x.getQuantity());
                        if (stock.executeUpdate() != 1) {
                            throw new SQLException("Insufficient stock for product ID " + x.getProductId());
                        }
                    }
                }

                int orderId;
                try (PreparedStatement order = c.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    order.setInt(1, userId);
                    order.setInt(2, addressId);
                    order.setDouble(3, total);
                    order.executeUpdate();

                    try (ResultSet rs = order.getGeneratedKeys()) {
                        if (!rs.next()) throw new SQLException("Order ID was not generated");
                        orderId = rs.getInt(1);
                    }
                }

                try (PreparedStatement item = c.prepareStatement(itemSql)) {
                    for (CartItem x : items) {
                        item.setInt(1, orderId);
                        item.setInt(2, x.getProductId());
                        item.setInt(3, x.getQuantity());
                        item.setDouble(4, x.getPrice());
                        item.addBatch();
                    }
                    item.executeBatch();
                }

                c.commit();
                return orderId;
            } catch (SQLException e) {
                c.rollback();
                throw e;
            }
        }
    }
}
