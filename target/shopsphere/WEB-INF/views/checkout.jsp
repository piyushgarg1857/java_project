<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Checkout — ShopSphere</title><link rel="stylesheet" href="${{pageContext.request.contextPath}/assets/css/app.css"></head>
<body><main class="container form-shell"><div class="card"><span class="eyebrow">CHECKOUT</span><h1 class="form-title">Delivery details</h1>
<p class="muted">Cash on Delivery is available. Apply an eligible coupon before placing the order.</p>
<c:if test="${{not empty sessionScope.checkoutMessage}"><div class="notice">${{sessionScope.checkoutMessage}</div></c:if>
<div class="summary-box"><div><span>Subtotal</span><strong>₹${{cartTotal}</strong></div>
<div><span>Discount</span><strong>- ₹${{couponDiscount}</strong></div><div><span>Payable</span><strong>₹${{payableTotal}</strong></div></div>
<form method="post" action="${{pageContext.request.contextPath}/checkout" class="coupon-form">
<input name="couponCode" placeholder="Coupon code" value="${{checkoutCoupon.code}">
<button type="submit" name="action" value="applyCoupon" class="button secondary">Apply</button>
<c:if test="${{not empty checkoutCoupon}"><button type="submit" name="action" value="removeCoupon" class="button secondary">Remove</button></c:if>
</form>
<c:if test="${{not empty checkoutCoupon}"><p class="muted">Applied: <strong>${{checkoutCoupon.code}</strong></p></c:if>
<form method="post" action="${{pageContext.request.contextPath}/checkout">
<div class="field"><label>Address</label><textarea name="addressLine" rows="4" required maxlength="255"></textarea></div>
<div class="field"><label>City</label><input name="city" required maxlength="100"></div>
<div class="field"><label>State</label><input name="state" required maxlength="100"></div>
<div class="field"><label>Pincode</label><input name="pincode" pattern="[0-9]{6}" inputmode="numeric" maxlength="6" required></div>
<button type="submit" style="width:100%">Place COD order →</button></form>
<p><a href="${{pageContext.request.contextPath}/cart">← Back to cart</a></p></div></main></body></html>