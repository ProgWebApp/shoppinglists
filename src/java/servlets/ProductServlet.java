package servlets;

import db.daos.ProductDAO;
import db.entities.Product;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
public class ProductServlet extends HttpServlet {

    private ProductDAO productDao;

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
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        Product product = new Product();

        Integer userId = user.getId();
        Integer productId = null;
        
        if (request.getParameter("productId") != null) {
            productId = Integer.valueOf(request.getParameter("productId"));
            try {
                product = productDao.getByPrimaryKey(productId);
            } catch (DAOException ex) {
                throw new ServletException("Impossible to get the product", ex);
            }
        }

        /* ID */
        product.setId(productId);

        /* NAME */
        String productName = request.getParameter("name");
        product.setName(productName);
        
        /* NOTES */
        String productNotes = request.getParameter("notes");
        product.setNotes(productNotes);
        
        /* CATEGORY */
        Integer productCategoryId;
        boolean emptyCategory = false;
        try{
            productCategoryId = Integer.valueOf(request.getParameter("category"));
            product.setProductCategoryId(productCategoryId);
        }catch(NumberFormatException ex){
            emptyCategory = true;
        }
        
        /* CONTROLLO CAMPI VUOTI */
        if (productName.isEmpty() || productNotes.isEmpty() || emptyCategory) {
            request.getSession().setAttribute("message", 1);
            request.getSession().setAttribute("product", product);
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/product.jsp"));
            return;
        }

        /* OWNER */
        if (productId == null) {
            product.setOwnerId(userId);
        }

        /* RESERVED */
        if (productId == null) {
            if (user.isAdmin()) {
                product.setReserved(false);
            } else {
                product.setReserved(true);
            }
        }

        /* LOGO */
        product.setLogoPath("");

        /* PHOTO */
        String productsFolder = getServletContext().getInitParameter("productsFolder");
        if (productsFolder == null) {
            throw new ServletException("Products folder not configured");
        }
        productsFolder = getServletContext().getRealPath(productsFolder);

        HashSet<String> photoPaths;
        if (productId == null) {
            photoPaths = new HashSet<>();
        } else {
            photoPaths = product.getPhotoPath();
        }
        for (Part part : request.getParts()) {
            if (part.getContentType() != null && part.getContentType().contains("image")) {
                System.out.println(part.getName());
                String fileName = UUID.randomUUID().toString() + Paths.get(part.getSubmittedFileName()).getFileName().toString(); //MSIE  fix.
                photoPaths.add(fileName);
                File directory = new File(productsFolder);
                directory.mkdirs();
                part.write(productsFolder + File.separator + fileName);
            }
        }
        String remove[] = request.getParameterValues("removePhotos");
        if (remove != null) {
            for (String photo : remove) {
                photoPaths.remove(photo);
                Files.delete(Paths.get(productsFolder + File.separator + photo));
            }
        }
        product.setPhotoPath(photoPaths);

        /* INSERT OR UPDATE */
        try {
            if (productId == null) {
                productId = productDao.insert(product);
                if (!user.isAdmin()) {
                    //productDao.addLinkWithUser(productId, userId); //solo per prodotti privati
                }
            } else {
                productDao.update(product);
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to insert or update the product", ex);
        }
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/products.jsp"));
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
