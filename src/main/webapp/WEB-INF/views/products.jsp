<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>ShopSphere - Products</title>
</head>
<body>
<h1>ShopSphere Products</h1>
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
<hr>
</article>
</c:forEach>
</c:otherwise>
</c:choose>
<a href="${pageContext.request.contextPath}/">Home</a>
</body>
</html>
