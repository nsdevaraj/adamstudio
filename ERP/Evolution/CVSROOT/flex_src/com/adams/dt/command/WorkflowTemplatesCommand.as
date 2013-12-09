package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.event.WorkflowstemplatesEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Phasestemplates;
	import com.adams.dt.model.vo.WorkflowTemplatePermission;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	public final class WorkflowTemplatesCommand extends AbstractCommand 
	{ 
		private var workflowstemplateEvent : WorkflowstemplatesEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			workflowstemplateEvent = WorkflowstemplatesEvent(event);
			this.delegate = DelegateLocator.getInstance().workflowtemplateDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			var template : Workflowstemplates = Workflowstemplates(workflowstemplateEvent.workflowstemplates);
		     switch(event.type){    
		         case WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS:
		          delegate.responder = new Callbacks(getAllTemplate,fault);
		          delegate.findAll();
		          break;
		         case WorkflowstemplatesEvent.EVENT_GET_WF_WORKFLOWSTEMPLATES:
		          delegate.responder = new Callbacks(getByIdWorkFlowTemplateResult,fault);	
		          delegate.findById(model.currentWorkflows.workflowId);
		          break;
		          case WorkflowstemplatesEvent.EVENT_GETBYWFID_WORKFLOWSTEMPLATES:
		          delegate.findById(model.currentWorkflows.workflowId);
		          break; 
		         case WorkflowstemplatesEvent.EVENT_BULK_UPDATE_WORKFLOWSTEMPLATES:
		          delegate.bulkUpdate(workflowstemplateEvent.workflowstemplatesColl);
		          break;  
		         case WorkflowstemplatesEvent.EVENT_CREATE_WORKFLOWSTEMPLATES:
		          delegate.create(template);
		          break; 
		         case WorkflowstemplatesEvent.EVENT_UPDATE_WORKFLOWSTEMPLATES:
		          delegate.update(template);
		          break; 
		         case WorkflowstemplatesEvent.EVENT_DELETE_WORKFLOWSTEMPLATES:
		          delegate.deleteVO(template);
		          break;
		         case WorkflowstemplatesEvent.EVENT_SELECT_WORKFLOWSTEMPLATES:
		          delegate.select(template);
		          break; 
		          
		         default:
		          break; 
		    }
		}
		public function getAllTemplate(rpcEvent : Object):void{
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			model.closeProjectTemplate = new ArrayCollection();
			model.modelAnnulationWorkflowTemplate = new ArrayCollection();
			model.firstRelease = new ArrayCollection();
			model.otherRelease = new ArrayCollection();
			model.fileAccessTemplates = new ArrayCollection();
			model.messageTemplatesCollection = new ArrayCollection();
			model.versionLoop = new ArrayCollection();
			model.backTask = new ArrayCollection();
			model.standByTemplatesCollection = new ArrayCollection();
			model.alarmTemplatesCollection = new ArrayCollection();
			model.sendImpMailTemplatesCollection = new ArrayCollection();
			model.indReaderMailTemplatesCollection = new ArrayCollection(); 
			model.checkImpremiurCollection = new ArrayCollection();
			model.impValidCollection = new ArrayCollection();
			model.indValidCollection = new ArrayCollection();
			model.CPValidCollection = new ArrayCollection();
			model.CPPValidCollection = new ArrayCollection();
			model.COMValidCollection = new ArrayCollection();
			model.AGEValidCollection = new ArrayCollection();
 			model.workflowstemplatesCollection = arrc;
			for each(var wTemp:Workflowstemplates in arrc){
				if(wTemp.optionStopLabel!=null){
					var stoplabel:Array = wTemp.optionStopLabel.split(",");
					for(var i:int=0;i<stoplabel.length;i++){
						var permissionStr:Number = Number(stoplabel[i]);
						switch(int(permissionStr)){
							case WorkflowTemplatePermission.CLOSED:
								model.closeProjectTemplate.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.ANNULATION:
								 model.modelAnnulationWorkflowTemplate.addItem(wTemp); 
							break;
							case WorkflowTemplatePermission.FIRSTRELEASE:
								model.firstRelease.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.OTHERRELEASE:
								model.otherRelease.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.FILEACCESS:
								model.fileAccessTemplates.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.MESSAGE:
								model.messageTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.VERSIONLOOP:
								model.versionLoop.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.BACKTASK:
								model.backTask.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.ALARM:
								model.alarmTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.STANDBY:
								model.standByTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.SENDIMPMAIL:
								model.sendImpMailTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.PDFREADER:
								model.indReaderMailTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.CHECKIMPREMIUR:
								model.checkImpremiurCollection.addItem( wTemp );	
							break;  
							case WorkflowTemplatePermission.IMPVALIDATOR:
								model.impValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.INDVALIDATOR:
								model.indValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.CPVALIDATOR:
								model.CPValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.CPPVALIDATOR:
								model.CPPValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.COMVALIDATOR:
								model.COMValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.AGENCEVALIDATOR:
								model.AGEValidCollection.addItem( wTemp );	
							break;
							default:
							break;
						}
					} 
				}
			}
			super.result(rpcEvent);
		} 
		
		public function getByIdWorkFlowTemplateResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			[ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")]
			var newWrkFlwarrc : ArrayCollection = new ArrayCollection();
			var workflwtemBulk:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_BULK_UPDATE_WORKFLOWSTEMPLATES);
			var cursor:IViewCursor =  model.createdPhaseTemplatesSet.createCursor();
			var sort:Sort = new Sort(); 
            sort.fields = [new SortField("phaseName")];
            model.createdPhaseTemplatesSet.sort = sort;
            model.createdPhaseTemplatesSet.refresh();
			for each(var wrkflwtemp:Workflowstemplates in arrc){
				var newwrkflwtemp:Workflowstemplates = new Workflowstemplates()
				newwrkflwtemp = wrkflwtemp;
				newwrkflwtemp.workflowTemplateId = 0;
				if(wrkflwtemp.phaseTemplateFK!=0){
					var phstmp:Phasestemplates = new Phasestemplates();
					phstmp.phaseName = GetVOUtil.getPhaseTemplateObject(wrkflwtemp.phaseTemplateFK).phaseName;
	            	var found:Boolean = cursor.findAny(phstmp);
		            if (found) {
						newwrkflwtemp.phaseTemplateFK = Phasestemplates(cursor.current).phaseTemplateId;
		            }
	  			}
				newwrkflwtemp.workflowFK = model.createdWorkflows.workflowId; 
				newWrkFlwarrc.addItem(newwrkflwtemp);
			}
			workflwtemBulk.workflowstemplatesColl= newWrkFlwarrc;
			var getAllSeq:SequenceGenerator = new SequenceGenerator([workflwtemBulk])
			getAllSeq.dispatch();
		}
	}
}
