package com.adams.dt.event
{
	import com.universalmind.cairngorm.events.UMEvent;
	import com.universalmind.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	/**
     * Class PagingEvent.
     * extends UMEvent class     
     */
	public class PagingEvent extends UMEvent
	{
		/**
     	 * The event type for getting all the pagination. but limited page view purpose
     	 */
		public static const EVENT_GET_LIMIT_PAGE:String='getLimitedResult';
 
 		/**
     	 * IValueObject vo class instance.
     	 */
		public var vo:IValueObject; 
		
		/**
     	 * startIndex variable.
     	 */
		public var startIndex:int;
		
		/**
     	 * endIndex variable.
     	 */
		public var endIndex:int;
		
		/**
         * Class Constructor.
         * 
         * @param type The event type for the event.
         * @param IResponder The event handlers for the event.
         * @param Boolean public of the event.
         * @param Boolean remove of the event.
         * @param language The event language vo for the event.
         */
		public function PagingEvent (pType:String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false,pVO:IValueObject=null){			
			vo= pVO;
			super(pType,handlers,true,false,vo);			
		}		 

		
	}

}