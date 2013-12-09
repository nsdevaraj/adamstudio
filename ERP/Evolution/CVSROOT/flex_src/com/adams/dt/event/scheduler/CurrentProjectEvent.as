package com.adams.dt.event.scheduler
{
	import com.universalmind.cairngorm.events.UMEvent;
	import mx.rpc.IResponder;
	public final class CurrentProjectEvent extends UMEvent
	{
		public static const GOTO_CURRENTPROJECT : String = "goCurrentProject";
		public var projectName : String;
		public function CurrentProjectEvent( type : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super( type,handlers,true,false );
		}
	}
}
