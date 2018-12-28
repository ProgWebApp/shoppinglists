package servlets;

import db.daos.MessageDAO;
import db.daos.ShoppingListDAO;
import db.entities.Message;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet that handles the sending of messages.
 */
public class MessagesServlet extends HttpServlet {

    private MessageDAO messageDAO;
    private ShoppingListDAO shoppingListDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            messageDAO = daoFactory.getDAO(MessageDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for message storage system", ex);
        }
        try {
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopping-list storage system", ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");
        Integer userId = user.getId();
        
        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if(request.getParameter("body")==null || request.getParameter("shoppingListId")==null){
            response.sendError(400);
            return;
        }
        Integer shoppingListId;
        Integer permissions;
        try {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
        } catch (NumberFormatException ex) {
            response.sendError(400);
            return;
        }
        try {
            permissions = shoppingListDAO.getPermission(shoppingListId, userId);
        } catch (DAOException ex) {
            response.sendError(500);
            return;
        }
        
        if(permissions!=1 && permissions!=2){
            response.sendError(403);
            return;
        }
        Message message = new Message();
        message.setBody(request.getParameter("body"));
        message.setSenderId(userId);
        message.setShoppingListId(shoppingListId);

        try {
            messageDAO.insert(message);
            shoppingListDAO.addNotifications(shoppingListId, userId);
        } catch (DAOException ex) {
            response.sendError(500);
        }
    }
}
