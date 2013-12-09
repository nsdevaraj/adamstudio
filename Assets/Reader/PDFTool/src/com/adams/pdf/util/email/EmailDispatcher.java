package com.adams.pdf.util.email;

import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.PasswordAuthentication;
import javax.mail.SendFailedException;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.URLName;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.adams.pdf.util.BuildConfig;
import com.sun.mail.smtp.SMTPAddressFailedException;
import com.sun.mail.smtp.SMTPAddressSucceededException;
import com.sun.mail.smtp.SMTPSendFailedException;
import com.sun.mail.smtp.SMTPTransport;

public class EmailDispatcher {

	private String smtpMailStarttlsEnable = "false";
	private String smtpMailAuth = "false";
	private String smtpMailDebugging = "false";

	String cc = null, bcc = null, url = null;
	String file = null;
	//String protocol = null, host = null;
	String record = null;	// name of folder in which to record mail
	boolean verbose = false;
	String port = "smtp";
	private Session session = null;
	private Properties serverprops = null;
	private SMTPTransport t = null;
	private String connectionError = "";
	private String dispatchError = "";
	private String errorDetails = "";

	public String getErrorDetails() {
		return errorDetails;
	}

	public EmailDispatcher() {

	}

	public void openTransport() {
		try {
			serverprops = new Properties();

			if(BuildConfig.smtpMailStarttlsEnable)
				smtpMailStarttlsEnable = "true";

			if(BuildConfig.smtpMailAuth)
				smtpMailAuth = "true";

			if(BuildConfig.smtpMailDebugging)
				smtpMailDebugging = "true";


			serverprops.put("mail.smtp.user", BuildConfig.smtpMailFromUser);
			serverprops.put("mail.smtp.host", BuildConfig.smtpMailHostName);
			serverprops.put("mail.smtp.port", BuildConfig.smtpMailHostPort);
			serverprops.put("mail.smtp.auth", smtpMailAuth);
			serverprops.put("mail.smtp.debug", smtpMailDebugging);
			serverprops.put("mail.smtp.socketFactory.port", BuildConfig.smtpMailHostPort);
			serverprops.put("mail.smtp.starttls.enable",smtpMailStarttlsEnable);
			if(BuildConfig.smtpMailIsSSL)
				serverprops.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			serverprops.put("mail.smtp.socketFactory.fallback", "false");

			// Get a Session object
			Authenticator authe = new SMTPAuthenticator();
			session = Session.getInstance(serverprops, null);
			session.setDebug(BuildConfig.smtpMailDebugging);

			t = (SMTPTransport)session.getTransport(port);
			if (BuildConfig.smtpMailAuth) {
				t.connect(BuildConfig.smtpMailHostName , BuildConfig.smtpMailFromUser, BuildConfig.smtpMailFromPass);
			} else {
				t.connect();
			}
		} catch (MessagingException e) {
			this.connectionError = e.getMessage();
		}
	}

	public void closeTransport() {
		try {
			t.close();
			session = null;
			serverprops = null;
		} catch (MessagingException e) {
			//handleFailedException(e);
		}
	}

    public boolean dispatch(com.adams.pdf.util.email.Message message) {
    	Message msg = null;
    	boolean dispatchSuccess = true;
    	try {
			msg = buildMessage(session, message);
    		try {
    			t.sendMessage(msg, msg.getAllRecipients());
    		} catch(Exception e) {
    			throw e;
    		} finally {if (verbose) {
    				System.out.println("Response: " + t.getLastServerResponse());
    			}
    		}
		} catch (Exception e) {
		    handleFailedException(e);
		    dispatchSuccess = false;
		}
		return dispatchSuccess;
    }

	private Message buildMessage(Session session, com.adams.pdf.util.email.Message message) throws MessagingException, AddressException {
		Message msg = new MimeMessage(session);
		if (BuildConfig.smtpMailFromUser != null)
			msg.setFrom(new InternetAddress(BuildConfig.smtpMailFromUser));
		else
			msg.setFrom();

		msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(message.getTo(), false));
		if (message.getCc()!= null)
			msg.setRecipients(Message.RecipientType.CC, InternetAddress.parse(message.getCc(), false));
		if (message.getBcc()!= null)
			msg.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(message.getBcc(), false));

		msg.setSubject(message.getSubject());
		msg.setText(message.getText());
		msg.setHeader("Content-Type", "text/html");
		msg.setSentDate(new Date());
		return msg;
	}

	private void handleFailedException(Exception e) {
		String dispatchError = "";
		if (e instanceof SendFailedException) {
			MessagingException sfe = (MessagingException)e;
			if (sfe instanceof SMTPSendFailedException) {
			    SMTPSendFailedException ssfe = (SMTPSendFailedException)sfe;
			    dispatchError += "SMTP SEND FAILED:";
			    if (verbose)
			    	dispatchError += "\n"+ ssfe.toString();
			    dispatchError += "\n  Command: " + ssfe.getCommand();
			    dispatchError += "\n  RetCode: " + ssfe.getReturnCode();
			    dispatchError += "\n  Response: " + ssfe.getMessage();
			} else {
			    if (verbose)
			    	dispatchError += "\nSend failed: " + sfe.toString();
			}
			Exception ne;
			while ((ne = sfe.getNextException()) != null && ne instanceof MessagingException) {
			    sfe = (MessagingException)ne;
			    if (sfe instanceof SMTPAddressFailedException) {
			    	SMTPAddressFailedException ssfe = (SMTPAddressFailedException)sfe;
			    	dispatchError += "\nADDRESS FAILED:";
			    	if (verbose)
			    		dispatchError += "\n"+ssfe.toString();
			    	dispatchError += "\n  Address: " + ssfe.getAddress();
			    	dispatchError += "\n  Command: " + ssfe.getCommand();
			    	dispatchError += "\n  RetCode: " + ssfe.getReturnCode();
			    	dispatchError += "\n  Response: " + ssfe.getMessage();
			    } else if (sfe instanceof SMTPAddressSucceededException) {
			    	dispatchError += "\nADDRESS SUCCEEDED:";
			    	SMTPAddressSucceededException ssfe = (SMTPAddressSucceededException)sfe;
			    	if (verbose)
			    		dispatchError += "\n"+ssfe.toString();
			    	dispatchError += "\n  Address: " + ssfe.getAddress();
			    	dispatchError += "\n  Command: " + ssfe.getCommand();
			    	dispatchError += "\n  RetCode: " + ssfe.getReturnCode();
			    	dispatchError += "\n  Response: " + ssfe.getMessage();
			    }
			}
		} else {
			dispatchError = e.getMessage();
		}
		this.dispatchError = dispatchError;
		this.errorDetails = "Error:\n"+this.connectionError + "\n" + this.dispatchError;
	}

	private static void saveACopy(String url, String protocol, String host,
			String user, String password, String record, Session session,
			Message msg) throws NoSuchProviderException, MessagingException {
		/*
	     * Save a copy of the message, if requested.
	     */
	    if (record != null) {
			// Get a Store object
			Store store = null;
			if (url != null) {
			    URLName urln = new URLName(url);
			    store = session.getStore(urln);
			    store.connect();
			} else {
			    if (protocol != null)
				store = session.getStore(protocol);
			    else
				store = session.getStore();

			    // Connect
			    if (host != null || user != null || password != null)
				store.connect(host, user, password);
			    else
				store.connect();
			}

			// Get record Folder.  Create if it does not exist.
			Folder folder = store.getFolder(record);
			if (folder == null) {
			    System.err.println("Can't get record folder.");
			    System.exit(1);
			}
			if (!folder.exists())
			    folder.create(Folder.HOLDS_MESSAGES);

			Message[] msgs = new Message[1];
			msgs[0] = msg;
			folder.appendMessages(msgs);

			System.out.println("Mail was recorded successfully.");
	    }
	}

	private class SMTPAuthenticator extends javax.mail.Authenticator
    {
        public PasswordAuthentication getPasswordAuthentication()
        {
            return new PasswordAuthentication(BuildConfig.smtpMailFromUser, BuildConfig.smtpMailFromPass);
        }
    }

}
