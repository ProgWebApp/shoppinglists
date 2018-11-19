/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ProductDAO;
import db.daos.ShoppingListCategoryDAO;
import db.daos.ShoppingListDAO;
import db.entities.Product;
import db.entities.ShoppingList;
import db.entities.User;
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
public class ProductListServlet extends HttpServlet {

    private ShoppingListDAO shoppingListDAO;
    private ProductDAO productDAO;
    private ShoppingListCategoryDAO shoppingListCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopping-list storage system", ex);
        }
        try {
            productDAO = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
        }
        try {
            shoppingListCategoryDAO = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shoppingListCategory storage system", ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * @param shoppingListId identifica la lista in questione
     * @param productId identifica il prodotto della lista
     * @param necessary specifica se prodotto è necessario o meno
     * @param action specifica l'azione da eseguire:
     * @ 0 -> toglie il prodotto dalla lista
     * @ 1 -> setta il prodotto come non necessario (comprato)
     * @ 2 -> setta il prodotto come necessario (da comprare)
     * @ 3 -> aggiunge il prodotto alla lista in questione
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("doget");
        /* RECUPER L'UTENTE LOGGATO, SE ESISTE */
        User user = (User) request.getSession().getAttribute("user");

        /* SE NON ESISTE UN UTENTE LOGGATO, RECUPERO L'UTENTE ANONIMO, SE ESISTE */
        String userId = null;
        if (user == null) {
            Cookie[] cookies = request.getCookies();
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userId")) {
                    userId = cookie.getValue();
                }
            }
        }

        /* SE NON ESISTE UTENTE LOGGATO NE UTENTE ANONIMO RESTITUISCO ERRORE */
        if (user == null && userId == null) {
            System.out.println("e1");
            response.setStatus(403);
            return;
        }

        ShoppingList shoppingList = null;
        Product product = null;
        Integer shoppingListId = null;
        Integer productId;
        Integer action;
        Integer quantity = 1;
        Integer permissions = null;

        /* SE UTENTE ANONIMO, RECUPERO LA SUA LISTA, SE ESITE */
        if (userId != null) {
            try {
                shoppingList = shoppingListDAO.getByCookie(userId);
                shoppingListId = shoppingList.getId();
                if (shoppingListId == null) {
                    System.out.println("e1");
                    response.setStatus(403);
                    return;
                }
            } catch (DAOException ex) {
                System.out.println("e2");
                response.setStatus(403);
                return;
            }
        }

        if ((userId != null || request.getParameter("shoppingListId") != null)
                && request.getParameter("productId") != null && request.getParameter("action") != null) {
            try {
                if (user != null) {
                    shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
                }
                productId = Integer.valueOf(request.getParameter("productId"));
                action = Integer.valueOf(request.getParameter("action"));
            } catch (RuntimeException ex) {
                System.out.println("e3");
                response.setStatus(400);
                return;
            }
            try {
                /* CONTROLLO CHE L'UTENTE ABBIA I PERMESSI SULLA LISTA E SUL PRODOTTO */
                if (user != null && shoppingList == null) {
                    shoppingList = shoppingListDAO.getIfVisible(shoppingListId, user.getId());
                    product = productDAO.getIfVisible(productId, user.getId());
                    permissions = shoppingListDAO.getPermission(shoppingListId, user.getId());
                } else if (userId != null) {
                    product = productDAO.getByPrimaryKey(productId);
                    if (product.isReserved()) {
                        product = null;
                    }
                }
                System.out.println(shoppingList);
                System.out.println(product);
                if (shoppingList == null || product == null) {
                    System.out.println("e4");
                    response.setStatus(403);
                    return;
                }
                switch (action) {
                    case 0:
                        if ((user != null && permissions == 2) || userId != null) {
                            shoppingListDAO.removeProduct(shoppingListId, productId);
                        } else {
                            response.setStatus(403);
                            System.out.println("e6");
                        }
                        break;
                    case 1:
                        if ((user != null && (permissions == 1 || permissions == 2)) || userId != null) {
                            shoppingListDAO.updateProduct(shoppingListId, productId, quantity, false);
                        } else {
                            response.setStatus(403);
                            System.out.println("e7");
                        }
                        break;
                    case 2:
                        if ((user != null && (permissions == 1 || permissions == 2)) || userId != null) {
                            shoppingListDAO.updateProduct(shoppingListId, productId, quantity, true);
                        } else {
                            response.setStatus(403);
                            System.out.println("e8");
                        }
                        break;
                    case 3:
                        if (((user != null && permissions == 2) || userId != null) && shoppingListCategoryDAO.hasProductCategory(shoppingList.getListCategoryId(), product.getProductCategoryId())) {
                            shoppingListDAO.addProduct(shoppingListId, productId, quantity, true);
                            if (user != null && productDAO.getByPrimaryKey(productId).isReserved()) {
                                productDAO.shareProductToList(productId, shoppingListId);
                            }
                        } else {
                            response.setStatus(403);
                            System.out.println("e9");
                        }
                        break;
                }
            } catch (DAOException ex) {
                response.setStatus(500);
                System.out.println("e10");
            }
        } else {
            response.setStatus(400);
            System.out.println("e11");
        }
    }

}
