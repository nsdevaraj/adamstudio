package com.adams.dt.event
{
	import com.adams.dt.model.vo.FileDetails;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import mx.controls.Alert;

	public class LocalDataBaseEvent extends CairngormEvent
	{
		
		public static const EVENT_GET_FILEDETAILS:String='getLocalDbFileDetails';
		public static const EVENT_CREATE_FILEDETAILS:String='createLocalDbFileDetails';				
		public var fileDetails:FileDetails;
		
		public function LocalDataBaseEvent (pType:String, pFileDetails:FileDetails=null){
			fileDetails= pFileDetails;
			super(pType);
			
		}
		override public function clone():Event{
		
			return new LocalDataBaseEvent(type, fileDetails);
			
		}

		
	}

}