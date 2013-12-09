package com.adams.dt.event
{ 
	import com.adams.dt.model.vo.Projects;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;

	public class SchedulerEvent extends CairngormEvent
	{
		
		public static const EVENT_FETCH_TASK:String='fetchTask';
		
		public var project:Projects;
		
		public function SchedulerEvent (pType:String, pProject:Projects=null){
			
			project= pProject;
			super(pType);
			
		}
		
		override public function clone():Event{
		
			return new SchedulerEvent(type, project);
			
		}

		
	}

}