/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ProductCategoryDAO;
import db.daos.ProductDAO;
import db.entities.Product;
import db.entities.ProductCategory;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pberi
 */
public class ProductPublic extends HttpServlet {

    private ProductDAO productDao;
    private ProductCategoryDAO productCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productDao = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
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

        /* RECUPERO IL PRODOTTO E RESTITUISCO ERRORE SE IL PRODOTTO NON ESISTE (O NON E VISIBILE) */
        Product product;
        try {
            product = productDao.getByPrimaryKey(productId);
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
        /* RISPONDO */
        ProductCategory category;
        try {
            category = productCategoryDAO.getByPrimaryKey(product.getProductCategoryId());
        } catch (DAOException ex) {
            response.setStatus(500);
            return;
        }
        request.setAttribute("product", product);
        request.setAttribute("modifiable", false);
        request.setAttribute("productCategory", category);
        getServletContext().getRequestDispatcher("/restricted/product.jsp").forward(request, response);
    }
}
