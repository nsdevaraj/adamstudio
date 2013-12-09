package com.adams.dt.event
{
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Teamlines;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class TeamlineEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_TEAMLINE : String = 'getAllTeamline';
		public static const EVENT_GET_TEAMLINE : String = 'getTeamline';
		public static const EVENT_CREATE_TEAMLINE : String = 'createTeamline';
		public static const EVENT_UPDATE_TEAMLINE : String = 'updateTeamline';
		public static const EVENT_DELETE_TEAMLINE : String = 'deleteTeamline';
		public static const EVENT_DELETE_TEAMLINE_UNSELECTPERSON : String = 'deleteTeamlineonUnselectPerson';
		public static const EVENT_SELECT_TEAMLINE : String = 'selectTeamline';
		public static const EVENT_PROFILE_PROJECT_TEAMLINE : String = 'getProfileProjectTeamline';
		public static const EVENT_CURRENT_PROJECT_TEAMLINE : String = 'getProjectTeamline';
		//public static const EVENT_GETPROJECT_CLOSE : String = 'projectClose';          //change for Tasks event
		public static const EVENT_PUSH_PROJECT_TEAMLINE : String = 'getPushProjectTeamline';
		//add by kumar July 28 separate taskid push purpose
		public static const EVENT_CLOSE_PROJECT_TEAMLINE : String = 'getCloseProjectTeamline';	
		public static const EVENT_PUSH_PROJECTSTATUS_TEAMLINE : String = 'getStatusProjectTeamline';	
			
		public static const EVENT_PUSH_DELAYSTATUS_TEAMLINE : String = 'getStatusDelayTeamline';
		public static const EVENT_PUSH_DELAYEDTASKSTATUS_TEAMLINE : String = 'getStatusDelayedTaskTeamline';
		
		public static const EVENT_PROJECT_ABORTED_TEAMLINE : String = 'getAbortedTeamline';
		//public static const EVENT_GETABORTEDPROJECT_CLOSE : String = 'AbortedProjectClose';   //change for Tasks event
		public static const EVENT_GET_IMP_TEAMLINE : String = 'getImpTeamLine';
		public static const EVENT_UPDATE_IMPTEAMLINE : String = 'updateImpTeamLine';
		public static const EVENT_PROJECT_TEAMLINE : String = 'projectTeamline';	
		public static const EVENT_FINISHED_TASK_TEAMLINE : String = 'taskFinishTeamline';
		public static const EVENT_DELETEALL : String = 'DeleteAllTeamline';	
		
		public static const EVENT_DELETE_TEAMLINE_SELECTION : String = 'deleteTeamlineSelection';
		public static const EVENT_CREATE_TEAMLINE_SELECTION : String = 'createTeamlineSelection';
		
			
		public var teamline:Teamlines;
		public var projectObj:Projects;
		public var projectId:int;
		public var profileId:int;
		public var teamlineCollection : ArrayCollection;
		public var finishTask:Tasks;
		public var presetTempMessage:String = '';
		
		
		public function TeamlineEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, teamlines : Teamlines = null  )
		{
			teamline = teamlines;
			super(pType,handlers,true,false,teamline);
		}

	}
}
