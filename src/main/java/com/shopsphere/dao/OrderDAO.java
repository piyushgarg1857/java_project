package com.shopsphere.dao;

import com.shopsphere.config.DBConnection;
import com.shopsphere.model.CartItem;
import java.sql.*;
import java.util.List;

public class OrderDAO {
    public int create(int userId, int addressId, List<CartItem> items, double total) throws SQLException {
        String orderSql="INSERT INTO orders(user_id,address_id,total_amount,payment_method,payment_status,order_status) VALUES(?,?,?,'COD','PENDING','PLACED')";
        try(Connection c=DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try(PreparedStatement order=c.prepareStatement(orderSql,Statement.RETURN_GENERATED_KEYS)) {
                order.setInt(1,userId); order.setInt(2,addressId); order.setDouble(3,total);
                order.executeUpdate();
                int orderId;
                try(ResultSet rs=order.getGeneratedKeys()) {
                    if(!rs.next()) throw new SQLException("Order ID was not generated");
                    orderId=rs.getInt(1);
                }
                try(PreparedStatement item=c.prepareStatement("INSERT INTO order_items(order_id,product_id,quantity,price) VALUES(?,?,?,?)")) {
                    for(CartItem x:items) {
                        item.setInt(1,orderId); item.setInt(2,x.getProductId());
                        item.setInt(3,x.getQuantity()); item.setDouble(4,x.getPrice());
                        item.addBatch();
                    }
                    item.executeBatch();
                }
                c.commit();
                return orderId;
            } catch(SQLException e) {
                c.rollback();
                throw e;
            }
        }
    }
}
