<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>ShopSphere - Products</title></head>
<body>
<h1>ShopSphere Products</h1>
<p>
  <a href="${pageContext.request.contextPath}/">Home</a> |
  <a href="${pageContext.request.contextPath}/cart">Cart</a> |
  <a href="${pageContext.request.contextPath}/wishlist">Wishlist</a>
</p>

<c:choose>
<c:when test="${empty products}"><p>No products available yet.</p></c:when>
<c:otherwise>
<c:forEach var="product" items="${products}">
<article>
  <h2>${product.name}</h2>
  <p>Brand: ${product.brand}</p>
  <p>${product.description}</p>
  <strong>₹${product.price}</strong>
  <p>Stock: ${product.stock}</p>

  <c:if test="${product.stock > 0}">
    <form method="post" action="${pageContext.request.contextPath}/cart" style="display:inline">
      <input type="hidden" name="productId" value="${product.productId}">
      <input type="number" name="quantity" value="1" min="1" max="${product.stock}" required>
      <button type="submit">Add to Cart</button>
    </form>
  </c:if>
  <c:if test="${product.stock <= 0}"><span>Out of stock</span></c:if>

  <form method="post" action="${pageContext.request.contextPath}/wishlist" style="display:inline">
    <input type="hidden" name="productId" value="${product.productId}">
    <button type="submit">Add to Wishlist</button>
  </form>
  <hr>
</article>
</c:forEach>
</c:otherwise>
</c:choose>
</body>
</html>
