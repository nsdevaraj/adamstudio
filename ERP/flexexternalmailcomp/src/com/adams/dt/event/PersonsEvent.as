package com.adams.dt.event
{	
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	public final class PersonsEvent extends UMEvent
	{
		public static const EVENT_GETMSG_SENDER:String='messageSender';
		public static const EVENT_GETIMP_PERSONS : String = 'getImp';
		public static const EVENT_CONSU_STATUSONLINE : String = 'consumerOnlineStatus';
		public static const EVENT_GET_PERSONS : String = 'getPersons';
		public static const EVENT_GET_PERSONSID:String='mailpersonid';
		public static const EVENT_GET_ALL_PERSONSS:String='getAll';
		
		
		public static const EVENT_GET_AUTH_PERSONS : String = 'getAuthPersons';
		
		/* public static const EVENT_PUSH_STATUSONLINE : String = 'pushOnlineStatus';
		public static const EVENT_CONSU_STATUSONLINE : String = 'consumerOnlineStatus';
		public static const EVENT_UPDATE_ONLINE_PERSONS : String = 'updateOnlineStatus';
		public static const EVENT_GET_ONLINE_PERSONS : String = 'getOnlinePersons';
		public static const EVENT_UPDATE_STRATUS_PERSONS : String = 'updateStratusId';
		public static const EVENT_GET_ALL_PERSONSS : String = 'getAllPersons';
		public static const EVENT_COLLECT_ALL_PERSONSS : String = 'collectAllPersons';
		public static const EVENT_GET_PERSONS : String = 'getPersons';
		public static const EVENT_CREATE_PERSONS : String = 'createPersons';
		public static const EVENT_UPDATE_PERSONS : String = 'updatePersons';
		public static const EVENT_DELETE_PERSONS : String = 'deletePersons';
		public static const EVENT_GETPRJ_PERSONS : String = 'prjPersons';
		public static const EVENT_GETMSG_SENDER : String = 'messageSender';
		public static const EVENT_CONSU_ADMIN : String = 'consumerAdminStatus';
		public static const EVENT_PRODU_ADMIN : String = 'producerAdminStatus';
		public static const EVENT_GETIMP_PERSONS : String = 'getImp'; */
		
		//public static const EVENT_GET_PERSONSID:String='mailpersonid';

		public var persons:Persons;
		public var project:Projects;
		public var profiles:Profiles;
		public var loginName:String;
		public var personId:int;
		public function PersonsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pPersons : Persons = null )
		{
			persons = pPersons;
			super(pType,handlers,true,false,persons);
		}

	}
}