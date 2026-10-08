package com.shopsphere.web;

import com.shopsphere.dao.OrderDetailDAO;
import com.shopsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/order-detail")
public class OrderDetailServlet extends HttpServlet {
    private final OrderDetailDAO dao = new OrderDetailDAO();

    @Override
    protected void doGet(HttpServletRequest q, HttpServletResponse p) throws ServletException, IOException {
        HttpSession s = q.getSession(false);
        User u = s == null ? null : (User) s.getAttribute("loggedInUser");
        if (u == null) {
            p.sendRedirect(q.getContextPath() + "/login");
            return;
        }
        try {
            int id = Integer.parseInt(q.getParameter("orderId"));
            var order = dao.findOrder(u.getUserId(), id);
            if (order == null) {
                p.sendError(404, "Order not found");
                return;
            }
            q.setAttribute("order", order);
            q.setAttribute("items", dao.findItems(u.getUserId(), id));
            q.getRequestDispatcher("/WEB-INF/views/order-detail.jsp").forward(q, p);
        } catch (NumberFormatException e) {
            p.sendError(400, "Invalid order id");
        } catch (Exception e) {
            throw new ServletException("Unable to load order detail", e);
        }
    }
}
