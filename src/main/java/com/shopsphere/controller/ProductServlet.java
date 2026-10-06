package com.shopsphere.controller;
import com.shopsphere.dao.ProductDAO; import jakarta.servlet.*; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.IOException;
@WebServlet("/products")
public class ProductServlet extends HttpServlet {
 private final ProductDAO dao=new ProductDAO();
 protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
  try{String q=req.getParameter("q");int category=parse(req.getParameter("category"),0),page=parse(req.getParameter("page"),1);String sort=req.getParameter("sort");
   req.setAttribute("products",dao.search(q,category,sort,page,12));req.setAttribute("query",q);req.setAttribute("category",category);req.setAttribute("sort",sort==null?"newest":sort);req.setAttribute("page",page);
   req.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(req,resp);
  }catch(Exception e){throw new ServletException("Unable to load products",e);}
 }
 private int parse(String v,int fallback){try{return v==null?fallback:Integer.parseInt(v);}catch(NumberFormatException e){return fallback;}}
}