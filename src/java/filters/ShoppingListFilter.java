package filters;

import db.daos.ShoppingListCategoryDAO;
import db.daos.ShoppingListDAO;
import db.entities.ShoppingList;
import db.entities.ShoppingListCategory;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ShoppingListFilter implements Filter {

    private ShoppingListDAO shoppingListDAO;
    private ShoppingListCategoryDAO shoppingListCategoryDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        DAOFactory daoFactory = (DAOFactory) filterConfig.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for shoppingList storage system");
        }
        try {
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get shoppingList dao", ex);
        }
        try {
            shoppingListCategoryDAO = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get shoppingList category dao", ex);
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

        if (httpRequest.getParameter("shoppingListId") != null) {
            User user = (User) session.getAttribute("user");
            ShoppingList shoppingList;
            try {
                shoppingList = shoppingListDAO.getByPrimaryKey(Integer.valueOf(httpRequest.getParameter("shoppingListId")));
            } catch (DAOException ex) {
                //la shoppingList non esiste
                httpResponse.sendRedirect(httpResponse.encodeRedirectURL(httpRequest.getAttribute("contextPath") + "noPermissions.jsp0"));
                return;
            }
            if (!(shoppingList.getOwnerId().intValue()==user.getId().intValue() || user.isAdmin())) {
                //il prodotto è pubblico e l'utente non è un admin
                httpResponse.sendRedirect(httpResponse.encodeRedirectURL(httpRequest.getAttribute("contextPath") + "noPermissions.jsp1"));
                return;
            }

            httpRequest.setAttribute("shoppingList", shoppingList);
        }
        List<ShoppingListCategory> categories;
        try {
            categories = shoppingListCategoryDAO.getAll();
        } catch (DAOException ex) {
            throw new ServletException("Impossible to get the categories", ex);
        }
        httpRequest.setAttribute("shoppingListCategories", categories);
        chain.doFilter(request, response);
    }

}
