package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.WorkflowstemplatesEvent;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.WorkflowTemplatePermission;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	public final class WorkflowTemplatesCommand extends AbstractCommand 
	{ 
		private var etasks:Tasks = new Tasks();		
		private var workflowstemplateEvent : WorkflowstemplatesEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			workflowstemplateEvent = WorkflowstemplatesEvent(event);
			this.delegate = DelegateLocator.getInstance().workflowtemplateDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			var template : Workflowstemplates = Workflowstemplates(workflowstemplateEvent.workflowstemplates);
		    switch(event.type){ 
		          case WorkflowstemplatesEvent.EVENT_GETMSG_WORKFLOWSTEMPLATES:
					delegate.responder = new Callbacks(getMsgWorkflowTemplateresult,fault);
					etasks = Tasks(workflowstemplateEvent.tasks);
					trace("WorkflowTemplatesCommand :"+Profiles(workflowstemplateEvent.profile).profileId);	
					delegate.findByMailProfileId(Profiles(workflowstemplateEvent.profile).profileId); //Message default passing  
		          break;
		          case WorkflowstemplatesEvent.EVENT_GETMSG_WORKFLOWSTEMPLATESID:
		          delegate.responder = new Callbacks(getMsgWorkflowResult,fault);
		          trace("WorkflowTemplatesCommand findById:"+model.currentProjects.workflowFK);	
		          delegate.findById(model.currentProjects.workflowFK);
		          break; 
		          case WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS:
	          		delegate.responder = new Callbacks(getAllTemplate,fault);
	          		//delegate.findAll();
	          		delegate.getList();
		          break;
		         default:
		          break; 
		    }
		}
		public function getAllTemplate(rpcEvent : Object):void{
			//june 08 2010
			model.delayUpdateTxt = "All Workflowtemplates";
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;	
			model.workflowstemplatesCollection = arrc;
			for each(var wTemp:Workflowstemplates in arrc){
				if(wTemp.optionStopLabel!=null){
					var stoplabel:Array = wTemp.optionStopLabel.split(",");
					for(var i:int=0;i<stoplabel.length;i++){
						var permissionStr:Number = Number(stoplabel[i]);
						switch(int(permissionStr)){
							/* case WorkflowTemplatePermission.CLOSED:
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
							break; */							
							case WorkflowTemplatePermission.MESSAGE:
								model.messageTemplatesCollection.addItem(wTemp);
							break;
							/* case WorkflowTemplatePermission.VERSIONLOOP:
								model.versionLoop.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.ALARM:
								model.alarmTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.STANDBY:
								model.standByTemplatesCollection.addItem(wTemp);
							break; 
							case WorkflowTemplatePermission.SENDIMPMAIL:
								model.sendImpMailTemplatesCollection.addItem(wTemp);
							break; */
							case WorkflowTemplatePermission.CHECKIMPREMIUR:
								model.checkImpremiurCollection.addItem( wTemp );
							break;
							case WorkflowTemplatePermission.PDFREADER:
								model.indReaderMailTemplatesCollection.addItem(wTemp);
							break;
						}
					} 						
				}
			}
			super.result(rpcEvent);
		} 
		public function getMsgWorkflowResult( rpcEvent : Object ) : void
		{ 	
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;			
			for each(var wTemp:Workflowstemplates in arrc){
				if(wTemp.optionStopLabel!=null){
					var stoplabel:Array = wTemp.optionStopLabel.split(",");
					for(var i:int=0;i<stoplabel.length;i++){
						var permissionStr:String = stoplabel[i];
						switch(permissionStr){
							case WorkflowTemplatePermission.CLOSED:
								//model.closeProjectTemplate.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.ANNULATION:
								 //model.modelAnnulationWorkflowTemplate.addItem(wTemp); 
							break;
							case WorkflowTemplatePermission.FIRSTRELEASE:
								//model.firstRelease.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.OTHERRELEASE:
								//model.otherRelease.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.FILEACCESS:
								//model.fileAccessTemplates.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.MESSAGE:
								model.messageTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.VERSIONLOOP:
								//model.versionLoop.addItem(wTemp);
							break;
						}
					} 
						
				}
			}
			super.result(rpcEvent);
		} 
		
		public function getMsgWorkflowTemplateresult( rpcEvent : Object ) : void
		{ 	
			super.result(rpcEvent);	
			var arr:ArrayCollection = ArrayCollection(rpcEvent.result);
			trace("getMsgWorkflowTemplateesult :"+arr.length);	
		}
	}
}
