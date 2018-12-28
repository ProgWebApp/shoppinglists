package servlets;

import db.daos.ProductDAO;
import db.daos.ShoppingListDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ShareListsServlet extends HttpServlet {

    private ShoppingListDAO shoppingListDAO;
    private ProductDAO productDAO;

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
            productDAO = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User userActive = (User) request.getSession().getAttribute("user");

        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI OBBLIGATORI*/
        if (request.getParameter("userId") == null || request.getParameter("shoppingListId") == null || request.getParameter("action") == null) {
            response.sendError(400);
            return;
        }

        /* RESTITUISCO UN ERRORE SE I PARAMETRI NON SONO CONFORMI*/
        Integer userId;
        Integer shoppingListId;
        Integer action;
        try {
            userId = Integer.valueOf(request.getParameter("userId"));
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
            action = Integer.valueOf(request.getParameter("action"));
        } catch (NumberFormatException ex) {
            response.sendError(400);
            return;
        }

        /* CONTROLLO L'ESISTENZA DI UN PARAMETRO DEI PERMESSI, ALTRIMENTI IMPOSTO IL DEFAULT */
        Integer permissions;
        if (request.getParameter("permissions") != null) {
            try {
                permissions = Integer.valueOf(request.getParameter("permissions"));
            } catch (NumberFormatException ex) {
            System.out.println("fallita conversione");
                response.sendError(400);
                return;
            }
        } else {
            permissions = 1; //imposto il valore minimo di permissions
        }

        /* RISPONDO */
        try {
            if (shoppingListDAO.getPermission(shoppingListId, userActive.getId()) == 2) {
                //se l'utente ha i permessi di modifica della lista
                switch (action) {
                    case 0:
                        shoppingListDAO.removeMember(shoppingListId, userId);
                        break;
                    case 1:
                        shoppingListDAO.addMember(shoppingListId, userId, permissions);
                        productDAO.shareProductFromList(shoppingListId, userId);
                        break;
                    case 2:
                        shoppingListDAO.updateMember(shoppingListId, userId, permissions);
                        break;
                }
            } else {
                response.sendError(403);
            }
        } catch (DAOException ex) {
            response.sendError(500);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    }
}
