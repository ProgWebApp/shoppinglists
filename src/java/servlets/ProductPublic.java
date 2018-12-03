/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ProductCategoryDAO;
import db.daos.ProductDAO;
import db.daos.ShoppingListCategoryDAO;
import db.daos.ShoppingListDAO;
import db.entities.Product;
import db.entities.ProductCategory;
import db.entities.ShoppingList;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pberi
 */
public class ProductPublic extends HttpServlet {

    private ProductDAO productDAO;
    private ShoppingListDAO shoppingListDAO;
    private ShoppingListCategoryDAO shoppingListCategoryDAO;
    private ProductCategoryDAO productCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productDAO = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
        }
        try {
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shoppingList storage system", ex);
        }
        try {
            shoppingListCategoryDAO = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shoppingListCategory storage system", ex);
        }
        try {
            productCategoryDAO = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get product category dao", ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("productId") == null) {
            response.setStatus(400);
            return;
        }

        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer productId;
        try {
            productId = Integer.valueOf(request.getParameter("productId"));
        } catch (NumberFormatException ex) {
            response.setStatus(400);
            return;
        }

        /* RECUPERO IL PRODOTTO E RESTITUISCO ERRORE SE IL PRODOTTO NON ESISTE (O NON E' PUBBLICO) */
        Product product;
        try {
            product = productDAO.getByPrimaryKey(productId);
        } catch (DAOException ex) {
            response.setStatus(500);
            return;
        }
        if (product == null) {
            response.setStatus(403);
            return;
        }
        if (product.isReserved()) {
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "noPermissions.jsp"));
            return;
        }

        /* RECUPERO L'UTENTE NON LOGGATO, SE ESISTE */
        String userId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userId")) {
                    userId = cookie.getValue();
                }
            }
        }

        /* SE L'UTENTE ESISTE RECUPERO LA SUA LISTA*/
        ShoppingList shoppingList = null;
        if (userId != null) {
            try {
                shoppingList = shoppingListDAO.getByCookie(userId);
            } catch (DAOException ex) {
                response.setStatus(500);
                return;
            }
        }

        /* RISPONDO */
        ProductCategory category;
        try {
            category = productCategoryDAO.getByPrimaryKey(product.getProductCategoryId());
            /* SE L'UTENTE HA UNA LISTA, CONTROLLO SE IL PRODOTTO PUO' ESSERE INSERITO */
            if (shoppingList != null && shoppingListCategoryDAO.hasProductCategory(shoppingList.getListCategoryId(), product.getProductCategoryId())) {
                request.setAttribute("myList", shoppingList.getId());
            }
        } catch (DAOException ex) {
            response.setStatus(500);
            return;
        }
        request.setAttribute("product", product);
        request.setAttribute("modifiable", false);
        request.setAttribute("productCategory", category);
        getServletContext().getRequestDispatcher("/product.jsp").forward(request, response);
    }
}
