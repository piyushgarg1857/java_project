package com.shopsphere.controller;

import com.shopsphere.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final AuthService authService=new AuthService();

    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException,IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req,resp);
    }

    @Override protected void doPost(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException,IOException {
        try {
            boolean created=authService.register(req.getParameter("name"),req.getParameter("email"),
                    req.getParameter("password"),req.getParameter("mobile"));
            if(!created) {
                req.setAttribute("error","Registration failed. Check details or email may already exist.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req,resp);
                return;
            }
            resp.sendRedirect(req.getContextPath()+"/login?registered=true");
        } catch(Exception e) {
            throw new ServletException("Registration failed",e);
        }
    }
}
