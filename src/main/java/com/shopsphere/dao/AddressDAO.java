package com.shopsphere.dao;
import com.shopsphere.config.DBConnection; import java.sql.*;
public class AddressDAO{
 public int create(int userId,String line,String city,String state,String pincode)throws SQLException{
  String q="INSERT INTO addresses(user_id,address_line,city,state,pincode,address_type) VALUES(?,?,?,?,?,'SHIPPING')";
  try(Connection c=DBConnection.getConnection();PreparedStatement s=c.prepareStatement(q,Statement.RETURN_GENERATED_KEYS)){
   s.setInt(1,userId);s.setString(2,line);s.setString(3,city);s.setString(4,state);s.setString(5,pincode);s.executeUpdate();
   try(ResultSet r=s.getGeneratedKeys()){r.next();return r.getInt(1);}
  }
 }
}