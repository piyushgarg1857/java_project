<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.shopsphere.model.Coupon,com.shopsphere.model.User,java.util.List,com.shopsphere.model.Address" %>
<% String ctx = request.getContextPath(); %>
<% User loggedInUser = (User) session.getAttribute("loggedInUser"); %>
<% Coupon checkoutCoupon = (Coupon) request.getAttribute("checkoutCoupon"); %>
<% String checkoutMessage = (String) session.getAttribute("checkoutMessage"); %>
<% List<Address> savedAddresses = (List<Address>) request.getAttribute("savedAddresses"); %>
<% String rzpKey = (String) request.getAttribute("razorpayKeyId"); %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Checkout — ShopSphere</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/app.css">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        .pay-option { display: flex; align-items: center; gap: 12px; padding: 14px; background: #161616; border: 1px solid rgba(255,255,255,0.14); border-radius: 8px; margin-bottom: 12px; cursor: pointer; transition: all 0.2s ease; }
        .pay-option:hover, .pay-option.active { border-color: var(--accent, #d8c8a8); background: #1f1f1f; }
        .pay-option input[type="radio"] { accent-color: #d8c8a8; width: 18px; height: 18px; }
    </style>
</head>
<body>
<header class="nav-header">
    <div class="container nav-inner">
        <a class="brand-logo" href="<%= ctx %>/">ShopSphere</a>
        <span class="eyebrow">SECURE CHECKOUT</span>
        <a class="btn ghost" href="<%= ctx %>/cart">Back to bag</a>
    </div>
</header>
<main class="container form-shell">
    <div class="card">
        <span class="eyebrow">01 DELIVERY · 02 ORDER · 03 PAYMENT</span>
        <h1 class="form-title">Complete your order.</h1>
        <p class="muted">Select your delivery address and preferred payment method.</p>

        <% if (checkoutMessage != null && !checkoutMessage.isBlank()) { %>
            <div class="notice" style="margin-top:16px;"><%= checkoutMessage %></div>
            <% session.removeAttribute("checkoutMessage"); %>
        <% } %>

        <div class="summary-box" style="margin-top:20px;">
            <div><span>Subtotal</span><strong>₹${cartTotal}</strong></div>
            <div><span>Discount</span><strong>- ₹${couponDiscount}</strong></div>
            <div><span>Payable Total</span><strong style="color:var(--accent,#d8c8a8);">₹${payableTotal}</strong></div>
        </div>

        <!-- Coupon Form -->
        <form method="post" action="<%= ctx %>/checkout" class="coupon-form" style="margin-top:16px;">
            <input name="couponCode" placeholder="Coupon code" value="<%= checkoutCoupon != null ? checkoutCoupon.getCode() : "" %>">
            <button type="submit" name="action" value="applyCoupon" class="btn secondary">Apply</button>
            <% if (checkoutCoupon != null) { %>
                <button type="submit" name="action" value="removeCoupon" class="btn secondary">Remove</button>
            <% } %>
        </form>
        <% if (checkoutCoupon != null) { %>
            <p class="muted" style="font-size:12px; margin-top:6px;">Applied coupon: <strong><%= checkoutCoupon.getCode() %></strong></p>
        <% } %>

        <!-- Main Order Form -->
        <form id="checkoutForm" method="post" action="<%= ctx %>/checkout" style="margin-top:24px;">
            <input type="hidden" name="razorpay_payment_id" id="rzpPaymentId" value="">
            
            <h3 style="font-size:14px; font-weight:600; text-transform:uppercase; letter-spacing:0.08em; color:var(--accent); margin-bottom:12px;">Delivery Address</h3>

            <% if (savedAddresses != null && !savedAddresses.isEmpty()) { %>
                <div style="margin-bottom:16px;">
                    <label style="font-size:12px; color:#a6a19a; display:block; margin-bottom:8px;">Saved Addresses:</label>
                    <% for (Address addr : savedAddresses) { %>
                        <label style="display:flex; align-items:center; gap:10px; margin-bottom:8px; cursor:pointer;">
                            <input type="radio" name="addressId" value="<%= addr.getAddressId() %>" onchange="document.getElementById('manualAddr').style.display='none'">
                            <span style="font-size:13px; color:#f3efe7;"><%= addr.getAddressLine() %>, <%= addr.getCity() %>, <%= addr.getState() %> - <%= addr.getPincode() %></span>
                        </label>
                    <% } %>
                    <label style="display:flex; align-items:center; gap:10px; margin-top:8px; cursor:pointer;">
                        <input type="radio" name="addressId" value="" checked onchange="document.getElementById('manualAddr').style.display='block'">
                        <span style="font-size:13px; color:var(--accent);">Enter New Address</span>
                    </label>
                </div>
            <% } %>

            <div id="manualAddr">
                <div class="field">
                    <label>Street Address</label>
                    <textarea name="addressLine" rows="3" maxlength="255" placeholder="House/Flat No., Street, Area"></textarea>
                </div>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px;">
                    <div class="field">
                        <label>City</label>
                        <input name="city" maxlength="100" placeholder="New Delhi">
                    </div>
                    <div class="field">
                        <label>State</label>
                        <input name="state" maxlength="100" placeholder="Delhi">
                    </div>
                </div>
                <div class="field">
                    <label>Pincode</label>
                    <input name="pincode" pattern="[0-9]{6}" inputmode="numeric" maxlength="6" placeholder="110001">
                </div>
            </div>

            <h3 style="font-size:14px; font-weight:600; text-transform:uppercase; letter-spacing:0.08em; color:var(--accent); margin-top:24px; margin-bottom:12px;">Select Payment Method</h3>

            <label class="pay-option active" onclick="togglePaymentChoice(this)">
                <input type="radio" name="paymentMethod" value="COD" checked>
                <div>
                    <strong style="display:block; color:#f3efe7; font-size:13px;">Cash on Delivery (COD)</strong>
                    <span style="font-size:11px; color:#a6a19a;">Pay with cash when your package is delivered to your doorstep.</span>
                </div>
            </label>

            <label class="pay-option" onclick="togglePaymentChoice(this)">
                <input type="radio" name="paymentMethod" value="RAZORPAY">
                <div>
                    <strong style="display:block; color:#f3efe7; font-size:13px;">Razorpay Online (UPI / Credit & Debit Cards / NetBanking)</strong>
                    <span style="font-size:11px; color:#a6a19a;">Instant secure online payment with Razorpay Test Modal.</span>
                </div>
            </label>

            <button type="button" id="paySubmitBtn" onclick="handleCheckoutSubmit()" style="width:100%; margin-top:20px; padding:14px; font-size:13px; font-weight:bold; letter-spacing:1px; text-transform:uppercase;">
                Place Order (₹${payableTotal})
            </button>
        </form>
    </div>
</main>

<script>
    function togglePaymentChoice(el) {
        document.querySelectorAll('.pay-option').forEach(item => item.classList.remove('active'));
        el.classList.add('active');
        const radio = el.querySelector('input[type="radio"]');
        if (radio) radio.checked = true;
    }

    function handleCheckoutSubmit() {
        const form = document.getElementById('checkoutForm');
        const addressIdRadio = form.querySelector('input[name="addressId"]:checked');

        if (!addressIdRadio || addressIdRadio.value === "") {
            const addrLine = form.querySelector('textarea[name="addressLine"]').value.trim();
            const city = form.querySelector('input[name="city"]').value.trim();
            const state = form.querySelector('input[name="state"]').value.trim();
            const pincode = form.querySelector('input[name="pincode"]').value.trim();

            if (!addrLine || !city || !state || !pincode) {
                alert("Please fill in all address details.");
                return;
            }
        }

        const selectedMethod = form.querySelector('input[name="paymentMethod"]:checked').value;
        const total = "${payableTotal}";

        if (selectedMethod === 'RAZORPAY') {
            const options = {
                "key": "<%= rzpKey != null ? rzpKey : "rzp_test_TlXJYK6hDkOsvX" %>",
                "amount": Math.round(parseFloat(total) * 100),
                "currency": "INR",
                "name": "ShopSphere Luxury E-Commerce",
                "description": "Order Payment",
                "handler": function (response) {
                    document.getElementById('rzpPaymentId').value = response.razorpay_payment_id || "pay_test_success";
                    form.submit();
                },
                "prefill": {
                    "name": "<%= loggedInUser != null ? loggedInUser.getName() : "" %>",
                    "email": "<%= loggedInUser != null ? loggedInUser.getEmail() : "" %>"
                },
                "theme": {
                    "color": "#d8c8a8"
                }
            };
            try {
                const rzp = new Razorpay(options);
                rzp.open();
            } catch (e) {
                console.error("Razorpay error:", e);
                form.submit();
            }
        } else {
            form.submit();
        }
    }
</script>

<footer class="main-footer">
    <div class="container">
        <div class="footer-bottom">
            <span>© 2026 ShopSphere</span>
            <a href="<%= ctx %>/products">Continue shopping</a>
        </div>
    </div>
</footer>
</body>
</html>