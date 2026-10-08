<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.shopsphere.model.Address" %>
<% List<Address> addresses = (List<Address>) request.getAttribute("addresses"); %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Saved Addresses — ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<header class="nav-header">
    <div class="container nav-inner">
        <nav class="nav-menu">
            <a class="nav-link" href="${pageContext.request.contextPath}/">Shop</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/products">Collections</a>
        </nav>
        <a class="brand-logo" href="${pageContext.request.contextPath}/">ShopSphere</a>
        <div>
            <a class="btn ghost" href="${pageContext.request.contextPath}/profile">Profile</a>
            <a class="btn ghost" href="${pageContext.request.contextPath}/orders">Orders</a>
        </div>
    </div>
</header>
<main class="container section">
    <div class="section-head">
        <div>
            <span class="eyebrow">ACCOUNT</span>
            <h2>Saved addresses</h2>
            <p class="muted">Manage your shipping and billing locations.</p>
        </div>
        <a class="btn ghost" href="${pageContext.request.contextPath}/profile">← Back to profile</a>
    </div>
    
    <div class="grid" style="grid-template-columns: 1fr 2fr; gap: 24px;">
        <section class="card">
            <h3>Add shipping address</h3>
            <form method="post" action="${pageContext.request.contextPath}/addresses" style="margin-top:16px;">
                <div class="field"><label>Address Line</label><input name="addressLine" maxlength="255" required placeholder="Street address, apartment"></div>
                <div class="field"><label>City</label><input name="city" maxlength="100" required placeholder="City"></div>
                <div class="field"><label>State</label><input name="state" maxlength="100" required placeholder="State"></div>
                <div class="field"><label>Pincode</label><input name="pincode" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required placeholder="6-digit PIN"></div>
                <button type="submit" style="width:100%; margin-top:8px;">Save address</button>
            </form>
        </section>
        
        <section class="card">
            <h3>Your saved locations</h3>
            <div style="margin-top:16px; display:flex; flex-direction:column; gap:12px;">
                <% if (addresses == null || addresses.isEmpty()) { %>
                <div class="card empty"><p class="muted">No saved addresses yet. Add a location to speed up checkout.</p></div>
                <% } else { for (Address a : addresses) { %>
                <div class="card" style="display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        <strong><%= a.getAddressLine() %></strong>
                        <div class="muted"><%= a.getCity() %>, <%= a.getState() %> — <%= a.getPincode() %></div>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/addresses">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="addressId" value="<%= a.getAddressId() %>">
                        <button class="btn danger" type="submit">Delete</button>
                    </form>
                </div>
                <% } } %>
            </div>
        </section>
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
