package com.adams.dt.event.PDFTool
{
	import com.adams.dt.model.ModelLocator;
	import com.universalmind.cairngorm.events.UMEvent;
	import mx.rpc.IResponder;	
	public class updateSVGDataEvent extends UMEvent
	{
		
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		   
		public static const UPDATE_SVGDATA : String = "updateSVGData";
		 
		public function updateSVGDataEvent(EVENT_TYPE:String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
		
			super(EVENT_TYPE,handlers,true,false);
			
		}

	}
}