<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Register - ShopSphere</title></head>
<body>
<h1>Create ShopSphere Account</h1>
<% if(request.getAttribute("error") != null){ %>
<p><%= request.getAttribute("error") %></p>
<% } %>
<form method="post" action="${pageContext.request.contextPath}/register">
<label>Name <input type="text" name="name" required></label><br>
<label>Email <input type="email" name="email" required></label><br>
<label>Mobile <input type="text" name="mobile"></label><br>
<label>Password <input type="password" name="password" minlength="6" required></label><br>
<button type="submit">Register</button>
</form>
<p><a href="${pageContext.request.contextPath}/login">Already have an account?</a></p>
<p><a href="${pageContext.request.contextPath}/">Back to home</a></p>
</body>
</html>
