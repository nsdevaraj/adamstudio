package com.adams.dt.event
{
	import com.adams.dt.model.vo.Propertiespresets;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class PropertiespresetsEvent extends UMEvent
	{
		public static const EVENT_GET_PROPERTIESPRESETS : String = 'getPropertiespresets';
		public static const EVENT_CREATE_PROPERTIESPRESETS : String = 'createPropertiespresets';
		public static const EVENT_UPDATE_PROPERTIESPRESETS : String = 'updatePropertiespresets';
		public static const EVENT_DELETE_PROPERTIESPRESETS : String = 'deletePropertiespresets';
		public static const EVENT_SELECT_PROPERTIESPRESETS : String = 'selectPropertiespresets';
		public static const EVENT_GET_ALLPROPERTY : String = 'getAllProperty';
		public static const EVENT_BULK_UPDATE_PROPERTIESPRESETS : String = 'bulkUpdateProperty';
		
		public static const EVENT_GET_CONTAINERLOGIN : String = 'getContainerLogin';
		
		public var propertiespresets : Propertiespresets = new Propertiespresets();
		[ArrayElementType("com.adams.dt.model.vo.Propertiespresets")]
		public var propertiespresetsColl:ArrayCollection = new ArrayCollection();
		public function PropertiespresetsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pPropertiespresets : Propertiespresets = null  )
		{
			super(pType,handlers,true,false,propertiespresets);
		}

	}
}
