package com.adams.dam.event
{
	import com.adams.dam.model.vo.Projects;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	
	public final class ProjectsEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_PROJECTS:String = 'getAllProjects';
		
		public var projects:Projects;
		
		public function ProjectsEvent( pType:String, handlers:IResponder = null, bubbles:Boolean = true, cancelable:Boolean = false, pProjects:Projects = null )
		{
			projects = pProjects;
			super( pType, handlers, true, false, projects );
		}
	}
}
