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
		
		/* public static const EVENT_GET_ALL_PROJECTSS : String = 'getAllProjects';
		public static const EVENT_GET_PROJECTS : String = 'getProjects';
		public static const EVENT_CREATE_PROJECTS : String = 'createProjects';
		public static const EVENT_UPDATE_PROJECTS : String = 'updateProjects';
		public static const EVENT_DELETE_PROJECTS : String = 'deleteProjects';
		public static const EVENT_SELECT_PROJECTS : String = 'selectProjects';
		public static const EVENT_PUSH_SELECT_PROJECTS : String = 'pushSelectProjects';
		public static const EVENT_UPDATE_PROJECTNOTES : String = 'updateProjectNotes';
		
		//add by kumar 30th July
		public static const EVENT_STATUSUPDATE_PROJECTS : String = 'selectUpadteProjects';
		public static const EVENT_PUSH_GET_PROJECTSID : String = 'getProjectId'; */
		
		
		public var projects : Projects;
		public var eventPushProjectsId : Number;
		public function ProjectsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pProjects : Projects = null )
		{
			projects = pProjects;
			super(pType,handlers,true,false,projects);
		}

	}
}
