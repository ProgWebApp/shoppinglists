/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Email;

import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Logger;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletContext;

public class Email {

    static StringBuilder plainTextMessageBuilder;
    static StringBuilder htmlMessageBuilder;
    boolean emailSent;
    static String emailError;
    static String host;
    static String port;
    static String username;
    static String password;

    public static void send(String recipient, String subject, String message, ServletContext context) throws NullPointerException {
        if (subject == null) {
            throw new NullPointerException("Subject is null!");
        }
        if (message == null) {
            throw new NullPointerException("Message is null!");
        }
        host = context.getInitParameter("smtp-hostname");
        port = context.getInitParameter("smtp-port");
        username = context.getInitParameter("smtp-username");
        password = context.getInitParameter("smtp-password");

        plainTextMessageBuilder = new StringBuilder();
        plainTextMessageBuilder.append(message).append("\n");
        htmlMessageBuilder = new StringBuilder();
        message = message.replace(" ", "&nbsp;");
        message = message.replace("\n", "<br>");
        htmlMessageBuilder.append(message).append("<br>");

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
            msg.setRecipients(Message.RecipientType.TO, new InternetAddress[]{new InternetAddress(recipient)});
            msg.setSubject(subject);
            msg.setSentDate(new Date());
            msg.setContent(multipart);

            Transport.send(msg);
        } catch (MessagingException | UnsupportedEncodingException me) {
            throw new NullPointerException(me.getMessage());
        }
    }

}
