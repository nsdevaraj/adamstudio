package com.adams.dt.event
{
	import com.adams.dt.model.vo.TeamTemplates;
	import com.adams.dt.model.vo.Workflows;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;

	public class TeamTemplatesEvent extends CairngormEvent
	{
		
		public static const EVENT_GET_ALL_TEAMTEMPLATESS:String='getAllTeamTemplates';
		public static const EVENT_GET_TEAMTEMPLATES:String='getTeamTemplates';
		public static const EVENT_CREATE_TEAMTEMPLATES:String='createTeamTemplates';
		public static const EVENT_UPDATE_TEAMTEMPLATES:String='updateTeamTemplates';
		public static const EVENT_DELETE_TEAMTEMPLATES:String='deleteTeamTemplates';
		public static const EVENT_SELECT_TEAMTEMPLATES:String='selectTeamTemplates';

		

		public var teamtemplates:TeamTemplates;
		public var workFlow:Workflows;
		public function TeamTemplatesEvent (pType:String, pTeamTemplates:TeamTemplates=null){
			
			teamtemplates= pTeamTemplates;
			super(pType);
			
		}
		
		override public function clone():Event{
		
			return new TeamTemplatesEvent(type, teamtemplates);
			
		}

		
	}

}