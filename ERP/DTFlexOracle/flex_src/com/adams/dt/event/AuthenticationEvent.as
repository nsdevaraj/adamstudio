package com.adams.dt.event
{
	import com.adams.dt.model.vo.LoginVO;
	import com.universalmind.cairngorm.events.UMEvent;
	import mx.rpc.IResponder;
	public final class AuthenticationEvent extends UMEvent
	{
		public var loginVO : LoginVO;
		public static const EVENT_AUTHENTICATION : String = 'authentication';
		public function AuthenticationEvent(loginVO : LoginVO, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super(EVENT_AUTHENTICATION,handlers );
			super.data = loginVO;
		}
	}
}
