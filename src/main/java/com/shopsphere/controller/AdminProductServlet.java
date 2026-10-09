package com.shopsphere.controller;

import com.shopsphere.model.Product;
import com.shopsphere.service.CatalogAdminService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Collections;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    private final CatalogAdminService service = new CatalogAdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("categories", service.categories());
            String action = req.getParameter("action");
            if ("delete".equals(action) || "toggle".equals(action)) {
                String idParam = req.getParameter("id");
                if (idParam != null && !idParam.isBlank()) {
                    service.deleteProduct(Integer.parseInt(idParam));
                }
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }
            req.setAttribute("editProduct", null);
            if ("edit".equals(action)) {
                String idParam = req.getParameter("id");
                if (idParam != null && !idParam.isBlank()) {
                    req.setAttribute("editProduct", service.findProduct(Integer.parseInt(idParam)));
                }
            }
            req.setAttribute("products", service.products());
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("products", Collections.emptyList());
            req.setAttribute("error", "Unable to manage products: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Product p = new Product();
            p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            p.setName(req.getParameter("name"));
            p.setBrand(req.getParameter("brand"));
            p.setDescription(req.getParameter("description"));
            p.setPrice(Double.parseDouble(req.getParameter("price")));
            p.setDiscount(Double.parseDouble(req.getParameter("discount")));
            p.setStock(Integer.parseInt(req.getParameter("stock")));
            p.setImageUrl(req.getParameter("imageUrl"));

            String statusParam = req.getParameter("status");
            boolean status = "update".equals(req.getParameter("action")) ? ("true".equalsIgnoreCase(statusParam) || "on".equalsIgnoreCase(statusParam)) : true;
            p.setStatus(status);

            if ("update".equals(req.getParameter("action"))) {
                p.setProductId(Integer.parseInt(req.getParameter("productId")));
                service.updateProduct(p);
            } else {
                service.createProduct(p);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("products", Collections.emptyList());
            req.setAttribute("error", "Product operation failed: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
        }
    }
}
