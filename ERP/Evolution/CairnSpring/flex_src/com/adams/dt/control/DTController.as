package com.adams.dt.control
{
	import com.adams.dt.command.*; 
	import com.adams.dt.event.*; 
	import com.universalmind.cairngorm.control.FrontController;
	
	/**
     * Class DTController.
     * extends FrontController class            
     * Maps all events to commands. When a view dispatches an event, 
     * the controller maps it to the corresponding command, calling its 
     * execute method and passing it the event.
     */

	public final class DTController extends FrontController
	{
		/**
         * DTController Class Constructor.
         *          
         */
		public function DTController()
		{
			super();
			
			/**
         	* Map the language events to commands.
         	*/
			addCommand(LangEvent.EVENT_GET_ALL_LANGS , InitializeDTCommand);
			
			/**
         	* Map the pagination events to commands.
         	*/
			addCommand(PagingEvent.EVENT_GET_LIMIT_PAGE,PagingCommand);
		}
	}
}


