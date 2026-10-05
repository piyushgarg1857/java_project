package com.shopsphere.controller;

import com.shopsphere.model.Product;
import com.shopsphere.service.CatalogAdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    private final CatalogAdminService service=new CatalogAdminService();

    @Override protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws IOException {
        try {
            Product p=new Product();
            p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            p.setName(req.getParameter("name")); p.setBrand(req.getParameter("brand"));
            p.setDescription(req.getParameter("description"));
            p.setPrice(Double.parseDouble(req.getParameter("price")));
            p.setDiscount(Double.parseDouble(req.getParameter("discount")));
            p.setStock(Integer.parseInt(req.getParameter("stock")));
            p.setImageUrl(req.getParameter("imageUrl"));
            String action=req.getParameter("action");
            if("update".equals(action)) {
                p.setProductId(Integer.parseInt(req.getParameter("productId")));
                service.updateProduct(p);
            } else service.createProduct(p);
            resp.sendRedirect(req.getContextPath()+"/products");
        } catch(Exception e){ throw new IOException("Product operation failed",e); }
    }
}
