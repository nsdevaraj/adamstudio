package com.adams.dt.event
{
	import com.adams.dt.model.vo.TeamTemplates;
	import com.adams.dt.model.vo.Teamlinestemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;

	public class TeamlineTemplatesEvent extends CairngormEvent
	{
		
		public static const EVENT_GET_ALL_TEAMLINETEMPLATES:String='getAllTeamlineTemplates';
		public static const EVENT_GET_TEAMLINETEMPLATES:String='getTeamlineTemplates';
		public static const EVENT_CREATE_TEAMLINETEMPLATES:String='createTeamlineTemplates';
		public static const EVENT_UPDATE_TEAMLINETEMPLATES:String='updateTeamlineTemplates';
		public static const EVENT_DELETE_TEAMLINETEMPLATES:String='deleteTeamlineTemplates';
		public static const EVENT_SELECT_TEAMLINETEMPLATES:String='selectTeamlineTemplates';

		public var teamtemplates:TeamTemplates;
		public var teamlinetemplates:Teamlinestemplates;
		public function TeamlineTemplatesEvent (pType:String, pTeamlineTemplates:Teamlinestemplates=null){
			
			teamlinetemplates = pTeamlineTemplates;
			super(pType);
			
		}
		
		override public function clone():Event{		
			return new TeamlineTemplatesEvent(type, teamlinetemplates);
			
		}

		
	}

}