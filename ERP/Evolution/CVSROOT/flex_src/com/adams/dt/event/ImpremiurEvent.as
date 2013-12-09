package com.adams.dt.event
{
	import com.adams.dt.model.vo.Impremiur;
	import com.adams.dt.model.vo.Workflows;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public final class ImpremiurEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_IMPREMIUR : String = 'getAllImpremiur';
		public static const EVENT_COPY_WF_IMPREMIUR : String = 'copyAllImpremiur';
		public static const EVENT_BULKUPDATE_IMPREMIUR : String = 'bulkupdateImpremiur';
		public static const EVENT_CREATE_IMPREMIUR : String = 'createImpremiur';
		
		public var impremiur:Impremiur;
		public var impremiurCollection:ArrayCollection;
		public var workflow:Workflows = new Workflows();
		public function ImpremiurEvent(pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, impremiurs : Impremiur = null  )
		{
			impremiur = impremiurs;
			super(pType,handlers,true,false,impremiur);
		}

	}
}