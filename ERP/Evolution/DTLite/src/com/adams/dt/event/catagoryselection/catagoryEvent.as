package com.adams.dt.event.catagoryselection
{
	import com.universalmind.cairngorm.events.UMEvent;
	import mx.rpc.IResponder;	
	public final class catagoryEvent extends UMEvent
	{
		public static var CATAGORYBREAD_DATA : String = "catagorybreadcrumbdatas" 
		public function catagoryEvent(pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super(pType,handlers,true,false);
		}
	}
}
