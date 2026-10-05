package com.shopsphere.dao;

import com.shopsphere.config.DBConnection;
import com.shopsphere.model.Product;
import java.sql.*;
import java.util.*;

public class WishlistDAO {
    public void add(int userId, int productId) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement s = c.prepareStatement("INSERT IGNORE INTO wishlist(user_id,product_id) VALUES(?,?)")) {
            s.setInt(1, userId);
            s.setInt(2, productId);
            s.executeUpdate();
        }
    }

    public void remove(int userId, int productId) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement s = c.prepareStatement("DELETE FROM wishlist WHERE user_id=? AND product_id=?")) {
            s.setInt(1, userId);
            s.setInt(2, productId);
            s.executeUpdate();
        }
    }

    public List<Product> findByUser(int userId) throws SQLException {
        String q = "SELECT p.product_id,p.category_id,p.name,p.brand,p.description,p.price,p.discount,p.stock,p.image_url,p.status " +
                   "FROM wishlist w JOIN products p ON p.product_id=w.product_id " +
                   "WHERE w.user_id=? AND p.status=TRUE ORDER BY w.created_at DESC";
        List<Product> products = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, userId);
            try (ResultSet rs = s.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setName(rs.getString("name"));
                    p.setBrand(rs.getString("brand"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getDouble("price"));
                    p.setDiscount(rs.getDouble("discount"));
                    p.setStock(rs.getInt("stock"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setStatus(rs.getBoolean("status"));
                    products.add(p);
                }
            }
        }
        return products;
    }
}
