package util;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailService {
    private final Session session;
    private final String from;

    public EmailService(String host, int port, String username, String password, boolean startTls, String fromAddress) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", String.valueOf(startTls)); // true per porta 587
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", String.valueOf(port));
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");      // utile in dev
        props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3"); // evita negoziazioni vecchie
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");
        this.from = fromAddress;

        this.session = Session.getInstance(props, new Authenticator() {
            @Override protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
    }

    public void sendHtml(String to, String subject, String html, String replyTo) throws MessagingException, UnsupportedEncodingException {
        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(from, "TecnoDeposit"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject(subject, "UTF-8");
        msg.setContent(html, "text/html; charset=UTF-8");
        if (replyTo != null && !replyTo.isEmpty()) {
            msg.setReplyTo(new Address[]{ new InternetAddress(replyTo) });
        }
        Transport.send(msg);
    }
}
