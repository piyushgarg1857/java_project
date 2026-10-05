package com.shopsphere.service;

import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.User;
import java.sql.SQLException;

public class AuthService {
    private final UserDAO userDAO = new UserDAO();

    public boolean register(String name, String email, String password, String mobile) throws SQLException {
        if(name==null || name.isBlank() || email==null || email.isBlank() ||
           password==null || password.length()<6) return false;
        if(userDAO.findByEmail(email.trim())!=null) return false;

        User user=new User();
        user.setName(name.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(password);
        user.setMobile(mobile);
        return userDAO.create(user);
    }

    public User login(String email, String password) throws SQLException {
        if(email==null || password==null) return null;
        User user=userDAO.findByEmail(email.trim().toLowerCase());
        if(user==null || !user.getPassword().equals(password)) return null;
        user.setPassword(null);
        return user;
    }
}
