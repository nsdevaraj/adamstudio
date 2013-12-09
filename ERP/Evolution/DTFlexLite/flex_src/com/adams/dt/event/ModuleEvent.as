package com.adams.dt.event
{
	import com.adams.dt.model.vo.Modules;
	import com.adams.dt.model.vo.Profiles;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
		public class ModuleEvent extends UMEvent
		{
			public static const EVENT_GET_ALL_MODULES: String ='getAllModules'
			public var module:Modules = new Modules();
			public var profile:Profiles = new Profiles();
			public function ModuleEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pModule:Modules= null  )
			{ 
				module = pModule;
				super(pType,handlers,true,false,module);
			}
	
		}
}