package com.adams.dt.event
{
	import com.adams.dt.model.vo.DefaultTemplate;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	
	public final class DefaultTemplateEvent extends UMEvent
	{
		public static const EVENT_CREATE_DEFAULT_TEMPLATE : String = 'createDefaultTemplate';
		public static const EVENT_GET_ALL_DEFAULT_TEMPLATE : String ='getAllDefaultTemplate'
		public static const UPDATE_DEFAULT_TEMPLATE : String = 'updateDefaultTemplate';
		public static const BULK_UPDATE_DEFAULT_TEMPLATE : String = 'bulkUpdateDefaultTemplate';
		public static const GET_COMMON_DEFAULT_TEMPLATE : String = 'getCommonDefaultTemplate';
		public static const GET_DEFAULT_TEMPLATE : String = 'getDefaultTemplate';
		public static const DELETE_DEFAULT_TEMPLATE : String = 'deleteDefaultTemplate';
		public var defaultTemplates:DefaultTemplate;
		public var companyId:int
		public function DefaultTemplateEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, templates:DefaultTemplate = null )
		{
			defaultTemplates = templates;
			super( pType, handlers, true, false, defaultTemplates );
		}

	}
}
