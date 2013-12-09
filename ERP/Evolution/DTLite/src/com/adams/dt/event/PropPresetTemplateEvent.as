package com.adams.dt.event
{
	import com.adams.dt.model.vo.Proppresetstemplates;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public class PropPresetTemplateEvent  extends UMEvent
	{
		public static const EVENT_GET_PROPPRESET_TEMPLATE : String = 'getPropPresetTempById';
		public static const EVENT_DELETE_PROPPRESET_TEMPLATE : String = 'deletePropPresetTemp';
		public static const EVENT_BULK_UPDATE_PROPPRESET_TEMPLATE : String = 'bulkUpdatePropPresetTemp';
		public static const EVENT_DELETE_PROPPRESET_TEMPLATE_BYID : String = 'deletePropPresetTempById';
		public static const EVENT_CREATE_PROPPRESET_TEMPLATE : String = 'createPropPresetTempById';
		public static const EVENT_UPDATE_PROPPRESET_TEMPLATE : String = 'updatePropPresetTemp';
		
		public var prop_PesetTemp:Proppresetstemplates ;
		public var create_propPresetTemp:Proppresetstemplates
		public var prop_PesetColl:ArrayCollection = new ArrayCollection();
		public var propInt :int
		public var deletePropPreset:ArrayCollection = new ArrayCollection();
		public var updateColl:ArrayCollection = new ArrayCollection();
		public function PropPresetTemplateEvent(pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pPresetTemplate : Proppresetstemplates = null )
		{
			prop_PesetTemp = pPresetTemplate;
			super(pType,handlers,true,false,prop_PesetTemp);
		}

	}
}