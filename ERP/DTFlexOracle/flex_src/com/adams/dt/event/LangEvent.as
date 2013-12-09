package com.adams.dt.event
{
	import com.adams.dt.model.vo.LangEntries;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	public final class LangEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_LANGS : String = 'getAllLanguages';
		public var langentry : LangEntries;
		public function LangEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, plang : LangEntries = null )
		{
			langentry = plang;
			super(pType,handlers,true,false,langentry);
		}
	}
}
