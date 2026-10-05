package com.shopsphere.service;
import com.shopsphere.dao.UserDAO; import com.shopsphere.model.User; import com.shopsphere.util.PasswordUtil; import com.shopsphere.security.PasswordPolicy; import java.sql.SQLException;
public class AuthService{
 private final UserDAO dao=new UserDAO();
 public boolean register(String n,String e,String p,String m)throws SQLException{if(n==null||n.isBlank()||e==null||e.isBlank()||p==null||!PasswordPolicy.isStrong(p))return false;e=e.trim().toLowerCase();if(dao.findByEmail(e)!=null)return false;User u=new User();u.setName(n.trim());u.setEmail(e);u.setPassword(PasswordUtil.hash(p));u.setMobile(m);return dao.create(u);}
 public User login(String e,String p)throws SQLException{if(e==null||p==null)return null;User u=dao.findByEmail(e.trim().toLowerCase());if(u==null||!PasswordUtil.verify(p,u.getPassword()))return null;if(!u.getPassword().startsWith("PBKDF2$"))dao.updatePassword(u.getUserId(),PasswordUtil.hash(p));u.setPassword(null);return u;}
}