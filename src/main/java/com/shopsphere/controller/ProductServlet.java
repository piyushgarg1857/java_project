package com.shopsphere.controller;

import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Collections;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private final ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        int category = parse(req.getParameter("category"), 0);
        int page = parse(req.getParameter("page"), 1);
        String sort = req.getParameter("sort");

        List<Product> products = null;
        try {
            products = dao.search(q, category, sort, page, 12);
        } catch (Exception e) {
            e.printStackTrace();
            try {
                products = dao.findAll();
            } catch (Exception ex) {
                ex.printStackTrace();
                products = Collections.emptyList();
            }
        }

        if (products == null) {
            products = Collections.emptyList();
        }

        req.setAttribute("products", products);
        req.setAttribute("query", q == null ? "" : q);
        req.setAttribute("category", category);
        req.setAttribute("sort", sort == null ? "newest" : sort);
        req.setAttribute("page", page);
        req.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(req, resp);
    }

    private int parse(String v, int fallback) {
        try {
            return v == null ? fallback : Integer.parseInt(v);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}