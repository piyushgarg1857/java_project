package com.shopsphere.service;
import com.shopsphere.dao.CartDAO; import com.shopsphere.model.CartItem; import java.sql.SQLException; import java.util.List;
public class CartService { private final CartDAO dao=new CartDAO();
 public List<CartItem> getCart(int userId)throws SQLException{return dao.findByUser(userId);}
 public void add(int userId,int productId,int quantity)throws SQLException{dao.add(userId,productId,Math.max(1,quantity));}
 public void remove(int userId,int productId)throws SQLException{dao.remove(userId,productId);}
 public void clear(int userId)throws SQLException{dao.clear(userId);}
}