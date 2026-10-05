package com.shopsphere.controller;
import com.shopsphere.model.User; import com.shopsphere.service.CartService; import jakarta.servlet.*; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.*;
@WebServlet("/cart")
public class CartServlet extends HttpServlet{
 private final CartService service=new CartService();
 private User user(HttpServletRequest r){return (User)r.getSession().getAttribute("loggedInUser");}
 protected void doGet(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{try{r.setAttribute("items",service.getCart(user(r).getUserId()));r.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(r,p);}catch(Exception e){throw new ServletException(e);}}
 protected void doPost(HttpServletRequest r,HttpServletResponse p)throws IOException{try{User u=user(r);String a=r.getParameter("action");int id=Integer.parseInt(r.getParameter("productId"));if("remove".equals(a))service.remove(u.getUserId(),id);else service.add(u.getUserId(),id,Integer.parseInt(r.getParameter("quantity")));p.sendRedirect(r.getContextPath()+"/cart");}catch(Exception e){throw new IOException(e);}}
}