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
import java.io.PrintWriter;
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
public class ShareListsServlet extends HttpServlet {

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
     *
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User userActive = (User) request.getSession().getAttribute("user");
        User user = null;
        Integer userActiveId = user.getId();
        Integer userId = null;
        Integer shoppingListId = null;
        Integer permission = null;
        try {
            userId = Integer.valueOf(request.getParameter("userId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        try {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        try {
            permission = Integer.valueOf(request.getParameter("permission"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        
        try {
            shoppingListDao.addMember(shoppingListId, userId, permission);
            productDao.shareProductFromList(shoppingListId, userId);
        } catch (DAOException ex) {
            Logger.getLogger(ShoppingListServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/shopping.lists.html"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer shoppingListId = null;
        Integer userId = null;
        try {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        try {
            userId = Integer.valueOf(request.getParameter("userId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
            try {
                shoppingListDao.removeMember(shoppingListId, userId);
            } catch (DAOException ex) {
                Logger.getLogger(ShoppingListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
    }
}
