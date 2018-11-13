/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ProductCategoryDAO;
import db.entities.ProductCategory;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashSet;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("productCategoryId") == null || request.getParameter("res") == null) {
            response.setStatus(400);
            return;
        }

        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer productCategoryId;
        Integer res;
        try {
            productCategoryId = Integer.valueOf(request.getParameter("productCategoryId"));
            res = Integer.valueOf(request.getParameter("res"));
            if (res > 2) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException ex) {
            response.setStatus(400);
            return;
        }

        /* RECUPERO LA CATEGORIA DI PRODOTTO */
        ProductCategory productCategory;
        try {
            productCategory = productCategoryDao.getByPrimaryKey(productCategoryId);
        } catch (DAOException ex) {
            response.setStatus(500);
            return;
        }

        /* RISPONDO */
        request.setAttribute("productCategory", productCategory);
        switch (res) {
            case 1:
                getServletContext().getRequestDispatcher("/restricted/productCategory.jsp").forward(request, response);
                break;
            case 2:
                if (!user.isAdmin()) {
                    response.setStatus(403);
                } else {
                    getServletContext().getRequestDispatcher("/restricted/productCategoryForm.jsp").forward(request, response);
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");
        
        /* CONTROLLO CHE L'UTENTE SIA ADMIN */
        if (!user.isAdmin()) {
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "noPermissions.jsp"));
            return;
        }

        /* RECUPERO LA CATEGORIA DI PRODOTTO, SE ESISTE, OPPURE NE CREO UNO NUOVA */
        ProductCategory productCategory = new ProductCategory();
        Integer productCategoryId = null;

        if (request.getParameter("productCategoryId") != null) {
            try {
                productCategoryId = Integer.valueOf(request.getParameter("productCategoryId"));
            } catch (NumberFormatException ex) {
                throw new ServletException("This request require a parameter named productCategoryId whit an int value");
            }
            try {
                productCategory = productCategoryDao.getByPrimaryKey(productCategoryId);
            } catch (DAOException ex) {
                throw new ServletException("Impossible to get the productCateogry", ex);
            }
        }

        /* ID */
        productCategory.setId(productCategoryId);
        /* NAME */
        String productCategoryName = request.getParameter("name");
        productCategory.setName(productCategoryName);
        /* DESCRIPTION */
        String productCategoryDescription = request.getParameter("description");
        productCategory.setDescription(productCategoryDescription);
        /* LOGO */
        Part logoFilePart = request.getPart("logo");
        Boolean emptyLogo = false;
        //il logo è obbligatorio solo per la creazione
        if (productCategoryId == null && logoFilePart.getSize() == 0) {
            emptyLogo = true;
        }

        /* CONTROLLO CAMPI VUOTI */
        if (productCategoryName.isEmpty() || productCategoryDescription.isEmpty() || emptyLogo) {
            request.getSession().setAttribute("message", 1);
            request.getSession().setAttribute("productCategory", productCategory);
            getServletContext().getRequestDispatcher("/restricted/productCategoryForm.jsp").forward(request, response);
            return;
        }

        /* LOGO */
        //carico il logo solo se è stato specificato
        if (logoFilePart.getSize() > 0) {
            String logoFileName = UUID.randomUUID().toString() + Paths.get(logoFilePart.getSubmittedFileName()).getFileName().toString(); //MSIE  fix.
            String logosFolder = getServletContext().getInitParameter("logosFolder");
            if (logosFolder == null) {
                throw new ServletException("Logos folder not configured");
            }
            logosFolder = getServletContext().getRealPath(logosFolder);
            File logoDirectory = new File(logosFolder);
            logoDirectory.mkdirs();
            logoFilePart.write(logosFolder + File.separator + logoFileName);
            productCategory.setLogoPath(logoFileName);
        }

        /* ICONS */
        String iconsFolder = getServletContext().getInitParameter("iconsFolder");
        if (iconsFolder == null) {
            throw new ServletException("Icons folder not configured");
        }
        iconsFolder = getServletContext().getRealPath(iconsFolder);
        HashSet<String> iconPaths;
        if (productCategoryId == null) {
            iconPaths = new HashSet<>();
        } else {
            iconPaths = productCategory.getIconPath();
        }
        for (Part part : request.getParts()) {
            if (part.getContentType() != null && part.getContentType().contains("image") && part.getName().equals("icons")) {
                String fileName = UUID.randomUUID().toString() + Paths.get(part.getSubmittedFileName()).getFileName().toString(); //MSIE  fix.
                iconPaths.add(fileName);
                File directory = new File(iconsFolder);
                directory.mkdirs();
                part.write(iconsFolder + File.separator + fileName);
            }
        }
        String remove[] = request.getParameterValues("removeIcons");
        if (remove != null) {
            for (String icon : remove) {
                iconPaths.remove(icon);
                Files.delete(Paths.get(iconsFolder + File.separator + icon));
            }
        }
        productCategory.setIconPath(iconPaths);

        /* INSERT OR UPDATE */
        try {
            if (productCategoryId == null) {
                productCategoryId = productCategoryDao.insert(productCategory);
            } else {
                productCategoryDao.update(productCategory);
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to insert or update the productCategory", ex);
        }

        /* REDIRECT ALLA PAGINA DELLA CATEGORIA DI PRODOTTO */
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/ProductCategoryServlet?res=1&productCategoryId=" + productCategoryId));
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("productCategoryId") == null) {
            response.setStatus(400);
            return;
        }

        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer productCategoryId;
        try {
            productCategoryId = Integer.valueOf(request.getParameter("productCategoryId"));
        } catch (NumberFormatException ex) {
            response.setStatus(400);
            return;
        }

        /* CONTROLLO CHE L'UTENTE SIA ADMIN */
        User user = (User) request.getSession().getAttribute("user");
        if (!user.isAdmin()) {
            response.setStatus(403);
            return;
        }

        /* RISPONDO */
        try {
            productCategoryDao.delete(productCategoryId);
            response.setStatus(204);
        } catch (DAOException ex) {
            response.setStatus(500);
        }
    }
}
