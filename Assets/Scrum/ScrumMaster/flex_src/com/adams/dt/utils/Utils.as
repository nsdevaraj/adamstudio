package com.adams.dt.utils
{
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Presetstemplates;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.WorkFlowset;
	import com.adams.dt.model.vo.Workflows;
	import com.adams.dt.model.vo.Workflowstemplates;
	
	import mx.collections.ArrayCollection;

	public class Utils
	{ 
		public static var month:Array =  ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","sep",
			"Oct","Nov","Dec"];
		public static const SERVER_SPLITTER:String = "/";
		// function to return wfset for given fronttask wftemp id
		public static function getWorkflowTemplatesSet(workflowtempId:int):WorkFlowset{
			var wftSet:WorkFlowset
			// front task is assigned based on given input 
			var frontTask:Workflowstemplates = GetVOUtil.getVOObject(workflowtempId,GetVOUtil.workflowTemplateList,'workflowTemplateId',Workflowstemplates) as Workflowstemplates;  
			// back task associated with front task to be found
			var backTask:Workflowstemplates
			if(frontTask.nextTaskFk){
				wftSet = new WorkFlowset();
				// iteration for finding associated back task
				for each (var wTemp:Workflowstemplates in GetVOUtil.workflowTemplateList){
					// find the wftemp having same next task other than fronttask
					if(wTemp.nextTaskFk == frontTask.nextTaskFk && wTemp!=frontTask){
						backTask = wTemp;
						break;
					}
				}
				//assign back and front task to the VO
				wftSet.frontWFTask = frontTask;
				wftSet.backWFTask = backTask;
				//set the phase id for wfset
				wftSet.phasesId = frontTask.phaseTemplateFK
				//set backid for wfset
				if(backTask != null) {
					wftSet.backWorkFlowId = backTask.workflowTemplateId
				}
				//set frontid for wfset
				if(frontTask != null) {
					wftSet.frontWorkFlowId = frontTask.workflowTemplateId
				}
			}
			return wftSet;
		}
		public static function getWorkflowTemplates(wTemplates:ArrayCollection,workflowId:int):Workflowstemplates{
			for each (var wTemp:Workflowstemplates in wTemplates){
				if(wTemp.workflowFK == workflowId){
					return wTemp;
				}
			}
			return new Workflowstemplates();
		}
		public static function getAllWorkflowTemplatesSet(workflowFK:int):ArrayCollection{
			//the whole wflowset array collection to be returned
			var wftSetAc:ArrayCollection = new ArrayCollection();
			// to find the first workflwtemp in a given workflow
			var workflowTemplate:Workflowstemplates = getWorkflowTemplates(GetVOUtil.modelAnnulationWorkflowTemplate,workflowFK);
			// get the first wfset of first wftemp
			var wftSetObj:WorkFlowset= getWorkflowTemplatesSet(workflowTemplate.workflowTemplateId);
			// add the first element
			wftSetAc.addItem(wftSetObj);
			do{ 
				//recursive loop to find consecutive wfset elements
				wftSetObj = getWorkflowTemplatesSet(Workflowstemplates(wftSetObj.frontWFTask).nextTaskFk.workflowTemplateId);
				// if found, add them to the collection
				if(wftSetObj) wftSetAc.addItem(wftSetObj);
			}// recursion will occur only if next wfset obj is found and nexttask is not null
			while((wftSetObj)&& Workflowstemplates(wftSetObj.frontWFTask).nextTaskFk)
			// last element which have next task fk null is added seperately
			wftSetObj = new WorkFlowset();
			// finding the last wfset with single wftemplate
			wftSetObj.frontWFTask =GetVOUtil.getVOObject(wftSetAc.getItemAt(wftSetAc.length-1).frontWFTask.nextTaskFk.workflowTemplateId,GetVOUtil.workflowTemplateList,'workflowTemplateId',Workflowstemplates) as Workflowstemplates;
			wftSetObj.frontWorkFlowId = wftSetObj.frontWFTask.workflowTemplateId
			wftSetObj.phasesId = wftSetObj.frontWFTask.phaseTemplateFK
			// adding the parameters required and add it to the collection
			wftSetAc.addItem(wftSetObj);
			return wftSetAc;
		}
		
		public static function getCalculatedDate(date:Date,minutes:int):Date{
			date.seconds=+(minutes*60);
			return date;
		}
		public static function createTask(prvTsk:Tasks, prj:Projects, wft:Workflowstemplates, date:Date=null):Tasks{
			var tasks:Tasks = new Tasks();
			tasks.workFlowTemplateObject = wft;
			tasks.projectObject = prj;
			tasks.previousTask = prvTsk;
			tasks.taskStatusFK = TaskStatus.WAITING;
			if(!date) date= new Date();
			tasks.tDateCreation = date;
			tasks.tDateEndEstimated = getCalculatedDate(new Date(),tasks.workFlowTemplateObject.defaultEstimatedTime); 
			tasks.estimatedTime = tasks.workFlowTemplateObject.defaultEstimatedTime;
		    return tasks;
		}
		public static function createProject(name:String, wrkflw:Workflows, cat:Categories, date:Date=null):Projects{
			var prj:Projects = new Projects();
			prj.projectName = name;
			prj.categoryObject = cat;
			prj.workflowObject = wrkflw;
			if(!date) date= new Date();
			prj.projectStatusFK = ProjectStatus.WAITING;
			prj.projectQuantity = 1;
			prj.projectDateStart = date;
			prj.presetTemplateObject = GetVOUtil.presetTemplateList.items.getItemAt(0) as Presetstemplates;
			return prj;
		}
	}
}