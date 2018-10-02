/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ProductDAO;
import db.daos.UserDAO;
import db.entities.Product;
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

public class ProductServlet extends HttpServlet {

    private ProductDAO productDao;
    private UserDAO userDao;

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
            userDao = daoFactory.getDAO(UserDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for user storage system", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        Integer userId = user.getId();
        Integer productId = null;
        if (request.getParameter("productId") != null) {
            productId = Integer.valueOf(request.getParameter("productId"));
        }

        String productName = request.getParameter("name");
        String productNotes = request.getParameter("notes");
        //Integer productCategoryId = Integer.valueOf(request.getParameter("productCategoryId"));
        //Integer productOwnerId = Integer.valueOf(request.getParameter("productOwnerId"));

        Product product = new Product();
        product.setId(productId);
        product.setName(productName);
        product.setNotes(productNotes);
        //product.setOwnerId(productOwnerId);
        product.setOwnerId(1);
        //product.setProductCategoryId(productCategoryId);
        product.setProductCategoryId(1);
        if (user.isAdmin()) {
            product.setReserved(false);
        } else {
            product.setReserved(true);
        }
        //logo e photo?
        product.setLogoPath("");
        product.setPhotoPath("");

        if (productName.isEmpty() || productNotes.isEmpty()) { // || productCategoryId == null || productOwnerId == null) {
            request.getSession().setAttribute("message", 1);
            request.getSession().setAttribute("product", product);
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/product.jsp"));
            return;
        }

        try {
            if (productId == null) {
                productDao.insert(product);
                if (!user.isAdmin()) {
                    productDao.addLinkWithUser(productId, userId); //solo per prodotti privati
                }
            } else {
                productDao.update(product);
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to insert or update the product", ex);
        }
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/products.html"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer productId = null;
        try {
            productId = Integer.valueOf(request.getParameter("productId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        if (productId != null) {
            try {
                productDao.delete(productId);
            } catch (DAOException ex) {
                Logger.getLogger(ProductServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
