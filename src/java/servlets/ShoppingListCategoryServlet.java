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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("shoppingListCategoryId") == null || request.getParameter("res") == null) {
            response.setStatus(400);
            return;
        }

        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer shoppingListCategoryId;
        Integer res;
        try {
            shoppingListCategoryId = Integer.valueOf(request.getParameter("shoppingListCategoryId"));
            res = Integer.valueOf(request.getParameter("res"));
            if (res > 2) {
                throw new NumberFormatException();
            }
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
        request.setAttribute("productCategoriesSelected", productCategoriesSelected);
        switch (res) {
            case 1:
                getServletContext().getRequestDispatcher("/shoppingListCategory.jsp").forward(request, response);
                break;
            case 2:
                if (!user.isAdmin()) {
                    response.setStatus(403);
                } else {
                    getServletContext().getRequestDispatcher("/restricted/shoppingListCategoryForm.jsp").forward(request, response);
                }
                break;
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
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");
        Integer userId = user.getId();

        /* SE LA CATEGORIA DI LISTA ESISTE, CONTROLLO CHE L'UTENTE SIA ADMIN */
        if (!user.isAdmin()) {
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "noPermissions.jsp"));
            return;
        }

        /* RECUPERO LA CATEGORIA DI PRODOTTO, SE ESISTE, OPPURE NE CREO UNO NUOVA */
        ShoppingListCategory shoppingListCategory = new ShoppingListCategory();
        Integer shoppingListCategoryId = null;

        if (request.getParameter("shoppingListCategoryId") != null) {
            try {
                shoppingListCategoryId = Integer.valueOf(request.getParameter("shoppingListCategoryId"));
            } catch (NumberFormatException ex) {
                throw new ServletException("This request require a parameter named shoppingListCategoryId whit an int value");
            }
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
        Boolean emptyLogo = false, emptyPC = false;
        //il logo è obbligatorio solo per la creazione
        if (shoppingListCategoryId == null && logoFilePart.getSize() == 0) {
            emptyLogo = true;
        }
        /* SHOP */
        String shoppingListCategoryShop = request.getParameter("shop");
        shoppingListCategory.setShop(shoppingListCategoryShop);
        
        /* PRODUCT CATEGORY */
        List<String> productCategoriesSelected = new ArrayList();
        if(request.getParameterValues("productCategories") == null){
            emptyPC = true;
        }else{
            productCategoriesSelected.addAll(Arrays.asList(request.getParameterValues("productCategories")));
        }
        
        /* CONTROLLO CAMPI VUOTI */
        if (shoppingListCategoryName.isEmpty() || shoppingListCategoryDescription.isEmpty() || emptyLogo || emptyPC) { //|| shoppingListCategoryShop.isEmpty()
            request.setAttribute("message", 1);
            request.setAttribute("shoppingListCategory", shoppingListCategory);
            request.setAttribute("pcss", productCategoriesSelected);
            getServletContext().getRequestDispatcher("/restricted/shoppingListCategoryForm.jsp").forward(request, response);
            return;
        }

        /* LOGO */
        //carico il logo solo se è stato specificato
        if (logoFilePart.getSize() > 0) {
            String logoFileName = UUID.randomUUID().toString() + Paths.get(logoFilePart.getSubmittedFileName()).getFileName().toString(); //MSIE  fix.
            String logosFolder = getServletContext().getRealPath("/images/shoppingListCategories");
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

        /* REDIRECT ALLA PAGINA DELLA CATEGORIA DI LISTA */
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/categories.jsp"));
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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

        /* CONTROLLO CHE L'UTENTE SIA ADMIN*/
        User user = (User) request.getSession().getAttribute("user");
        if (!user.isAdmin()) {
            response.setStatus(403);
            return;
        }

        /* RISPONDO */
        try {
            shoppingListCategoryDAO.delete(shoppingListCategoryId);
            response.setStatus(204);
        } catch (DAOException ex) {
            response.setStatus(500);
        }
    }
}
