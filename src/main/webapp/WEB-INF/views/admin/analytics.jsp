<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>
<%
    Map<String, Object> summary = (Map<String, Object>) request.getAttribute("summary");
    List<Map<String, Object>> daily = (List<Map<String, Object>>) request.getAttribute("daily");
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Store Analytics — ShopSphere Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<div class="admin-shell">
    <aside class="sidebar">
        <a class="brand" href="${pageContext.request.contextPath}/admin">Shop<span>Sphere</span></a>
        <a class="side-link" href="${pageContext.request.contextPath}/admin">▦ Dashboard</a>
        <a class="side-link" href="${pageContext.request.contextPath}/admin/products">◈ Products</a>
        <a class="side-link" href="${pageContext.request.contextPath}/admin/categories">◇ Categories</a>
        <a class="side-link" href="${pageContext.request.contextPath}/admin/orders">▤ Orders</a>
        <a class="side-link" href="${pageContext.request.contextPath}/admin/coupons">% Coupons</a>
        <a class="side-link" href="${pageContext.request.contextPath}/admin/users">◉ Customers</a>
        <a class="side-link" href="${pageContext.request.contextPath}/admin/reviews">★ Reviews</a>
        <a class="side-link active" href="${pageContext.request.contextPath}/admin/analytics">📊 Analytics</a>
        <a class="side-link" href="${pageContext.request.contextPath}/admin/export">⇩ Export orders</a>
        <a class="side-link" href="${pageContext.request.contextPath}/products">↗ Store</a>
    </aside>
    <main class="admin-main">
        <div class="section-head">
            <div>
                <span class="eyebrow">METRICS</span>
                <h1>Store Analytics</h1>
                <p class="muted">Performance indicators and sales growth metrics.</p>
            </div>
        </div>
        
        <div class="stats" style="grid-template-columns: repeat(4, 1fr); margin-bottom: 24px;">
            <div class="stat">
                <div class="value">₹<%= summary != null ? summary.get("revenue") : "0" %></div>
                <div class="label">Total Revenue</div>
            </div>
            <div class="stat">
                <div class="value"><%= summary != null ? summary.get("orders") : "0" %></div>
                <div class="label">Total Orders</div>
            </div>
            <div class="stat">
                <div class="value"><%= summary != null ? summary.get("users") : "0" %></div>
                <div class="label">Registered Users</div>
            </div>
            <div class="stat">
                <div class="value"><%= summary != null ? summary.get("products") : "0" %></div>
                <div class="label">Active Products</div>
            </div>
        </div>

        <div class="card">
            <h3>Recent Daily Revenue (Last 7 Days)</h3>
            <div class="table-wrap" style="margin-top:16px;">
                <table>
                    <tr>
                        <th>Date</th>
                        <th>Completed Orders</th>
                        <th>Daily Revenue</th>
                    </tr>
                    <% if (daily != null && !daily.isEmpty()) { for (Map<String, Object> d : daily) { %>
                    <tr>
                        <td><strong><%= d.get("day") %></strong></td>
                        <td><%= d.get("orders") %> orders</td>
                        <td><strong style="color:var(--accent)">₹<%= d.get("revenue") %></strong></td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="3" class="empty">No order history available.</td></tr>
                    <% } %>
                </table>
            </div>
        </div>
    </main>
</div>
</body>
</html>
