<%@ page contentType="text/html;charset=UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Sign In — ShopSphere</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/app.css">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <style>
        .auth-divider { display: flex; align-items: center; margin: 20px 0; color: var(--muted, #706b64); font-size: 11px; letter-spacing: 0.1em; text-transform: uppercase; }
        .auth-divider::before, .auth-divider::after { content: ""; flex: 1; border-bottom: 1px solid var(--line, rgba(255,255,255,.12)); }
        .auth-divider span { padding: 0 12px; }
        .google-btn { display: flex; align-items: center; justify-content: center; gap: 10px; width: 100%; padding: 12px; background: #161616; border: 1px solid var(--line, rgba(255,255,255,.18)); color: var(--text, #f3efe7); font-size: 12px; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; cursor: pointer; transition: all 0.25s ease; }
        .google-btn:hover { background: #222; border-color: var(--accent, #d8c8a8); color: var(--accent, #d8c8a8); }
    </style>
</head>
<body>
<main class="container form-shell">
    <div class="card">
        <a class="brand-logo" href="<%= ctx %>/">ShopSphere</a>
        <span class="eyebrow" style="display:block;margin-top:40px">ACCOUNT</span>
        <h1 class="form-title">Welcome back.</h1>
        <p class="muted">Sign in to manage your bag, wishlist and orders.</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert error" style="margin-top:16px;"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if ("true".equals(request.getParameter("registered"))) { %>
            <div class="alert success" style="margin-top:16px;">Registration successful. Please sign in.</div>
        <% } %>

        <!-- Google One-Tap & Sign-In Section -->
        <div style="margin-top:24px; display:flex; justify-content:center;">
            <div id="g_id_onload"
                 data-client_id="849204910294-shopsphere-google-oauth.apps.googleusercontent.com"
                 data-callback="handleGoogleCredential"
                 data-auto_prompt="true">
            </div>

            <div class="g_id_signin"
                 data-type="standard"
                 data-shape="rectangular"
                 data-theme="dark"
                 data-text="continue_with"
                 data-size="large"
                 data-logo_alignment="left">
            </div>
        </div>

        <div class="auth-divider"><span>OR SIGN IN WITH EMAIL</span></div>

        <form method="post" action="<%= ctx %>/login">
            <div class="field">
                <label>Email</label>
                <input type="email" name="email" autocomplete="email" required placeholder="you@example.com">
            </div>
            <div class="field">
                <label>Password</label>
                <input type="password" name="password" autocomplete="current-password" required placeholder="••••••••">
            </div>
            <button type="submit" style="width:100%">Sign in</button>
        </form>

        <!-- Hidden Form for Google OAuth Callback -->
        <form id="googleLoginForm" method="post" action="<%= ctx %>/google-login">
            <input type="hidden" name="credential" id="googleCredentialInput">
        </form>

        <p class="muted" style="margin-top:20px; text-align:center;">New here? <a href="<%= ctx %>/register" style="color:var(--accent);">Create an account</a></p>
        <div style="text-align:center; margin-top:12px;">
            <a class="btn ghost" href="<%= ctx %>/">Back home</a>
        </div>
    </div>
</main>

<script>
    function handleGoogleCredential(response) {
        if (response && response.credential) {
            document.getElementById("googleCredentialInput").value = response.credential;
            document.getElementById("googleLoginForm").submit();
        }
    }
</script>
</body>
</html>
