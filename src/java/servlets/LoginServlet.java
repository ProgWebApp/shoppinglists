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

/**
 * Servlet that handles the login web page.
 */
public class LoginServlet extends HttpServlet {

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
            User user = null;
            user = userDao.getByEmailAndPassword(email, password);
            
            if (user == null) {
                System.out.println("Email o password errati");
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "login.jsp?err=1"));
            } else if(!user.getCheck().equals("0")) {
                System.out.println("Account non verificato tramite mail");
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "login.jsp?err=2"));
            }else{
                request.getSession().setAttribute("user", user);
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "mainpagelogged.html"));
            }
        } catch (DAOException ex) {
            request.getServletContext().log("Impossible to retrieve the user", ex);
        }
    }
}
