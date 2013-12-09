package com.adams.dt.event
{
	import com.adams.dt.model.vo.Projects;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	public final class ProjectsEvent extends UMEvent
	{
		public static const EVENT_UPDATE_PROJECTS : String = 'updateProjects';
		public static const EVENT_GET_PROJECTS : String = 'getProjects';
		public static const EVENT_GET_PROJECTSID : String = 'getProjectsid';
				
		public var projects : Projects;
		public var eventPushProjectsId : Number;
		public function ProjectsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pProjects : Projects = null )
		{
			projects = pProjects;
			super(pType,handlers,true,false,projects);
		}

	}
}
