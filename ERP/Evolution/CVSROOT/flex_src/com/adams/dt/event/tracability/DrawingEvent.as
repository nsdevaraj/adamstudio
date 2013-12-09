package com.adams.dt.event.tracability
{
	import flash.events.Event;
	import mx.rpc.IResponder;
	public final class DrawingEvent extends Event
	{
		public static const SET_SELECTDATE : String = "selectedDateSet";
		public function DrawingEvent( type : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false )
		{
			super(type , bubbles , cancelable);
		}

	}
}
