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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import static org.apache.tomcat.jdbc.naming.GenericNamingResourcesFactory.capitalize;

@MultipartConfig
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
        User activeUser = null;
        activeUser = (User) request.getSession().getAttribute("user");
        if (activeUser != null) {
            if (request.getParameter("changeAvatar") != null && Integer.parseInt(request.getParameter("changeAvatar")) == 1) {
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
                activeUser.setAvatarPath(filename);
            } else if (request.getParameter("changeName") != null && Integer.parseInt(request.getParameter("changeName")) == 1) {
                String userFirstName = capitalize(request.getParameter("firstName"));
                String userLastName = capitalize(request.getParameter("lastName"));
                if (userFirstName == null || userLastName == null) {
                    request.getSession().setAttribute("message", 21);
                } else {
                    activeUser.setFirstName(userFirstName);
                    activeUser.setLastName(userLastName);
                    request.getSession().setAttribute("message", 22);
                }
            } else if (request.getParameter("changePassword") != null && Integer.parseInt(request.getParameter("changePassword")) == 1) {
                String realOldPassword = activeUser.getPassword();
                System.out.println("vecchia password: " + realOldPassword);
                String oldPassword = request.getParameter("oldPassword");
                String newPassword = request.getParameter("newPassword");
                String newPassword2 = request.getParameter("newPassword2");
                if (oldPassword == null || newPassword == null || newPassword2 == null) {
                    request.getSession().setAttribute("message", 31);
                } else {
                    if (!oldPassword.equals(realOldPassword)) {
                        request.getSession().setAttribute("message", 32);
                    } else if (!newPassword.equals(newPassword2)) {
                        request.getSession().setAttribute("message", 33);
                    } else {
                        activeUser.setPassword(newPassword2);
                        request.getSession().setAttribute("message", 34);
                    }
                }
            } else if (request.getParameter("deleteUser") != null && Integer.parseInt(request.getParameter("deleteUser")) == 1) {
                if (request.getParameter("idUser") == null) {
                    try {
                        userDao.delete(((User) request.getSession().getAttribute("user")).getId());
                        response.sendRedirect(response.encodeRedirectURL(contextPath + "login.jsp"));
                        return;
                    } catch (DAOException ex) {
                        Logger.getLogger(UserServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    if (activeUser.isAdmin()) {
                        try {
                            userDao.delete(Integer.parseInt(request.getParameter("idUser")));
                        } catch (DAOException ex) {
                            Logger.getLogger(UserServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
            }
            response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/user.jsp"));
            return;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = null;

        User activeUser = (User) request.getSession().getAttribute("user");
        Integer activeUserId = activeUser.getId();

        try {
            userId = Integer.valueOf(request.getParameter("userId"));
        } catch (RuntimeException ex) {
            System.out.println(ex);
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
