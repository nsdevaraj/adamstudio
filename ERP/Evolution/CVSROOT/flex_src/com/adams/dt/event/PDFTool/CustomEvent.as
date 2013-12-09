package com.adams.dt.event.PDFTool
{
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	public final class CustomEvent extends Event
	{
		public static const CUSTOM_CLICK : String = "customClick";
		public function CustomEvent(type : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super(type);
		}

	}
}
