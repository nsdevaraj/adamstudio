package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.StatusEvents;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.PhaseStatus;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.StatusTypes;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.WorkflowTemplatePermission;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	public final class StatusCommand extends AbstractCommand 
	{ 
		private var statusEvent : StatusEvents;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			statusEvent = StatusEvents(event);
			this.delegate = DelegateLocator.getInstance().statusDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){ 
				/* Get All status object*/   
			    case StatusEvents.EVENT_GET_ALL_STATUS:
			    	delegate.responder = new Callbacks(getAllResult,fault);
			    	delegate.findAll();
			     break; 
			    case StatusEvents.EVENT_GET_STATUS:
			    	delegate.findById(statusEvent.status.statusId);
			     break; 
			    case StatusEvents.EVENT_CREATE_STATUS:
			    	delegate.create(statusEvent.status);
			     break; 
			    case StatusEvents.EVENT_UPDATE_STATUS:
			    	delegate.update(statusEvent.status);
			     break; 
			    case StatusEvents.EVENT_DELETE_STATUS:
			    	delegate.deleteVO(statusEvent.status);
			     break; 
			    case StatusEvents.EVENT_SELECT_STATUS:
			    	delegate.select(statusEvent.status);
			     break;  
			    default:
			     break; 
			} 
			    
		}
		/**
		 * @param rpxEvent result object
		 * call function getTaskStatusColl to classify the status
		 * store the task status in model.taskStatusColl
		 * model.taskStatusColl is binded with combobox in todolist
		 */
		public function getAllResult( rpcEvent : Object ) : void
		{			
			model.getAllStatusColl = rpcEvent.result as ArrayCollection;
			model.taskStatusColl = getTaskStatusColl(model.getAllStatusColl);
			super.result(rpcEvent);
		}
		/**
		 * @param arrc status collection
		 * classify the status and store the id in corresponding status vo
		 * return the task status collection
		 */
		private function getTaskStatusColl(arrc:ArrayCollection):ArrayCollection{
			var temp:ArrayCollection  = new ArrayCollection();
			
			var taskColl:ArrayCollection = new ArrayCollection();
			var projectColl:ArrayCollection = new ArrayCollection();
			var workFLowTempColl:ArrayCollection = new ArrayCollection();
			var eventTypeColl:ArrayCollection = new ArrayCollection();
			var phaseColl:ArrayCollection = new ArrayCollection();
			
			var status:Status = new Status();
			status.statusLabel = 'All';
			temp.addItem(status);
			for each(var item:Status in arrc){				
				switch(item.type){
					case StatusTypes.TASKSTATUS:
						temp.addItem(item);
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
			}
			TaskStatus.taskStatusColl = taskColl;
			ProjectStatus.projectStatusColl = projectColl;
			WorkflowTemplatePermission.workFlowTempStatusColl = workFLowTempColl;
			EventStatus.eventStatusColl = eventTypeColl;
			PhaseStatus.phaseStatusColl = phaseColl;
			
			return temp;
		}
		 
	}
}
