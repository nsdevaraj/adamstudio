package com.universalmind.cairngorm.events
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.adobe.cairngorm.control.CairngormEventDispatcher;
    
    import flash.events.Event;
    import com.universalmind.cairngorm.vo.IValueObject;
    import mx.rpc.IResponder;
    
   /**
    * The UMEvent class is used to differentiate Cairngorm events 
    * from events raised by the underlying Flex framework (or even the standard CairngormEvent)
    * It is mandatory to use UMEvent for dispatching to Commands. Commands
    * understand and "use" the optional "handlers" responder within the event 
    * 
    * <p>For more information on how event dispatching works in Cairngorm, 
    * please check with CairngormEventDispatcher.</p>
    *
    * <p>For more information on how event dispatching works uniquely with Commands, 
    * please check with Command.</p>
    *
    * <p>
    * Events are typically broadcast as the result of a user gesture occuring
    * in the application, such as a button click, a menu selection, a double
    * click, a drag and drop operation, etc.  
    * </p>
    *
    * @see com.universalmind.cairngorm.controller.CairngormEventDispatcher
    * @see com.universalmind.cairngorm.commands.Command
    */	
    public class UMEvent extends CairngormEvent implements IUMEvent
    {
	      /**
	       * The data property can be used to hold information to be passed with the event
	       * in cases where the developer does not want to extend the UMEvent class.
	       * However, it is recommended that specific classes are created for each type
	       * of event to be dispatched.
	       */
	   	  	public var callbacks : IResponder = null;

			public function get responder():IResponder {
				return callbacks;
			}
			
	      /**
	       * Constructor, takes the event name (type), Responder proxy to allow caller to be notified,
	       * data object (defaults to null), and also defaults the standard Flex event properties bubbles and cancelable
	       * to true and false respectively.
	       * 
	       * @param eventType  This is the signature or type of event
	       * @param handlers   This is the "responder" proxy that allows notifications/callbacks to the original caller
	       * @param bubbles    This flag indicates if the event should "bubble". [default = true]
	       * @param cancelable This flag indicates if the event can be cancelled. [default = false]
	       * @parma data       This is the optional data object that can be packaged with the event without creating an event subclass
	       */
			public function UMEvent(	eventType 	: String 	= "com.universalmind.cairngorm.events.UMEvent", 
										handlers 	: IResponder = null, 
										bubbles	 	: Boolean	= true, 
										cancelable	: Boolean	= false,
										data		: *         = null) {
											
				super(eventType,bubbles,cancelable);
				
				this.callbacks = handlers;
				this.data      = data;
			}

			/**
			  * Per Adobe Flex recommendations all events should support a clone() operation for bubbling and dispatching purposes
			  * 
			  */ 			
			override public function clone():Event {
				return new UMEvent(type, callbacks, bubbles, cancelable).copyFrom(this);
			}
			
			/**
			  * Utility method to allow quick initialization of an event based on current settings from another event. 
			  * Also used to implement the clone() method functionality
			  * 
			  * @param src The event from which current settings and references should be copied.
			  * 
			  * 
			  */
			public function copyFrom(src : Event):Event {					
				// Note: can change/specify the values of type,bubbles,etc...
				// during at construction only.
				
				// Note the callbacks is copied by REFERENCE 
				if (src is UMEvent)         this.callbacks = (src as UMEvent).callbacks;
				if (src is CairngormEvent) 	this.data      = (src as UMEvent).data;
							
				return this;
			}
				 
		 /**
		 * This is the recommended method to dipsatch business events directly to the business layer(s).
       * <p><strong>Event hooks or event bubbling solutions are not recommended and have been deprecated</strong></p>
       * This method also completely distorts the event structures within Flex... no other events in Flex can dispatch themselves.
       * Events are "announcements" with optional data packaged in the announcement. Events are passive. NOT active.
       *  
       * Dispatch this event via the Cairngorm event dispatcher.
       */
      override public function dispatch() : Boolean
      {
         return CairngormEventDispatcher.getInstance().dispatchEvent( this );
      }    		

	}
}