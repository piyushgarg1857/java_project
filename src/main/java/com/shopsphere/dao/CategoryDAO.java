package com.shopsphere.dao;

import com.shopsphere.config.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public CategoryDAO() {
        ensureSchema();
    }

    private void ensureSchema() {
        try (Connection c = DBConnection.getConnection(); Statement stmt = c.createStatement()) {
            stmt.executeUpdate("ALTER TABLE categories ADD COLUMN IF NOT EXISTS image_url VARCHAR(500)");
        } catch (Exception ignored) {}
    }

    public List<String[]> findAll() throws SQLException {
        List<String[]> rows = new ArrayList<>();
        String sql = "SELECT category_id, name, description, COALESCE(image_url, '') AS image_url, status FROM categories ORDER BY category_id DESC";
        try (Connection c = DBConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql); ResultSet rs = s.executeQuery()) {
            while (rs.next()) {
                rows.add(new String[]{
                    String.valueOf(rs.getInt("category_id")),
                    rs.getString("name"),
                    rs.getString("description") != null ? rs.getString("description") : "",
                    rs.getString("image_url") != null ? rs.getString("image_url") : "",
                    String.valueOf(rs.getBoolean("status"))
                });
            }
        }
        return rows;
    }

    public String[] findById(int id) throws SQLException {
        String sql = "SELECT category_id, name, description, COALESCE(image_url, '') AS image_url, status FROM categories WHERE category_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, id);
            try (ResultSet rs = s.executeQuery()) {
                if (rs.next()) {
                    return new String[]{
                        String.valueOf(rs.getInt("category_id")),
                        rs.getString("name"),
                        rs.getString("description") != null ? rs.getString("description") : "",
                        rs.getString("image_url") != null ? rs.getString("image_url") : "",
                        String.valueOf(rs.getBoolean("status"))
                    };
                }
            }
        }
        return null;
    }

    public int create(String name, String description, String imageUrl) throws SQLException {
        String sql = "INSERT INTO categories(name, description, image_url, status) VALUES(?,?,?,TRUE)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            s.setString(1, name);
            s.setString(2, description);
            s.setString(3, imageUrl != null ? imageUrl.trim() : "");
            s.executeUpdate();
            try (ResultSet rs = s.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public boolean update(int id, String name, String description, String imageUrl, boolean status) throws SQLException {
        String sql = "UPDATE categories SET name=?, description=?, image_url=?, status=? WHERE category_id=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql)) {
            s.setString(1, name);
            s.setString(2, description);
            s.setString(3, imageUrl != null ? imageUrl.trim() : "");
            s.setBoolean(4, status);
            s.setInt(5, id);
            return s.executeUpdate() == 1;
        }
    }

    public boolean delete(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection(); PreparedStatement s = c.prepareStatement("UPDATE categories SET status = CASE WHEN status=TRUE THEN FALSE ELSE TRUE END WHERE category_id=?")) {
            s.setInt(1, id);
            return s.executeUpdate() == 1;
        }
    }
}
