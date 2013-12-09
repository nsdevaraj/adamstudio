package com.adams.dt.commands
{
	import com.adams.dt.model.collections.*;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.CurrentInstanceVO;
	import com.adams.dt.model.vo.DomainWorkflow;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.SignalVO;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.signals.ResultSignal;
	import com.adams.dt.signals.SignalSequence;
	import com.adams.dt.utils.Action;
	import com.adams.dt.utils.CategoryUtils;
	import com.adams.dt.utils.DateUtils;
	import com.adams.dt.utils.Description;
	import com.adams.dt.utils.Destination;
	import com.adams.dt.utils.GetVOUtil;
	import com.adams.dt.utils.ProfileCode;
	import com.adams.dt.utils.Utils;
	import com.adams.dt.view.models.IPersonPresentationModel;
	
	import mx.collections.ArrayCollection;

	public class ResultCommand
	{ 
		[Inject]
		public var resultSignal:ResultSignal; 
		[Inject]
		public var currentInstance:CurrentInstanceVO; 
		[Inject]
		public var personsModel:IPersonPresentationModel;

		[Inject]
		public var signalSequence:SignalSequence; 

		private var operation:String;
		private var destination:String;
		private var description:Object;
		public function execute():void
		{
			operation = resultSignal.action;
			destination = resultSignal.destination;
			description = resultSignal.description;
			switch( operation ) {
				case Action.GET_LIST:
					this[destination+'FindAllResult']();  			
				break;		
				case Action.GET_COUNT:
				break;
				case Action.READ:
				break;
				case Action.CREATE:
					this[destination+'CreateResult']();
				break;
				case Action.BULK_UPDATE: 
				break;
				case Action.DELETE:
				break;
				case Action.DELETE_ALL:
				break;
				case Action.UPDATE:
				break;
				case Action.QUERY:
					switch( description.type) {
						case Description.PERSONPROJECTLIST: 
							 this[destination+'ListResult']();
						break;
						case Description.PERSONPROFILELIST:
							 this[destination+'ListResult']();
						break;
						default:
						break;	
					}	
				break;
				case Action.FIND_ALL:
				break;
				case Action.FINDBY_ID:
					this[destination+'ListResult']();
				break;
				case Action.FINDBY_ID_NAME:
				break;
				case Action.FINDBY_NAME:
				break;
				case Action.FINDBY_NAME_ID:
				break;
				case Action.FINDBY_TASKID:
				break;
				case Action.PUSH_MSG:
					switch( description.type) {
						case Description.LOGIN: 
							this[destination+'PushResult']();
							break;
						default:
							break;
					}
					break;
				default:
				break;	
			} 
			signalSequence.onSignalDone();
		}
		public function projectCreateResult():void{
			personsModel.projectUpdate(currentInstance.currentProject);
			trace('result updated ' + operation+ ' '+destination);
		}
		public function taskCreateResult():void{
			switch( description.type) {
				case Description.INITTASK:
					var createTaskSignal:SignalVO = new SignalVO(Action.CREATE, Destination.TASK_SERVICE,{type:Description.LOOPPROJECT});
					if(currentInstance.currentTask.workFlowTemplateObject.nextTaskFk){
						createTaskSignal.valueObject = Utils.createTask(currentInstance.currentTask,currentInstance.currentProject,currentInstance.currentTask.workFlowTemplateObject.nextTaskFk);
						signalSequence.addSignal(createTaskSignal);
					}
					break;
				case Description.SECONDTASK:
					break;
				case Description.LOOPPROJECT:
					var createLoopTaskSignal:SignalVO = new SignalVO(Action.CREATE, Destination.TASK_SERVICE,{type:Description.LOOPPROJECT});
					var createUpdateTaskSignal:SignalVO = new SignalVO(Action.UPDATE, Destination.TASK_SERVICE);
					if(currentInstance.currentTask.workFlowTemplateObject.nextTaskFk ){
						var newDate:Date = DateUtils.dateAdd(currentInstance.currentTask.tDateCreation, currentInstance.currentTask.workFlowTemplateObject.phaseTemplateObject.phaseDurationDays);  
						createLoopTaskSignal.valueObject = Utils.createTask(currentInstance.currentTask,currentInstance.currentProject,currentInstance.currentTask.workFlowTemplateObject.nextTaskFk, newDate);
						currentInstance.currentTask.taskStatusFK = TaskStatus.FINISHED;
						currentInstance.currentTask.tDateEnd = newDate;
						createUpdateTaskSignal.valueObject = currentInstance.currentTask;
						signalSequence.addSignal(createUpdateTaskSignal);
						signalSequence.addSignal(createLoopTaskSignal);
					}else{
						currentInstance.config.prjCount++
						var prj:Projects = Utils.createProject("IB"+currentInstance.config.prjCount+"Project Name",currentInstance.currentWorkflow,currentInstance.currentCategory);
						var createProjectSignal:SignalVO = new SignalVO(Action.CREATE, Destination.PROJECT_SERVICE);
						createProjectSignal.valueObject = prj;
						if(currentInstance.config.prjCount<1000)signalSequence.addSignal(createProjectSignal);	
					}
				default:
					break;	
			}
			trace('result updated ' + operation+ ' '+destination);
		}
		public function personPushResult():void{ 
			trace('result updated ' + operation+ ' '+destination);
		}
		public function profileListResult():void{
			currentInstance.config.authenticated = 1;
			var domainWorkflowCollection:ArrayCollection = domainWorkflowList.items as ArrayCollection;
			if(currentInstance.currentPerson.profileObject.profileCode == ProfileCode.CLIENT){
				var currentCategory:Categories= CategoryUtils.getCategory(currentInstance.currentPerson.companyObject.companycode);
				currentInstance.currentDomain = currentCategory
				domainWorkflowCollection.filterFunction = findWorkflowList
				domainWorkflowCollection.refresh();
				for each(var domainWf:DomainWorkflow in domainWorkflowCollection){
					currentInstance.currentWorkFlowCollection.addItem(domainWf.workflowObject);
					currentInstance.currentDomainCollection.addItem(domainWf.categoryObject);
				}
				domainWorkflowCollection.filterFunction = null;
				domainWorkflowCollection.refresh();
			}else{
				currentInstance.currentWorkFlowCollection = workflowList.items as ArrayCollection;
				for each(var domainWfs:DomainWorkflow in domainWorkflowCollection){
					currentInstance.currentDomainCollection.addItem(domainWfs.categoryObject);
				}
			} 
		}
		public function teamlinestemplateListResult():void{
			currentInstance.currentWorkflow.teamlineTemplateCollection = teamlineTemplateList.collection;
			trace('result updated ' + operation+ ' '+destination);
		}
		private function findWorkflowList(item:DomainWorkflow):Boolean
		{
			var found:Boolean 
			if(item.domainFk == currentInstance.currentDomain.categoryId) found = true;
			return found;
		}
		public function moduleListResult():void{
			GetVOUtil.moduleList = moduleList; 
			trace('result updated ' + operation+ ' '+destination);
		}
		public function projectListResult():void{
			GetVOUtil.projectList = projectList;
			trace('result updated ' + operation+ ' '+destination);
		}
		public function taskListResult():void{
			personsModel.persons = taskList.items as ArrayCollection;
			trace('result updated ' + operation+ ' '+destination);
		}
		public function profileFindAllResult():void{ 
			GetVOUtil.profileList = profileList;
			trace('result updated ' + operation+ ' '+destination);
		}
		public function langFindAllResult():void{ 
			trace('result updated ' + operation+ ' '+destination);
		}
		public function chatFindAllResult():void{
			trace('result updated ' + operation+ ' '+destination);
		}
		public function workflowFindAllResult():void{
			GetVOUtil.workflowList = workflowList;
			trace('result updated ' + operation+ ' '+destination);
		}
		public function moduleFindAllResult():void{
			trace('result updated ' + operation+ ' '+destination);
		}
		public function proppresetstemplatesFindAllResult():void{
			trace('result updated ' + operation+ ' '+destination);
		} 
		public function personFindAllResult():void{
			GetVOUtil.personList = personList;
			if(resultSignal.description.type == Description.LOGIN){
				currentInstance.currentPerson = GetVOUtil.getPersonObject(currentInstance.config.login,currentInstance.config.password, personList.items as ArrayCollection);
				var getStatusSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.STATUS_SERVICE);
				var getCategorySignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.CATEGORY_SERVICE);
				var getReportsSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.REPORT_SERVICE);
				var getWorkflowSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.WORKFLOW_SERVICE);
				var getPhaseTemplateSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.PHASE_TEMPLATE_SERVICE);
				var getWorkflowTemplateSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.WORKFLOW_TEMPLATE_SERVICE);
				var getPropertyPresetSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.PROPERTY_PRESET_SERVICE);
				var getPresetTemplateSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.PRESETTEMPLATE_SERVICE);
				var getPropPresetTemplateSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.PROP_PRESET_TEMPLATE_SERVICE);
				var getDomainWorkflowSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.DOMAIN_SERVICE);
				var getModuleSignal:SignalVO = new SignalVO(Action.FINDBY_ID, Destination.MODULE_SERVICE);
				
				var getProjectsSignal:SignalVO = new SignalVO(Action.QUERY, Destination.PROJECT_SERVICE, {type:Description.PERSONPROJECTLIST},currentInstance.currentPerson.personId);
				var getTasksSignal:SignalVO = new SignalVO(Action.FINDBY_ID, Destination.TASK_SERVICE, null ,currentInstance.currentPerson.personId);
				var getPersonProfilesSignal:SignalVO = new SignalVO(Action.QUERY, Destination.PROFILE_SERVICE, {type:Description.PERSONPROFILELIST},currentInstance.currentPerson.personId);
				
				
				signalSequence.addSignal(getStatusSignal);			
				signalSequence.addSignal(getCategorySignal); 	
				signalSequence.addSignal(getReportsSignal);
				signalSequence.addSignal(getWorkflowSignal);
				signalSequence.addSignal(getPhaseTemplateSignal); 
				signalSequence.addSignal(getWorkflowTemplateSignal);
				signalSequence.addSignal(getPropertyPresetSignal);			
				signalSequence.addSignal(getPresetTemplateSignal);
				signalSequence.addSignal(getPropPresetTemplateSignal);
				signalSequence.addSignal(getDomainWorkflowSignal);
				signalSequence.addSignal(getModuleSignal);
				/*
				signalSequence.addSignal(getProjectsSignal);*/			
				signalSequence.addSignal(getTasksSignal); 
				signalSequence.addSignal(getPersonProfilesSignal);		
			} 
			trace('result updated '+ operation+ ' '+destination);
		} 
		public function statusFindAllResult():void{
			GetVOUtil.statusList = statusList;
			trace('result updated ' + operation+ ' '+destination);
		}
		public function phasestemplateFindAllResult():void{
			GetVOUtil.phaseTemplateList =phaseTemplateList;
			trace('result updated ' + operation+ ' '+destination);
		}
		public function workflowstemplateFindAllResult():void{
			GetVOUtil.workflowTemplateList = workflowTemplateList;
			trace('result updated ' + operation+ ' '+destination);
		}
		public function companyFindAllResult():void{
			GetVOUtil.companyList = companyList;
			trace('result updated ' + operation+ ' '+destination);
		}
		public function categoryFindAllResult():void{
			GetVOUtil.categoryList = categoryList;
			trace('result updated ' + operation+ ' '+destination);
		} 
		public function reportsFindAllResult():void{
			trace('result updated ' + operation+ ' '+destination);
		}
		public function propertiespresetFindAllResult():void{
			GetVOUtil.propertyPresetList = propertyPresetList;
			trace('result updated ' + operation+ ' '+destination);
		}
		public function presetstemplatesFindAllResult():void{
			GetVOUtil.presetTemplateList = presetTemplateList; 
			trace('result updated ' + operation+ ' '+destination);
		}
		public function domainworkflowFindAllResult():void{
			trace('result updated ' + operation+ ' '+destination);
		}  
		[Inject]
		public var companyList:CompanyCollection;
		[Inject]
		public var workflowTemplateList:WorkflowTemplateCollection;
		[Inject]
		public var moduleList:ModuleCollection;
		[Inject]
		public var statusList:StatusCollection;
		[Inject]
		public var personList:PersonCollection;
		[Inject]
		public var workflowList:WorkflowCollection;
		[Inject]
		public var projectList:ProjectCollection;
		[Inject]
		public var profileList:ProfileCollection;
		[Inject]
		public var phaseTemplateList:PhasesTemplateCollection;
		[Inject]
		public var domainWorkflowList:DomainworkflowCollection;
		[Inject]
		public var presetTemplateList:PresetsTemplatesCollection;
		[Inject]
		public var propertyPresetList:PropertiesPresetCollection;
		[Inject]
		public var categoryList:CategoryCollection;
		[Inject]
		public var taskList:TaskCollection;
		[Inject]
		public var teamlineTemplateList:TeamlinesTemplateCollection;
	}
}