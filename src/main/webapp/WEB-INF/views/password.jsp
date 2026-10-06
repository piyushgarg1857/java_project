<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Change Password — ShopSphere</title><link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css"></head>
<body><main class="container form-shell"><div class="card"><span class="eyebrow">SECURITY</span><h1 class="form-title">Change password</h1>
<p class="muted">Use 8–128 characters with uppercase, lowercase and a digit.</p>
<% if(request.getAttribute("error")!=null){ %><div class="alert error"><%=request.getAttribute("error")%></div><% } %>
<% if(request.getAttribute("success")!=null){ %><div class="alert success"><%=request.getAttribute("success")%></div><% } %>
<form method="post" action="<%=request.getContextPath()%>/password">
<div class="field"><label>Current password</label><input type="password" name="currentPassword" required></div>
<div class="field"><label>New password</label><input type="password" name="newPassword" minlength="8" maxlength="128" required></div>
<button type="submit" style="width:100%">Change password</button></form>
<p><a href="<%=request.getContextPath()%>/profile">← Back to profile</a></p></div></main></body></html>