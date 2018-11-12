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

    private ShoppingListDAO shoppingListDAO;
    private ProductDAO productDAO;

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User userActive = (User) request.getSession().getAttribute("user");
        Integer userActiveId = userActive.getId();
        Integer userId = null;
        Integer shoppingListId = null;
        Integer action = null;
        Integer permission = null;
        if (request.getParameter("userId") != null && request.getParameter("shoppingListId") != null && request.getParameter("action") != null) {

            try {
                userId = Integer.valueOf(request.getParameter("userId"));
                shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
                action = Integer.valueOf(request.getParameter("action"));
            } catch (RuntimeException ex) {
                //TODO: log the exception
            }
            if (request.getParameter("permission") != null) {
                try {
                    permission = Integer.valueOf(request.getParameter("permission"));
                } catch (RuntimeException ex) {
                    //TODO: log the exception
                }
            } else {
                permission = 0; //imposto il valore minimo di permission
            }
            try {
                if (shoppingListDAO.getPermission(shoppingListId, userActiveId) == 2) {
                    switch (action) {
                        case 0:
                            shoppingListDAO.removeMember(shoppingListId, userId);
                            break;
                        case 1:
                            shoppingListDAO.addMember(shoppingListId, userId, permission);
                            productDAO.shareProductFromList(shoppingListId, userId);
                            break;
                        case 2:
                            shoppingListDAO.updateMember(shoppingListId, userId, permission);
                            break;
                    }
                }
            } catch (DAOException ex) {
                Logger.getLogger(ShareListsServlet.class.getName()).log(Level.SEVERE, null, ex);
                System.out.println(ex.getMessage());
            } 
        } else {
            request.getSession().setAttribute("message", 1);
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/shoppingLists.jsp"));
        }     
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response
    ) {
    }
}
