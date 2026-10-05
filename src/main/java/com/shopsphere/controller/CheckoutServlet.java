package com.shopsphere.controller;
import com.shopsphere.model.User; import com.shopsphere.service.OrderService; import jakarta.servlet.*; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.*;
@WebServlet("/checkout") public class CheckoutServlet extends HttpServlet{
 private final OrderService service=new OrderService();
 protected void doGet(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{r.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(r,p);}
 protected void doPost(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{try{User u=(User)r.getSession().getAttribute("loggedInUser");int id=service.placeOrder(u.getUserId(),r.getParameter("addressLine"),r.getParameter("city"),r.getParameter("state"),r.getParameter("pincode"));r.setAttribute("orderId",id);r.getRequestDispatcher("/WEB-INF/views/order-success.jsp").forward(r,p);}catch(Exception e){throw new ServletException("Checkout failed",e);}}
}