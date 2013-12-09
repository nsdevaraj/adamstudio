package com.adams.dt.event.sortingevent
{
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	public class SortingEvent extends UMEvent
	{
		
		public var monthName:String='';
		public var yearName:String='';
		public var weekName:String='';
		public var toggleName:String='';
		public var toggleStatus:Boolean;
		public static const EVENT_GET_SORT_MONTH : String = 'getsortByMonth';
		public static const EVENT_GET_SORT_YEAR : String = 'getsortByYear';
		public static const EVENT_GET_SORT_WEEK : String = 'getsortByWeek';
		public static const EVENT_GET_TOGGLE_NAME : String = 'getToggleName';
		public function SortingEvent (cType : String ,handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super(cType,handlers,true,false);
		}
	}
}