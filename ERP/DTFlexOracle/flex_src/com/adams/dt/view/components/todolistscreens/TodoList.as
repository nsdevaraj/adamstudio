package com.adams.dt.view.components.todolistscreens
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Workflowstemplates;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	
	public class TodoList extends Canvas implements ITodoList
	{
		[Bindable]
		public var model:ModelLocator = ModelLocator.getInstance();
		public var tasks:Tasks = new Tasks();
		private var _property:Object;
		 
		public function get property():Object {
			return _property;
		}
		
		public function set property( value:Object ):void {
			_property = value;
		}
		public function TodoList():void {
		
		}
		
		public function updateProperties():void {
			
		} 
		
		/**
		 * create the next task by using the "model.workflowstemplates.nextTaskFk"
		 * functionality same for all the screen except CloseProjectScreen
		 * the function overrided in property screen to update the properties
		 */
		public function gotoNextTask():void {
			tasks.workflowtemplateFK = model.workflowstemplates.nextTaskFk;
			tasks.projectObject = model.currentTasks.projectObject;
			
			model.currentTasks.tDateEnd = model.currentTime;
			model.currentTasks.onairTime = Utils.getDiffrenceBtDate( model.currentTasks.tDateInprogress, model.currentTime );
			
			var status1 : Status = new Status();
			tasks.previousTask = model.currentTasks;
			tasks.fileObj = model.currentTasks.fileObj;
			
			var tsklbl:String = model.currentTasks.workflowtemplateFK.taskLabel;
			var tskcode:String = model.currentTasks.workflowtemplateFK.taskCode;
			if( model.currentTasks ) {	
				if( tsklbl == "VALIDATION CREA" && (tskcode == "PDF01A" || tskcode == "PDF01B")){	
					var currentWorkflowFk:Workflowstemplates = GetVOUtil.getWorkflowTemplate(model.currentTasks.workflowtemplateFK.workflowTemplateId); //model.workflowstemplates.nextTaskFk.workflowTemplateId
					var itemValidation:String = Utils.getPropertyString(currentWorkflowFk.profileObject.profileCode);
					var dynamicPropertyPj:Propertiespj = Utils.assignValidation(itemValidation,"Next",model.currentTasks.projectObject.propertiespjSet);
					if(dynamicPropertyPj!=null){
						var arrC:ArrayCollection = new ArrayCollection();					
						arrC.addItem(dynamicPropertyPj);
						model.propertiespjCollection = arrC;				
						model.currentTasks.projectObject.propertiespjSet = arrC;
					}
				}		
			}			
			var status : Status = new Status();
			status.statusId = TaskStatus.WAITING;
			
			tasks.taskStatusFK = status.statusId;
			tasks.tDateCreation = model.currentTime;
			tasks.tDateEndEstimated = Utils.getCalculatedDate( model.currentTime, tasks.workflowtemplateFK.defaultEstimatedTime ); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;
			
			model.currentTasks.taskComment = getComment();
			
			if( model.currentTasks.previousTask ) {
			  model.currentTasks.fileObj = model.currentTasks.previousTask.fileObj;
			}  
			
			tasks.onairTime = 0; 
			
			/* check the release template to update the release status in file */
			var firstRelease:int = Utils.getWorkflowTemplates(model.firstRelease,model.currentTasks.workflowtemplateFK.workflowFK).workflowTemplateId;
			var otherRelease:int = Utils.getWorkflowTemplates(model.otherRelease,model.currentTasks.workflowtemplateFK.workflowFK).workflowTemplateId;
			
			model.release = 0;
			
			if( model.currentTasks.workflowtemplateFK.workflowTemplateId == firstRelease ) {
				model.release = 1; 
				updateTaskFileCollection();
			}
			else if( model.currentTasks.workflowtemplateFK.workflowTemplateId == otherRelease ) {
				model.release = 2;
				updateTaskFileCollection();
			}
			
			if( ( !model.currentTasks.nextTask ) && ( model.currentTasks.taskStatusFK != TaskStatus.FINISHED ) ) {
				model.currentTasks.nextTask = tasks;
				status1.statusId = TaskStatus.FINISHED; 
				model.currentTasks.taskStatusFK = status1.statusId;
				var event : TasksEvent = new TasksEvent( TasksEvent.EVENT_CREATE_TASKS );
				event.tasks = tasks;
				event.dispatch();
			}  			
		}
		
		/**
		 * update the release status in uploaded File Collection
		 */ 
		private function updateTaskFileCollection():void{
			for each( var item:FileDetails in model.taskFileCollection ) {
				if( item.taskId == model.currentTasks.previousTask.taskId ) {
					item.releaseStatus = model.release;	
					model.fileCollectionToUpdate.addItem( item );
				}
			}
		}
		
		/**
		 * create the previous task by using the "model.workflowstemplates.nextTaskFk"
		 * functionality same for all the screen 
		 * the function overrided in property screen to update the properties
		 */
		public function gotoPrevTask():void {
			tasks.workflowtemplateFK = model.workflowstemplates.prevTaskFk;
			tasks.projectObject = model.currentTasks.projectObject;
			tasks.previousTask = model.currentTasks;
			
			model.currentTasks.tDateEnd = model.currentTime;
			
			var status1 : Status = new Status();
			tasks.previousTask = model.currentTasks;
			tasks.fileObj = model.currentTasks.fileObj;
			
			if( model.currentTasks.previousTask ) {				
				model.currentTasks.fileObj = model.currentTasks.previousTask.fileObj;
			}
			var tsklbl:String = model.currentTasks.workflowtemplateFK.taskLabel;
			var tskcode:String = model.currentTasks.workflowtemplateFK.taskCode;	
			if( model.currentTasks ) {	
				if( tsklbl == "VALIDATION CREA" && tskcode == "PDF02B"){		
					tasks.personDetails = model.currentTasks.previousTask.personDetails;
				}		
			}
			//After validation - FAB click into the back button validation sataus change 1 
			if( tsklbl == "VALIDATION CREA" && tskcode == "PDF02A"){				
				var currentWorkflowFk:Workflowstemplates = GetVOUtil.getWorkflowTemplate(model.workflowstemplates.prevTaskFk.workflowTemplateId);
				var itemValidation:String = Utils.getPropertyString(currentWorkflowFk.profileObject.profileCode);
				//var dynamicPropertyPj:Propertiespj = Utils.assignValidation(itemValidation,"Previous");
				var dynamicPropertyPj:Propertiespj = Utils.assignValidation(itemValidation,"Previous",model.currentTasks.projectObject.propertiespjSet);
				if(dynamicPropertyPj!=null){
					var arrC:ArrayCollection = new ArrayCollection();					
					arrC.addItem(dynamicPropertyPj);
					model.propertiespjCollection = arrC;				
					model.currentTasks.projectObject.propertiespjSet = arrC;
				}
			}				
			var status : Status = new Status();
			status.statusId = TaskStatus.WAITING;
			
			tasks.taskStatusFK = status.statusId;
			tasks.tDateCreation = model.currentTime;
			tasks.tDateEndEstimated =Utils.getCalculatedDate( model.currentTime, tasks.workflowtemplateFK.defaultEstimatedTime ); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;			
			
			model.currentTasks.taskComment = getComment();
			
			tasks.onairTime = 54;
			
			if( ( !model.currentTasks.nextTask ) && ( model.currentTasks.taskStatusFK != TaskStatus.FINISHED ) ) {
				model.currentTasks.nextTask = tasks;
				status1.statusId = TaskStatus.FINISHED;
				model.currentTasks.taskStatusFK = status1.statusId;			
				var event:TasksEvent = new TasksEvent( TasksEvent.EVENT_CREATE_TASKS );
				event.tasks = tasks;
				event.dispatch();
			}
			 
		}
		
		/**
		 * Convert the comment string to byte array
		 */ 
		public function getComment():ByteArray {
			var by : ByteArray = new ByteArray();
			by.writeUTFBytes( model.currentTaskComment );
			return by;
		}
		
		/**
		 * create the Loop task by using the "model.workflowstemplates.loopFk"
		 * functionality same for all the screen 
		 */
		public function gotoLoopTask():void {
			var tasks:Tasks = new Tasks();
			tasks.workflowtemplateFK = model.workflowstemplates.loopFk;
			tasks.projectObject = model.currentTasks.projectObject;
			tasks.previousTask = model.currentTasks;
			
			model.currentTasks.tDateEnd = model.currentTime;
			
			var status1 : Status = new Status();
			
			tasks.previousTask = model.currentTasks;
			tasks.fileObj = model.currentTasks.fileObj;
			
			if( model.currentTasks.previousTask ) {
				model.currentTasks.fileObj = model.currentTasks.previousTask.fileObj;
			}	
			
			var status:Status = new Status();
			status.statusId = TaskStatus.WAITING;
			
			tasks.taskStatusFK = status.statusId;
			tasks.tDateCreation = model.currentTime;
			tasks.tDateEndEstimated =Utils.getCalculatedDate(model.currentTime,tasks.workflowtemplateFK.defaultEstimatedTime); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;
			
			model.currentTasks.taskComment = getComment(); 
			
			tasks.onairTime = 0;
			
			if( ( !model.currentTasks.nextTask ) && ( model.currentTasks.taskStatusFK != TaskStatus.FINISHED ) ) {
				model.currentTasks.nextTask = tasks;
				status1.statusId = TaskStatus.FINISHED;
				model.currentTasks.taskStatusFK = status1.statusId;
				var event : TasksEvent = new TasksEvent( TasksEvent.EVENT_CREATE_TASKS );
				event.tasks = tasks;
				event.dispatch();
			}
        }
        
        /**
		 * create the jump task by using the "model.workflowstemplates.jumpToTaskFk"
		 * functionality same for all the screen 
		 */
		public function jumpTo():void {
        	var tasks:Tasks = new Tasks();
			tasks.workflowtemplateFK = model.workflowstemplates.jumpToTaskFk;
			tasks.projectObject = model.currentTasks.projectObject;	
			
			model.currentTasks.tDateEnd = model.currentTime;
						
			var status1:Status = new Status();
			status1.statusId = TaskStatus.FINISHED;
			
			model.currentTasks.taskStatusFK= status1.statusId;
			
			tasks.previousTask =  model.currentTasks;	
			tasks.fileObj = model.currentTasks.fileObj;		
			
			if( model.currentTasks.previousTask ) {
				model.currentTasks.fileObj = model.currentTasks.previousTask.fileObj;
			}	
			
			var status:Status = new Status();
			status.statusId = TaskStatus.WAITING;
			
			tasks.taskStatusFK = status.statusId;
			tasks.tDateCreation = model.currentTime;
			tasks.tDateEndEstimated = Utils.getCalculatedDate( model.currentTime, tasks.workflowtemplateFK.defaultEstimatedTime ); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;
			
			model.currentTasks.taskComment = getComment(); 
			tasks.onairTime = 0;
			model.currentTasks.nextTask = tasks;
			var event:TasksEvent = new TasksEvent( TasksEvent.EVENT_CREATE_TASKS );
			event.tasks = tasks;
			event.dispatch();
        }
	}
}
