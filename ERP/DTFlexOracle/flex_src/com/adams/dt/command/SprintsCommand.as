package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.SprintsEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.controls.Alert;
	
	public class SprintsCommand extends AbstractCommand
	{
		private var sprintsEvent:SprintsEvent;
		
		override public function execute( event:CairngormEvent ) : void {	 
			super.execute( event );
			sprintsEvent = event as SprintsEvent;
			this.delegate = DelegateLocator.getInstance().sprintsDelegate;
			this.delegate.responder = new Callbacks( result, fault );
			
			switch( event.type ){    
		       case SprintsEvent.EVENT_BULK_UPDATE_SPRINTS:
		       		delegate.responder = new Callbacks( bulkSprintsUpdateResult, fault );
		       		delegate.bulkUpdate( sprintsEvent.updateCollection );
		        	break; 
		       default:
		        	break; 
		    }
		}	
        
        private function bulkSprintsUpdateResult( rpcEvent:Object ):void {
        	super.result( rpcEvent );
        	Alert.show( " Successfully Updated " );
        }
        
	}
}