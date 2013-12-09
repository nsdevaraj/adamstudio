package com.adams.dt.event
{
	import com.adams.dt.model.vo.SMTPEmailVO;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	public final class SMTPEmailEvent extends UMEvent
	{
		
		public static const EVENT_CREATE_SMTPEMAIL : String = 'createSmtpEmail';		
		
		public var smtpvo : SMTPEmailVO;
		public function SMTPEmailEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pSmtpEmailvo : SMTPEmailVO = null  )
		{			
			smtpvo = pSmtpEmailvo;
			super(pType,handlers,true,false,smtpvo); 	
		}		
		
		/* public static const EVENT_CREATE_SMTPEMAIL : String = 'createSmtpEmail';
		public var result:Object;
		public function SMTPEmailEvent ( pEvent:String, pSmtpVo:Object )
		{	
			super ( pEvent );
			result = pSmtpVo;
		} */


	}
}
