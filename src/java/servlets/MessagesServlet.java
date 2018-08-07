package servlets;

import db.daos.MessageDAO;
import db.daos.ShoppingListDAO;
import db.entities.Message;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet that handles the sending of messages.
 */
public class MessagesServlet extends HttpServlet {

    private MessageDAO messageDao;
    private ShoppingListDAO shoppingListDao;
    private static final DateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            messageDao = daoFactory.getDAO(MessageDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for message storage system", ex);
        }
        try {
            shoppingListDao = daoFactory.getDAO(ShoppingListDAO.class);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String body = request.getParameter("body");
        Integer shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
        Integer userId = (Integer) request.getSession().getAttribute("user");

        Message message = new Message();
        message.setBody(body);
        message.setDate(sdf.format(new Date()));
        message.setSenderId(userId);
        message.setShoppingListId(shoppingListId);

        try {
            messageDao.insert(message);
            shoppingListDao.addNotifications(shoppingListId);
        } catch (DAOException ex) {
            request.getServletContext().log("Impossible to send the message", ex);
        }
    }
}
