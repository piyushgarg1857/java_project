package com.shopsphere.dao;

import com.shopsphere.config.DBConnection;
import com.shopsphere.model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private static final String FIND_ALL =
        "SELECT product_id, category_id, name, brand, description, price, discount, stock, image_url, status FROM products WHERE status = TRUE ORDER BY product_id DESC";
    private static final String FIND_BY_ID =
        "SELECT product_id, category_id, name, brand, description, price, discount, stock, image_url, status FROM products WHERE product_id = ? AND status = TRUE";

    public List<Product> findAll() throws SQLException {
        List<Product> products = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement s = c.prepareStatement(FIND_ALL);
             ResultSet rs = s.executeQuery()) {
            while (rs.next()) products.add(map(rs));
        }
        return products;
    }

    public Product findById(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement s = c.prepareStatement(FIND_BY_ID)) {
            s.setInt(1, id);
            try (ResultSet rs = s.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    private Product map(ResultSet rs) throws SQLException {
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
        return p;
    }
}
