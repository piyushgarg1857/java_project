package com.shopsphere.dao;
import com.shopsphere.config.DBConnection; import java.sql.*;
public class WishlistDAO{
 public void add(int u,int p)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement("INSERT IGNORE INTO wishlist(user_id,product_id) VALUES(?,?)")){s.setInt(1,u);s.setInt(2,p);s.executeUpdate();}}
 public void remove(int u,int p)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement("DELETE FROM wishlist WHERE user_id=? AND product_id=?")){s.setInt(1,u);s.setInt(2,p);s.executeUpdate();}}
}