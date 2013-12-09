package com.adams.dt.event
{
	import flash.events.Event;
	import com.adams.dt.model.vo.Status;
	import com.adobe.cairngorm.control.CairngormEvent;

	public class StatusEvent extends CairngormEvent
	{
		
		public static const EVENT_GET_ALL_STATUSS:String='getAllStatus';
		public static const EVENT_GET_STATUS:String='getStatus';
		public static const EVENT_CREATE_STATUS:String='createStatus';
		public static const EVENT_UPDATE_STATUS:String='updateStatus';
		public static const EVENT_DELETE_STATUS:String='deleteStatus';
		public static const EVENT_SELECT_STATUS:String='selectStatus';

		

		public var status:Status;
		
		public function StatusEvent (pType:String, pStatus:Status=null){
			
			status= pStatus;
			super(pType);
			
		}
		
		override public function clone():Event{
		
			return new StatusEvent(type, status);
			
		}

		
	}

}