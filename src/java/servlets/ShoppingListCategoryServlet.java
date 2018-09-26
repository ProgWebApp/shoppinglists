/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ShoppingListCategoryDAO;
import db.entities.ShoppingListCategory;
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

public class ShoppingListCategoryServlet extends HttpServlet {

    private ShoppingListCategoryDAO shoppingListCategoryDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListCategoryDao = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopping-list-Category storage system", ex);
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
        
        Integer shoppingListCategoryId = null;
        try {
            shoppingListCategoryId = Integer.valueOf(request.getParameter("shoppingListCategoryId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String logoPath = request.getParameter("logo");

        if (name == null) {
            response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/shoppinglistcategory.html"));
        }
        try {
            ShoppingListCategory shoppingListCategory = new ShoppingListCategory();
            shoppingListCategory.setId(shoppingListCategoryId);
            shoppingListCategory.setName(name);
            shoppingListCategory.setDescription(description);
            shoppingListCategory.setLogoPath(logoPath);
            if (shoppingListCategoryId == null) {
                shoppingListCategoryDao.insert(shoppingListCategory);
            } else {
                shoppingListCategoryDao.update(shoppingListCategory);
            }
        } catch (DAOException ex) {
            Logger.getLogger(ShoppingListCategoryServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (!response.isCommitted()) {
            response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/shoppingListCategories.html"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer shoppingListCategoryId = null;
        try {
            shoppingListCategoryId = Integer.valueOf(request.getParameter("shoppingListCategoryId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        if (shoppingListCategoryId != null) {
            try {
                shoppingListCategoryDao.delete(shoppingListCategoryId);
            } catch (DAOException ex) {
                Logger.getLogger(ShoppingListCategoryServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
