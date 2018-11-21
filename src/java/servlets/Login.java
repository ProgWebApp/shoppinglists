package servlets;

import db.daos.UserDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet that handles the login web page.
 */
public class Login extends HttpServlet {

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
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        

        try {
            User user = userDao.getByEmailAndPassword(email, password);

            if (user == null) {
                request.getSession().setAttribute("message", 1);
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "login.jsp"));
            } else if (!user.getCheck().equals("0")) {
                request.getSession().setAttribute("message", 2);
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "login.jsp"));
            } else {
                if(request.getParameter("rememberMe")!= null && request.getParameter("rememberMe").equals("true")){
                    String token = UUID.randomUUID().toString();
                    LocalDate date = LocalDate.now().plusMonths(1);
                    Date expiration = java.sql.Date.valueOf(date);
                    userDao.setToken(user.getId(), token, expiration);
                    Cookie cookie = new Cookie("token", token);
                    cookie.setMaxAge(2678400);
                    response.addCookie(cookie);
                }
                request.getSession().setAttribute("user", user);
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "index.jsp"));
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to retrieve the user", ex);
        }
    }
}
