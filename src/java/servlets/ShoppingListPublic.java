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
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
public class ShoppingListPublic extends HttpServlet {

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
        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if (request.getParameter("res") == null) {
            response.sendError(400);
            return;
        }
        /* RESTITUISCO UN ERRORE SE I PAREMETRI NON SONO CONFORMI */
        Integer res;
        try {
            res = Integer.valueOf(request.getParameter("res"));
            if (res != 1 && res != 2) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException ex) {
            response.sendError(400);
            return;
        }

        /* RECUPERO L'UTENTE, SE ESISTE */
        String userId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userId")) {
                    userId = cookie.getValue();
                }
            }
        }

        /* SE L'UTENTE ESISTE RECUPERO LA LISTA*/
        ShoppingList shoppingList = null;
        if (userId != null) {
            try {
                shoppingList = shoppingListDAO.getByCookie(userId);
            } catch (DAOException ex) {
                response.sendError(500);
                return;
            }
        }

        /* SE L'UTENTE NON ESISTE O NON HA UNA LISTA, REINDIRIZZO L'UTENTE ALLA PAGINA DI CREAZIONE DELLA LISTA */
        if (userId == null || shoppingList == null) {
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "shoppingListForm.jsp"));
            return;
        }

        /* RISPONDO */
        request.setAttribute("shoppingList", shoppingList);
        switch (res) {
            case 1:
                List<Product> products;
                ShoppingListCategory category;
                try {
                    products = shoppingListDAO.getProducts(shoppingList.getId());
                    category = shoppingListCategoryDAO.getByPrimaryKey(shoppingList.getListCategoryId());
                } catch (DAOException ex) {
                    response.sendError(500);
                    return;
                }
                request.setAttribute("products", products);
                request.setAttribute("shoppingListCategory", category);
                getServletContext().getRequestDispatcher("/shoppingList.jsp").forward(request, response);
                break;
            case 2:
                getServletContext().getRequestDispatcher("/shoppingListForm.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE, SE ESISTE */
        String userId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userId")) {
                    userId = cookie.getValue();
                }
            }
        }

        /* RECUPERO LA LISTA, SE ESISTE, OPPURE NE CREO UNA NUOVA */
        ShoppingList shoppingList = null;
        if (userId != null) {
            try {
                shoppingList = shoppingListDAO.getByCookie(userId);
            } catch (DAOException ex) {
                response.sendError(500);
                return;
            }
        } else {
            userId = UUID.randomUUID().toString();
            Cookie cookie = new Cookie("userId", userId);
            cookie.setMaxAge(2678400);
            cookie.setDomain(request.getServerName());
            cookie.setPath("/");
            response.addCookie(cookie);
        }

        if (shoppingList == null) {
            shoppingList = new ShoppingList();
        }

        /* COOKIE */
        shoppingList.setCookie(userId);

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
        if (shoppingList.getId() == null && imageFilePart.getSize() == 0) {
            emptyImage = true;
            shoppingList.setImagePath(null);
        }
        /* CONTROLLO CAMPI VUOTI */
        if (shoppingListName.isEmpty() || shoppingListDescription.isEmpty() || emptyListCategory || emptyImage) {
            request.setAttribute("message", 1);
            request.setAttribute("shoppingList", shoppingList);
            getServletContext().getRequestDispatcher("/shoppingListForm.jsp").forward(request, response);
            return;
        }

        /* LOGO */
        //carico il logo solo se è stato specificato
        if (imageFilePart.getSize() > 0) {
            String imageFileName = UUID.randomUUID().toString() + Paths.get(imageFilePart.getSubmittedFileName()).getFileName().toString(); //MSIE  fix.
            String imagesFolder = getServletContext().getRealPath("/images/shoppingList");
            File imageDirectory = new File(imagesFolder);
            imageDirectory.mkdirs();
            imageFilePart.write(imagesFolder + File.separator + imageFileName);
            shoppingList.setImagePath(imageFileName);
        }

        /* OWNER */
        shoppingList.setOwnerId(null);

        /* INSERT OR UPDATE */
        try {
            if (shoppingList.getId() == null) {
                shoppingListDAO.insert(shoppingList);
            } else {
                shoppingListDAO.update(shoppingList);
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to insert or update the shoppingList", ex);
        }

        /* REDIRECT ALLA PAGINA DELLA LISTA */
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "ShoppingListPublic?res=1"));
    }
    
     @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        /* RECUPERO L'UTENTE, SE ESISTE */
        String userId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userId")) {
                    userId = cookie.getValue();
                }
            }
        }

        /* SE L'UTENTE ESISTE RECUPERO LA LISTA*/
        ShoppingList shoppingList = null;
        if (userId != null) {
            try {
                shoppingList = shoppingListDAO.getByCookie(userId);
            } catch (DAOException ex) {
                response.sendError(500);
                return;
            }
        }

        /* SE L'UTENTE NON ESISTE O NON HA UNA LISTA, REINDIRIZZO L'UTENTE ALLA PAGINA DI CREAZIONE DELLA LISTA */
        if (userId == null || shoppingList == null) {
            response.sendError(403);
            return;
        }

        /* RISPONDO */
        try {
            shoppingListDAO.delete(shoppingList.getId());
            response.sendError(204);
        } catch (DAOException ex) {
            response.sendError(500);
        }
    }
}
