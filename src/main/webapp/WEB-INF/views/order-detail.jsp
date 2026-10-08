<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>
<%
    Map<String, Object> order = (Map<String, Object>) request.getAttribute("order");
    List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("items");
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Order #<%= order != null ? order.get("orderId") : "" %> — ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<nav class="nav-header">
    <div class="container nav-inner">
        <a class="brand-logo" href="${pageContext.request.contextPath}/">ShopSphere</a>
        <a class="btn ghost" href="${pageContext.request.contextPath}/orders">← Back to orders</a>
    </div>
</nav>
<main class="container section">
    <div class="section-head">
        <div>
            <span class="eyebrow">ORDER RECEIPT</span>
            <h2>Order #<%= order != null ? order.get("orderId") : "" %></h2>
            <p class="muted">Placed on <%= order != null ? order.get("createdAt") : "" %></p>
        </div>
        <div>
            <span class="chip success"><%= order != null ? order.get("orderStatus") : "PLACED" %></span>
        </div>
    </div>
    
    <div class="grid" style="grid-template-columns: 2fr 1fr; gap: 24px;">
        <div class="card">
            <h3>Items in this order</h3>
            <div class="table-wrap" style="margin-top:16px;">
                <table>
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Qty</th>
                        <th>Subtotal</th>
                    </tr>
                    <% if (items != null) { for (Map<String, Object> item : items) { %>
                    <tr>
                        <td><strong><%= item.get("productName") %></strong></td>
                        <td>₹<%= item.get("unitPrice") %></td>
                        <td><%= item.get("quantity") %></td>
                        <td><strong>₹<%= item.get("totalPrice") %></strong></td>
                    </tr>
                    <% } } %>
                </table>
            </div>
        </div>
        
        <div class="card">
            <h3>Order Summary</h3>
            <div style="margin-top:16px; display:flex; flex-direction:column; gap:12px;">
                <div style="display:flex; justify-content:space-between;">
                    <span class="muted">Payment Method</span>
                    <strong><%= order != null ? order.get("paymentMethod") : "COD" %></strong>
                </div>
                <div style="display:flex; justify-content:space-between;">
                    <span class="muted">Payment Status</span>
                    <span class="chip success"><%= order != null ? order.get("paymentStatus") : "PAID" %></span>
                </div>
                <div style="display:flex; justify-content:space-between;">
                    <span class="muted">Shipping Address</span>
                    <strong style="text-align:right; max-width:180px;"><%= order != null ? order.get("shippingAddress") : "Default address" %></strong>
                </div>
                <hr style="border:0; border-top:1px solid var(--line); margin:8px 0;">
                <div style="display:flex; justify-content:space-between; font-size:18px;">
                    <strong>Total Amount</strong>
                    <strong style="color:var(--accent)">₹<%= order != null ? order.get("totalAmount") : "0.00" %></strong>
                </div>
            </div>
        </div>
    </div>
</main>
<footer class="main-footer">
    <div class="container">
        <div class="footer-bottom">
            <span>© 2026 ShopSphere</span>
            <a href="${pageContext.request.contextPath}/products">Continue shopping</a>
        </div>
    </div>
</footer>
</body>
</html>
