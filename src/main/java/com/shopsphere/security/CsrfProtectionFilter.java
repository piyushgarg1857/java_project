package com.shopsphere.security;

import com.shopsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URI;

@WebFilter("/*")
public class CsrfProtectionFilter implements Filter {
    private static final String[] SAFE = {"GET", "HEAD", "OPTIONS"};

    private boolean safe(String method) {
        for (String m : SAFE) if (m.equalsIgnoreCase(method)) return true;
        return false;
    }

    private boolean sameOrigin(String value, HttpServletRequest request) {
        if (value == null || value.isBlank()) return false;
        try {
            URI origin = URI.create(value);
            int port = origin.getPort() == -1 ? request.getScheme().equalsIgnoreCase("https") ? 443 : 80 : origin.getPort();
            int requestPort = request.getServerPort();
            return origin.getScheme().equalsIgnoreCase(request.getScheme())
                    && origin.getHost().equalsIgnoreCase(request.getServerName())
                    && port == requestPort;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest http = (HttpServletRequest) request;
        HttpServletResponse out = (HttpServletResponse) response;

        if (safe(http.getMethod()) || http.getSession(false) == null
                || http.getSession(false).getAttribute("loggedInUser") == null) {
            chain.doFilter(request, response);
            return;
        }

        String origin = http.getHeader("Origin");
        String referer = http.getHeader("Referer");
        if (!sameOrigin(origin, http) && !sameOrigin(referer, http)) {
            out.sendError(HttpServletResponse.SC_FORBIDDEN, "Cross-site request blocked.");
            return;
        }

        chain.doFilter(request, response);
    }
}
