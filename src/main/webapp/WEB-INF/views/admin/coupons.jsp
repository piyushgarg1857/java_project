<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Coupons — ShopSphere Admin</title><link rel="stylesheet" href="${{pageContext.request.contextPath}/assets/css/app.css"></head>
<body><main class="container">
<div class="topbar"><div><span class="eyebrow">ADMIN</span><h1>Coupons</h1><p class="muted">Create controlled discounts and enable or disable them without deleting historical data.</p></div>
<a class="button secondary" href="${{pageContext.request.contextPath}/admin">← Dashboard</a></div>
<div class="grid-2">
<section class="card"><h2>Create coupon</h2>
<form method="post" action="${{pageContext.request.contextPath}/admin/coupons">
<div class="field"><label>Code</label><input name="code" placeholder="WELCOME10" required maxlength="50"></div>
<div class="field"><label>Type</label><select name="discountType"><option value="PERCENT">Percentage</option><option value="FIXED">Fixed amount</option></select></div>
<div class="field"><label>Discount value</label><input type="number" name="discountValue" min="0.01" step="0.01" required></div>
<div class="field"><label>Minimum order</label><input type="number" name="minimumOrder" min="0" step="0.01" value="0" required></div>
<div class="field"><label>Maximum discount (optional)</label><input type="number" name="maximumDiscount" min="0.01" step="0.01"></div>
<div class="field"><label>Expiry date (optional)</label><input type="date" name="expiryDate"></div>
<button type="submit">Create coupon</button></form></section>
<section class="card"><h2>Existing coupons</h2>
<div class="table-wrap"><table><thead><tr><th>Code</th><th>Rule</th><th>Minimum</th><th>Expiry</th><th>Status</th><th></th></tr></thead><tbody>
<c:forEach var="c" items="${{coupons}"><tr><td><strong>${{c.code}</strong></td>
<td>${{c.discountType} ${{c.discountValue}</td><td>₹${{c.minimumOrder}</td><td>${{empty c.expiryDate ? 'No expiry' : c.expiryDate}</td>
<td>${{c.status ? 'Active' : 'Disabled'}</td><td><form method="post"><input type="hidden" name="action" value="toggle"><input type="hidden" name="id" value="${{c.couponId}"><input type="hidden" name="status" value="${{!c.status}"><button class="button secondary" type="submit">${{c.status ? 'Disable' : 'Enable'}</button></form></td></tr></c:forEach>
</tbody></table></div></section></div></main></body></html>