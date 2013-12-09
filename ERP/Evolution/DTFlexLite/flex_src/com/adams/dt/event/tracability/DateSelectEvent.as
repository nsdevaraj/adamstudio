package com.adams.dt.event.tracability
{
	import flash.events.Event;
	import mx.rpc.IResponder;
	public final class DateSelectEvent extends Event
	{
		public static const DATE_SELECTED : String = "dateSelected";
		public function DateSelectEvent( type : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false )
		{
			super(type , bubbles , cancelable);
		}

	}
}
