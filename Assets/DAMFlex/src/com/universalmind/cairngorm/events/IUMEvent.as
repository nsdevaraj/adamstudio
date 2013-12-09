package com.universalmind.cairngorm.events
{
    import flash.events.Event;
	
 /**
    * This interface is similar to the IValueObject interface to 
    * require all UMEvent implementations to have copyFrom() and clone()
    * functionality
    */
	public interface IUMEvent
	{
	  /**
	    * This method allows events to easily initialize themselved based on
	    * values within other instances.
	    */
		function copyFrom(src : Event)	: Event;
    /**
		  * This method allows events to easily clone themselves; and allows developers
		  * to quickly create new copies for re-dispatching, 
		  */		
		function clone()				        : Event;
	}
}