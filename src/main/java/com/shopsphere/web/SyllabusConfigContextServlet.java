package com.shopsphere.web;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(value="/syllabus/config-context", initParams={
        @WebInitParam(name="moduleName", value="ServletConfig and ServletContext")
})
public class SyllabusConfigContextServlet extends HttpServlet {
    @Override public void init(ServletConfig config) throws ServletException {
        super.init(config);
        config.getServletContext().setAttribute("shopSphereAppName", "ShopSphere");
    }
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ServletConfig config=getServletConfig();
        ServletContext context=getServletContext();
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().printf("<h1>%s</h1><p>Init parameter: %s</p><p>Application attribute: %s</p>",
                "ServletConfig / ServletContext Demo",
                config.getInitParameter("moduleName"),
                context.getAttribute("shopSphereAppName"));
    }
}
