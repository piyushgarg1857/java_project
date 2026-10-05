package com.shopsphere.dao;

import com.shopsphere.config.DBConnection;
import com.shopsphere.model.User;
import java.sql.*;

public class UserDAO {
    private static final String FIND_BY_EMAIL =
        "SELECT user_id,name,email,password,mobile,role,status FROM users WHERE email=? AND status=TRUE";
    private static final String INSERT =
        "INSERT INTO users(name,email,password,mobile,role,status) VALUES(?,?,?,?, 'CUSTOMER', TRUE)";

    public User findByEmail(String email) throws SQLException {
        try (Connection c=DBConnection.getConnection();
             PreparedStatement s=c.prepareStatement(FIND_BY_EMAIL)) {
            s.setString(1,email);
            try(ResultSet rs=s.executeQuery()) {
                if(!rs.next()) return null;
                User u=new User();
                u.setUserId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password"));
                u.setMobile(rs.getString("mobile"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getBoolean("status"));
                return u;
            }
        }
    }

    public boolean create(User user) throws SQLException {
        try(Connection c=DBConnection.getConnection();
            PreparedStatement s=c.prepareStatement(INSERT)) {
            s.setString(1,user.getName());
            s.setString(2,user.getEmail());
            s.setString(3,user.getPassword());
            s.setString(4,user.getMobile());
            return s.executeUpdate()==1;
        }
    }
}
