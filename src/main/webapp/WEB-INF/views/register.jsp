<%@ page contentType="text/html;charset=UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Create Account — ShopSphere</title>
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
        <span class="eyebrow" style="display:block;margin-top:40px">CREATE ACCOUNT</span>
        <h1 class="form-title">Join ShopSphere.</h1>
        <p class="muted">Create a secure account and start exploring the collection.</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert error" style="margin-top:16px;"><%= request.getAttribute("error") %></div>
        <% } %>

        <!-- Google One-Tap & Sign-Up Section -->
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
                 data-text="signup_with"
                 data-size="large"
                 data-logo_alignment="left">
            </div>
        </div>

        <div class="auth-divider"><span>OR REGISTER WITH EMAIL</span></div>

        <form method="post" action="<%= ctx %>/register">
            <div class="field">
                <label>Full name</label>
                <input name="name" required placeholder="John Doe">
            </div>
            <div class="field">
                <label>Email</label>
                <input type="email" name="email" required placeholder="you@example.com">
            </div>
            <div class="field">
                <label>Mobile</label>
                <input name="mobile" placeholder="+91 9876543210">
            </div>
            <div class="field">
                <label>Password</label>
                <input type="password" name="password" minlength="8" maxlength="128" required placeholder="••••••••">
                <small class="muted">8–128 characters with uppercase, lowercase and a digit.</small>
            </div>
            <button type="submit" style="width:100%">Create account</button>
        </form>

        <!-- Hidden Form for Google OAuth Callback -->
        <form id="googleLoginForm" method="post" action="<%= ctx %>/google-login">
            <input type="hidden" name="credential" id="googleCredentialInput">
        </form>

        <p class="muted" style="margin-top:20px; text-align:center;">Already registered? <a href="<%= ctx %>/login" style="color:var(--accent);">Sign in</a></p>
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
