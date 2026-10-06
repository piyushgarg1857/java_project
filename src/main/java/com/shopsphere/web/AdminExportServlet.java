package com.shopsphere.web;
import com.shopsphere.config.DBConnection; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.*;
@WebServlet("/admin/export")
public class AdminExportServlet extends HttpServlet {
 protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws IOException{
  resp.setContentType("text/csv;charset=UTF-8"); resp.setHeader("Content-Disposition","attachment; filename=shopsphere-orders.csv");
  try(var out=resp.getWriter();var c=DBConnection.getConnection();var s=c.prepareStatement("SELECT o.order_id,u.email,o.total_amount,o.order_status,o.created_at FROM orders o JOIN users u ON u.user_id=o.user_id ORDER BY o.created_at DESC");var r=s.executeQuery()){
   out.println("order_id,email,total_amount,order_status,created_at");
   while(r.next()){out.printf("%d,%s,%s,%s,%s%n",r.getInt(1),csv(r.getString(2)),r.getBigDecimal(3),csv(r.getString(4)),r.getTimestamp(5));}
  }catch(Exception e){throw new IOException("Unable to export orders",e);}
 }
 private String csv(String v){
  String value=v==null?"":v;
  return "\\\""+value.replace("\\\"","\\\"\\\"")+"\\\"";
 }
}