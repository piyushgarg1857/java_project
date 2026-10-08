package com.shopsphere.controller;

import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.User;
import com.shopsphere.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet({"/google-oauth", "/google-callback"})
public class GoogleOAuthServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(GoogleOAuthServlet.class.getName());
    private final UserDAO userDao = new UserDAO();

    private static final String CLIENT_ID = System.getenv().getOrDefault(
        "GOOGLE_CLIENT_ID", "849204910294-shopsphere-google-oauth.apps.googleusercontent.com"
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if ("/google-oauth".equals(servletPath)) {
            // Determine dynamic redirect URI
            String scheme = req.getScheme();
            String serverName = req.getServerName();
            int port = req.getServerPort();
            String contextPath = req.getContextPath();

            String redirectUri;
            if ("localhost".equalsIgnoreCase(serverName) || "127.0.0.1".equals(serverName)) {
                redirectUri = scheme + "://" + serverName + (port != 80 && port != 443 ? ":" + port : "") + contextPath + "/google-callback";
            } else {
                redirectUri = "https://" + serverName + contextPath + "/google-callback";
            }

            String googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + URLEncoder.encode(CLIENT_ID, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                + "&response_type=token"
                + "&scope=" + URLEncoder.encode("openid email profile", StandardCharsets.UTF_8)
                + "&prompt=select_account";

            LOGGER.info("[GOOGLE OAUTH REDIRECT] Redirecting user to Google Account Selection screen...");
            resp.sendRedirect(googleAuthUrl);
            return;
        }

        if ("/google-callback".equals(servletPath)) {
            // Handle OAuth2 Implicit Flow hash fragment or access token
            String accessToken = req.getParameter("access_token");
            String email = req.getParameter("email");
            String name = req.getParameter("name");

            if (accessToken != null && !accessToken.isBlank()) {
                // Fetch profile directly from Google UserInfo API
                String[] googleProfile = fetchGoogleUserInfo(accessToken);
                if (googleProfile != null) {
                    email = googleProfile[0];
                    name = googleProfile[1];
                }
            }

            // If token in URL hash fragment on client-side, return HTML token reader
            if (email == null || email.isBlank()) {
                resp.setContentType("text/html;charset=UTF-8");
                resp.getWriter().write(buildCallbackClientHtml(req.getContextPath()));
                return;
            }

            processGoogleLogin(email, name, req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String name = req.getParameter("name");
        String accessToken = req.getParameter("access_token");

        if (accessToken != null && !accessToken.isBlank()) {
            String[] profile = fetchGoogleUserInfo(accessToken);
            if (profile != null) {
                email = profile[0];
                name = profile[1];
            }
        }

        if (email != null && !email.isBlank()) {
            processGoogleLogin(email, name, req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }

    private void processGoogleLogin(String email, String name, HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            email = email.trim().toLowerCase();
            if (name == null || name.isBlank()) {
                name = email.split("@")[0];
            }

            User user = userDao.findByEmail(email);
            if (user == null) {
                user = new User();
                user.setName(name);
                user.setEmail(email);
                user.setPassword(PasswordUtil.hash("G_OAUTH_" + UUID.randomUUID().toString()));
                user.setMobile("");
                user.setRole("CUSTOMER");
                user.setStatus(true);

                userDao.create(user);
                user = userDao.findByEmail(email);

                com.shopsphere.service.EmailService.sendOrderReceiptAsync(email, name, 0, 0.0);
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("loggedInUser", user);
            LOGGER.info("[GOOGLE OAUTH SUCCESS] User logged in: " + email);

            resp.sendRedirect(req.getContextPath() + "/");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Google login error", e);
            req.setAttribute("error", "Google authentication failed.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }

    private String[] fetchGoogleUserInfo(String accessToken) {
        try {
            URL url = new URL("https://www.googleapis.com/oauth2/v3/userinfo");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            if (conn.getResponseCode() == 200) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder json = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) json.append(line);
                    String body = json.toString();
                    String email = extractJsonField(body, "email");
                    String name = extractJsonField(body, "name");
                    return new String[]{email, name};
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to fetch Google userinfo", e);
        }
        return null;
    }

    private String extractJsonField(String json, String key) {
        String searchKey = "\"" + key + "\":";
        int idx = json.indexOf(searchKey);
        if (idx == -1) return null;
        int start = idx + searchKey.length();
        while (start < json.length() && (json.charAt(start) == ' ' || json.charAt(start) == '"')) {
            start++;
        }
        int end = start;
        while (end < json.length() && json.charAt(end) != '"' && json.charAt(end) != ',' && json.charAt(end) != '}') {
            end++;
        }
        return json.substring(start, end).trim();
    }

    private String buildCallbackClientHtml(String contextPath) {
        return "<!doctype html><html><head><title>Google Sign-In Callback</title></head><body>"
             + "<p style='font-family:sans-serif; text-align:center; margin-top:50px;'>Connecting to Google Account...</p>"
             + "<form id='cbForm' method='post' action='" + contextPath + "/google-callback'>"
             + "<input type='hidden' name='access_token' id='atInput'>"
             + "<input type='hidden' name='email' id='emailInput'>"
             + "<input type='hidden' name='name' id='nameInput'>"
             + "</form>"
             + "<script>"
             + "var hash = window.location.hash.substring(1);"
             + "var params = new URLSearchParams(hash);"
             + "var token = params.get('access_token');"
             + "if (token) {"
             + "  document.getElementById('atInput').value = token;"
             + "  document.getElementById('cbForm').submit();"
             + "} else {"
             + "  window.location.href = '" + contextPath + "/login';"
             + "}"
             + "</script></body></html>";
    }
}
