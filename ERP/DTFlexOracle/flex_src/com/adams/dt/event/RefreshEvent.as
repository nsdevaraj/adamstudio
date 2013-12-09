package com.adams.dt.event
{
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;

	public class RefreshEvent extends UMEvent
	{
		
		public static const REFRESH:String='refresh';
		
		public function RefreshEvent (pType:String){
			super(pType);			
		}
		
		override public function clone():Event{
			return new RefreshEvent(type);
			
		}

		
	}

}