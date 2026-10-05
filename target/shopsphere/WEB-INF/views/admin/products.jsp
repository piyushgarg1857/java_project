<%@ page contentType="text/html;charset=UTF-8" %><%@ page import="java.util.List" %>
<!doctype html><html><body><h1>Product Management</h1>
<form method="post" action="${pageContext.request.contextPath}/admin/products">
<select name="categoryId" required><% for(String[] c:(List<String[]>)request.getAttribute("categories")){ if("true".equals(c[3])){ %><option value="<%=c[0]%>"><%=c[1]%></option><% }} %></select>
<input name="name" placeholder="Product name" required><input name="brand" placeholder="Brand">
<input name="price" type="number" step="0.01" placeholder="Price" required><input name="discount" type="number" step="0.01" value="0">
<input name="stock" type="number" value="0" required><input name="imageUrl" placeholder="Image URL"><br>
<textarea name="description" placeholder="Description"></textarea><br><button>Add Product</button>
</form><p><a href="${pageContext.request.contextPath}/admin">Admin Dashboard</a></p></body></html>