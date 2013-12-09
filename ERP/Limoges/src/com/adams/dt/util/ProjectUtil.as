package com.adams.dt.util
{
	import com.adams.dt.model.vo.*;
	
	import mx.collections.ArrayCollection;
	
	public class ProjectUtil
	{
		public static function abortProject(changeStatus:String, projects:Projects,closeCollection:ArrayCollection,tasks:Tasks,person:Persons,comment:String):Array
		{		 
			
			projects.projectDateEnd = new Date();	
			var closeTaskCollection:ArrayCollection = new ArrayCollection();
			var closeProjectCollection:ArrayCollection = ProcessUtil.getWorkflowTemplatesCollection(closeCollection,projects.workflowFK);	
			for each(var wTemp:Workflowstemplates in closeProjectCollection){
				var taskData:Tasks = new Tasks();
				taskData.taskId = NaN;
				taskData.previousTask = tasks;
				taskData.projectObject = projects;
				var status:Status = new Status();
				status.statusId = TaskStatus.WAITING;
				taskData.taskStatusFK = status.statusId;
				var str:String =person.personFirstname+Utils.SEPERATOR+
					comment+Utils.SEPERATOR+
					person.personId+","+
					person.defaultProfile;
				taskData.taskComment = ProcessUtil.convertToByteArray( str );
				taskData.tDateCreation = new Date();
				taskData.workflowtemplateFK = wTemp;
				closeTaskCollection.addItem(taskData); 
			} 
			var tempPropertiesCollection:ArrayCollection = projects.propertiespjSet as ArrayCollection;
			var pjresult:String = Utils.pjParameters( tempPropertiesCollection );
			var propertyPresetFk:String = String(pjresult.split("#&#")[1]).slice(0,-1);
			var fieldValue:String = String(pjresult.split("#&#")[0]).slice(0,-1);
			var closeComments:String = ProcessUtil.convertToByteArray(comment).toString();
			var projectclosingMode:String;
			if(changeStatus ==  Utils.ABORT){
				projects.projectStatusFK = ProjectStatus.ABORTED;
				projectclosingMode = Utils.ABORT;
			}else if(changeStatus == Utils.ARCHIVE){
				projects.projectStatusFK = ProjectStatus.ARCHIVED;	
				projectclosingMode = Utils.ARCHIVE;
			}
			var objArray:Array = []
			objArray.push(projects.projectId);
			objArray.push(tasks.taskId);
			objArray.push(projects.workflowFK);
			objArray.push(closeComments);
			objArray.push(propertyPresetFk);
			objArray.push(fieldValue);
			objArray.push(projectclosingMode);
			objArray.push(person.personId);
			objArray.push(closeTaskCollection);
			return objArray;
		}
		public static function standByProject( projects:Projects , workflowFk:int , projectStatus:int, taskMessage:String, personFk:int ):Array{
			var objArray:Array = [];
			objArray.push( projects.projectId );
			objArray.push( workflowFk );
			objArray.push( projectStatus );
			objArray.push( taskMessage );
			objArray.push( personFk );
			return objArray;
		}
	}
}