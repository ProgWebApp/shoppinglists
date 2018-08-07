/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ProductCategoryDAO;
import db.entities.ProductCategory;
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


public class ProductCategoryServlet extends HttpServlet {
 private ProductCategoryDAO productCategoryDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDao = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for productCategory storage system", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String contextPath = getServletContext().getContextPath();
        if (!contextPath.endsWith("/")) {
            contextPath += "/";
        }

        Integer productCategoryId = null;
        try {
            productCategoryId = Integer.valueOf(request.getParameter("productCategoryId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String logoPath = request.getParameter("logo");

        if (name == null ) {
            response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/productCategory.html"));
        }
        try {
            ProductCategory productCategory = new ProductCategory();
            productCategory.setId(productCategoryId);
            productCategory.setName(name);
            productCategory.setDescription(description);
            productCategory.setLogoPath(logoPath);
            
            if (productCategoryId == null) {
                productCategoryDao.insert(productCategory);
                
            } else {
                productCategoryDao.update(productCategory);
            }
        } catch (DAOException ex) {
            Logger.getLogger(ProductCategoryServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/product.html"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer productCategoryId = null;
        try {
            productCategoryId = Integer.valueOf(request.getParameter("productCategoryId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        if (productCategoryId != null) {
            try {
                productCategoryDao.delete(productCategoryId);
            } catch (DAOException ex) {
                Logger.getLogger(ProductCategoryServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
