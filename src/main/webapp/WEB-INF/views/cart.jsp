<%@ page contentType="text/html;charset=UTF-8" %><%@ page import="java.util.List,com.shopsphere.model.CartItem" %>
<!doctype html><html><body><h1>My Cart</h1>
<% for(CartItem x:(List<CartItem>)request.getAttribute("items")){ %>
<div><strong><%=x.getProductName()%></strong> — ₹<%=x.getPrice()%> × <%=x.getQuantity()%> = ₹<%=x.getSubtotal()%>
<form method="post" action="${pageContext.request.contextPath}/cart" style="display:inline"><input type="hidden" name="action" value="remove"><input type="hidden" name="productId" value="<%=x.getProductId()%>"><button>Remove</button></form></div><hr>
<% } %><a href="${pageContext.request.contextPath}/products">Continue shopping</a></body></html>