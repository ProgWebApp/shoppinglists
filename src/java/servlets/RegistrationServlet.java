package servlets;

import Email.Email;
import db.daos.UserDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.exceptions.UniqueConstraintException;
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
import javax.servlet.http.Part;

@MultipartConfig
public class RegistrationServlet extends HttpServlet {

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

        String userFirstName = request.getParameter("firstName");
        String userLastName = request.getParameter("lastName");
        String userEmail = request.getParameter("email");
        String userPassword = request.getParameter("password");
        String avatarsFolder = getServletContext().getInitParameter("avatarsFolder");
        if (avatarsFolder == null) {
            throw new ServletException("Avatars folder not configured");
        }
        avatarsFolder = getServletContext().getRealPath(avatarsFolder);
        Part filePart = request.getPart("avatar");
        String fileName = UUID.randomUUID().toString() + Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); //MSIE  fix.

        User user = new User();
        user.setFirstName(userFirstName);
        user.setLastName(userLastName);
        user.setEmail(userEmail);
        user.setPassword(userPassword);
        user.setAvatarPath(fileName);
        String check = UUID.randomUUID().toString();
        user.setCheck(check);

        if (userFirstName.isEmpty() || userLastName.isEmpty() || userEmail.isEmpty() || userPassword.isEmpty() || filePart.getSize() == 0) {
            user.setAvatarPath("");
            request.getSession().setAttribute("message", 1);
            request.getSession().setAttribute("newUser", user);
            response.sendRedirect(response.encodeRedirectURL(contextPath + "registration.jsp"));
            return;
        }

        try (InputStream fileContent = filePart.getInputStream()) {
            File directory = new File(avatarsFolder);
            directory.mkdirs();
            File file = new File(avatarsFolder, fileName);
            Files.copy(fileContent, file.toPath());
        } catch (FileAlreadyExistsException ex) {
            throw new ServletException("File \"" + fileName + "\" already exists on the server", ex);
        } catch (RuntimeException ex) {
            throw new ServletException("Impossible to upload the file \"" + fileName + "\"", ex);
        }

        try {
            userDao.insert(user);
            
            String hostName = request.getServerName() + ":" + request.getServerPort();
            String testo = "Grazie per esserti iscritto al sito, per completare la registrazione clicca sul seguente link:\n"
                    + "http://" + hostName + contextPath + "VerifyEmailServlet?check=" + check + "\n"
                    + "Nel caso il link non dovesse funzionare copialo nella barra del browser e premi invio.\n"
                    + "Questa è una mail generata automaticamente, si prega di non ispondere a questo messaggio.";
            Email.send(userEmail, "Registrazione shopping-list", testo);

        } catch (DAOException ex) {
            if (ex.getCause() instanceof UniqueConstraintException) {
                user.setEmail("");
                user.setAvatarPath("");
                request.getSession().setAttribute("newUser", user);
                request.getSession().setAttribute("message", 2);
                response.sendRedirect(response.encodeRedirectURL(contextPath + "registration.jsp"));
                return;
            }
            throw new ServletException(ex);
        }
        request.getSession().setAttribute("message", 3);
        response.sendRedirect(response.encodeRedirectURL(contextPath + "login.jsp"));
    }
}
