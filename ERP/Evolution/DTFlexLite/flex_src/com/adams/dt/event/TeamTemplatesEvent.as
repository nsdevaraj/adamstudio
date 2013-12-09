package com.adams.dt.event
{
	import com.adams.dt.model.vo.TeamTemplates;
	import com.adams.dt.model.vo.Workflows;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	public final class TeamTemplatesEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_TEAMTEMPLATESS : String = 'getAllTeamTemplates';
		public static const EVENT_GET_TEAMTEMPLATES : String = 'getTeamTemplates';
		public static const EVENT_CREATE_TEAMTEMPLATES : String = 'createTeamTemplates';
		public static const EVENT_UPDATE_TEAMTEMPLATES : String = 'updateTeamTemplates';
		public static const EVENT_DELETE_TEAMTEMPLATES : String = 'deleteTeamTemplates';
		public static const EVENT_SELECT_TEAMTEMPLATES : String = 'selectTeamTemplates';
		public var teamtemplates : TeamTemplates;
		public var workFlow : Workflows;
		public function TeamTemplatesEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pTeamTemplates : TeamTemplates = null  )
		{
			teamtemplates = pTeamTemplates;
			super(pType,handlers,true,false,teamtemplates);
		}

	}
}
