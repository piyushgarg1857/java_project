package com.shopsphere.controller;

import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("products", productService.getActiveProducts());
            request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load products", e);
        }
    }
}
