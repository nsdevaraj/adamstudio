package com.adams.suite.utils
{
	
	import com.adams.suite.utils.MD5;
	import com.adams.suite.utils.SMTPEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
    import org.alivepdf.encoding.Base64;
	
	public class SMTPMailer extends Socket 
	{
		private var sHost:String;
		private var buffer:Array = new Array();
		
		// regexp pattern
		private var reg:RegExp = /^\d{3}/img;
		
		// PNG, JPEG header values
		private static const PNG:Number = 0x89504E47;
		private static const JPEG:Number = 0xFFD8;
		
		// common SMTP server response codes
		// other codes could be added to add fonctionalities and more events
		private static const ACTION_OK:Number = 0xFA;
		private static const AUTHENTICATED:Number = 0xEB;
		private static const DISCONNECTED:Number = 0xDD;
		private static const READY:Number = 0xDC;
		private static const DATA:Number = 0x162;
		private static const BAD_SEQUENCE:Number = 0x1F7;
		
		public function SMTPMailer ( pHost:String, pPort:int) 
		{
			super ( pHost, pPort );			
			sHost = pHost;
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		/*
		* This method lets you authenticate, just pass a login and password
		*/
		public function authenticate ( pLogin:String, pPass:String ):void
		{
			writeUTFBytes ("EHLO "+sHost+"\r\n");
			writeUTFBytes ("AUTH LOGIN\r\n");
			writeUTFBytes (Base64.encode64String (pLogin)+"\r\n");
			writeUTFBytes (Base64.encode64String (pPass)+"\r\n");
			flush();
		}
		
		/*
		* This method is used to send emails with attached files and HTML 
		* takes an incoming Bytearray and convert it to base64 string
		* for instance pass a JPEG ByteArray stream to get a picture attached in the mail ;)
		*/
		public function sendAttachedMail ( origFrom:String, pFrom:String, pDest:String, pSubject:String, pMess:String, pByteArray:ByteArray, pFileName:String ) :void
		{
			try {

				writeUTFBytes ("HELO "+sHost+"\r\n");
				writeUTFBytes ("MAIL FROM: <"+origFrom+">\r\n");
				writeUTFBytes ("RCPT TO: <"+pDest+">\r\n");
				writeUTFBytes ("DATA\r\n");
				writeUTFBytes ("From: "+pFrom+"\r\n");
				writeUTFBytes ("To: "+pDest+"\r\n");
				writeUTFBytes ("Date : "+new Date().toString()+"\r\n");
				writeUTFBytes ("Subject: "+pSubject+"\r\n");
				writeUTFBytes ("Mime-Version: 1.0\r\n");
				
				var md5Boundary:String = MD5.hash ( String ( getTimer() ) );
				
				writeUTFBytes ("Content-Type: multipart/mixed; boundary=------------"+md5Boundary+"\r\n");
				writeUTFBytes("\r\n");
				writeUTFBytes ("This is a multi-part message in MIME format.\r\n");
				writeUTFBytes ("--------------"+md5Boundary+"\r\n");
				writeUTFBytes ("Content-Type: text/html; charset=UTF-8; format=flowed\r\n");
				writeUTFBytes("\r\n");
				writeUTFBytes (pMess+"\r\n");
				writeUTFBytes ("--------------"+md5Boundary+"\r\n");
				writeUTFBytes ( readHeader (pByteArray, pFileName) );
				writeUTFBytes ("Content-Transfer-Encoding: base64\r\n");
				writeUTFBytes ("\r\n");
				
				var base64String:String = Base64.encode64 ( pByteArray, true );

				writeUTFBytes ( base64String+"\r\n");
				writeUTFBytes ("--------------"+md5Boundary+"-\r\n");
				writeUTFBytes (".\r\n");
				flush();
				
			} catch ( pError:Error )
			{
				trace("Error : Socket error, please check the sendAttachedMail() method parameters");
				trace("Arguments : " + arguments );		
			}
		}
		
		/*
		* This method is used to send HTML emails
		* just pass the HTML string to pMess
		*/
		public function sendHTMLMail ( origFrom:String, pFrom:String, pDest:String, pSubject:String, pMess:String ):void
		{
			try 
			{			
				writeUTFBytes ("HELO "+sHost+"\r\n");
				writeUTFBytes ("MAIL FROM: <"+origFrom+">\r\n");
				writeUTFBytes ("RCPT TO: <"+pDest+">\r\n");
				writeUTFBytes ("DATA\r\n");
				writeUTFBytes ("From: "+pFrom+"\r\n");
				writeUTFBytes ("To: "+pDest+"\r\n");
				writeUTFBytes ("Subject: "+pSubject+"\r\n");
				writeUTFBytes ("Mime-Version: 1.0\r\n");
				writeUTFBytes ("Content-Type: text/html; charset=UTF-8; format=flowed\r\n");
				writeUTFBytes("\r\n");
				writeUTFBytes (pMess+"\r\n");
				writeUTFBytes (".\r\n");
				flush();
				
			} catch ( pError:Error )
			{	
				trace("Error : Socket error, please check the sendHTMLMail() method parameters");
				trace("Arguments : " + arguments );	
			}
		}
		
		/*
		* This method automatically detects the header of the binary stream and returns appropriate headers (jpg, png)
		* classic application/octet-stream content type is added for different kind of files
		*/
		private function readHeader ( pByteArray:ByteArray, pFileName:String ):String 
		{
			pByteArray.position = 0;
			
			var sOutput:String = null;
			
			if ( pByteArray.readUnsignedInt () == SMTPMailer.PNG ) 
			{
				sOutput = "Content-Type: image/png; name="+pFileName+"\r\n";
				sOutput += "Content-Disposition: attachment filename="+pFileName+"\r\n";
				return sOutput;	
			}
			
			pByteArray.position = 0;
			
			if ( pByteArray.readUnsignedShort() == SMTPMailer.JPEG ) 
			{
				sOutput = "Content-Type: image/jpeg; name="+pFileName+"\r\n";
				sOutput += "Content-Disposition: attachment filename="+pFileName+"\r\n";
				return sOutput;	
			}
				
			sOutput = "Content-Type: application/octet-stream; name="+pFileName+"\r\n";
			sOutput += "Content-Disposition: attachment filename="+pFileName+"\r\n";
			
			return sOutput;
		}
		
		// check SMTP response and dispatch proper events
		// Keep in mind SMTP servers can have different result messages the detection can be modified to match some specific SMTP servers
		private function socketDataHandler ( pEvt:ProgressEvent ):void
		{
			var response:String = pEvt.target.readUTFBytes ( pEvt.target.bytesAvailable );
			buffer.length = 0;
			var result:Array = reg.exec(response);
            
			while (result != null)
			{	
				buffer.push (result[0]);
				result = reg.exec(response);
			}
			
			var smtpReturn:Number = buffer[buffer.length-1];
			var smtpInfos:SMTPInfos = new SMTPInfos ( smtpReturn, response );
		
			if ( smtpReturn == SMTPMailer.READY ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.CONNECTED, smtpInfos ) );
			
			else if ( smtpReturn == SMTPMailer.ACTION_OK && (response.toLowerCase().indexOf ("queued") != -1 || response.toLowerCase().indexOf ("accepted") != -1 ||
					response.toLowerCase().indexOf ("qp") != -1) ) dispatchEvent ( new SMTPEvent ( SMTPEvent.MAIL_SENT, smtpInfos ) );
			else if ( smtpReturn == SMTPMailer.AUTHENTICATED ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.AUTHENTICATED, smtpInfos ) );
			else if ( smtpReturn == SMTPMailer.DISCONNECTED ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.DISCONNECTED, smtpInfos ) );
			else if ( smtpReturn == SMTPMailer.BAD_SEQUENCE ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.BAD_SEQUENCE, smtpInfos ) );
			else if ( smtpReturn != SMTPMailer.DATA ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.MAIL_ERROR, smtpInfos ) );	
		}
	}
}