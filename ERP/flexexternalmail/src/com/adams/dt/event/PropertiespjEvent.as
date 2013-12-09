package com.adams.dt.event
{
	import com.adams.dt.model.vo.Propertiespj;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class PropertiespjEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_PROPERTIESPJS : String = 'getAllPropertiespj';
		public static const EVENT_GET_PROPERTIESPJ : String = 'getPropertiespj';
		public static const EVENT_CREATE_PROPERTIESPJ : String = 'createPropertiespj';
		public static const EVENT_UPDATE_PROPERTIESPJ : String = 'updatePropertiespj';
		public static const EVENT_DELETE_PROPERTIESPJ : String = 'deletePropertiespj';
		public static const EVENT_SELECT_PROPERTIESPJ : String = 'selectPropertiespj';
		public static const EVENT_BULKUPDATE_PROPERTIESPJ : String = 'bulkupdatePropertiespj';
		public static const EVENT_BULKUPDATE_DEPORTPROPERTIESPJ : String = 'bulkupdateDeportPropertiespj';
		
		
		public var propertiespj : Propertiespj;
		public var propertiespjCollection : ArrayCollection;
		public function PropertiespjEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pPropertiespj : Propertiespj = null  )
		{
			propertiespj = pPropertiespj;
			super(pType,handlers,true,false,propertiespj);
		}

	}
}
