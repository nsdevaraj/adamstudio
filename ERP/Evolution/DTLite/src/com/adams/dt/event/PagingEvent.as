package com.adams.dt.event
{
	import com.universalmind.cairngorm.events.UMEvent;
	import com.universalmind.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class PagingEvent extends UMEvent
	{
		
		public static const EVENT_GET_SQL_QUERY:String='getSQLQuery';
	    public static const EVENT_GET_PROJECT_COUNT:String='getProjectCount';
	    public static const EVENT_GET_PROJECT_PAGED:String='getProjectPage'; 
	 	
		public var vo:IValueObject; 
		public var startIndex:int; 
		public var endIndex:int; 
		public var queryString:String;
		public var colIndex:int;
		public function PagingEvent (pType:String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false,pVO:IValueObject=null){			
			vo= pVO;
			super(pType,handlers,true,false,vo);			
		}		 

		
	}

}