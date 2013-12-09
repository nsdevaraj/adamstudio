package com.adams.dt.event
{
	import flash.events.Event;
	import com.adams.dt.model.vo.Groups;
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GroupsEvent extends CairngormEvent
	{
		
		public static const EVENT_GET_ALL_GROUPSS:String='getAllGroups';
		public static const EVENT_GET_GROUPS:String='getGroups';
		public static const EVENT_CREATE_GROUPS:String='createGroups';
		public static const EVENT_UPDATE_GROUPS:String='updateGroups';
		public static const EVENT_DELETE_GROUPS:String='deleteGroups';
		public static const EVENT_SELECT_GROUPS:String='selectGroups';

		

		public var groups:Groups;
		
		public function GroupsEvent (pType:String, pGroups:Groups=null){
			
			groups= pGroups;
			super(pType);
			
		}
		
		override public function clone():Event{
		
			return new GroupsEvent(type, groups);
			
		}

		
	}

}