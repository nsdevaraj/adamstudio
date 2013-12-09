package com.adams.dt.event
{
	import com.adams.dt.model.vo.LoginVO;
	import com.universalmind.cairngorm.events.UMEvent;
	import mx.rpc.IResponder;
	public final class ChannelSetEvent extends UMEvent
	{
		public static const SET_CHANNEL : String = "setChannel";
		public var loginVO : LoginVO;
		public function ChannelSetEvent(type : String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false )
		{
			super( type,handlers );
		}
	}
}
