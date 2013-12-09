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
		   switch(event.type){    
		       case PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS:
		       delegate.responder = new Callbacks(findAllResult,fault);
		        delegate.findAll();
		        break; 
		       case PhasestemplatesEvent.EVENT_GET_PHASESTEMPLATES:		       
		        delegate.responder = new Callbacks(findByWorkFlowIdResult,fault);
		        delegate.findByWorkFlowId(model.project.workflowFK);
		        break; 
		      case PhasestemplatesEvent.EVENT_GETWORKFLOW_PHASESTEMPLATES:		       
		        delegate.responder = new Callbacks(copyToNewWorkFlowIdResult,fault);
		        delegate.findByWorkFlowId(phasestemplatesEvent.workFlow.workflowId);
		        break;
		      case PhasestemplatesEvent.EVENT_BULKUPDATE_PHASESTEMPLATES:	
		      	delegate.responder = new Callbacks(bulkUpdateResult,fault);	     
		        delegate.bulkUpdate(phasestemplatesEvent.phasestemplatesColl);
		        break;
		      case PhasestemplatesEvent.EVENT_CREATE_PHASESTEMPLATES:
		        delegate.create(phasestemplatesEvent.phasestemplates);
		        break; 
		       case PhasestemplatesEvent.EVENT_UPDATE_PHASESTEMPLATES:
		        delegate.update(phasestemplatesEvent.phasestemplates);
		        break; 
		       case PhasestemplatesEvent.EVENT_DELETE_PHASESTEMPLATES:
		        delegate.deleteVO(phasestemplatesEvent.phasestemplates);
		        break; 
		       case PhasestemplatesEvent.EVENT_SELECT_PHASESTEMPLATES:
		        delegate.findById(phasestemplatesEvent.phasestemplates.phaseTemplateId);
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
		
		
		public function copyToNewWorkFlowIdResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			[ArrayElementType("com.adams.dt.model.vo.Phasestemplates")]
			var newWrkFlwarrc : ArrayCollection = new ArrayCollection();
			var phaseBulk:PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_BULKUPDATE_PHASESTEMPLATES);
			for each(var phstemp:Phasestemplates in arrc){
				var newphstemp:Phasestemplates = new Phasestemplates();
				newphstemp = phstemp;
				newphstemp.workflowId = model.createdWorkflows.workflowId;
				newphstemp.phaseTemplateId = 0;
				newWrkFlwarrc.addItem(newphstemp);
			}
			phaseBulk.phasestemplatesColl = newWrkFlwarrc
			phaseBulk.dispatch();
		}
		public function bulkUpdateResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.createdPhaseTemplatesSet = rpcEvent.result as ArrayCollection;
			 
			var workflwTemplEvent:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GET_WF_WORKFLOWSTEMPLATES);
			workflwTemplEvent.dispatch();			
		}
		public function findByWorkFlowIdResult( rpcEvent : Object ) : void
		{
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			model.phasestemplatesCollection = arrc;
			var phaseCollection : ArrayCollection = new ArrayCollection();
			var prevItem : Phases;
			var phasestemplatesCollection_Len:int=model.phasestemplatesCollection.length;
			for(var i : int = 0; i < phasestemplatesCollection_Len;i++)
			{
				var item : Phasestemplates = model.phasestemplatesCollection.getItemAt(i) as Phasestemplates;
				var phase : Phases = new Phases();
				phase.phaseName = item.phaseName;
				phase.phaseStatus = PhaseStatus.WAITING;
				phase.phaseTemplateFK = item.phaseTemplateId;
				phase.projectFk = model.project.projectId;
				var phsstr:String;
				item.phaseTemplateId>9 ? phsstr ="P0" :phsstr="P00"
				item.phaseTemplateId>99 ? phsstr ="P":null; 
				phase.phaseCode = phsstr + item.phaseTemplateId;
				phase.phaseDuration = item.phaseDurationDays;
				phase.phaseDelay = 0;
				if( i == 0 )
				{
					phase.phaseStart = model.currentTime;
					phase.phaseEndPlanified = new Date( phase.phaseStart.getTime() + ( phase.phaseDuration * DateUtil.DAY_IN_MILLISECONDS ) );
				}
				else
				{
					if( prevItem != null ) {
						phase.phaseStart = prevItem.phaseEndPlanified;
						phase.phaseEndPlanified = new Date( phase.phaseStart.getTime() + ( phase.phaseDuration * DateUtil.DAY_IN_MILLISECONDS ) );
					}
				}

				phaseCollection.addItem(phase);
				prevItem = phase;
			}
			model.phasesCollection= phaseCollection;
			super.result(rpcEvent);
		} 	
	}
}
