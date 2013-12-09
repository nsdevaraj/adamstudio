package com.adams.dt.events
{ 
	import com.adams.dt.model.vo.IValueObject;
	import flash.events.Event;
	import mx.collections.IList;  
	public final class ServiceEvent extends Event 
	{
		public static const EVENT_PERSON_CREATE:String = 'personCreate';
		public static const EVENT_PERSON_UPDATE:String = 'personUpdate';
		public static const EVENT_PERSON_READ:String = 'personRead';
		public static const EVENT_PERSON_DELETE:String = 'personDelete';
		public static const EVENT_PERSON_COUNT:String = 'personCount';
		public static const EVENT_PERSON_FINDALL:String = 'personFindAll';
		public static const EVENT_PERSON_BULKUPDATE:String = 'personBulkUpdate';
		public static const EVENT_PERSON_DELETEALL:String = 'personDeleteAll';
		
		public var oldValueObject:IValueObject;
		public var valueObject:IValueObject;
		public var oldList:IList;
		public var list:IList;  
		public var count:int;
		
		public function ServiceEvent (pType : String ,bubbles:Boolean=true,cancelable:Boolean=false )
		{ 
			super(pType,true,false);
		}
	}
}