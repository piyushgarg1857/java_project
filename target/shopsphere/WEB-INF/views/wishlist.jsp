<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head><meta charset="UTF-8"><title>My Wishlist - ShopSphere</title></head>
<body>
<h1>My Wishlist</h1>
<c:choose>
  <c:when test="${empty products}"><p>Your wishlist is empty.</p></c:when>
  <c:otherwise>
    <c:forEach var="product" items="${products}">
      <article>
        <h2>${product.name}</h2>
        <p>${product.brand}</p>
        <p>₹${product.price} | Stock: ${product.stock}</p>
        <form method="post" action="${pageContext.request.contextPath}/cart" style="display:inline">
          <input type="hidden" name="productId" value="${product.productId}">
          <input type="hidden" name="quantity" value="1">
          <button type="submit" ${product.stock <= 0 ? 'disabled' : ''}>Add to Cart</button>
        </form>
        <form method="post" action="${pageContext.request.contextPath}/wishlist" style="display:inline">
          <input type="hidden" name="action" value="remove">
          <input type="hidden" name="productId" value="${product.productId}">
          <button type="submit">Remove</button>
        </form>
        <hr>
      </article>
    </c:forEach>
  </c:otherwise>
</c:choose>
<p><a href="${pageContext.request.contextPath}/products">Continue Shopping</a> | <a href="${pageContext.request.contextPath}/cart">Cart</a></p>
</body>
</html>
