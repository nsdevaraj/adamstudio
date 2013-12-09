package com.adams.dt.event
{	
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Profiles;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	public final class ProfilesEvent extends UMEvent
	{
		public static const EVENT_MSGSENDER_PROFILES : String = 'getsenderProfiles';
		public static const EVENT_GET_ALL_PROFILESS : String = 'getAllProfiles';
		public static const EVENT_GETPRJ_PROFILES : String = 'prjProfiles';
		
		/*
		public static const EVENT_GET_PROFILES : String = 'getProfiles';
		public static const EVENT_CREATE_PROFILES : String = 'createProfiles';
		public static const EVENT_UPDATE_PROFILES : String = 'updateProfiles';
		public static const EVENT_DELETE_PROFILES : String = 'deleteProfiles';
		public static const EVENT_SELECT_PROFILES : String = 'selectProfiles';
		public static const EVENT_GETPRJ_PROFILES : String = 'prjProfiles'; */
		
		public var profiles : Profiles;
		public var person : Persons;
		public function ProfilesEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pProfiles : Profiles = null  )
		{
			profiles = pProfiles;
			super(pType,handlers,true,false,profiles);
		}
	}	
}