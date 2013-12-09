package com.adams.dt.event
{
	import com.adams.dt.model.vo.TeamTemplates;
	import com.adams.dt.model.vo.Teamlinestemplates;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class TeamlineTemplatesEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_TEAMLINETEMPLATES : String = 'getAllTeamlineTemplates';
		public static const EVENT_GET_TEAMLINETEMPLATES : String = 'getTeamlineTemplates';
		public static const EVENT_GETWF_TEAMLINETEMPLATES : String = 'getWfTeamlineTemplates';
		public static const EVENT_CREATE_TEAMLINETEMPLATES : String = 'createTeamlineTemplates';
		public static const EVENT_UPDATE_TEAMLINETEMPLATES : String = 'updateTeamlineTemplates';
		public static const EVENT_DELETE_TEAMLINETEMPLATES : String = 'deleteTeamlineTemplates';
		public static const EVENT_SELECT_TEAMLINETEMPLATES : String = 'selectTeamlineTemplates';
		public static const EVENT_BULK_UPDATE_TEAMLINETEMPLATES : String = 'bulkUpdateTeamlineTemplates'
		public static const EVENT_DELETE_ALL_TEAMLINETEMPLATES : String = 'deleteAllTeamlineTemplates'
		public var teamtemplates : TeamTemplates = new TeamTemplates();
		public var teamlinetemplates : Teamlinestemplates;
		public var teamlinetemplateArr:ArrayCollection = new ArrayCollection();
		public function TeamlineTemplatesEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pTeamlineTemplates : Teamlinestemplates = null  )
		{
			teamlinetemplates = pTeamlineTemplates;
			super(pType,handlers,true,false,teamlinetemplates);
		}

	}
}
