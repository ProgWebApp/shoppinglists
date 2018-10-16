package filters;

import db.daos.ProductCategoryDAO;
import db.daos.ShoppingListCategoryDAO;
import db.entities.ProductCategory;
import db.entities.ShoppingListCategory;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.exceptions.UniqueConstraintException;
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

public class ShoppingListCategoryFilter implements Filter {

    private ShoppingListCategoryDAO shoppingListCategoryDAO;
    private ProductCategoryDAO productCategoryDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        DAOFactory daoFactory = (DAOFactory) filterConfig.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for shoppingListCategory storage system");
        }
        try {
            shoppingListCategoryDAO = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {

            throw new ServletException("Impossible to get shoppingList category dao", ex);

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

        if (httpRequest.getParameter("shoppingListCategoryId") != null) {
            User user = (User) session.getAttribute("user");
            ShoppingListCategory shoppingListCategory;
            List<ProductCategory> productCategorySelected; 
            try {
                shoppingListCategory = shoppingListCategoryDAO.getByPrimaryKey(Integer.valueOf(httpRequest.getParameter("shoppingListCategoryId")));
                productCategorySelected = shoppingListCategoryDAO.getProductCategories(Integer.valueOf(httpRequest.getParameter("shoppingListCategoryId")));
            } catch (DAOException ex) {
                //ex.printStackTrace();
                httpResponse.sendRedirect(httpResponse.encodeRedirectURL(httpRequest.getAttribute("contextPath") + "noPermissions.jsp0"));
                return;
            }
            if (!user.isAdmin()) {
                //l'utente non è un admin
                httpResponse.sendRedirect(httpResponse.encodeRedirectURL(httpRequest.getAttribute("contextPath") + "noPermissions.jsp1"));
                return;
            }
            httpRequest.setAttribute("shoppingListCategory", shoppingListCategory);
            httpRequest.setAttribute("productCategorySelected", productCategorySelected);    
        }
        List<ProductCategory> productCategories = null;
        try {
            productCategories = productCategoryDAO.getAll();
        } catch (DAOException ex) {
            throw new ServletException("Impossible to get the product categories", ex);
        }
        httpRequest.setAttribute("productCategories", productCategories);
        System.out.println(productCategories);
        chain.doFilter(request, response);
    }

}
