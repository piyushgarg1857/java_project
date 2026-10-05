<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Integer status = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    String message = (String) request.getAttribute("jakarta.servlet.error.message");
    if (message == null || message.isBlank()) message = "Something went wrong while processing your request.";
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Error — ShopSphere</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
</head>
<body>
<main class="container form-shell">
  <div class="card">
    <span class="eyebrow">SHOPSPHERE</span>
    <h1 class="form-title"><%= status == null ? "Error" : status %></h1>
    <p class="muted"><%= message %></p>
    <p><a class="button" href="<%=request.getContextPath()%>/products">Back to storefront</a></p>
  </div>
</main>
</body>
</html>
