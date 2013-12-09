package com.adams.dt.event
{
	import com.adams.dt.model.vo.Columns;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;

	public final class ColumnsEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_COLUMNS : String = 'getAllColumns'; 
		public var column : Columns;
		
		public function ColumnsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pColumns : Columns= null  )
		{
			column = pColumns;
			super(pType,handlers,true,false,column);
		}


	}
}
