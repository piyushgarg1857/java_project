<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.shopsphere.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>ShopSphere</title></head>
<body>
<h1>ShopSphere</h1>
<p>RTU Advanced Java E-Commerce Project</p>
<%
User loggedInUser=(User)session.getAttribute("loggedInUser");
if(loggedInUser==null){
%>
<p><a href="${pageContext.request.contextPath}/login">Login</a> | <a href="${pageContext.request.contextPath}/register">Register</a></p>
<% } else { %>
<p>Welcome, <strong><%= loggedInUser.getName() %></strong></p>
<p><a href="${pageContext.request.contextPath}/logout">Logout</a></p>
<% } %>
<p><a href="${pageContext.request.contextPath}/products">Browse Products</a></p>
</body>
</html>
