package com.adams.dt.event.tracability
{
	import flash.events.Event;
	import mx.rpc.IResponder;
	public final class PeriodChangeEvent extends Event
	{
		public static const PERIOD_CHANGE : String = "periodChanged";
		public function PeriodChangeEvent( type : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super(type , bubbles , cancelable);
		}

	}
}
