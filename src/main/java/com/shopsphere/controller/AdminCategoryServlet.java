package com.shopsphere.controller;

import com.shopsphere.service.CatalogAdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {
    private final CatalogAdminService service = new CatalogAdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            if ("edit".equals(action)) {
                String idParam = req.getParameter("id");
                if (idParam != null && !idParam.isBlank()) {
                    req.setAttribute("editCategory", service.findCategory(Integer.parseInt(idParam)));
                }
            }
            req.setAttribute("categories", service.categories());
            req.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load categories", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String action = req.getParameter("action");
            if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String name = req.getParameter("name");
                String description = req.getParameter("description");
                String imageUrl = req.getParameter("imageUrl");
                boolean status = "true".equalsIgnoreCase(req.getParameter("status")) || "on".equalsIgnoreCase(req.getParameter("status"));

                service.updateCategory(id, name, description, imageUrl, status);
            } else if ("delete".equals(action) || "toggle".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                service.deleteCategory(id);
            } else {
                String name = req.getParameter("name");
                String description = req.getParameter("description");
                String imageUrl = req.getParameter("imageUrl");

                service.createCategory(name, description, imageUrl);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        } catch (Exception e) {
            throw new IOException("Category operation failed", e);
        }
    }
}
