package com.shopsphere.controller;

import com.shopsphere.model.Product;
import com.shopsphere.service.CatalogAdminService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    private final CatalogAdminService service = new CatalogAdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("categories", service.categories());
            String action = req.getParameter("action");
            if ("delete".equals(action)) {
                service.deleteProduct(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }
            req.setAttribute("editProduct", null);
            if ("edit".equals(action)) {
                req.setAttribute("editProduct", service.findProduct(Integer.parseInt(req.getParameter("id"))));
            }
            req.setAttribute("products", service.products());
            req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to manage products", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
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

            if ("update".equals(req.getParameter("action"))) {
                p.setProductId(Integer.parseInt(req.getParameter("productId")));
                service.updateProduct(p);
            } else {
                service.createProduct(p);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        } catch (Exception e) {
            throw new IOException("Product operation failed", e);
        }
    }
}
