package com.adams.dt.business.util 
{	
	import com.adams.dt.business.smtp.SMTPMailer;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.SMTPEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert; 
    public class SMTPUtil
    {
        [Bindable]
		private static var model : ModelLocator = ModelLocator.getInstance();
		// create the socket connection to any SMTP socket
		// use your ISP SMTP
		private static var myMailer:SMTPMailer
		private static var fromEmail:String
		private static var origEmail:String
		
		private static const ErrTitle:String = " SMTP Config "
		public function SMTPUtil():void {
			if(!myMailer) myMailer = new SMTPMailer (model.SmtpHost, model.SmtpPort);
			fromEmail = model.SmtpfrmLbl;
			origEmail = model.SmtpTeamEmail;
			myMailer.authenticate(model.SmtpUsername,model.SmtpPassword)
			// register events
			// event dispatched when mail is successfully sent
			myMailer.addEventListener(SMTPEvent.MAIL_SENT, onMailSent,false,0,true);
			// event dispatched when mail could not be sent
			myMailer.addEventListener(SMTPEvent.MAIL_ERROR, onMailError,false,0,true);
			// event dispatched when SMTPMailer successfully connected to the SMTP server
			myMailer.addEventListener(SMTPEvent.CONNECTED, onConnected,false,0,true);
			// event dispatched when SMTP server disconnected the client for different reasons
			myMailer.addEventListener(SMTPEvent.DISCONNECTED, onDisconnected,false,0,true);
			// event dispatched when the client has authenticated successfully
			myMailer.addEventListener(SMTPEvent.AUTHENTICATED, onAuthSuccess,false,0,true);
			// event dispatched when the client could not authenticate
			myMailer.addEventListener(SMTPEvent.BAD_SEQUENCE, onAuthFailed,false,0,true);
		}
		public static function mail( to_mail:String, subject_mail:String, message_mail:String ):void
		{
			// send HTML email with picture file attached
			myMailer.sendHTMLMail(origEmail, fromEmail, to_mail, subject_mail, message_mail)
		}
		private static function onAuthFailed ( pEvt:SMTPEvent ):void
		{
			var errStr:String = "Authentication Error",ErrTitle
			Alert.show(errStr);
			createNewErrEvent(errStr);
		}
		private static function onAuthSuccess ( pEvt:SMTPEvent ):void
		{
			//Alert.show("Authentication OK !");
		}
		private static function onConnected ( pEvt:SMTPEvent ):void 
		{
			//Alert.show("Connected : \n\n" + pEvt.result.message+ "Code : \n\n" + pEvt.result.code);
		}
		private static function onMailSent ( pEvt:SMTPEvent ):void 
		{
			// when data available, read it
			//Alert.show("Mail sent :\n\n" + pEvt.result.message+ "Code : \n\n" + pEvt.result.code);
		}
		private static function onMailError ( pEvt:SMTPEvent ):void 
		{
			var errStr:String = "Error :\n" + pEvt.result.message+"Code :" + pEvt.result.code
			if(pEvt.result.code!=250) {
				Alert.show(errStr);
				createNewErrEvent(errStr);
			}
		}
		private static function onDisconnected ( pEvt:SMTPEvent ):void 
		{
			var errStr:String = "User disconnected :\n" + pEvt.result.message+ "Code : " + pEvt.result.code
			Alert.show(errStr);
			createNewErrEvent(errStr);
		}
		private static function socketErrorHandler ( pEvt:IOErrorEvent ):void 
		{
			var errStr:String = "Connection error !" 
			Alert.show(errStr);
			createNewErrEvent(errStr);
		}
		private static function createNewErrEvent ( erEvtStr:String):void 
		{
			 var errEvent:Events = new Events()
			 var by:ByteArray = new ByteArray();
			 by.writeUTFBytes(erEvtStr);
			 errEvent.details = by;
			 errEvent.eventName = 'SMTP Error'; 
			 errEvent.eventDateStart = new Date();
			 errEvent.eventType = EventStatus.SMTPError;
			 var eventsEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS)
			 if(model.person.personLogin){
			 	errEvent.personFk = model.person.personId;
			 	eventsEvent.events =  errEvent;
			 	eventsEvent.dispatch();			 
			 }
		}
    }
}