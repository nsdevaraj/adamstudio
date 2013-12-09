package com.adams.dt.view.models
{
	import com.adams.dt.model.collections.CategoryCollection;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Teamlines;
	import com.adams.dt.model.vo.Teamlinestemplates;
	import com.adams.dt.utils.CategoryUtils;
	import com.adams.dt.utils.Description;
	
	import mx.collections.ArrayCollection;
	 
	[Bindable]
	public class PersonPresentationModel implements IPersonPresentationModel
	{ 
		
		import com.adams.dt.model.vo.CurrentInstanceVO;
		import com.adams.dt.model.vo.Phases;
		import com.adams.dt.model.vo.Phasestemplates;
		import com.adams.dt.model.vo.Projects;
		import com.adams.dt.model.vo.SignalVO;
		import com.adams.dt.model.vo.Workflows;
		import com.adams.dt.model.vo.Workflowstemplates;
		import com.adams.dt.signals.SignalSequence;
		import com.adams.dt.utils.Action;
		import com.adams.dt.utils.Destination;
		import com.adams.dt.utils.GetVOUtil;
		import com.adams.dt.utils.Utils;
		
		import flash.events.MouseEvent;
		
		import mx.collections.ArrayCollection;
		
		
		[Inject]
		public var signalSequence:SignalSequence;
		[Inject]
		public var categoryList:CategoryCollection;
		
		private var _projectName:String;
		private var _currentInstance:CurrentInstanceVO; 
		
		private var _persons:ArrayCollection;

		public function get projectName():String
		{
			return _projectName;
		}

		public function set projectName(value:String):void
		{
			_projectName = value;
		}
		
		[Inject]
		public function get currentInstance():CurrentInstanceVO
		{
			return _currentInstance;
		}

		
		public function set currentInstance(value:CurrentInstanceVO):void
		{
			_currentInstance = value;
		}

		public function get persons():ArrayCollection
		{
			return _persons;
		}
		
		public function set persons(v:ArrayCollection):void
		{
			_persons = v;
		}
		
		public function createTaskSet(workflowFK:int,prj:Projects,workflowCode:String,duration:int=0):void{
			//the whole wflowset array collection to be returned
			var taskSetAc:ArrayCollection = new ArrayCollection();
			// to find the first workflwtemp in a given workflow
			var workflowTemplate:Workflowstemplates = Utils.getWorkflowTemplates(GetVOUtil.modelAnnulationWorkflowTemplate,workflowFK);
			//create first Task
			var createTaskSignal:SignalVO = new SignalVO(Action.CREATE, Destination.TASK_SERVICE);
			createTaskSignal.valueObject = Utils.createTask(null,prj,workflowTemplate);
			signalSequence.addSignal(createTaskSignal);
		}
		public function clickHandler(event:MouseEvent):void
		{
			var curDate:Date = new Date();
			currentInstance.currentCategory = CategoryUtils.checkCategory(currentInstance.currentDomain, Utils.month[curDate.month], categoryList.items as ArrayCollection);
			if(!currentInstance.currentCategory){
				var catYear:Categories= CategoryUtils.checkCategory(currentInstance.currentDomain, String(curDate.fullYear), categoryList.items as ArrayCollection);
		
				//currentInstance.currentCategory catYear
				trace(catYear);
			}else{ 
				if(currentInstance.currentWorkflow.teamlineTemplateCollection.length == 0){
					var getTeamLineTemplateSignal:SignalVO = new SignalVO(Action.FINDBY_ID, Destination.TEAMLINE_TEMPLATE_SERVICE );
					getTeamLineTemplateSignal.id = currentInstance.currentWorkflow.workflowId;
					signalSequence.addSignal(getTeamLineTemplateSignal);
				}
				projectCreate();
			}
		}
		protected function projectCreate():void{
			var prj:Projects = Utils.createProject(projectName,currentInstance.currentWorkflow,currentInstance.currentCategory);
			var createProjectSignal:SignalVO = new SignalVO(Action.CREATE, Destination.PROJECT_SERVICE);
			createProjectSignal.valueObject = prj;
			signalSequence.addSignal(createProjectSignal);
		}
		public function projectUpdate(prj:Projects):void
		{
			for each(var phaseTemp:Phasestemplates in currentInstance.currentWorkflow.phaseTemplateCollection){
				var phase:Phases = new Phases();
				phase.phaseTemplateObject = phaseTemp;
				phase.projectObject = prj;
				prj.phasesSet.addItem(phase); 
			}
			for each(var teamTemp:Teamlinestemplates in currentInstance.currentWorkflow.teamlineTemplateCollection){
				var teamLine:Teamlines= new Teamlines();
				teamLine.profileObject = teamTemp.profileObject;
				teamLine.personObject = teamTemp.personObject;
				teamLine.projectObject = prj;
				prj.teamSet.addItem(teamLine); 
			}
			var createProjectPhasesSignal:SignalVO = new SignalVO(Action.BULK_UPDATE, Destination.PHASE_SERVICE);
			createProjectPhasesSignal.List = prj.phasesSet;
			var createProjectTeamSignal:SignalVO = new SignalVO(Action.BULK_UPDATE, Destination.TEAMLINE_SERVICE);
			createProjectTeamSignal.List = prj.teamSet;
			signalSequence.addSignal(createProjectPhasesSignal);
			signalSequence.addSignal(createProjectTeamSignal);
			
			//create first Task
			var workflowTemplate:Workflowstemplates = Utils.getWorkflowTemplates(GetVOUtil.modelAnnulationWorkflowTemplate,currentInstance.currentWorkflow.workflowId);
			var createTaskSignal:SignalVO = new SignalVO(Action.CREATE, Destination.TASK_SERVICE,{type:Description.INITTASK});
			createTaskSignal.valueObject = Utils.createTask(null,prj,workflowTemplate);
			signalSequence.addSignal(createTaskSignal);
		}
	}
}