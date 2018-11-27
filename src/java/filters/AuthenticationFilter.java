package filters;

import db.entities.User;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthenticationFilter implements Filter {

    private FilterConfig filterConfig = null;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (request instanceof HttpServletRequest && response instanceof HttpServletResponse) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            HttpSession session = ((HttpServletRequest) request).getSession(true);
            User user = null;
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
            if (user == null) {
                if (session != null) {
                    if (httpRequest.getQueryString() != null) {
                        session.setAttribute("destination", httpRequest.getRequestURL() + "?" + httpRequest.getQueryString());
                    } else {
                        session.setAttribute("destination", httpRequest.getRequestURL().toString());
                    }
                }
                httpResponse.sendRedirect(httpResponse.encodeRedirectURL(httpRequest.getAttribute("contextPath") + "login.jsp"));
                return;
            }
        }
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    @Override
    public void destroy() {
    }

}
