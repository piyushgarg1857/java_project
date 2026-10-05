<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Admin - Categories</title></head>
<body>
<h1>Category Management</h1>
<form method="post" action="${pageContext.request.contextPath}/admin/categories">
<input type="hidden" name="action" value="create">
<input name="name" placeholder="Category name" required>
<input name="description" placeholder="Description">
<button type="submit">Add Category</button>
</form>
<table border="1">
<tr><th>ID</th><th>Name</th><th>Description</th><th>Status</th><th>Action</th></tr>
<% for(String[] row:(List<String[]>)request.getAttribute("categories")){ %>
<tr>
<td><%=row[0]%></td><td><%=row[1]%></td><td><%=row[2]%></td><td><%=row[3]%></td>
<td><form method="post" action="${pageContext.request.contextPath}/admin/categories">
<input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%=row[0]%>">
<button type="submit">Disable</button></form></td>
</tr>
<% } %>
</table>
<a href="${pageContext.request.contextPath}/">Home</a>
</body></html>
