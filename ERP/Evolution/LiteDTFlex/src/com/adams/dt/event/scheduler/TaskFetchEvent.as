package com.adams.dt.event.scheduler
{
	import com.adams.dt.control.DTController;
	import com.universalmind.cairngorm.events.UMEvent;
	import com.adams.dt.model.vo.Projects;
	import flash.events.Event;
	public final class TaskFetchEvent extends UMEvent
	{
		public static const EVENT_FETCH_TASK : String = 'fetchTask';
		public var project : Projects;
		public function TaskFetchEvent (pType : String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false , pProject : Projects = null)
		{
			project = pProject;
			super(pType,handlers,true,false,project);
		}

	}
}
