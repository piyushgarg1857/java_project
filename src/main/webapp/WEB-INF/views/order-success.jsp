<%@ page contentType="text/html;charset=UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Order Placed — ShopSphere</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/app.css">
    <style>
        .success-card { max-width: 540px; margin: 60px auto; text-align: center; padding: 40px 30px; }
        .success-icon { width: 72px; height: 72px; background: #e6f4ea; color: #137333; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 36px; margin-bottom: 24px; }
    </style>
</head>
<body>
<nav class="nav">
    <div class="container nav-inner">
        <a class="brand" href="<%= ctx %>/">Shop<span>Sphere</span></a>
        <a class="btn ghost" href="<%= ctx %>/orders">My Orders</a>
    </div>
</nav>

<main class="container">
    <div class="card success-card">
        <div class="success-icon">✓</div>
        <span class="eyebrow" style="color:var(--accent);">THANK YOU FOR YOUR ORDER</span>
        <h1 style="margin: 12px 0 8px 0; font-family: var(--font-serif, serif);">Order #${orderId} Placed!</h1>
        <p class="muted">Your order has been confirmed. A receipt has been generated and sent to your email.</p>
        
        <div style="background: var(--bg-body, #fafafa); border: 1px dashed var(--line, #ddd); border-radius: 8px; padding: 16px; margin: 24px 0; text-align: left;">
            <div style="display:flex; justify-content:space-between; margin-bottom: 8px;">
                <span class="muted">Order Number:</span>
                <strong>#${orderId}</strong>
            </div>
            <div style="display:flex; justify-content:space-between; margin-bottom: 8px;">
                <span class="muted">Status:</span>
                <span class="chip success">CONFIRMED</span>
            </div>
            <div style="display:flex; justify-content:space-between;">
                <span class="muted">Payment Method:</span>
                <strong>Cash on Delivery (COD) / Verified</strong>
            </div>
        </div>

        <div style="display:flex; gap: 12px; justify-content: center;">
            <a class="button primary" href="<%= ctx %>/order-detail?orderId=${orderId}">View Order Details</a>
            <a class="button secondary" href="<%= ctx %>/products">Continue Shopping</a>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="container footer-inner">
        <div>© 2026 ShopSphere. All rights reserved.</div>
    </div>
</footer>
</body>
</html>