<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>
<%
    Map<String, Object> order = (Map<String, Object>) request.getAttribute("order");
    List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("items");
    String ctx = request.getContextPath();
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Order #<%= order != null ? order.get("orderId") : "" %> — ShopSphere</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/app.css">
</head>
<body>
<nav class="nav">
    <div class="container nav-inner">
        <a class="brand" href="<%= ctx %>/">Shop<span>Sphere</span></a>
        <a class="btn ghost" href="<%= ctx %>/orders">← Back to my orders</a>
    </div>
</nav>
<main class="container section">
    <div class="section-head">
        <div>
            <span class="eyebrow">ORDER RECEIPT</span>
            <h2>Order #<%= order != null ? order.get("orderId") : "" %></h2>
            <p class="muted">Placed on <%= order != null ? order.get("createdAt") : "" %></p>
        </div>
        <div style="display:flex; gap:12px; align-items:center;">
            <% if (order != null && order.get("orderId") != null) { %>
                <a href="<%= ctx %>/invoice?orderId=<%= order.get("orderId") %>" target="_blank" class="btn secondary" style="display:inline-flex; align-items:center; gap:8px;">
                    📄 Download Tax Invoice (PDF)
                </a>
            <% } %>
            <span class="chip success"><%= order != null ? order.get("orderStatus") : "PLACED" %></span>
        </div>
    </div>

    <!-- Order Progress Timeline -->
    <%
        String status = order != null && order.get("orderStatus") != null ? order.get("orderStatus").toString().toUpperCase() : "PLACED";
        int step = 1;
        if ("PROCESSING".equals(status)) step = 2;
        else if ("SHIPPED".equals(status)) step = 3;
        else if ("DELIVERED".equals(status)) step = 4;
        else if ("CANCELLED".equals(status)) step = -1;
    %>
    <div class="card" style="margin-bottom: 24px; padding: 28px 24px; background: #0e0e0e; border: 1px solid rgba(216, 200, 168, 0.15); border-radius: 12px;">
        <h4 style="font-size: 13px; text-transform: uppercase; letter-spacing: 1.5px; color: #d8c8a8; margin-bottom: 24px;">Order Status Tracker</h4>
        <% if (step == -1) { %>
            <div style="padding: 16px; background: rgba(220, 53, 69, 0.1); border: 1px solid #dc3545; color: #ff6b6b; border-radius: 8px; text-align: center; font-weight: 600;">
                ⚠️ This order has been CANCELLED.
            </div>
        <% } else { %>
            <div style="display: flex; justify-content: space-between; position: relative; margin: 0 20px;">
                <!-- Connecting Line -->
                <div style="position: absolute; top: 14px; left: 0; right: 0; height: 3px; background: #222; z-index: 1;"></div>
                <div style="position: absolute; top: 14px; left: 0; width: <%= (step - 1) * 33.33 %>%; height: 3px; background: linear-gradient(90deg, #d8c8a8, #b59a5b); z-index: 1; transition: width 0.4s ease;"></div>

                <!-- Step 1: Placed -->
                <div style="position: relative; z-index: 2; text-align: center;">
                    <div style="width: 30px; height: 30px; border-radius: 50%; background: <%= step >= 1 ? "#d8c8a8" : "#222" %>; color: #000; display: flex; align-items: center; justify-content: center; font-weight: bold; margin: 0 auto; box-shadow: <%= step >= 1 ? "0 0 12px rgba(216, 200, 168, 0.5)" : "none" %>;">
                        <%= step >= 1 ? "✓" : "1" %>
                    </div>
                    <div style="margin-top: 10px; font-size: 13px; font-weight: <%= step == 1 ? "bold" : "500" %>; color: <%= step >= 1 ? "#fff" : "#666" %>;">Placed</div>
                </div>

                <!-- Step 2: Processing -->
                <div style="position: relative; z-index: 2; text-align: center;">
                    <div style="width: 30px; height: 30px; border-radius: 50%; background: <%= step >= 2 ? "#d8c8a8" : "#222" %>; color: #000; display: flex; align-items: center; justify-content: center; font-weight: bold; margin: 0 auto; box-shadow: <%= step >= 2 ? "0 0 12px rgba(216, 200, 168, 0.5)" : "none" %>;">
                        <%= step >= 2 ? "✓" : "2" %>
                    </div>
                    <div style="margin-top: 10px; font-size: 13px; font-weight: <%= step == 2 ? "bold" : "500" %>; color: <%= step >= 2 ? "#fff" : "#666" %>;">Processing</div>
                </div>

                <!-- Step 3: Shipped -->
                <div style="position: relative; z-index: 2; text-align: center;">
                    <div style="width: 30px; height: 30px; border-radius: 50%; background: <%= step >= 3 ? "#d8c8a8" : "#222" %>; color: #000; display: flex; align-items: center; justify-content: center; font-weight: bold; margin: 0 auto; box-shadow: <%= step >= 3 ? "0 0 12px rgba(216, 200, 168, 0.5)" : "none" %>;">
                        <%= step >= 3 ? "✓" : "3" %>
                    </div>
                    <div style="margin-top: 10px; font-size: 13px; font-weight: <%= step == 3 ? "bold" : "500" %>; color: <%= step >= 3 ? "#fff" : "#666" %>;">Shipped</div>
                </div>

                <!-- Step 4: Delivered -->
                <div style="position: relative; z-index: 2; text-align: center;">
                    <div style="width: 30px; height: 30px; border-radius: 50%; background: <%= step >= 4 ? "#28a745" : "#222" %>; color: <%= step >= 4 ? "#fff" : "#666" %>; display: flex; align-items: center; justify-content: center; font-weight: bold; margin: 0 auto; box-shadow: <%= step >= 4 ? "0 0 12px rgba(40, 167, 69, 0.5)" : "none" %>;">
                        <%= step >= 4 ? "✓" : "4" %>
                    </div>
                    <div style="margin-top: 10px; font-size: 13px; font-weight: <%= step == 4 ? "bold" : "500" %>; color: <%= step >= 4 ? "#28a745" : "#666" %>;">Delivered</div>
                </div>
            </div>
        <% } %>
    </div>
    
    <div class="grid" style="grid-template-columns: 2fr 1fr; gap: 24px;">
        <div class="card">
            <h3>Items in this order</h3>
            <div class="table-wrap" style="margin-top:16px;">
                <table>
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Price</th>
                            <th>Qty</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (items != null && !items.isEmpty()) { 
                            for (Map<String, Object> item : items) { %>
                        <tr>
                            <td><strong><%= item.get("productName") %></strong></td>
                            <td>₹<%= item.get("unitPrice") %></td>
                            <td><%= item.get("quantity") %></td>
                            <td><strong>₹<%= item.get("totalPrice") %></strong></td>
                        </tr>
                        <%  } 
                           } else { %>
                        <tr>
                            <td colspan="4" class="empty">No item details found for this order.</td>
                        </tr>
                        <% } %>
                    </tbody>
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
<footer class="footer">
    <div class="container footer-inner">
        <div>© 2026 ShopSphere. All rights reserved.</div>
        <div>
            <a href="<%= ctx %>/products" class="muted">Continue shopping</a>
        </div>
    </div>
</footer>
</body>
</html>

