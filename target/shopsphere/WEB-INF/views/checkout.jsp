<%@ page contentType="text/html;charset=UTF-8" %><!doctype html><html><body><h1>Checkout</h1>
<form method="post" action="${pageContext.request.contextPath}/checkout">
<textarea name="addressLine" placeholder="Address" required></textarea><br><input name="city" placeholder="City" required><br><input name="state" placeholder="State" required><br><input name="pincode" placeholder="Pincode" required><br><button>Place COD Order</button>
</form></body></html>