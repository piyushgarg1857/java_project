package com.shopsphere.controller;
import com.shopsphere.dao.AdminUserDAO; import com.shopsphere.security.InputValidator;
import jakarta.servlet.*; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.IOException;
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
 private final AdminUserDAO dao=new AdminUserDAO();
 protected void doGet(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{try{r.setAttribute("users",dao.findAll());r.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(r,p);}catch(Exception e){throw new ServletException("Unable to load users",e);}}
 protected void doPost(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{try{int id=InputValidator.positiveInt(r.getParameter("userId"),"User");String action=r.getParameter("action");if("toggle".equals(action))dao.setStatus(id,"true".equalsIgnoreCase(r.getParameter("status")));else if("role".equals(action))dao.setRole(id,r.getParameter("role"));else throw new IllegalArgumentException("Invalid user action");p.sendRedirect(r.getContextPath()+"/admin/users");}catch(IllegalArgumentException e){p.sendError(400,e.getMessage());}catch(Exception e){throw new ServletException("Unable to update user",e);}}
}
