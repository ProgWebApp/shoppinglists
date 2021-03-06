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
import java.io.PrintWriter;
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
     * productId identifica il prodotto della lista
     * necessary specifica se prodotto è necessario o meno
     * action specifica l'azione da eseguire:
     *  0: toglie il prodotto dalla lista
     *  1: setta il prodotto come non necessario (comprato)
     *  2: setta il prodotto come necessario (da comprare)
     *  3: aggiunge il prodotto alla lista in questione
     *
     * @param request servlet request
     * @param response servlet response
     * @throws IOException if an I/O error occurs
     * @throws ServletException if a servlet-specific error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPER L'UTENTE LOGGATO, SE ESISTE */
        User user = (User) request.getSession().getAttribute("user");

        /* SE NON ESISTE UN UTENTE LOGGATO, RECUPERO L'UTENTE ANONIMO, SE ESISTE */
        String userId = null;
        if (user == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("userId")) {
                        userId = cookie.getValue();
                    }
                }
            }
        }

        /* SE NON ESISTE UTENTE LOGGATO NE UTENTE ANONIMO RESTITUISCO ERRORE */
        if (user == null && userId == null) {
            response.sendError(403);
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
                    response.sendError(400);
                    return;
                }
            } catch (DAOException ex) {
                response.sendError(500);
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
                response.sendError(500);
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
                    response.sendError(403);
                    return;
                }
                switch (action) {
                    case 0:
                        if ((user != null && permissions == 2) || userId != null) {
                            shoppingListDAO.removeProduct(shoppingListId, productId);
                        } else {
                            response.sendError(403);
                        }
                        break;
                    case 1:
                        if ((user != null && (permissions == 1 || permissions == 2)) || userId != null) {
                            shoppingListDAO.updateProduct(shoppingListId, productId, quantity, false);
                        } else {
                            response.sendError(403);
                        }
                        break;
                    case 2:
                        if ((user != null && (permissions == 1 || permissions == 2)) || userId != null) {
                            shoppingListDAO.updateProduct(shoppingListId, productId, quantity, true);
                        } else {
                            response.sendError(403);
                        }
                        break;
                    case 3:
                        if (((user != null && permissions == 2) || userId != null) && shoppingListCategoryDAO.hasProductCategory(shoppingList.getListCategoryId(), product.getProductCategoryId())) {
                            shoppingListDAO.addProduct(shoppingListId, productId, quantity, true);
                            if (user != null && productDAO.getByPrimaryKey(productId).isReserved()) {
                                productDAO.shareProductToList(productId, shoppingListId);
                            }
                            StringBuilder sb = new StringBuilder();
                            sb.append("{\"product\": ");
                            sb.append("{"
                                    + "\"id\": \"" + product.getId() + "\", "
                                    + "\"name\": \"" + product.getName() + "\", "
                                    + "\"notes\": \"" + escape(product.getNotes()) + "\", "
                                    + "\"logoPath\": \"" + product.getLogoPath() + "\", "
                                    + "\"photoPath\": \"" + product.getPhotoPath() + "\", "
                                    + "\"productCategoryId\": \"" + product.getProductCategoryId() + "\", "
                                    + "\"ownerId\": \"" + product.getOwnerId() + "\", "
                                    + "\"reserved\": \"" + product.isReserved() + "\", "
                                    + "\"necessary\": \"" + product.getNecessary() + "\""
                                    + "}}");
                            PrintWriter out = response.getWriter();
                            response.setContentType("application/json");
                            response.setCharacterEncoding("UTF-8");
                            out.print(sb);
                            out.flush();
                        } else {
                            response.sendError(403);
                        }
                        break;
                }
            } catch (DAOException ex) {
                response.sendError(500);
            }
        } else {
            response.sendError(400);
        }
    }

    private String escape(String raw) {
        String escaped = raw;
        escaped = escaped.replace("\\", "\\\\");
        escaped = escaped.replace("\"", "\\\"");
        escaped = escaped.replace("\b", "\\b");
        escaped = escaped.replace("\f", "\\f");
        escaped = escaped.replace("\n", "\\n");
        escaped = escaped.replace("\r", "\\r");
        escaped = escaped.replace("\t", "\\t");
        return escaped;
    }
}
