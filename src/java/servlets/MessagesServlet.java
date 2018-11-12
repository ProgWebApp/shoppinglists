package servlets;

import db.daos.MessageDAO;
import db.daos.ShoppingListDAO;
import db.entities.Message;
import db.entities.ShoppingList;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
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
    private static final DateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

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

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RECUPERO L'UTENTE */
        User user = (User) request.getSession().getAttribute("user");
        Integer userId = user.getId();
        
        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        if(request.getParameter("body")==null || request.getParameter("shoppingListId")==null){
            response.setStatus(400);
            return;
        }
        Integer shoppingListId;
        Integer permissions=null;
        try {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
        } catch (NumberFormatException ex) {
            response.setStatus(400);
            return;
        }
        try {
            permissions = shoppingListDAO.getPermission(shoppingListId, userId);
        } catch (DAOException ex) {
            //Logger.getLogger(MessagesServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        if(permissions!=1 && permissions!=2){
            response.setStatus(403);
            return;
        }
        String body = request.getParameter("body");
        Message message = new Message();
        message.setBody(body);
        
        message.setSenderId(userId);
        message.setShoppingListId(shoppingListId);

        try {
            messageDAO.insert(message);
            shoppingListDAO.addNotifications(shoppingListId);
        } catch (DAOException ex) {
            //request.getServletContext().log("Impossible to send the message", ex);
        }
    }
}
