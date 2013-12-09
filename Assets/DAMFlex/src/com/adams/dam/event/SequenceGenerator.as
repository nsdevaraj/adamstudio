package com.adams.dam.event
{
	import com.universalmind.cairngorm.events.generator.EventGenerator;
	
	import mx.rpc.IResponder;

	public class SequenceGenerator extends EventGenerator
	{
		public function SequenceGenerator( eventsToFire:Array = null, handlers:IResponder = null, failCount:int = 0, triggerType:String = TRIGGER_SEQUENCE )
		{
			super( eventsToFire, handlers, failCount, triggerType );
		}
	}
}