package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.PhasestemplatesEvent;
	import com.adams.dt.event.TeamTemplatesEvent;
	import com.adams.dt.event.WorkflowsEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.TeamTemplates;
	import com.adams.dt.model.vo.Workflows;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	public final class WorkFlowsCommand extends AbstractCommand 
	{ 
		private var workflowsEvent : WorkflowsEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			workflowsEvent  = WorkflowsEvent(event);
			this.delegate = DelegateLocator.getInstance().workflowDelegate;
			this.delegate.responder = new Callbacks(result,fault);
		  switch(event.type){    
		         case WorkflowsEvent.EVENT_GET_ALL_WORKFLOWSS: 
			          delegate.responder = new Callbacks(getAllWorkflowResult,fault);
			          trace("EVENT_GET_ALL_WORKFLOWSS calling findAll");
			          delegate.findAll();
		          break; 
		         case WorkflowsEvent.EVENT_GET_WORKFLOWS:
		          delegate = DelegateLocator.getInstance().workflowDelegate;
		          delegate.responder = new Callbacks(getWorkflowResult,fault);
		          trace("EVENT_GET_WORKFLOWS findWorkflow:"+model.domain.categoryId);
		          delegate.findWorkflow(model.domain.categoryId);
		          break;
		         case WorkflowsEvent.EVENT_GET_WORKFLOW:
		          delegate.responder = new Callbacks(getWorkflowIDResult,fault);
		          delegate.findById(model.currentWorkflows.workflowId);
		          break;  
		         case WorkflowsEvent.EVENT_CREATE_WORKFLOWS:
		          delegate.responder = new Callbacks(createNewWorkflowResult,fault);
		          delegate.create(workflowsEvent.workflows);
		          break; 
		         case WorkflowsEvent.EVENT_UPDATE_WORKFLOWS:
		          delegate.responder = new Callbacks(upDateResult,fault);
		          delegate.update(workflowsEvent.workflows);
		          break; 
		         case WorkflowsEvent.EVENT_DELETE_WORKFLOWS:
		          delegate.deleteVO(workflowsEvent.workflows);
		          break; 
		         case WorkflowsEvent.EVENT_SELECT_WORKFLOWS:
		          delegate.select(workflowsEvent.workflows);
		          break;  
		         case WorkflowsEvent.EVENT_TEAMLINETEMPLATE:
		         delegate.responder = new Callbacks(getTeamlineTemplateResult,fault);
		         delegate.findByDomainWorkFlow(workflowsEvent.workflows);
		         default:
		          break; 
		    }
		}
		public function createNewWorkflowResult( rpcEvent : Object ) : void{
			super.result(rpcEvent);
			var createdWorkflow:Workflows = Workflows(rpcEvent.message.body);
			model.workflowsCollection.addItem(createdWorkflow);
			var teamtempEvt:TeamTemplatesEvent= new TeamTemplatesEvent(TeamTemplatesEvent.EVENT_CREATE_TEAMTEMPLATES);
			var teamtemp:TeamTemplates = new TeamTemplates()
			teamtemp.teamTemplateLabel = createdWorkflow.workflowLabel+' Team';
			teamtemp.workflowFk= createdWorkflow.workflowId;
 			teamtempEvt.teamtemplates = teamtemp;
 			
 			
 			var phasetempEvt:PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_GETWORKFLOW_PHASESTEMPLATES);
 			phasetempEvt.workFlow.workflowId= model.currentWorkflows.workflowId;
			model.createdWorkflows = createdWorkflow;
 			var getAllSeq:SequenceGenerator = new SequenceGenerator([phasetempEvt,teamtempEvt])
			getAllSeq.dispatch();
		}		 			
		public function getTeamlineTemplateResult( rpcEvent : Object ) : void
		{
			var TeamArr : ArrayCollection = rpcEvent.result as ArrayCollection;
			model.teamLinetemplatesCollection = TeamArr;
			super.result(rpcEvent);
		}
		public function getAllWorkflowResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			 trace("getAllWorkflowResult calling");
			model.workflowsCollection = rpcEvent.result as ArrayCollection;
			trace("getAllWorkflowResult :"+model.workflowsCollection.length);
		} 
		public function getWorkflowIDResult( rpcEvent : Object ) : void
		{
			model.workflowsCollection = rpcEvent.result as ArrayCollection;
			super.result(rpcEvent);
		}
		public function getWorkflowResult( rpcEvent : Object ) : void
		{
			
			var domainworkflowCollection:ArrayCollection = rpcEvent.result as ArrayCollection;
			trace("getWorkflowResult :"+domainworkflowCollection.length);
			model.workflowsCollection = domainworkflowCollection;	
			model.currentWorkflows = domainworkflowCollection.getItemAt(0) as Workflows;
			super.result(rpcEvent);
		}
		public function upDateResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.workflowsCollection = rpcEvent.result as ArrayCollection;
			
		}
	}
}
