package com.shopsphere.dao;

import com.shopsphere.config.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    public List<String[]> findAll() throws SQLException {
        List<String[]> rows=new ArrayList<>();
        String sql="SELECT category_id,name,description,status FROM categories ORDER BY category_id DESC";
        try(Connection c=DBConnection.getConnection(); PreparedStatement s=c.prepareStatement(sql); ResultSet rs=s.executeQuery()){
            while(rs.next()) rows.add(new String[]{
                String.valueOf(rs.getInt("category_id")),rs.getString("name"),
                rs.getString("description"),String.valueOf(rs.getBoolean("status"))
            });
        }
        return rows;
    }

    public int create(String name,String description) throws SQLException {
        String sql="INSERT INTO categories(name,description,status) VALUES(?,?,TRUE)";
        try(Connection c=DBConnection.getConnection(); PreparedStatement s=c.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)){
            s.setString(1,name); s.setString(2,description); s.executeUpdate();
            try(ResultSet rs=s.getGeneratedKeys()){ return rs.next()?rs.getInt(1):0; }
        }
    }

    public boolean delete(int id) throws SQLException {
        try(Connection c=DBConnection.getConnection(); PreparedStatement s=c.prepareStatement("UPDATE categories SET status=FALSE WHERE category_id=?")){
            s.setInt(1,id); return s.executeUpdate()==1;
        }
    }
}
