package com.adams.dt.event
{
	import com.adams.dt.model.vo.DefaultTemplateValue;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public final class DefaultTemplateValueEvent extends UMEvent
	{
		
		public static const EVENT_CREATE_DEFAULT_TEMPLATE_VALUE : String = 'createDefaultTemplateValue';
		public static const EVENT_GET_ALL_DEFAULT_TEMPLATE_VALUE : String ='getAllDefaultTemplateValue'
		public static const BULK_UPDATE_DEFAULT_TEMPLATE_VALUE : String = 'bulkUpdateDefaultTemplateValue';
		public static const UPDATE_DEFAULT_TEMPLATE_VALUE : String = 'updateDefaultTemplateValue';
		public static const GET_DEFAULT_TEMPLATE_VALUE : String = 'getDefaultTemplateValue';
		public static const GET_DELETE_TEMPLATE_VALUE : String = 'getDeleteTemplateValue';
		public static const DELETE_DEFAULT_TEMPLATE_VALUE : String = 'deleteDefaultTemplateValue';
		
		public var defaultTemplateValues:DefaultTemplateValue;
		public var defaultTemplateValuesID:int;
		public var defaultTempValuesArr:ArrayCollection = new ArrayCollection();
		public function DefaultTemplateValueEvent( pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, templateValues:DefaultTemplateValue = null )
		{
			defaultTemplateValues = templateValues;
			super( pType, handlers, true, false, defaultTemplateValues );
		}

	}
}
