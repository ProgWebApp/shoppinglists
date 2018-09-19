package servlets;

import Email.Email;
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
import java.util.logging.Level;
import java.util.logging.Logger;
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
        String filename = null;
        if ((filePart != null) && (filePart.getSize() > 0)) {
            filename = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();//MSIE  fix.
            try (InputStream fileContent = filePart.getInputStream()) {
                File directory = new File(avatarsFolder);
                directory.mkdirs();
                File file = new File(avatarsFolder, filename);
                Files.copy(fileContent, file.toPath());
            } catch (FileAlreadyExistsException ex) {
                getServletContext().log("File \"" + filename + "\" already exists on the server");
            } catch (RuntimeException ex) {
                //TODO: handle the exception
                getServletContext().log("impossible to upload the file", ex);
            }
        }

        if (userFirstName == null || userLastName == null || userEmail == null || userPassword == null) {
            response.sendRedirect(response.encodeRedirectURL(contextPath + "registration.html"));
        }
        try {
            User user = new User();
            user.setFirstName(userFirstName);
            user.setLastName(userLastName);
            user.setEmail(userEmail);
            user.setPassword(userPassword);
            user.setAvatarPath(filename);

            String check = UUID.randomUUID().toString();

            user.setCheck(check);
            userDao.insert(user);
            String testo = "Grazie per esserti iscritto al sito, per completare la registrazione clicca sul link sottostante:\n"
                    + contextPath + "VerifyEmailServlet?check=" + check
                    + "\nQuesta è una mail generata automaticamente, si prega di non ispondere a questo messaggio.";
            Email.send(userEmail, "Registrazione shopping-list", testo);

        } catch (DAOException ex) {
            Logger.getLogger(RegistrationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (!response.isCommitted()) {
            response.sendRedirect(response.encodeRedirectURL(contextPath + "login.html"));
        }
    }
}
