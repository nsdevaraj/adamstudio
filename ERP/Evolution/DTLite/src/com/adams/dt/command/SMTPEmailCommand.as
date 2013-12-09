package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.SMTPEmailEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	public final class SMTPEmailCommand extends AbstractCommand 
	{ 
		private var smtpemailEvent : SMTPEmailEvent;		
		
		override public function execute( event:CairngormEvent ):void {	 
			
			super.execute( event );
			
			smtpemailEvent = event as SMTPEmailEvent;
			
			this.delegate = DelegateLocator.getInstance().smtpEmailUtilDelegate;
			this.delegate.responder = new Callbacks( result, fault ); 
		  
		  switch( event.type ) {   		      
		  	case SMTPEmailEvent.EVENT_CREATE_SMTPEMAIL:
		    	this.delegate = DelegateLocator.getInstance().pagingDelegate;
		        delegate.responder = new Callbacks( createEMailResult, fault );
		       	delegate.SmtpSSLMail( smtpemailEvent.smtpvo.msgTo, smtpemailEvent.smtpvo.msgSubject, smtpemailEvent.smtpvo.msgBody );
		    break; 		      
		    default:
		    break; 
		  }
		}
		
		private function createEMailResult( rpcEvent:Object ):void {
			super.result( rpcEvent );	
		}
	}
}
