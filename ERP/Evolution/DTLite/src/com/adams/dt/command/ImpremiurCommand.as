package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.ImpremiurEvent;
	import com.adams.dt.model.vo.Impremiur;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	public final class ImpremiurCommand extends AbstractCommand
	{
		private var impremiurEvent:ImpremiurEvent;
		
		override public function execute( event : CairngormEvent ) : void
		{
			super.execute(event);
			impremiurEvent = ImpremiurEvent(event);
			this.delegate = DelegateLocator.getInstance().impremiurDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			 switch(event.type){    
				      	case ImpremiurEvent.EVENT_GET_ALL_IMPREMIUR:
				      		delegate.responder = new Callbacks(findAllImpremiurResult,fault);
				        	delegate.findAll();
			       		break; 
			       		case ImpremiurEvent.EVENT_CREATE_IMPREMIUR:
			       			/* delegate.responder = new Callbacks(getImpreID,fault); */
							delegate.create(impremiurEvent.impremiur);  
			     		default:
			    		break; 
			}
		}
		public function findAllImpremiurResult( rpcEvent : Object ) : void
		{
			model.ImpremiurCollection = rpcEvent.result as ArrayCollection;
			super.result(rpcEvent);
		} 
	}
}