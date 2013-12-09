package com.adams.dt.event
{
	import com.adams.dt.model.vo.Translate;
	import com.universalmind.cairngorm.events.UMEvent;
	import mx.rpc.IResponder;
	public final class TranslationEvent extends UMEvent
	{
		public static const GOOGLE_TRANSLATE : String = "translate";
		public var translateVO : Translate;
		public function TranslationEvent( type : String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false )
		{
			super( type );
		}
	}
}
