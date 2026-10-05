package com.shopsphere.service;
import com.shopsphere.dao.*; import com.shopsphere.model.CartItem; import java.sql.SQLException; import java.util.List;
public class OrderService{
 private final CartDAO cart=new CartDAO(); private final AddressDAO address=new AddressDAO(); private final OrderDAO orders=new OrderDAO();
 public int placeOrder(int userId,String line,String city,String state,String pincode)throws SQLException{
  List<CartItem> items=cart.findByUser(userId); if(items.isEmpty()) throw new IllegalStateException("Cart is empty");
  double total=items.stream().mapToDouble(CartItem::getSubtotal).sum();
  int addressId=address.create(userId,line,city,state,pincode); int orderId=orders.create(userId,addressId,items,total); cart.clear(userId); return orderId;
 }
}