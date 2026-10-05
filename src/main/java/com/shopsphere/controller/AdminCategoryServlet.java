package com.shopsphere.controller;

import com.shopsphere.service.CatalogAdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {
    private final CatalogAdminService service=new CatalogAdminService();

    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        try {
            req.setAttribute("categories",service.categories());
            req.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(req,resp);
        } catch(Exception e){ throw new ServletException("Unable to load categories",e); }
    }

    @Override protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws IOException {
        try {
            String action=req.getParameter("action");
            if("delete".equals(action)) service.deleteCategory(Integer.parseInt(req.getParameter("id")));
            else service.createCategory(req.getParameter("name"),req.getParameter("description"));
            resp.sendRedirect(req.getContextPath()+"/admin/categories");
        } catch(Exception e){ throw new IOException("Category operation failed",e); }
    }
}
