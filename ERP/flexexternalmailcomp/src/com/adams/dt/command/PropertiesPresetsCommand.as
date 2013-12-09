package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.PropertiespresetsEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	import com.adams.dt.event.generator.SequenceGenerator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	public final class PropertiesPresetsCommand extends AbstractCommand 
	{  
		private var propertiespresetsEvent : PropertiespresetsEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			propertiespresetsEvent = PropertiespresetsEvent(event);
			this.delegate = DelegateLocator.getInstance().propertiespresetsDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){  
				 case PropertiespresetsEvent.EVENT_GET_ALLPROPERTY:				 	
					delegate.responder = new Callbacks(getAllPropertiesPresetsResult,fault);
					delegate.findAll();
				 	break; 
				default:
					break; 
				}
		}
		
		public function getAllPropertiesPresetsResult( rpcEvent : Object ) : void
		{			
			super.result(rpcEvent);
			model.propertiespresetsCollection = rpcEvent.result as ArrayCollection;
			
			/* var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.propertiespresetsCollection.list = arrc.list;
			arrc.refresh();
			model.propertiespresetsCollection.refresh(); */
		}	 
	}
}
