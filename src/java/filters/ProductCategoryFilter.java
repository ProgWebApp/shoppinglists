package filters;

import db.daos.ProductCategoryDAO;
import db.daos.ProductDAO;
import db.entities.Product;
import db.entities.ProductCategory;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.util.List;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ProductCategoryFilter implements Filter {

    private ProductDAO productDAO;
    private ProductCategoryDAO productCategoryDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        DAOFactory daoFactory = (DAOFactory) filterConfig.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDAO = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get product category dao", ex);
        }
    }

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        if (httpRequest.getParameter("productCategoryId") != null) {
            User user = (User) session.getAttribute("user");
            ProductCategory productCategory;
            try {
                productCategory = productCategoryDAO.getByPrimaryKey(Integer.valueOf(httpRequest.getParameter("productCategoryId")));
            } catch (DAOException ex) {
                //la categoria non esiste
                httpResponse.sendRedirect(httpResponse.encodeRedirectURL(httpRequest.getAttribute("contextPath") + "noPermissions.jsp0"));
                return;
            }
            if (!user.isAdmin()) {
                //l'utente non è un admin
                httpResponse.sendRedirect(httpResponse.encodeRedirectURL(httpRequest.getAttribute("contextPath") + "noPermissions.jsp1"));
                return;
            }

            httpRequest.setAttribute("productCategory", productCategory);
        }
        chain.doFilter(request, response);
    }

}
