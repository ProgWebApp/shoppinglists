/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Email;

import java.util.Date;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;

public class Email {

    static String username = "prog.sistemi1@gmail.com";
    static String password = "moxapdvwligeqzfu";

    public static void send(String recipient, String subject, String message) throws NullPointerException {
        if (subject == null) {
            throw new NullPointerException("Subject is null!");
        }
        if (message == null) {
            throw new NullPointerException("Message is null!");
        }
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.setProperty("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(username));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            msg.setSubject(subject);
            msg.setSentDate(new Date());
            msg.setText(message);
            Transport.send(msg);
        } catch (MessagingException me) {
            me.printStackTrace(System.err);
            throw new NullPointerException(me.getMessage());
        }
    }

}
