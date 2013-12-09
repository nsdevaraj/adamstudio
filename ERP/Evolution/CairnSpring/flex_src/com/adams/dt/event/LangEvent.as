package com.adams.dt.event
{
	import com.adams.dt.model.vo.LangEntries;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	
	/**
     * Class LangEvent.
     * extends UMEvent class     
     */
	public final class LangEvent extends UMEvent
	{
		/**
     	 * The event type for getting all the Languages.
     	 */
		public static const EVENT_GET_ALL_LANGS : String = 'getAllLanguages';
		
		/**
     	 * Languages vo class instance.
     	 */
		public var langentry : LangEntries;
		
		/**
         * Class Constructor.
         * 
         * @param type The event type for the event.
         * @param IResponder The event handlers for the event.
         * @param Boolean public of the event.
         * @param Boolean remove of the event.
         * @param language The event language vo for the event.
         */

		public function LangEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, plang : LangEntries = null )
		{
			langentry = plang;
			super(pType,handlers,true,false,langentry);
		}
	}
}
