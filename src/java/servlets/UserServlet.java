package servlets;

import db.daos.UserDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.FileAlreadyExistsException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import static org.apache.tomcat.jdbc.naming.GenericNamingResourcesFactory.capitalize;

@MultipartConfig
public class UserServlet extends HttpServlet {

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
        User activeUser = (User) request.getSession().getAttribute("user");
        if (request.getParameter("changeAvatar") != null && Integer.parseInt(request.getParameter("changeAvatar")) == 1) {
            String avatarsFolder = getServletContext().getRealPath("/images/avatars");
            Part filePart = request.getPart("avatar");
            if ((filePart != null) && (filePart.getSize() > 0)) {
                String filename = UUID.randomUUID().toString() + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();//MSIE  fix.
                try (InputStream fileContent = filePart.getInputStream()) {
                    File directory = new File(avatarsFolder);
                    directory.mkdirs();
                    File file = new File(avatarsFolder, filename);
                    Files.copy(fileContent, file.toPath());
                    activeUser.setAvatarPath(filename);
                    userDAO.update(activeUser);
                } catch (FileAlreadyExistsException | RuntimeException | DAOException ex) {
                    System.out.println(ex.getCause().getMessage());
                    request.getSession().setAttribute("message", 11);
                }
            }
        } else if (request.getParameter("changeName") != null && Integer.parseInt(request.getParameter("changeName")) == 1) {
            if (request.getParameter("firstName") == null || request.getParameter("lastName") == null) {
                request.getSession().setAttribute("message", 21);
            } else {
                String userFirstName = capitalize(request.getParameter("firstName"));
                String userLastName = capitalize(request.getParameter("lastName"));
                if (userFirstName.isEmpty() || userLastName.isEmpty()) {
                    request.getSession().setAttribute("message", 21);
                } else {
                    activeUser.setFirstName(userFirstName);
                    activeUser.setLastName(userLastName);
                    try {
                        userDAO.update(activeUser);
                    } catch (DAOException ex) {
                        request.getSession().setAttribute("message", 22);
                    }
                    request.getSession().setAttribute("message", 23);
                }
            }
        } else if (request.getParameter("changePassword") != null && Integer.parseInt(request.getParameter("changePassword")) == 1) {
            try {
                String oldPassword = request.getParameter("oldPassword");
                String newPassword1 = request.getParameter("newPassword1");
                String newPassword2 = request.getParameter("newPassword2");
                if (oldPassword.isEmpty() || newPassword1.isEmpty() || newPassword2.isEmpty()) {
                    request.getSession().setAttribute("message", 31);
                } else if (userDAO.getByEmailAndPassword(activeUser.getEmail(), oldPassword) == null) {
                    request.getSession().setAttribute("message", 32);
                } else if(!newPassword1.matches("((?=.*\\d)(?=.*[A-Z])(?=.*[@#$%]).{6,20})")){
                    request.getSession().setAttribute("message", 36);
                } else if (!newPassword1.equals(newPassword2)) {
                    request.getSession().setAttribute("message", 33);
                } else {
                    activeUser.setPassword(newPassword2);
                    userDAO.updatePassword(activeUser);
                    request.getSession().setAttribute("message", 35);
                }
            } catch (DAOException ex) {
                request.getSession().setAttribute("message", 34);
            }
        }
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/user.jsp"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /* RESTITUISCO UN ERRORE SE NON HO RICEVUTO TUTTI I PARAMETRI */
        User activeUser = (User) request.getSession().getAttribute("user");

        /* RISPONDO */
        HttpSession session = request.getSession(false);
        try {
            userDAO.delete(activeUser.getId());
            session.invalidate();
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "index.jsp"));
        } catch (DAOException ex) {
            response.sendError(500);
        }
    }
}
