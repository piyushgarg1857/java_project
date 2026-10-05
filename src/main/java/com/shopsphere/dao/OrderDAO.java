package com.shopsphere.dao;
import com.shopsphere.config.DBConnection; import com.shopsphere.model.CartItem; import java.sql.*; import java.util.List;
public class OrderDAO{
 public int create(int userId,int addressId,List<CartItem> items,double total)throws SQLException{
  String oq="INSERT INTO orders(user_id,address_id,total_amount,payment_method,payment_status,order_status) VALUES(?,?,?,'COD','PENDING','PLACED')";
  try(Connection c=DBConnection.getConnection()){c.setAutoCommit(false);try(PreparedStatement o=c.prepareStatement(oq,Statement.RETURN_GENERATED_KEYS)){o.setInt(1,userId);o.setInt(2,addressId);o.setDouble(3,total);o.executeUpdate();int id;try(ResultSet r=o.getGeneratedKeys()){r.next();id=r.getInt(1);}
   try(PreparedStatement i=c.prepareStatement("INSERT INTO order_items(order_id,product_id,quantity,price) VALUES(?,?,?,?)")){for(CartItem x:items){i.setInt(1,id);i.setInt(2,x.getProductId());i.setInt(3,x.getQuantity());i.setDouble(4,x.getPrice());i.addBatch();}i.executeBatch();}
   c.commit();return id;}catch(Exception e){c.rollback();throw e;}}
 }
}