package com.shopsphere.dao;
import com.shopsphere.config.DBConnection; import com.shopsphere.model.User; import java.sql.*; import java.util.*;
public class AdminUserDAO {
 public List<User> findAll()throws SQLException{List<User> out=new ArrayList<>();String q="SELECT user_id,name,email,password,mobile,role,status FROM users ORDER BY user_id DESC";try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement(q);ResultSet r=s.executeQuery()){while(r.next()){User u=new User();u.setUserId(r.getInt(1));u.setName(r.getString(2));u.setEmail(r.getString(3));u.setMobile(r.getString(5));u.setRole(r.getString(6));u.setStatus(r.getBoolean(7));out.add(u);}}return out;}
 public void setStatus(int id,boolean status)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement("UPDATE users SET status=? WHERE user_id=?")){s.setBoolean(1,status);s.setInt(2,id);s.executeUpdate();}}
 public void setRole(int id,String role)throws SQLException{if(!"CUSTOMER".equals(role)&&!"ADMIN".equals(role))throw new IllegalArgumentException("Invalid role");try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement("UPDATE users SET role=? WHERE user_id=?")){s.setString(1,role);s.setInt(2,id);s.executeUpdate();}}
}
