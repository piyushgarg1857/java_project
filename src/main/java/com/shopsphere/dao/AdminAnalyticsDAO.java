package com.shopsphere.dao;

import com.shopsphere.config.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class AdminAnalyticsDAO {

    public Map<String, Object> summary() throws SQLException {
        Map<String, Object> m = new LinkedHashMap<>();
        int usersCount = 0, productsCount = 0, ordersCount = 0, reviewsCount = 0;
        BigDecimal revenue = BigDecimal.ZERO;

        try (Connection c = DBConnection.getConnection()) {
            try (Statement s = c.createStatement(); ResultSet r = s.executeQuery("SELECT COUNT(*) FROM users")) { if (r.next()) usersCount = r.getInt(1); } catch (Exception ignored) {}
            try (Statement s = c.createStatement(); ResultSet r = s.executeQuery("SELECT COUNT(*) FROM products WHERE status=TRUE")) { if (r.next()) productsCount = r.getInt(1); } catch (Exception ignored) {}
            try (Statement s = c.createStatement(); ResultSet r = s.executeQuery("SELECT COUNT(*), COALESCE(SUM(total_amount),0) FROM orders WHERE order_status<>'CANCELLED'")) {
                if (r.next()) {
                    ordersCount = r.getInt(1);
                    revenue = r.getBigDecimal(2) != null ? r.getBigDecimal(2) : BigDecimal.ZERO;
                }
            } catch (Exception ignored) {}
            try (Statement s = c.createStatement(); ResultSet r = s.executeQuery("SELECT COUNT(*) FROM reviews")) { if (r.next()) reviewsCount = r.getInt(1); } catch (Exception ignored) {}
        }

        m.put("users", usersCount);
        m.put("products", productsCount);
        m.put("orders", ordersCount);
        m.put("revenue", revenue);
        m.put("reviews", reviewsCount);
        return m;
    }

    public List<Map<String, Object>> recentOrders() throws SQLException {
        List<Map<String, Object>> out = new ArrayList<>();
        String q = "SELECT DATE(created_at), COUNT(*), COALESCE(SUM(total_amount),0) FROM orders WHERE order_status<>'CANCELLED' GROUP BY DATE(created_at) ORDER BY DATE(created_at) DESC LIMIT 7";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement s = c.prepareStatement(q);
             ResultSet r = s.executeQuery()) {
            while (r.next()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("day", r.getDate(1) != null ? r.getDate(1).toString() : "Today");
                m.put("orders", r.getInt(2));
                m.put("revenue", r.getBigDecimal(3) != null ? r.getBigDecimal(3) : BigDecimal.ZERO);
                out.add(m);
            }
        } catch (Exception ignored) {}
        return out;
    }
}
