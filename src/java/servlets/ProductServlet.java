package servlets;

import db.daos.ProductCategoryDAO;
import db.daos.ProductDAO;
import db.daos.ShoppingListDAO;
import db.entities.Product;
import db.entities.ProductCategory;
import db.entities.ShoppingList;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.HashSet;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO;
    private ShoppingListDAO shoppingListDAO;
    private ProductCategoryDAO productCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productDAO = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
        }
        try {
            productCategoryDAO = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get product category dao", ex);
        }
        try {
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get shoppingList dao", ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("productId") == null || request.getParameter("res") == null) {
            response.sendError(400);
            return;
        }

        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer productId;
        Integer res;
        try {
            productId = Integer.valueOf(request.getParameter("productId"));
            res = Integer.valueOf(request.getParameter("res"));
            if (res > 2) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException ex) {
            response.sendError(400);
            return;
        }

        /* RECUPERO IL PRODOTTO E RESTITUISCO ERRORE SE IL PRODOTTO NON ESISTE (O NON E VISIBILE) */
        Product product;
        try {
            product = productDAO.getIfVisible(productId, user.getId());
        } catch (DAOException ex) {
            response.sendError(500);
            return;
        }
        if (product == null) {
            if (res == 0) {
                response.sendError(403);
            } else {
                response.sendError(403);
            }
            return;
        }

        /* RISPONDO */
        request.setAttribute("product", product);
        switch (res) {
            case 0:
                PrintWriter out = response.getWriter();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                out.print(product.toString());
                out.flush();
                break;
            case 1:
                if (checkPermissions(user, product) == 0) {
                    request.setAttribute("modifiable", true);
                } else {
                    request.setAttribute("modifiable", false);
                }
                ProductCategory category;
                List<ShoppingList> shoppingLists;
                try {
                    category = productCategoryDAO.getByPrimaryKey(product.getProductCategoryId());
                    shoppingLists = shoppingListDAO.getListsByProductCategory(product.getProductCategoryId(), user.getId());
                } catch (DAOException ex) {
                    response.sendError(500);
                    return;
                }
                request.setAttribute("productCategory", category);
                request.setAttribute("shoppingLists", shoppingLists);
                getServletContext().getRequestDispatcher("/product.jsp").forward(request, response);
                break;
            case 2:
                if (checkPermissions(user, product) == 0) {
                    getServletContext().getRequestDispatcher("/restricted/productForm.jsp").forward(request, response);
                } else {
                    response.sendError(403);
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");
        Integer userId = user.getId();

        /* RECUPERO IL PRODOTTO, SE ESISTE, OPPURE NE CREO UNO NUOVO */
        Product product = new Product();
        Integer productId = null;
        if (request.getParameter("productId") != null) {
            try {
                productId = Integer.valueOf(request.getParameter("productId"));
            } catch (NumberFormatException ex) {
                throw new ServletException("This request require a parameter named productId whit an int value");
            }
            try {
                product = productDAO.getByPrimaryKey(productId);
            } catch (DAOException ex) {
                throw new ServletException("Impossible to get the product", ex);
            }
            /* SE IL PRODOTTO ESISTE, CONTROLLO I PERMESSI DELL'UTENTE */
            if (checkPermissions(user, product) != 0) {
                response.sendError(403);
                return;
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
        boolean newCategory = false;
        try {
            productCategoryId = Integer.valueOf(request.getParameter("category"));
            if (productId != null && !product.getProductCategoryId().equals(productCategoryId)) {
                newCategory = true;
            }
            product.setProductCategoryId(productCategoryId);
        } catch (NumberFormatException ex) {
            emptyCategory = true;
        }

        /* LOGO */
        String logo = request.getParameter("logo");
        boolean emptyLogo = false;
        if (logo != null) {
            product.setLogoPath(logo);
        } else if (productId == null || newCategory) {    //il logo è obbligatorio solo quando creo o cambio categoria
            emptyLogo = true;
            product.setLogoPath("");
        }

        /* CONTROLLO CAMPI VUOTI */
        if (productName.isEmpty() || productNotes.isEmpty() || emptyCategory || emptyLogo) {
            request.setAttribute("message", 1);
            request.setAttribute("product", product);
            List<ProductCategory> categories;
            try {
                categories = productCategoryDAO.getAll();
            } catch (DAOException ex) {
                throw new ServletException("Impossible to get the categories", ex);
            }
            request.setAttribute("categories", categories);
            getServletContext().getRequestDispatcher("/restricted/productForm.jsp").forward(request, response);
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

        /* PHOTO */
        String productsFolder = getServletContext().getRealPath("/images/products");

        HashSet<String> photoPaths;
        if (productId == null) {
            photoPaths = new HashSet<>();
        } else {
            photoPaths = product.getPhotoPath();
        }
        for (Part part : request.getParts()) {
            if (part.getContentType() != null && part.getContentType().contains("image")) {
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
                //Files.delete(Paths.get(productsFolder + File.separator + photo));
            }
        }
        product.setPhotoPath(photoPaths);

        /* INSERT OR UPDATE */
        try {
            if (productId == null) {
                productId = productDAO.insert(product);
                if (!user.isAdmin()) {
                    productDAO.addLinkWithUser(productId, userId); //solo per prodotti privati
                }
            } else {
                productDAO.update(product);
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to insert or update the product", ex);
        }

        /* REDIRECT ALLA PAGINA DEL PRODOTTO */
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/ProductServlet?res=1&productId=" + productId));
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("productId") == null) {
            response.sendError(400);
            return;
        }

        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer productId;
        try {
            productId = Integer.valueOf(request.getParameter("productId"));
        } catch (NumberFormatException ex) {
            response.sendError(400);
            return;
        }

        /* RECUPERO IL PRODOTTO */
        Product product;
        try {
            product = productDAO.getByPrimaryKey(productId);
        } catch (DAOException ex) {
            response.sendError(500);
            return;
        }

        /* CONTROLLO CHE L'UTENTE ABBIA I PERMESSI */
        User user = (User) request.getSession().getAttribute("user");
        if (checkPermissions(user, product) != 0) {
            response.sendError(403);
            return;
        }

        /* RISPONDO */
        try {
            productDAO.delete(productId);
            response.sendError(204);
        } catch (DAOException ex) {
            response.sendError(500);
        }
    }

    private int checkPermissions(User user, Product product) {
        if (!product.isReserved() && !user.isAdmin()) {
            //il prodotto è pubblico e l'utente non è un admin
            return 1;
        }
        if (product.isReserved() && user.getId().intValue() != product.getOwnerId().intValue()) {
            //il prodotto è privato e l'utente non è il proprietario
            return 2;
        }
        return 0;
    }
}
