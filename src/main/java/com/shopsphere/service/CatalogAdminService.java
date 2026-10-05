package com.shopsphere.service;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.ProductAdminDAO;
import com.shopsphere.model.Product;
import java.sql.SQLException;
import java.util.List;

public class CatalogAdminService {
    private final CategoryDAO categoryDAO=new CategoryDAO();
    private final ProductAdminDAO productDAO=new ProductAdminDAO();

    public List<String[]> categories() throws SQLException { return categoryDAO.findAll(); }
    public int createCategory(String name,String description) throws SQLException { return categoryDAO.create(name,description); }
    public boolean deleteCategory(int id) throws SQLException { return categoryDAO.delete(id); }
    public int createProduct(Product p) throws SQLException { return productDAO.create(p); }
    public boolean updateProduct(Product p) throws SQLException { return productDAO.update(p); }
    public boolean deleteProduct(int id) throws SQLException { return productDAO.delete(id); }
}
