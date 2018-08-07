/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.UserDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class UserServlet extends HttpServlet {

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String contextPath = getServletContext().getContextPath();
        if (!contextPath.endsWith("/")) {
            contextPath += "/";
        }
        User activeUser = (User) request.getSession().getAttribute("user");
        Integer activeUserId = activeUser.getId();
        Integer userId = null;

        try {
            userId = Integer.valueOf(request.getParameter("userId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        String userFirstName = request.getParameter("firstName");
        String userLastName = request.getParameter("lastName");
        String userEmail = request.getParameter("email");
        String userPassword = request.getParameter("password");
        String userAvatarPath = request.getParameter("avatarPath");
        Boolean userIsAdmin = Boolean.valueOf(request.getParameter("isAdmin"));

        if (userFirstName == null || userLastName == null || userEmail == null || userPassword == null) {
            response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/user.html"));
        }
        try {
            User user = new User();
            user.setId(userId);
            user.setFirstName(userFirstName);
            user.setLastName(userLastName);
            user.setEmail(userEmail);
            user.setPassword(userPassword);
            user.setAvatarPath(userAvatarPath);
            user.setAdmin(userIsAdmin);

            if (userId == null) {
                userDao.insert(user);
            } else if (activeUser.isAdmin() || activeUserId.equals(userId)) {
                userDao.update(user);
            }
        } catch (DAOException ex) {
            Logger.getLogger(UserServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/user.html"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = null;
        User activeUser = (User) request.getSession().getAttribute("user");
        Integer activeUserId = activeUser.getId();

        try {
            userId = Integer.valueOf(request.getParameter("userId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        if (userId != null && ((activeUser.isAdmin()) || activeUserId.equals(userId))) {
            try {
                userDao.delete(userId);
            } catch (DAOException ex) {
                Logger.getLogger(UserServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
