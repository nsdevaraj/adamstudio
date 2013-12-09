package com.adams.dt.event
{
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	public final class PersonsEvent extends UMEvent
	{
		public static const EVENT_PUSH_STATUSONLINE:String = 'pushOnlineStatus';
		public static const EVENT_CONSU_STATUSONLINE:String = 'consumerOnlineStatus';
		public static const EVENT_UPDATE_ONLINE_PERSONS:String = 'updateOnlineStatus';
		public static const EVENT_SELECTED_PERSON:String = 'selectPerson';
		public static const EVENT_GET_ONLINE_PERSONS:String = 'getOnlinePersons';
		public static const EVENT_UPDATE_STRATUS_PERSONS:String = 'updateStratusId';
		public static const EVENT_GET_ALL_PERSONS:String = 'getAllPersons';
		public static const EVENT_UPDATE_ALL_PERSONS:String = 'updateAllPersons';
		public static const EVENT_GET_PERSONS:String = 'getPersons';
		public static const EVENT_CREATE_PERSONS:String = 'createPersons';
		public static const EVENT_UPDATE_PERSONS:String = 'updatePersons';
		public static const EVENT_DELETE_PERSONS:String = 'deletePersons';
		public static const EVENT_GETPRJ_PERSONS:String = 'prjPersons';
		public static const EVENT_GETMSG_SENDER:String = 'messageSender';
		public static const EVENT_CONSU_ADMIN:String = 'consumerAdminStatus';
		public static const EVENT_PRODU_ADMIN:String = 'producerAdminStatus';
		public static const EVENT_BULK_DELETE_PERSONS:String = 'bulkdeletePersons';
		public static const EVENT_BULK_UPDATE_PERSONS:String = 'bulkupdatePersons';
		public static const EVENT_CREATE_SINGLE_PERSONS:String = 'createSinglePersons';
		public static const EVENT_PRODUCER:String = 'producerChat';
		
		public static const EVENT_GETIND_PERSONS : String = 'getInd';
		public static const EVENT_PERSON_LOGOUT : String = 'personLogout';
		
		public static const EVENT_CHAT_CONSUMER : String = 'consumerChat';
		public static const EVENT_CHAT_PRODUCER : String = 'producerChat';
		
		public static const EVENT_LOGIN_RESULT : String = 'LoginResult';
		public var personId:int;
				
		public var adminmonitorscreen:String;
		public var OnlineOffline:String = "Online";
		public var persons:Persons;
		public var project:Projects;
		public var profiles:Profiles;
		public var selectedPerson:String;
		public var getPersonId:int;
		
		public function PersonsEvent( pType:String, handlers:IResponder=null, bubbles:Boolean=true, cancelable:Boolean=false, pPersons:Persons=null )
		{
			persons = pPersons;
			super( pType, handlers, true, false, persons );
		}
	}
}
