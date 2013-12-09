package com.adams.dt.event
{
	import com.adams.dt.model.vo.FileDetails;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class LocalDataBaseEvent extends UMEvent
	{
		
		public static const EVENT_GET_FILEDETAILS:String='getLocalDbFileDetails';
		public static const EVENT_CREATE_FILEDETAILS:String='createLocalDbFileDetails';				
		public var fileDetails:ArrayCollection;
		public var fileDetailsObj:FileDetails;
		public function LocalDataBaseEvent (pType:String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pFileDetails:ArrayCollection=null ){
			fileDetails= pFileDetails;
			super(pType,handlers,true,false,fileDetails);
			
		}
		
	}

}