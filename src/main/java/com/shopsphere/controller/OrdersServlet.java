package com.shopsphere.controller;

import com.shopsphere.dao.OrderHistoryDAO;
import com.shopsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {
    private final OrderHistoryDAO dao = new OrderHistoryDAO();

    @Override
    protected void doGet(HttpServletRequest r, HttpServletResponse p) throws ServletException, IOException {
        HttpSession s = r.getSession(false);
        User u = s == null ? null : (User) s.getAttribute("loggedInUser");
        if (u == null) {
            p.sendRedirect(r.getContextPath() + "/login");
            return;
        }
        try {
            r.setAttribute("orders", dao.findByUser(u.getUserId()));
            r.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(r, p);
        } catch (Exception e) {
            throw new ServletException("Unable to load orders", e);
        }
    }
}