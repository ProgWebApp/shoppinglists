/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ProductCategoryDAO;
import db.daos.ShoppingListCategoryDAO;
import db.entities.ProductCategory;
import db.entities.ShoppingListCategory;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.exceptions.UniqueConstraintException;
import db.factories.DAOFactory;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
public class ShoppingListCategoryServlet extends HttpServlet {

    private ShoppingListCategoryDAO shoppingListCategoryDAO;
    private ProductCategoryDAO productCategoryDAO;

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
        try {
            productCategoryDAO = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for productCategory storage system", ex);
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

        User user = (User) request.getSession().getAttribute("user");
        ShoppingListCategory shoppingListCategory = new ShoppingListCategory();
        Integer userId = user.getId();
        Integer shoppingListCategoryId = null;

        if (request.getParameter("shoppingListCategoryId") != null) {
            shoppingListCategoryId = Integer.valueOf(request.getParameter("shoppingListCategoryId"));
            try {
                shoppingListCategory = shoppingListCategoryDAO.getByPrimaryKey(shoppingListCategoryId);
            } catch (DAOException ex) {
                throw new ServletException("Impossible to get the shoppingListCateogry", ex);
            }
        }

        /* ID */
        shoppingListCategory.setId(shoppingListCategoryId);

        /* NAME */
        String shoppingListCategoryName = request.getParameter("name");
        shoppingListCategory.setName(shoppingListCategoryName);

        /* DESCRIPTION */
        String shoppingListCategoryDescription = request.getParameter("description");
        shoppingListCategory.setDescription(shoppingListCategoryDescription);

        /* LOGO */
        Part logoFilePart = request.getPart("logo");
        Boolean emptyLogo = false;
        //il logo è obbligatorio solo per la creazione
        if (shoppingListCategoryId == null && logoFilePart.getSize() == 0) {
            emptyLogo = true;
        }

        /* CONTROLLO CAMPI VUOTI */
        if (shoppingListCategoryName.isEmpty() || shoppingListCategoryDescription.isEmpty() || emptyLogo) {
            request.getSession().setAttribute("message", 1);
            request.getSession().setAttribute("shoppingListCategory", shoppingListCategory);
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/shoppingListCategory.jsp"));
            return;
        }

        /* LOGO */
        //carico il logo solo se è stato specificato
        if (logoFilePart.getSize() > 0) {
            String logoFileName = UUID.randomUUID().toString() + Paths.get(logoFilePart.getSubmittedFileName()).getFileName().toString(); //MSIE  fix.
            String logosFolder = "images/shoppingListCategories";
            logosFolder = getServletContext().getRealPath(logosFolder);
            File logoDirectory = new File(logosFolder);
            logoDirectory.mkdirs();
            logoFilePart.write(logosFolder + File.separator + logoFileName);
            shoppingListCategory.setLogoPath(logoFileName);
        }

        /* INSERT OR UPDATE */
        try {
            if (shoppingListCategoryId == null) {
                shoppingListCategoryId = shoppingListCategoryDAO.insert(shoppingListCategory);
            } else {
                shoppingListCategoryDAO.update(shoppingListCategory);
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to insert or update the shoppingListCategory", ex);
        }

        /* PRODUCT CATEGORY */
        List<String> productCategoriesSelected = Arrays.asList(request.getParameterValues("productCategories"));
        List<ProductCategory> productCategories = null;
        try {
            productCategories = productCategoryDAO.getAll();
        } catch (DAOException ex) {
            throw new ServletException("Impossible to get the lists of productCateogry", ex);
        }
        for (ProductCategory productCategory : productCategories) {
            System.out.println(productCategory.getId());
            if (productCategoriesSelected.contains(productCategory.getId().toString())) {
                try {
                    System.out.println("inserisco in pclc");
                    shoppingListCategoryDAO.addProductCategory(shoppingListCategoryId, productCategory.getId());
                } catch (DAOException ex) {
                    if (!(ex.getCause() instanceof UniqueConstraintException)) {
                        throw new ServletException("Impossible to add the productCategory to the shoppingListCateogry", ex);
                    }
                }
            } else {
                try {
                    shoppingListCategoryDAO.removeProductCategory(shoppingListCategoryId, productCategory.getId());
                } catch (DAOException ex) {
                    throw new ServletException("Impossible to remove the productCategory to the shoppingListCategory", ex);
                }
            }
        }
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/shoppingListCategories.html"));
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
                shoppingListCategoryDAO.delete(shoppingListCategoryId);
            } catch (DAOException ex) {
                Logger.getLogger(ShoppingListCategoryServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
