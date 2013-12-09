package com.adams.dt.event
{	
	import com.adams.dt.model.vo.Propertiespresets;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class PropertiespresetsEvent extends UMEvent
	{
		public static const EVENT_GET_ALLPROPERTY:String='getAllProperty';  //used
		
		public var propertiespresets : Propertiespresets = new Propertiespresets();
		[ArrayElementType("com.adams.dt.model.vo.Propertiespresets")]
		public var propertiespresetsColl:ArrayCollection = new ArrayCollection();
		public function PropertiespresetsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pPropertiespresets : Propertiespresets = null  )
		{
			super(pType,handlers,true,false,propertiespresets);
		}
	}
}