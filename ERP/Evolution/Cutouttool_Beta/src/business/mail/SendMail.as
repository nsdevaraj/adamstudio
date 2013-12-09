package business.mail
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class SendMail extends EventDispatcher
	{
		public static const HOST:String = 'smtp.wp.pl';
		public static const USERNAME:String = 'devaraj';
		public static const PASSWORD:String = 'adams2009';
		public static const FROM:String = 'adams@localhost';
		public static const PORT:int = 25;
		public function SendMail(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function mail(mailto:String,subject:String,msg:String):void{
			var smtp:SmtpSocket = new SmtpSocket();
			smtp.Host = HOST;
			smtp.Username = USERNAME;
			smtp.Password = PASSWORD;
			smtp.frmLbl = FROM;
			smtp.Port = PORT;
			smtp.connect(smtp.Host,	smtp.Port );  
			smtp.recepient = mailto;
			smtp.QuickSubject = subject;
			smtp.msgBody = msg;
		}
		
	}
}