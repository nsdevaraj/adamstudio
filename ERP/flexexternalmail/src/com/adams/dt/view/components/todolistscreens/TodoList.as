package com.adams.dt.view.components.todolistscreens
{
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	
	import flash.utils.ByteArray;
	
	import mx.containers.Canvas;
	public class TodoList extends Canvas implements ITodoList
	{
		[Bindable]
		public var model : ModelLocator = ModelLocator.getInstance();
		public var tasks : Tasks = new Tasks();
		public function TodoList() : void
		{
		}

		public function gotoNextTask() : void
		{
			tasks.workflowtemplateFK = model.workflowstemplates.nextTaskFk;
			tasks.projectObject = model.currentTasks.projectObject;
		//	model.currentProjects = tasks.projectObject;
			model.currentTasks.tDateEnd = model.currentTime;
			model.currentTasks.onairTime = Utils.getDiffrenceBtDate(model.currentTasks.tDateInprogress,model.currentTime);
			var status1 : Status = new Status();
			tasks.previousTask = model.currentTasks;
			tasks.fileObj = model.currentTasks.fileObj;
			var status : Status = new Status();
			status.statusId = TaskStatus.WAITING;
			tasks.taskStatusFK = status.statusId;
			tasks.tDateCreation = model.currentTime;
			tasks.tDateEndEstimated = Utils.getCalculatedDate(model.currentTime,tasks.workflowtemplateFK.defaultEstimatedTime); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;
			model.currentTasks.taskComment = getComment();
			if(model.currentTasks.previousTask!=null)
			  model.currentTasks.fileObj = model.currentTasks.previousTask.fileObj;
			//tasks.tDateDeadline = model.currentTime;
			//tasks.deadlineTime = 23;
			tasks.onairTime = 0;
			
			/* var firstRelease:int = Utils.getWorkflowTemplates(model.firstRelease,model.currentTasks.workflowtemplateFK.workflowFK).workflowTemplateId;
			var otherRelease:int = Utils.getWorkflowTemplates(model.otherRelease,model.currentTasks.workflowtemplateFK.workflowFK).workflowTemplateId;
			model.release = 0;
			if(model.currentTasks.workflowtemplateFK.workflowTemplateId == firstRelease){
				model.release = 1; 
				updateTaskFileCollection();
			}else if(model.currentTasks.workflowtemplateFK.workflowTemplateId == otherRelease){
				model.release = 2;
				updateTaskFileCollection();
			} */
			
			if(model.currentTasks.nextTask == null&&model.currentTasks.taskStatusFK!=TaskStatus.FINISHED){
				model.currentTasks.nextTask = tasks;
				status1.statusId = TaskStatus.FINISHED; 
				model.currentTasks.taskStatusFK = status1.statusId;
				var event : TasksEvent = new TasksEvent( TasksEvent.EVENT_CREATE_TASKS );
				event.tasks = tasks;
				CairngormEventDispatcher.getInstance().dispatchEvent(event);
			}
			
		}
		
		private function updateTaskFileCollection():void{
			
			for each(var item:FileDetails in model.taskFileCollection){
				if(item.taskId == model.currentTasks.previousTask.taskId){
					item.releaseStatus = model.release;	
					model.fileCollectionToUpdate.addItem(item);
				
				}
			}
		}
		
		public function gotoPrevTask() : void
		{
			tasks.workflowtemplateFK = model.workflowstemplates.prevTaskFk;
			tasks.projectObject = model.currentTasks.projectObject;
			//model.currentProjects = tasks.projectObject;
			tasks.previousTask = model.currentTasks;
			model.currentTasks.tDateEnd = model.currentTime;
			
			var status1 : Status = new Status();
			tasks.previousTask = model.currentTasks;
			tasks.fileObj = model.currentTasks.fileObj;
			if(model.currentTasks.previousTask!=null)
				model.currentTasks.fileObj = model.currentTasks.previousTask.fileObj;
			var status : Status = new Status();
			status.statusId = TaskStatus.WAITING;
			tasks.taskStatusFK = status.statusId;
			tasks.tDateCreation = model.currentTime;
			tasks.tDateEndEstimated =Utils.getCalculatedDate(model.currentTime,tasks.workflowtemplateFK.defaultEstimatedTime); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;			
			model.currentTasks.taskComment = getComment();
			//tasks.tDateDeadline = model.currentTime;
			//tasks.deadlineTime = 23;
			tasks.onairTime = 54;
			if(model.currentTasks.nextTask == null&&model.currentTasks.taskStatusFK!=TaskStatus.FINISHED){
				model.currentTasks.nextTask = tasks;
				status1.statusId = TaskStatus.FINISHED;
				model.currentTasks.taskStatusFK = status1.statusId;			
				var event : TasksEvent = new TasksEvent( TasksEvent.EVENT_CREATE_TASKS);
				event.tasks = tasks;
				CairngormEventDispatcher.getInstance().dispatchEvent(event);
			}
			 
		}
		
		public function getComment() : ByteArray
		{
			var by : ByteArray = new ByteArray();
			by.writeUTFBytes(model.currentTaskComment);
			return by;
		}

		public function gotoLoopTask() : void
		{
		}

		public function jumpTo() : void
		{
		}
	}
}
