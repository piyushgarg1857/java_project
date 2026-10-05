package com.shopsphere.controller;

import com.shopsphere.model.User;
import com.shopsphere.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final AuthService authService=new AuthService();

    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException,IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req,resp);
    }

    @Override protected void doPost(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException,IOException {
        try {
            User user=authService.login(req.getParameter("email"),req.getParameter("password"));
            if(user==null) {
                req.setAttribute("error","Invalid email or password.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req,resp);
                return;
            }
            req.getSession(true).setAttribute("loggedInUser",user);
            resp.sendRedirect(req.getContextPath()+"/products");
        } catch(Exception e) {
            throw new ServletException("Login failed",e);
        }
    }
}
