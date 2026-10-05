package com.shopsphere.controller;

import com.shopsphere.dao.WishlistDAO;
import com.shopsphere.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    private final WishlistDAO dao = new WishlistDAO();

    private User user(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("loggedInUser");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("products", dao.findByUser(user(request).getUserId()));
            request.getRequestDispatcher("/WEB-INF/views/wishlist.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Unable to load wishlist", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            User u = user(request);
            int productId = Integer.parseInt(request.getParameter("productId"));
            if ("remove".equals(request.getParameter("action"))) {
                dao.remove(u.getUserId(), productId);
            } else {
                dao.add(u.getUserId(), productId);
            }
            response.sendRedirect(request.getContextPath() + "/wishlist");
        } catch (Exception e) {
            throw new IOException("Wishlist operation failed", e);
        }
    }
}
