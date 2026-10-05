package com.shopsphere.config;
import java.sql.*;
public final class DBConnection {
 private static final String DEFAULT_URL="jdbc:mysql://localhost:3306/shopsphere?useSSL=false&serverTimezone=UTC";
 private DBConnection(){}
 static{try{Class.forName("com.mysql.cj.jdbc.Driver");}catch(ClassNotFoundException e){throw new ExceptionInInitializerError(e);}}
 public static Connection getConnection()throws SQLException{
  String url=required("SHOPSPHERE_DB_URL",DEFAULT_URL);
  String user=required("SHOPSPHERE_DB_USER",null);
  String password=required("SHOPSPHERE_DB_PASSWORD",null);
  return DriverManager.getConnection(url,user,password);
 }
 private static String required(String key,String fallback){
  String v=System.getenv(key);
  if(v==null||v.isBlank()) {
   if(fallback!=null) return fallback;
   throw new IllegalStateException(key+" environment variable is required.");
  }
  return v;
 }
}
