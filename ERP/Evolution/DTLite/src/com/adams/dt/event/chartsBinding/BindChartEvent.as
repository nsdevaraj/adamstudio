package com.adams.dt.event.chartsBinding
{
	import flash.events.Event;
	
	public final class BindChartEvent extends Event
	{
		public static const DO_BINDING : String = "makeBinding";
		
		public function BindChartEvent( type : String , bubbles : Boolean = false , cancelable : Boolean = false )
		{
			super(type , bubbles , cancelable);
		}

		override public function clone() : Event
		{
			return new BindChartEvent( type , bubbles , cancelable );
		}
	}
}
