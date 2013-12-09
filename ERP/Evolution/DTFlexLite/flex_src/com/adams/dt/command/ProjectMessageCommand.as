package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.ProjectMessageEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Teamlines;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class ProjectMessageCommand extends AbstractCommand 
	{ 
		private var projectMessageEvent : ProjectMessageEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			projectMessageEvent =ProjectMessageEvent(event);
			this.delegate = DelegateLocator.getInstance().projectMessageDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){    
				case ProjectMessageEvent.EVENT_SEND_MESSAGETOALL:
						sendMessageToAll();
					break; 
				default:
					break; 
				}
		}
		public function sendMessageToAll( ) : void
		{ 
			var handler:IResponder = new Callbacks(teamLineResult,fault);
			var teamline:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PROJECT_TEAMLINE, handler );
			teamline.projectId = model.currentProjects.projectId; 		
 	  		teamline.dispatch();			
		}
		public function teamLineResult(rpcEvent : Object):void{
			var teamMembers:ArrayCollection = rpcEvent.result;
			var messageTaskCollection:ArrayCollection = new ArrayCollection();
			model.messageTaskCollection = new ArrayCollection();
			model.messageBulkMailCollection = new ArrayCollection();
			for each(var item:Teamlines in teamMembers){
				if(item.personID !=model.person.personId&&item.profileID !=1){
					var taskData:Tasks = new Tasks();
					taskData.taskId = NaN;
					if(model.currentTasks){
					if(model.currentTasks.taskId!=0)
					taskData.previousTask = model.currentTasks;
					} 
					taskData.projectObject = model.currentProjects;
					/* taskData.personDetails = new Persons();
					taskData.personDetails.personId = item.personID; */
					taskData.personDetails = GetVOUtil.getPersonObject(item.personID);					
					var by:ByteArray = new ByteArray()
					var sep:String = "&#$%^!@";
					var str:String = model.person.personFirstname+sep+projectMessageEvent.subject+sep+projectMessageEvent.body+sep
						+model.person.personId+","+model.person.defaultProfile;
					by.writeUTFBytes(str)
					taskData.taskComment = by;
					var status:Status = new Status();
					status.statusId = TaskStatus.WAITING;
					taskData.taskStatusFK = status.statusId;
					taskData.tDateCreation = model.currentTime;
					taskData.workflowtemplateFK = getMessageTemplate(item.profileID);	
					taskData.tDateEndEstimated = Utils.getCalculatedDate(model.currentTime,taskData.workflowtemplateFK.defaultEstimatedTime); 
					taskData.estimatedTime = taskData.workflowtemplateFK.defaultEstimatedTime;			
					messageTaskCollection.addItem(taskData);
				}
			}
			var taskEvent:TasksEvent = new TasksEvent(TasksEvent.CREATE_NWEMSG_TASKS);
			taskEvent.tasksCollection = messageTaskCollection;
			taskEvent.dispatch();
		}
		public function getMessageTemplate(pro:int):Workflowstemplates{
			var messageTemplateCollection:ArrayCollection = Utils.getWorkflowTemplatesCollection(model.messageTemplatesCollection,model.currentProjects.workflowFK);
			for each(var item:Workflowstemplates in  messageTemplateCollection){
				if(item.profileFK== pro){
					return item;
				}
			}
			return null;
		}
	}
}