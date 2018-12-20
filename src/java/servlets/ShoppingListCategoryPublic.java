/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ShoppingListCategoryDAO;
import db.entities.ProductCategory;
import db.entities.ShoppingListCategory;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pberi
 */
public class ShoppingListCategoryPublic extends HttpServlet {

    private ShoppingListCategoryDAO shoppingListCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListCategoryDAO = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopping-list-Category storage system", ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("shoppingListCategoryId") == null) {
            response.setStatus(400);
            return;
        }

        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer shoppingListCategoryId;
        try {
            shoppingListCategoryId = Integer.valueOf(request.getParameter("shoppingListCategoryId"));
        } catch (NumberFormatException ex) {
            response.setStatus(400);
            return;
        }

        /* RECUPERO LA CATEGORIA DI LISTA */
        ShoppingListCategory shoppingListCategory;
        List<ProductCategory> productCategoriesSelected;
        try {
            shoppingListCategory = shoppingListCategoryDAO.getByPrimaryKey(shoppingListCategoryId);
            productCategoriesSelected = shoppingListCategoryDAO.getProductCategories(shoppingListCategoryId);
        } catch (DAOException ex) {
            response.setStatus(500);
            return;
        }

        /* RISPONDO */
        request.setAttribute("shoppingListCategory", shoppingListCategory);
        request.setAttribute("products", productCategoriesSelected);
        getServletContext().getRequestDispatcher("/shoppingListCategory.jsp").forward(request, response);
    }
}
