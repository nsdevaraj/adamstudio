package com.adams.dt.event
{
	import flash.events.Event;

	public class ApplicationStatusEvent extends Event
	{
		
		public static const EVENT_IDLESTATE:String='idlestate';
		
		public function ApplicationStatusEvent (pType:String){
			super(pType);
			
		}
		
		override public function clone():Event{
		
			return new ApplicationStatusEvent(type);
			
		}

		
	}

}