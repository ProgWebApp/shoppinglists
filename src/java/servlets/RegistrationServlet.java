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
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Logger;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

/**
 *
 * @author pberi
 */
public class RegistrationServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     *
     * @author Stefano Chirico
     * @since 2018.05.03
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getServletContext().getContextPath();
        if (contextPath.endsWith("/")) {
            contextPath = contextPath.substring(0, contextPath.length() - 1);
        }

        DAOFactory daoFactory = (DAOFactory) request.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            response.sendError(500, "Impossible to access the database. Error retrieving DAO factory");
            return;
        }

        Integer userId = null;
        String userIdS = request.getParameter("userId");
        if (userIdS != null) {
            try {
                userId = Integer.valueOf(userIdS);
            } catch (NumberFormatException nfe) {
                response.sendError(500, "Impossible to send the email. The server returned: " + nfe.getMessage());
                return;
            }
        }
        if (userId == null) {
            response.sendError(500, "Impossible to send the email. No user selected!!!");
            return;
        }

        try {
            UserDAO userDao = daoFactory.getDAO(UserDAO.class);
            User user = userDao.getByPrimaryKey(userId);
            if (user == null) {
                response.sendError(500, "Impossible to send the email. No valid user with id: " + userId);
                return;
            }
            String subject = "Conferma shoppinglist";
            String message = "Messaggio di conferma della mail";
            
            StringBuilder plainTextMessageBuilder = new StringBuilder();
            plainTextMessageBuilder.append(message).append("\n");

            StringBuilder htmlMessageBuilder = new StringBuilder();
            message = message.replace(" ", "&nbsp;");
            message = message.replace("\n", "<br>");
            htmlMessageBuilder.append(message).append("<br>");

            final String host = getServletContext().getInitParameter("smtp-hostname");
            final String port = getServletContext().getInitParameter("smtp-port");
            final String username = getServletContext().getInitParameter("smtp-username");
            final String password = getServletContext().getInitParameter("smtp-password");
            
            Properties props = System.getProperties();
            props.setProperty("mail.smtp.host", host);
            props.setProperty("mail.smtp.port", port);
            props.setProperty("mail.smtp.socketFactory.port", port);
            props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.setProperty("mail.smtp.auth", "true");
            props.setProperty("mail.smtp.starttls.enable", "true");
            props.setProperty("mail.debug", "true");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            try {
                Multipart multipart = new MimeMultipart("alternative");

                BodyPart messageBodyPart1 = new MimeBodyPart();
                messageBodyPart1.setText(plainTextMessageBuilder.toString());

                BodyPart messageBodyPart2 = new MimeBodyPart();
                messageBodyPart2.setContent(htmlMessageBuilder.toString(), "text/html; charset=utf-8");

                multipart.addBodyPart(messageBodyPart1);
                multipart.addBodyPart(messageBodyPart2);

                Message msg = new MimeMessage(session);
                msg.setFrom(new InternetAddress(username, "Shopping List - Notifier"));
                msg.setRecipients(Message.RecipientType.TO, new InternetAddress[]{new InternetAddress(user.getEmail(), (user.getFirstName() + " " + user.getLastName()).trim())});
                msg.setSubject(subject);
                msg.setSentDate(new Date());
                msg.setContent(multipart);

                Transport.send(msg);

                request.setAttribute("emailSent", true);
                if (!response.isCommitted()) {
                    RequestDispatcher dispatcher = request.getServletContext().getRequestDispatcher(response.encodeRedirectURL("/restricted/users.html"));
                    dispatcher.forward(request, response);
//                    response.sendRedirect(response.encodeRedirectURL(contextPath + "/restricted/users.html"));
                }
            } catch (MessagingException | UnsupportedEncodingException me) {
                Logger.getLogger(getClass().getName()).severe(me.toString());

                request.setAttribute("emailSent", false);
                request.setAttribute("emailError", me.getMessage());
                if (!response.isCommitted()) {
                    RequestDispatcher dispatcher = request.getServletContext().getRequestDispatcher(response.encodeRedirectURL("/restricted/users.html"));
                    dispatcher.forward(request, response);
//                    response.sendRedirect(response.encodeRedirectURL(contextPath + "/restricted/users.html"));
                }
            }
        } catch (DAOFactoryException | DAOException ex) {
            Logger.getLogger(getClass().getName()).severe(ex.toString());
            response.sendError(500, "Impossible to send the email. The server returned: " + ex.getMessage());
        }
    }
}
