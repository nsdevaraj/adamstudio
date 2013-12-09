package com.adams.dt.event
{
	import com.adams.dt.model.vo.Events;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	public final class EventsEvent extends UMEvent
	{
		public static const EVENT_CREATE_EVENTS : String = 'createEvents';
		
		
		/* public static const EVENT_GET_ALL_EVENTSS : String = 'getAllEvents';
		public static const EVENT_GET_EVENTS : String = 'getEvents';
		public static const EVENT_CREATE_EVENTS : String = 'createEvents';
		public static const EVENT_UPDATE_EVENTS : String = 'updateEvents';
		public static const EVENT_DELETE_EVENTS : String = 'deleteEvents';
		public static const EVENT_SELECT_EVENTS : String = 'selectEvents';
		public static const EVENT_GETCURRENTPROJECT_EVENTS : String = 'getCurrentEvents'; */
		
		public var events : Events;
		public function EventsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pEvents : Events = null)
		{
			events = pEvents;
			super(pType,handlers,true,false,events);
		}
		
	}
}
