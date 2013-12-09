package com.adams.dt.event.departure
{
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	
	public class DepartureMapEvent extends Event
	{
		public static const MAP_DEPARTURE : String = "mapDeparture";
		public var changedField:String;
		
		public function DepartureMapEvent( type:String, handlers:IResponder = null, bubbles:Boolean = true, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}

	}
}


