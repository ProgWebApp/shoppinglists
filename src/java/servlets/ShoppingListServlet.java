/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ShoppingListCategoryDAO;
import db.daos.ShoppingListDAO;
import db.entities.Product;
import db.entities.ShoppingList;
import db.entities.ShoppingListCategory;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
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
public class ShoppingListServlet extends HttpServlet {

    private ShoppingListDAO shoppingListDAO;
    private ShoppingListCategoryDAO shoppingListCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopping-list storage system", ex);
        }
        try {
            shoppingListCategoryDAO = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopping-list category storage system", ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("shoppingListId") == null || request.getParameter("res") == null) {
            response.setStatus(400);
            return;
        }
        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer shoppingListId;
        Integer res;
        try {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
            res = Integer.valueOf(request.getParameter("res"));
            if (res > 2) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException ex) {
            response.setStatus(400);
            return;
        }

        /* RECUPERO LA LISTA E RESTITUISCO ERRORE SE LA LISTA NON ESISTE (O NON E VISIBILE) */
        ShoppingList shoppingList;
        try {
            shoppingList = shoppingListDAO.getIfVisible(shoppingListId, user.getId());
        } catch (DAOException ex) {
            ex.getCause().printStackTrace();
            response.setStatus(500);
            return;
        }
        if (shoppingList == null) {
            if (res == 0) {
                response.setStatus(403);
            } else {
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "noPermissions.jsp"));
            }
            return;
        }

        /* RISPONDO */
        request.setAttribute("shoppingList", shoppingList);
        switch (res) {
            case 0:
                PrintWriter out = response.getWriter();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                out.print(shoppingList.toString());
                out.flush();
                break;
            case 1:
                if (checkPermissions(user, shoppingList) == 2) {
                    request.setAttribute("modifiable", true);
                } else {
                    request.setAttribute("modifiable", false);
                }
                List<Product> products;
                List<User> users;
                ShoppingListCategory category;
                try {
                    products = shoppingListDAO.getProducts(shoppingListId);
                    users = shoppingListDAO.getMembers(shoppingListId);
                    category = shoppingListCategoryDAO.getByPrimaryKey(shoppingList.getListCategoryId());
                } catch (DAOException ex) {
                    response.setStatus(500);
                    return;
                }
                request.setAttribute("products", products);
                request.setAttribute("users", users);
                request.setAttribute("shoppingListCategory", category);
                getServletContext().getRequestDispatcher("/restricted/shoppingList.jsp").forward(request, response);
                break;
            case 2:
                if (checkPermissions(user, shoppingList) == 2) {
                    getServletContext().getRequestDispatcher("/restricted/shoppingListForm.jsp").forward(request, response);
                } else {
                    response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "noPermissions.jsp"));
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");
        Integer userId = user.getId();

        /* RECUPERO LA LISTA, SE ESISTE, OPPURE NE CREO UNA NUOVO */
        ShoppingList shoppingList = new ShoppingList();
        Integer shoppingListId = null;
        if (request.getParameter("shoppingListId") != null) {
            try {
                shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
            } catch (NumberFormatException ex) {
                throw new ServletException("This request require a parameter named shoppingListId whit an int value");
            }
            try {
                shoppingList = shoppingListDAO.getByPrimaryKey(shoppingListId);
            } catch (DAOException ex) {
                throw new ServletException("Impossible to get the shoppingList", ex);
            }
            /* SE LA LISTA ESISTE, CONTROLLO I PERMESSI DELL'UTENTE */
            if (checkPermissions(user, shoppingList) != 2) {
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "noPermissions.jsp"));
                return;
            }
        }

        /* ID */
        shoppingList.setId(shoppingListId);

        /* NAME */
        String shoppingListName = request.getParameter("name");
        shoppingList.setName(shoppingListName);

        /* DESCRIPTION */
        String shoppingListDescription = request.getParameter("description");
        shoppingList.setDescription(shoppingListDescription);

        /* CATEGORY */
        Integer shoppingListCategoryId;
        boolean emptyListCategory = false;
        try {
            shoppingListCategoryId = Integer.valueOf(request.getParameter("shoppingListCategory"));
            shoppingList.setListCategoryId(shoppingListCategoryId);
        } catch (NumberFormatException ex) {
            shoppingList.setListCategoryId(null);
            emptyListCategory = true;
        }
        /* LOGO */
        Part imageFilePart = request.getPart("image");
        Boolean emptyImage = false;
        if (shoppingListId == null && imageFilePart.getSize() == 0) {
            emptyImage = true;
            shoppingList.setImagePath(null);
        }
        /* CONTROLLO CAMPI VUOTI */
        if (shoppingListName.isEmpty() || shoppingListDescription.isEmpty() || emptyListCategory || emptyImage) {
            request.getSession().setAttribute("message", 1);
            request.getSession().setAttribute("shoppingList", shoppingList);
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/shoppingList.jsp"));
            return;
        }

        /* OWNER */
        if (shoppingListId == null) {
            shoppingList.setOwnerId(userId);
        }

        /* LOGO */
        //carico il logo solo se è stato specificato
        if (imageFilePart.getSize() > 0) {
            String imageFileName = UUID.randomUUID().toString() + Paths.get(imageFilePart.getSubmittedFileName()).getFileName().toString(); //MSIE  fix.
            String imagesFolder = "images/shoppingList";
            imagesFolder = getServletContext().getRealPath(imagesFolder);
            File imageDirectory = new File(imagesFolder);
            imageDirectory.mkdirs();
            imageFilePart.write(imagesFolder + File.separator + imageFileName);
            shoppingList.setImagePath(imageFileName);
        }

        /* INSERT OR UPDATE */
        try {
            if (shoppingListId == null) {
                shoppingListId = shoppingListDAO.insert(shoppingList);
                shoppingListDAO.addMember(shoppingListId, userId, 2);
            } else {
                shoppingListDAO.update(shoppingList);
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to insert or update the shoppingList", ex);
        }

        /* REDIRECT ALLA PAGINA DELLA LISTA */
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/shoppingList?res=1&shoppingListId=" + shoppingListId));
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("shoppingListId") != null) {
            response.setStatus(400);
            return;
        }

        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer shoppingListId;
        try {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
        } catch (NumberFormatException ex) {
            response.setStatus(400);
            return;
        }

        /* RECUPERO LA LISTA */
        ShoppingList shoppingList;
        try {
            shoppingList = shoppingListDAO.getByPrimaryKey(shoppingListId);
        } catch (DAOException ex) {
            response.setStatus(500);
            return;
        }

        /* CONTROLLO CHE L'UTENTE ABBIA I PERMESSI */
        User user = (User) request.getSession().getAttribute("user");
        if (checkPermissions(user, shoppingList) != 2) {
            response.setStatus(403);
            return;
        }

        /* RISPONDO */
        try {
            shoppingListDAO.delete(shoppingListId);
            response.setStatus(204);
        } catch (DAOException ex) {
            response.setStatus(500);
        }
    }

    private int checkPermissions(User user, ShoppingList shoppingList) {
        try {
            return shoppingListDAO.getPermission(shoppingList.getId(), user.getId());
        } catch (DAOException ex) {
            return 0;
        }
    }

}
