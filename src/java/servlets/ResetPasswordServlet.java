/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import Email.Email;
import db.daos.UserDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pberi
 */
public class ResetPasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            userDAO = daoFactory.getDAO(UserDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for user storage system", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getParameter("res") == null) {
            response.sendError(400);
            return;
        }
        Integer res;
        User user;
        try {
            res = Integer.valueOf(request.getParameter("res"));
        } catch (NumberFormatException ex) {
            response.sendError(400);
            return;
        }
        switch (res) {
            case 1:
                String email = request.getParameter("email");
                if (email.isEmpty()) {
                    request.getSession().setAttribute("message", 1);
                    response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "retrievePassword.jsp"));
                    return;
                }
                try {
                    user = userDAO.getByEmail(email);
                    String check = UUID.randomUUID().toString();
                    user.setCheck(check);
                    user.setPassword(null);
                    userDAO.update(user);
                    userDAO.updatePassword(user);

                    String hostName = request.getServerName() + ":" + request.getServerPort();
                    String testo = "Per completare la procedura di ripristino della password clicca sul seguente link:\n"
                            + "https://" + hostName + request.getAttribute("contextPath") + "ResetPasswordServlet?check=" + check + "\n"
                            + "Nel caso il link non dovesse funzionare copialo nella barra del browser e premi invio.\n"
                            + "Questa è una mail generata automaticamente, si prega di non ispondere a questo messaggio.";
                    Email.send(email, "Reimpostazione password shopping-list", testo);
                } catch (DAOException ex) {
                    request.getServletContext().log("Impossible to retrieve the user", ex);
                    request.getSession().setAttribute("message", 1);
                    response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "retrievePassword.jsp"));
                }
                request.getSession().setAttribute("message", 2);
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "retrievePassword.jsp"));
                break;
            case 2:
                String password1 = request.getParameter("password1");
                String password2 = request.getParameter("password2");
                String check = request.getParameter("check");
                if (check.isEmpty()) {
                    request.getSession().setAttribute("message", 3);
                    response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "retrievePassword.jsp"));
                    return;
                }
                if (password1.isEmpty() || password2.isEmpty() || !password1.equals(password2)) {
                    request.getSession().setAttribute("message", 1);
                    request.getSession().setAttribute("check", check);
                    response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "resetPassword.jsp"));
                    return;
                }
                if (!password1.matches("((?=.*\\d)(?=.*[A-Z])(?=.*[@#$%]).{6,20})")) {
                    request.getSession().setAttribute("message", 2);
                    response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "resetPassword.jsp"));
                    return;
                }
                try {
                    user = userDAO.getByCheckCode(check);
                    user.setCheck("0");
                    user.setPassword(password2);
                    userDAO.update(user);
                    userDAO.updatePassword(user);
                } catch (DAOException ex) {
                    Logger.getLogger(ResetPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.getSession().setAttribute("message", 5);
                response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "login.jsp"));
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String check = request.getParameter("check");
        if (!check.isEmpty()) {
            try {
                User user = userDAO.getByCheckCode(check);
                if (user != null) {
                    request.getSession().setAttribute("check", check);
                    response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "resetPassword.jsp"));
                    return;
                }
            } catch (DAOException ex) {
            }
        }
        request.getSession().setAttribute("message", 3);
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "retrievePassword.jsp"));
    }
}
