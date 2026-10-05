package com.shopsphere.controller;
import com.shopsphere.dao.AddressDAO; import com.shopsphere.model.User; import com.shopsphere.security.InputValidator;
import jakarta.servlet.*; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.IOException;
@WebServlet("/addresses")
public class AddressServlet extends HttpServlet {
 private final AddressDAO dao=new AddressDAO();
 private User user(HttpServletRequest r){return (User)r.getSession().getAttribute("loggedInUser");}
 protected void doGet(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{try{r.setAttribute("addresses",dao.findByUser(user(r).getUserId()));r.getRequestDispatcher("/WEB-INF/views/addresses.jsp").forward(r,p);}catch(Exception e){throw new ServletException("Unable to load addresses",e);}}
 protected void doPost(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{try{
  User u=user(r); String action=r.getParameter("action");
  if("delete".equals(action)){int id=InputValidator.positiveInt(r.getParameter("addressId"),"Address");dao.delete(u.getUserId(),id);}
  else {String line=InputValidator.maxLength(InputValidator.required(r.getParameter("addressLine"),"Address"),"Address",255);String city=InputValidator.maxLength(InputValidator.required(r.getParameter("city"),"City"),"City",100);String state=InputValidator.maxLength(InputValidator.required(r.getParameter("state"),"State"),"State",100);String pin=InputValidator.pincode(r.getParameter("pincode"));dao.create(u.getUserId(),line,city,state,pin);}
  p.sendRedirect(r.getContextPath()+"/addresses");
 }catch(IllegalArgumentException e){p.sendError(400,e.getMessage());}catch(Exception e){throw new ServletException("Unable to save address",e);}}
}
