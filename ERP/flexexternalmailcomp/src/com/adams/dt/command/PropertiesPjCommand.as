package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.PropertiespjEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Proppresetstemplates;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	public final class PropertiesPjCommand extends AbstractCommand 
	{ 
		private var propertiespjEvent : PropertiespjEvent	;
		private var cursor:IViewCursor;			
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			propertiespjEvent = PropertiespjEvent(event);
			this.delegate = DelegateLocator.getInstance().propertiespjDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			
			  switch(event.type){
			    case PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ:
			     	delegate.responder = new Callbacks(bulkUpdateResult,fault); 
			     	delegate.bulkUpdate(model.propertiespjCollection);
			     	break; 			   
			    	default:
			     		break; 
			   } 
		}
		
		public function bulkUpdateResult( rpcEvent : Object ) : void
		{			
			super.result(rpcEvent);
			
			model.delayUpdateTxt = "Properties update";
			
			trace("--PropertiesPjCommand--bulkUpdateResult-----"+ArrayCollection(rpcEvent.message.body));
			model.mainClass.status("--PropertiesPjCommand--bulkUpdateResult-----"+ArrayCollection(rpcEvent.message.body)+ '\n'); 
			
			model.currentProjects.propertiespjSet = ArrayCollection(rpcEvent.message.body);
			var arrc:ArrayCollection = model.propertiespresetsCollection;
			model.propertiespresetsCollection = arrc;
			model.propertiespresetsCollection.refresh();
			var eventsArr:Array = [];
								
			var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
	  		var _events:Events = new Events();
			_events.eventDateStart = model.currentTime;
			_events.eventType = EventStatus.TASKMESSAGESEND; //Task create
			_events.personFk = model.person.personId;
			_events.taskFk = (model.currentTasks!=null)?model.currentTasks.taskId:0;
			_events.projectFk = model.currentProjects.projectId;
			_events.details = getUpdatedFieldDetails();
			_events.eventName = "Property Updation";		
			eEvent.events = _events;			
			//eventsArr.push(eEvent);			
			
			model.mainClass.status("updatedFieldCollection :"+model.updatedFieldCollection.length+ '\n');
			
			if(model.updatedFieldCollection.length>0)
			{		
				model.modelMessageTasks = createMessage('FAB');
				/* var messageTasks:Tasks = createMessage('FAB');
				var messageEvent:TasksEvent = new TasksEvent(TasksEvent.CREATE_PROPERTYMSG_TASKS);
				messageEvent.tasks = messageTasks;
				eventsArr.push(messageEvent); */							
			} 
			eventsArr.push(eEvent);
			
			/* model.updatedFieldCollection = new ArrayCollection();
			//if(model.newProjectCreated)	model.newProjectCreated = false;
	 		var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch(); */
	  		
	  		model.updatedFieldCollection = new ArrayCollection();
			//if(model.newProjectCreated)	model.newProjectCreated = false;
	 		var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch(); 
	  		
	  		//setTimeout(setTimeoutPropertyUpdate,2000,eventsArr);
			
		}
		private function setTimeoutPropertyUpdate(eventsArr:Array):void
		{
			model.updatedFieldCollection = new ArrayCollection();
			//if(model.newProjectCreated)	model.newProjectCreated = false;
	 		//var handler:IResponder = new Callbacks(result,fault)
	 		var handler:IResponder = new Callbacks(okResult);
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler);
	  		newProjectSeq.dispatch();
		}
		private function okResult(rpcEvent : Object):void{
	        model.mainClass.messageSettings();	
	    }
		private var details:String = new String();
		private function getUpdatedFieldDetails():String
		{
			for each(var obj:Object in model.updatedFieldCollection){
				var propertiesPj:Propertiespj = obj["propertiesPj"];
				var propertyPresetTemplate:Proppresetstemplates = obj["propertyPresetTemplate"];
				if(propertiesPj.propertyPreset.fieldType=='popup'){
					var val:String = String(propertyPresetTemplate.fieldOptionsValue).split(",")[Number(propertiesPj.fieldValue)]
					details+= propertyPresetTemplate.fieldLabel+" value Changed to "+ val+"\n"
				}else{
					details+= propertyPresetTemplate.fieldLabel+" value Changed to "+ propertiesPj.fieldValue+"\n"
				}
			}
			return details;
		}
		private function getProfileId(str:String):int{
			for each(var pro:Profiles in model.teamProfileCollection)
			{
				if(pro.profileCode == str){
					return pro.profileId;
				}
			}
			return 0;
		}
		public function getMessageTemplate(pro:int):Workflowstemplates
		{
			model.mainClass.status("getMessageTemplate messageTemplatesCollection length:"+model.messageTemplatesCollection.length+ '\n');
			model.mainClass.status("getMessageTemplate workflowId:"+model.currentProjects.workflowFK+ '\n');
			var messageTemplateCollection:ArrayCollection = Utils.getWorkflowTemplatesCollection(model.messageTemplatesCollection,model.currentProjects.workflowFK);
			for each(var item:Workflowstemplates in  messageTemplateCollection){
				if(item.profileObject.profileId == pro){
					return item;
					model.mainClass.status("getMessageTemplate item :"+item+ '\n'); 
				}
			}
			return null;
		}
		private function createMessage(profile:String):Tasks{
			var taskData:Tasks = new Tasks();
			taskData.taskId = NaN;
			//taskData.previousTask = model.currentTasks;
			taskData.projectObject = model.currentProjects;
			model.mainClass.status("model.currentProjects :"+model.currentProjects+ '\n');
			var domain:Categories = Utils.getDomains(model.currentProjects.categories);
			model.messageDomain = domain;
			model.mainClass.status("domain :"+domain+ '\n');			
			//taskData.personDetails = model.person;
			//taskData.personDetails.personId = getReplyID(String(model.currentTasks.taskComment)).split(",")[0];
			var by:ByteArray = new ByteArray()
			var sep:String = "&#$%^!@";
			var replySubject:String = '';
			//var str:String = model.person.personFirstname+sep+replySubject+sep+details+sep+model.person.personId+","+model.person.defaultProfile;
			var str:String = model.impPerson.personFirstname+sep+replySubject+sep+details+sep+model.impPerson.personId+","+model.impPerson.defaultProfile;
			model.mainClass.status("str :"+str+ '\n');			
			by.writeUTFBytes(str)
			taskData.taskComment = by;
			taskData.taskStatusFK = TaskStatus.WAITING;;
			taskData.tDateCreation = model.currentTime;
			taskData.workflowtemplateFK = getMessageTemplate(getProfileId(profile));	//FAB
			model.mainClass.status("taskData.workflowtemplateFK :"+taskData.workflowtemplateFK+ '\n');
			if(taskData.workflowtemplateFK!=null)
			{			
				taskData.tDateEndEstimated = Utils.getCalculatedDate(model.currentTime,taskData.workflowtemplateFK.defaultEstimatedTime); 
				taskData.estimatedTime = taskData.workflowtemplateFK.defaultEstimatedTime;
			}
			return taskData;
		}
		
		public static function getDomains(categories : Categories) : Categories
		{
			var tempCategories : Categories = new Categories(); 
			if(categories.categoryFK != null)
			{
				tempCategories = getDomains(categories.categoryFK);
			}else
			{
				return categories;
			}

			return tempCategories;
		}	
	}
}
