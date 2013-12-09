package com.adams.dt.event
{
	import com.adams.dt.model.vo.Presetstemplates;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	
	public class PresetTemplateEvent extends UMEvent
	{
		public static const EVENT_CREATE_PRESET_TEMPLATE : String = 'createPresetTemplate';
		public static const EVENT_UPDATE_PRESET_TEMPLATE : String = 'updatePresetTemplate';
		
		public static const EVENT_GET_PRESET_TEMPLATEID : String = 'getPresetTemplateId';
		public static const EVENT_GETALL_PRESETTEMPLATE : String = 'getAllPresetTemplate';
		
		public var preTemplate:Presetstemplates;
		public var presetTemplatesId:int;
		public function PresetTemplateEvent(pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pTemplates : Presetstemplates = null  )
		{
			preTemplate = pTemplates;
			super(pType,handlers,true,false,preTemplate);
		}

	}
}