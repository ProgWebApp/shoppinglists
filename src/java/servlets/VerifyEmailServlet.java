package servlets;

import db.daos.UserDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VerifyEmailServlet extends HttpServlet {

    private UserDAO userDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            userDao = daoFactory.getDAO(UserDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for user storage system", ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String check = request.getParameter("check");
        try {
            User user = userDao.getByCheckCode(check);
            if (user == null) {
                request.getSession().setAttribute("message", 1);
            } else {
                user.setCheck("0");
                userDao.update(user);
            }
        } catch (DAOException ex) {
            request.getServletContext().log("Impossible to retrieve the user", ex);
        }
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "login.jsp"));
    }
}
