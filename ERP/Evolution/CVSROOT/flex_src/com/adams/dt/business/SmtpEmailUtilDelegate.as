package com.adams.dt.business
{ 	
	import mx.rpc.IResponder;
	public final class SmtpEmailUtilDelegate extends AbstractDelegate implements IDAODelegate
	{
		public function SmtpEmailUtilDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.SMTP_EMAIL_SERVICE);
		}
		override public function SmtpSSLMail( msgTo:String, msgSubject:String, msgBody:String) : void
		{
			invoke("SmtpSSLMail",msgTo, msgSubject, msgBody);
		} 		
	}
}
