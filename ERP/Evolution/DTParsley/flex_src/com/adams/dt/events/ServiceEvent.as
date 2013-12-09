package com.adams.dt.events
{ 
	import com.adams.dt.model.vo.IValueObject;
	import flash.events.Event;
	import mx.collections.IList;  
	public final class ServiceEvent extends Event 
	{
		public static const EVENT_CREATE:String = 'Create';
		public static const EVENT_UPDATE:String = 'Update';
		public static const EVENT_READ:String = 'Read';
		public static const EVENT_DELETE:String = 'Delete';
		public static const EVENT_COUNT:String = 'Count';
		public static const EVENT_FINDALL:String = 'FindAll';
		public static const EVENT_BULKUPDATE:String = 'BulkUpdate';
		public static const EVENT_DELETEALL:String = 'DeleteAll';
		
		public var oldValueObject:IValueObject;
		public var valueObject:IValueObject;
		public var oldList:IList;
		public var list:IList;  
		public var count:int;
		public var destination:String;
		public function ServiceEvent (pType : String ,bubbles:Boolean=true,cancelable:Boolean=false )
		{ 
			super(pType,true,false);
		}
	}
}