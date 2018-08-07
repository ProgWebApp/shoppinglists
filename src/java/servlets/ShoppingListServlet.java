/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ShoppingListDAO;
import db.entities.ShoppingList;
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

public class ShoppingListServlet extends HttpServlet {

    private ShoppingListDAO shoppingListDao;

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

        String contextPath = getServletContext().getContextPath();
        if (!contextPath.endsWith("/")) {
            contextPath += "/";
        }
        User user = (User) request.getSession().getAttribute("user");

        Integer userId = user.getId();
        Integer shoppingListId = null;
        try {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        Integer shoppingListCategoryId = Integer.valueOf(request.getParameter("shoppingListCategoryId"));
        Integer ownerId = Integer.valueOf(request.getParameter("ownerId"));

        if (name == null || shoppingListCategoryId == null || ownerId == null) {
            response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/shopping.lists.html"));
        }
        try {
            ShoppingList shoppingList = new ShoppingList();
            shoppingList.setId(shoppingListId);
            shoppingList.setName(name);
            shoppingList.setDescription(description);
            shoppingList.setListCategoryId(shoppingListCategoryId);
            shoppingList.setOwnerId(ownerId);

            if (shoppingListId == null) {
                shoppingListDao.insert(shoppingList);
                shoppingListDao.addMember(shoppingListId, userId, 2);
            } else {
                shoppingListDao.update(shoppingList);
            }
        } catch (DAOException ex) {
            Logger.getLogger(ShoppingListServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/shopping.lists.html"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer shoppingListId = null;
        try {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        if (shoppingListId != null) {
            try {
                shoppingListDao.delete(shoppingListId);
            } catch (DAOException ex) {
                Logger.getLogger(ShoppingListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
