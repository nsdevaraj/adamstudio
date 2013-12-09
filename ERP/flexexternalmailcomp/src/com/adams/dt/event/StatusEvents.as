package com.adams.dt.event
{
	import com.adams.dt.model.vo.Status;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	public final class StatusEvents extends UMEvent
	{
		public static const EVENT_GET_ALL_STATUS : String = 'getAllStatus';
		public static const EVENT_GET_STATUS : String = 'getStatus';
		public static const EVENT_CREATE_STATUS : String = 'createStatus';
		public static const EVENT_UPDATE_STATUS : String = 'updateStatus';
		public static const EVENT_DELETE_STATUS : String = 'deleteStatus';
		public static const EVENT_SELECT_STATUS : String = 'selectStatus';
		public var status : Status;
		public function StatusEvents(pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false,pStatus : Status = null )
		{
			status = pStatus;
			super(pType,handlers,true,false,status);
		}

	}
}
