package com.adams.dt.event
{
	import com.adams.dt.command.TeamlinesCommand;
	import com.adams.dt.model.vo.Teamlines;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class TeamlineEvent extends UMEvent
	{
		public static const EVENT_SELECT_TEAMLINE : String = 'selectTeamline';
		public static const EVENT_PROFILE_PROJECT_TEAMLINE : String = 'getProfileProjectTeamline';
		public static const EVENT_TASK_STATUS : String = 'getTaskStatusTeamline';
		public static const EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE : String = 'getProfileProjectMSGTeamline';

		
		
		/* public static const EVENT_GET_ALL_TEAMLINE : String = 'getAllTeamline';
		public static const EVENT_GET_TEAMLINE : String = 'getTeamline';
		public static const EVENT_CREATE_TEAMLINE : String = 'createTeamline';
		public static const EVENT_UPDATE_TEAMLINE : String = 'updateTeamline';
		public static const EVENT_DELETE_TEAMLINE : String = 'deleteTeamline';		
		public static const EVENT_PROFILE_PROJECT_TEAMLINE : String = 'getProfileProjectTeamline';
		public static const EVENT_CURRENT_PROJECT_TEAMLINE : String = 'getProjectTeamline';
		public static const EVENT_GETPROJECT_CLOSE : String = 'projectClose';
		public static const EVENT_PUSH_PROJECT_TEAMLINE : String = 'getPushProjectTeamline';
		//add by kumar July 28 separate taskid push purpose
		public static const EVENT_CLOSE_PROJECT_TEAMLINE : String = 'getCloseProjectTeamline';	
		public static const EVENT_PUSH_PROJECTSTATUS_TEAMLINE : String = 'getStatusProjectTeamline';	
			
		public static const EVENT_PUSH_DELAYSTATUS_TEAMLINE : String = 'getStatusDelayTeamline'; */
			
		public var teamline : Teamlines;
		public var projectId:int;
		public var teamlineCollection : ArrayCollection;
		
		public function TeamlineEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, teamlines : Teamlines = null  )
		{
			teamline = teamlines;
			super(pType,handlers,true,false,teamline);
		}

	}
}

