package com.adams.dt.model.collections
{
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.PhaseStatus;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.StatusTypes;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.WorkflowTemplatePermission;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	

	public class StatusCollection extends AbstractCollection
	{
		public function StatusCollection()
		{
			super();
		}
		override public function set items(v:IList):void {
			var taskColl:ArrayCollection = new ArrayCollection();
			var projectColl:ArrayCollection = new ArrayCollection();
			var workFLowTempColl:ArrayCollection = new ArrayCollection();
			var eventTypeColl:ArrayCollection = new ArrayCollection();
			var phaseColl:ArrayCollection = new ArrayCollection();
			
			for each(var item:Status in v){
				switch(item.type){
					case StatusTypes.TASKSTATUS:
						taskColl.addItem(item);
						break;
					case StatusTypes.PROJECTSTATUS:
						projectColl.addItem(item);
						break;
					case StatusTypes.WORKFLOWTEMPLATETYPE:
						workFLowTempColl.addItem(item);
						break;
					case StatusTypes.EVENTTYPE:
						eventTypeColl.addItem(item);
						break;
					case StatusTypes.PHASESTATUS:
						phaseColl.addItem(item);
						break;
				}
				TaskStatus.taskStatusColl = taskColl;
				ProjectStatus.projectStatusColl = projectColl;
				WorkflowTemplatePermission.workFlowTempStatusColl = workFLowTempColl;
				EventStatus.eventStatusColl = eventTypeColl;
				PhaseStatus.phaseStatusColl = phaseColl;
				_items.addItem(item); 
			}
		}
	}
}