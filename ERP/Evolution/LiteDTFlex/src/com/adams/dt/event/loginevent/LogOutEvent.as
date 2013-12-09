package com.adams.dt.event.loginevent
{
	import com.adams.dt.model.vo.LoginVO;
	import com.adams.dt.model.vo.Persons;
	import com.universalmind.cairngorm.events.UMEvent;
	import flash.events.Event;
	import mx.rpc.IResponder;
	public final class LogOutEvent extends UMEvent
	{
		public static const EVENT_LOGOUT : String = "logOut";
		public var loginvo : LoginVO;
		public var personout : Persons;
		public function LogOutEvent (lType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super(lType,handlers,true,false);
			super.data = personout;
		}

	}
}
