package com.shopsphere.dao;

import com.shopsphere.config.DBConnection;
import com.shopsphere.model.Product;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class ProductAdminDAO {
    public int create(Product p) throws SQLException {
        String sql="INSERT INTO products(category_id,name,brand,description,price,discount,stock,image_url,status) VALUES(?,?,?,?,?,?,?,?,TRUE)";
        try(Connection c=DBConnection.getConnection(); PreparedStatement s=c.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)){
            s.setInt(1,p.getCategoryId()); s.setString(2,p.getName()); s.setString(3,p.getBrand());
            s.setString(4,p.getDescription()); s.setDouble(5,p.getPrice()); s.setDouble(6,p.getDiscount());
            s.setInt(7,p.getStock()); s.setString(8,p.getImageUrl()); s.executeUpdate();
            try(ResultSet rs=s.getGeneratedKeys()){ return rs.next()?rs.getInt(1):0; }
        }
    }

    public boolean update(Product p) throws SQLException {
        String sql="UPDATE products SET category_id=?,name=?,brand=?,description=?,price=?,discount=?,stock=?,image_url=? WHERE product_id=?";
        try(Connection c=DBConnection.getConnection(); PreparedStatement s=c.prepareStatement(sql)){
            s.setInt(1,p.getCategoryId()); s.setString(2,p.getName()); s.setString(3,p.getBrand());
            s.setString(4,p.getDescription()); s.setDouble(5,p.getPrice()); s.setDouble(6,p.getDiscount());
            s.setInt(7,p.getStock()); s.setString(8,p.getImageUrl()); s.setInt(9,p.getProductId());
            return s.executeUpdate()==1;
        }
    }

    public boolean delete(int id) throws SQLException {
        try(Connection c=DBConnection.getConnection(); PreparedStatement s=c.prepareStatement("UPDATE products SET status=FALSE WHERE product_id=?")){
            s.setInt(1,id); return s.executeUpdate()==1;
        }
    }
}
