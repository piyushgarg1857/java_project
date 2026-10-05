package com.shopsphere.controller;

import com.shopsphere.model.User;
import com.shopsphere.service.CartService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final CartService service = new CartService();

    private User user(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("loggedInUser");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("items", service.getCart(user(request).getUserId()));
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Unable to load cart", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            User u = user(request);
            int productId = Integer.parseInt(request.getParameter("productId"));
            String action = request.getParameter("action");

            if ("remove".equals(action)) {
                service.remove(u.getUserId(), productId);
            } else if ("update".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                service.updateQuantity(u.getUserId(), productId, quantity);
            } else {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                service.add(u.getUserId(), productId, quantity);
            }
            response.sendRedirect(request.getContextPath() + "/cart");
        } catch (Exception e) {
            throw new IOException("Cart operation failed", e);
        }
    }
}
