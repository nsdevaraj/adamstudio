package com.adams.dam.event
{
	
	import com.adams.dam.model.vo.LoginVO;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	
	public final class AuthenticationEvent extends UMEvent
	{
		public static const EVENT_AUTHENTICATION:String = 'authentication';
		
		public var loginVO:LoginVO;
		
		public function AuthenticationEvent( loginVO:LoginVO, handlers:IResponder = null, bubbles:Boolean = true, cancelable:Boolean = false )
		{
			this.loginVO = loginVO;
			super( EVENT_AUTHENTICATION, handlers );
		}
	}
}
