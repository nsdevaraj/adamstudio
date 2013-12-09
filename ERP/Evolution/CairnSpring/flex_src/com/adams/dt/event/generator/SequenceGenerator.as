package com.adams.dt.event.generator
{
	import com.universalmind.cairngorm.events.generator.EventGenerator;
	import mx.rpc.IResponder;

	/**
     * Class SequenceGenerator.
     * extends EventGenerator class     
     */
	public class SequenceGenerator extends EventGenerator
	{
		/**
         * SequenceGenerator Class Constructor.
         * 
         * @param Array type of events to Fire 
         * @param IResponder The event handlers for the event.
         * @param error of the event count.
         * @param triggerType of the event.
         */
		public function SequenceGenerator(eventsToFire:Array=null, handlers:IResponder=null, failCount:int=0, triggerType:String=TRIGGER_SEQUENCE)
		{
			super(eventsToFire, handlers, failCount, triggerType);
		}
		
	}
}