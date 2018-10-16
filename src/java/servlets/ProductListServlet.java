/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ProductDAO;
import db.daos.ShoppingListDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pberi
 */
public class ProductListServlet extends HttpServlet {

    private ShoppingListDAO shoppingListDao;
    private ProductDAO productDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListDao = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopping-list storage system", ex);
        }
        try {
            productDao = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        Integer userId = user.getId();
        Integer shoppingListId = null;
        Integer productId = null;
        Boolean necessary = true;
        Integer action = null;
        Integer quantity = 1;
        if (request.getParameter("shoppingListId") != null && request.getParameter("productId") != null && request.getParameter("necessary") != null && request.getParameter("action") != null) {
            try {
                shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
                productId = Integer.valueOf(request.getParameter("productId"));
                necessary = Boolean.valueOf(request.getParameter("necessary"));
                action = Integer.valueOf(request.getParameter("action"));
            } catch (RuntimeException ex) {
                //TODO: log the exception
            }
            try {
                switch (action) {
                    case 0:
                        shoppingListDao.removeProduct(shoppingListId, productId);
                        break;
                    case 1:
                        shoppingListDao.updateProduct(shoppingListId, productId, quantity, false);
                        break;
                    case 2:
                        shoppingListDao.updateProduct(shoppingListId, productId, quantity, true);
                        break;
                    case 3:
                        shoppingListDao.addProduct(shoppingListId, productId, quantity, necessary);
                        productDao.shareProductToList(productId, shoppingListId);
                        break;
                }
            } catch (DAOException ex) {
                Logger.getLogger(ShoppingListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/shoppingLists.jsp"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
}
