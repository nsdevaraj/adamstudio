package com.adams.dt.event.PDFTool
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		public static const CUSTOM_CLICK:String = "customClick";
		public function CustomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
            return new CustomEvent(type, bubbles, cancelable);
        }

	}
}