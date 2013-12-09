package com.adams.dt.event
{
	import com.adams.dt.model.vo.Projects;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	public final class ProjectsEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_PROJECTSS : String = 'getAllProjects';
		public static const EVENT_GET_PROJECTS : String = 'getProjects';
		public static const EVENT_GET_PROJECTCOUNTS : String = 'getProjectcounts';
		public static const CREATE_AUTO_PROJECTS : String = 'createAutoProjects';
		public static const EVENT_CREATE_PROJECTS : String = 'createProjects';
		public static const EVENT_UPDATE_PROJECTS : String = 'updateProjects';
		public static const EVENT_DELETE_PROJECTS : String = 'deleteProjects';
		public static const EVENT_DELETEALL_PROJECTS : String = 'deleteAllProjects';
		public static const EVENT_SELECT_PROJECTS : String = 'selectProjects';
		public static const EVENT_PUSH_SELECT_PROJECTS : String = 'pushSelectProjects';
		public static const EVENT_UPDATE_PROJECTNOTES : String = 'updateProjectNotes';
		public static const EVENT_UPDATE_PROJECTNAME : String = 'updateProjectName';
		public static const EVENT_CLOSE_PRJ_TASKCOMPLETE : String = 'complteTasksofPRj';
		
		//add by kumar 30th July
		public static const EVENT_STATUSUPDATE_PROJECTS : String = 'selectUpadteProjects';
		public static const EVENT_PUSH_GET_PROJECTSID : String = 'getProjectId';
		public static const EVENT_MOVE_DIRECTORY : String = 'moveProjDir';
		
		public static const EVENT_ORACLE_NEWPROJECTCALL : String = 'createOracleNewProject';		
		
		public var frompath : String;
		public var topath : String;
		public var projects : Projects;
		public var eventPushProjectsId : int;
		public var propertChange:String = '';
		
		public var codeEAN : String = '';
		public var codeGEST : String = '';
		public var codeIMPRE : String = '';
				
		public function ProjectsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pProjects : Projects = null )
		{
			projects = pProjects;
			super(pType,handlers,true,false,projects);
		}

	}
}
