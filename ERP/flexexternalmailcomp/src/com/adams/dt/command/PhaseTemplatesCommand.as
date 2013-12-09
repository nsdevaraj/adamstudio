package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.PhasestemplatesEvent;
	import com.adams.dt.event.WorkflowstemplatesEvent;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.PhaseStatus;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Phasestemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	public final class PhaseTemplatesCommand extends AbstractCommand 
	{ 
		private var phasestemplatesEvent : PhasestemplatesEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			phasestemplatesEvent = PhasestemplatesEvent(event);
			this.delegate = DelegateLocator.getInstance().phasetemplateDelegate;
			this.delegate.responder = new Callbacks(result,fault);
		   	switch(event.type)
		   	{    
		       	case PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS:
		       		delegate.responder = new Callbacks(findAllResult,fault);
		        	delegate.findAll();
		        	break; 		       
		       	default:
		        break; 
		    }
		}  
		public function findAllResult( rpcEvent : Object ) : void
		{			
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			model.allPhasestemplatesCollection = arrc
			super.result(rpcEvent);
		}
	}
}
