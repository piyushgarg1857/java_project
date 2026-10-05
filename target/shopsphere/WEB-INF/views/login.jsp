<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Login - ShopSphere</title></head>
<body>
<h1>ShopSphere Login</h1>
<% if(request.getAttribute("error") != null){ %>
<p><%= request.getAttribute("error") %></p>
<% } %>
<% if("true".equals(request.getParameter("registered"))){ %>
<p>Registration successful. Please login.</p>
<% } %>
<form method="post" action="${pageContext.request.contextPath}/login">
<label>Email <input type="email" name="email" required></label><br>
<label>Password <input type="password" name="password" required></label><br>
<button type="submit">Login</button>
</form>
<p><a href="${pageContext.request.contextPath}/register">Create account</a></p>
<p><a href="${pageContext.request.contextPath}/">Back to home</a></p>
</body>
</html>
