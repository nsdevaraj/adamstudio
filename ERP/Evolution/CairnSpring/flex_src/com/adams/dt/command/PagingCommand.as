package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.PagingEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	public final class PagingCommand extends AbstractCommand 
	{ 
		private var pagingEvent :PagingEvent 
		/**
	     * Method Name execute.
	     * @param pagingEvent 
	     * Use the delegate to execute the service and all language properties.
		 * return type void
	     */			
		override public function execute( event : CairngormEvent ) : void
		{	
			super.execute(event);
			pagingEvent = PagingEvent(event);
			this.delegate = DelegateLocator.getInstance().pagingDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){                  
				case PagingEvent.EVENT_GET_LIMIT_PAGE:
					delegate.responder = new Callbacks(checkFirstTenResult,fault);
					delegate.namedQuery('Languages.findAll',pagingEvent.startIndex,pagingEvent.endIndex);
					break; 
				default:
					break; 
				}
		}
		/**
	     * Method Name checkFirstTenResult.
	     * @param rpcEvent 
	     * Get the all language properties result
		 * return type void
	     */		
		public function checkFirstTenResult( rpcEvent : Object ) : void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			if(arrc.length>0){
				Alert.show("length of the result output :" +arrc.length.toString());
			}
	  		super.result(rpcEvent);	
	  	}    
 	}
}
										