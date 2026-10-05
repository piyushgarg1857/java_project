package com.shopsphere.controller;
import com.shopsphere.model.User; import com.shopsphere.dao.WishlistDAO; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.*;
@WebServlet("/wishlist") public class WishlistServlet extends HttpServlet{
 private final WishlistDAO dao=new WishlistDAO();
 protected void doPost(HttpServletRequest r,HttpServletResponse p)throws IOException{try{User u=(User)r.getSession().getAttribute("loggedInUser");int id=Integer.parseInt(r.getParameter("productId"));if("remove".equals(r.getParameter("action")))dao.remove(u.getUserId(),id);else dao.add(u.getUserId(),id);p.sendRedirect(r.getContextPath()+"/products");}catch(Exception e){throw new IOException(e);}}
}