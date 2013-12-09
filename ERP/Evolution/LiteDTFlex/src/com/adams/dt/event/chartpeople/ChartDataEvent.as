package com.adams.dt.event.chartpeople
{

	import com.universalmind.cairngorm.events.UMEvent;
	import mx.rpc.IResponder;
	public final class ChartDataEvent extends UMEvent
	{
		public static var EVENT_CHART_MESSAGE : String = "chartmessage"
		public static var EVENT_GETPROFILE_MESSAGE : String = "getprofilemessage";
		public var mailData : String;
		public function ChartDataEvent(pType : String,handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super(pType,handlers,true,false);
		}
	}
}
