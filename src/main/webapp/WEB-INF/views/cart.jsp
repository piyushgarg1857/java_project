<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.shopsphere.model.CartItem" %>
<!doctype html>
<html lang="en">
<body>
<h1>My Cart</h1>
<%
double total = 0;
List<CartItem> items = (List<CartItem>) request.getAttribute("items");
for (CartItem x : items) {
    total += x.getSubtotal();
%>
<div>
  <strong><%=x.getProductName()%></strong>
  — ₹<%=x.getPrice()%> ×
  <form method="post" action="${pageContext.request.contextPath}/cart" style="display:inline">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="productId" value="<%=x.getProductId()%>">
    <input type="number" name="quantity" min="1" value="<%=x.getQuantity()%>" required>
    <button type="submit">Update</button>
  </form>
  = ₹<%=x.getSubtotal()%>
  <form method="post" action="${pageContext.request.contextPath}/cart" style="display:inline">
    <input type="hidden" name="action" value="remove">
    <input type="hidden" name="productId" value="<%=x.getProductId()%>">
    <button type="submit">Remove</button>
  </form>
</div><hr>
<% } %>

<h2>Total: ₹<%=total%></h2>
<% if (items.isEmpty()) { %>
  <p>Your cart is empty.</p>
<% } else { %>
  <p><a href="${pageContext.request.contextPath}/checkout">Proceed to Checkout</a></p>
<% } %>
<p><a href="${pageContext.request.contextPath}/products">Continue shopping</a> | <a href="${pageContext.request.contextPath}/orders">My Orders</a></p>
</body>
</html>
