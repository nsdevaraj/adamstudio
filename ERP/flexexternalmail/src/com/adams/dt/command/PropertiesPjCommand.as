package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.PropertiespjEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Proppresetstemplates;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import flash.utils.ByteArray;
	import mx.rpc.IResponder;
	public final class PropertiesPjCommand extends AbstractCommand 
	{ 
		//import flash.utils.ByteArray;
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
			     	trace("PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ :"+model.propertiespjCollection.length);
			     	delegate.bulkUpdate(model.propertiespjCollection);
			     	break; 			   
			    	default:
			     		break; 
			   } 
		}
		
		public function bulkUpdateResult( rpcEvent : Object ) : void
		{			
			super.result(rpcEvent);
			if(model.typeName == 'All'){
				//if(model.typeSubAllName == 'AllProp'){			
						model.delayUpdateTxt = "Properties update";						
						trace("--PropertiesPjCommand--bulkUpdateResult-----"+ArrayCollection(rpcEvent.message.body)+ '\n'); 
									
						//model.currentProjects.propertiespjSet = ArrayCollection(rpcEvent.message.body);
						
						if( model.currentProjects.propertiespjSet.length == ArrayCollection( rpcEvent.message.body ).length )
							model.currentProjects.propertiespjSet = ArrayCollection( rpcEvent.message.body );
						else
							model.currentProjects.propertiespjSet = Utils.modifyItems( model.currentProjects.propertiespjSet, ArrayCollection( rpcEvent.message.body ) );
						Utils.refreshPendingCollection( model.currentProjects );
						
						var arrc:ArrayCollection = model.propertiespresetsCollection;
						model.propertiespresetsCollection = arrc;
						model.propertiespresetsCollection.refresh();
						var eventsArr:Array = [];
						
						trace("\n\n\n ############################ PropertiesPjCommand ::"+model.currentTasks.wftFK);
											
						var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
				  		var _events:Events = new Events();
						_events.eventDateStart = model.currentTime;
						_events.eventType = EventStatus.TASKMESSAGESEND; //Task create
						if(model.typeName == 'Prop'){
							_events.personFk = model.impPerson.personId;
						}
						else if(model.typeName == 'All'){
							//if(model.typeSubAllName == 'AllProp')
								_events.personFk =model.person.personId;// model.impPerson.personId;
						}
						else{
							_events.personFk = model.person.personId;
						}
							
						_events.taskFk = (model.currentTasks!=null)?model.currentTasks.taskId:0;
						_events.workflowtemplatesFk = (model.currentTasks!=null)?model.currentTasks.wftFK:0;
						_events.projectFk = model.currentProjects.projectId;
						//_events.details = getUpdatedFieldDetails();
						var by:ByteArray = new ByteArray();
						var str:String = getUpdatedFieldDetails();
						if(str!=''){
							by.writeUTFBytes(str);
						}
						else{
							str = "No changes made by IMP";
							by.writeUTFBytes(str);
						}
						
						_events.details = by;
						_events.eventName = "Property Updation";		
						eEvent.events = _events;			
						//eventsArr.push(eEvent);			
						
						trace("PropertiesPjCommand updatedFieldCollection :"+model.updatedFieldCollection.length+ '\n');
						model.modelMessageTasks = createMessage('FAB');
						trace("\n PropertiesPjCommand inner FAB MESSAGE ::"+model.modelMessageTasks);
							
						//if(model.updatedFieldCollection.length>0)
						//{		
							//model.modelMessageTasks = createMessage('FAB');
							//trace("\n PropertiesPjCommand inner FAB MESSAGE ::"+model.modelMessageTasks);
							/* var messageTasks:Tasks = createMessage('FAB');
							var messageEvent:TasksEvent = new TasksEvent(TasksEvent.CREATE_PROPERTYMSG_TASKS);
							messageEvent.tasks = messageTasks;
							eventsArr.push(messageEvent); */							
						//} 
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
				/*   	}
			  	else if(model.typeSubAllName == 'AllReader')
				{
					model.delayUpdateTxt = "Properties update";			
					trace("--PropertiesPjCommand--bulkUpdateResult--AllReader---"+ArrayCollection(rpcEvent.message.body)+ '\n'); 
				} */
			}
		}	
		private var details:String = new String();
		private function getUpdatedFieldDetails():String{
			for each(var obj:Object in model.updatedFieldCollection){
				var propertiesPj:Propertiespj = obj["propertiesPj"];
				var propertyPresetTemplate:Proppresetstemplates = obj["propertyPresetTemplate"]; 
				if(propertiesPj.propertyPreset.fieldType=='popup'|| propertiesPj.propertyPreset.fieldType == 'radio' ) {
					var val:String = String(propertyPresetTemplate.fieldOptionsValue).split(",")[Number(propertiesPj.fieldValue)]
					details+= propertyPresetTemplate.fieldLabel+" value Changed to "+ val+"\n"
				}else if(propertiesPj.propertyPreset.fieldType == 'checkbox'){
					details+= propertyPresetTemplate.fieldLabel+" value Changed to "+ propertiesPj.fieldValue+"\n"
				}
				else{
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
			var messageTemplateCollection:ArrayCollection = Utils.getWorkflowTemplatesCollection(model.messageTemplatesCollection,model.currentProjects.workflowFK);
			for each(var item:Workflowstemplates in  messageTemplateCollection){
				if(item.profileObject.profileId == pro){
					return item;
				}
			}
			return null;
		}
		private function createMessage(profile:String):Tasks{
			var taskData:Tasks = new Tasks();
			taskData.taskId = NaN;
			//taskData.previousTask = model.currentTasks;
			//taskData.projectObject = model.currentProjects;
			taskData.projectObject = model.currentTasks.projectObject;
			var domain:Categories = Utils.getDomains(model.currentProjects.categories);
			model.messageDomain = domain;
			trace("PropertiesPjCommand model.person.personId :"+model.person.personId+' , '+model.currentTasks.previousTask.personDetails.personFirstname+' , '+model.currentTasks.previousTask.personDetails.personId+'\n');			
			//taskData.personDetails = model.person;
			taskData.personFK = model.currentTasks.previousTask.personDetails.personId;
			//taskData.personDetails.personId = getReplyID(String(model.currentTasks.taskComment)).split(",")[0];
			var by:ByteArray = new ByteArray()
			var sep:String = "&#$%^!@";
			var replySubject:String = model.currentProjects.projectName;
			//var str:String = model.person.personFirstname+sep+replySubject+sep+details+sep+model.person.personId+","+model.person.defaultProfile;
			var str:String;
			if(model.updatedFieldCollection.length!=0){ 
				str = model.impPerson.personFirstname+sep+replySubject+sep+details+sep+model.impPerson.personId+","+model.impPerson.defaultProfile;
			}
			else{ 
				str = model.impPerson.personFirstname+sep+replySubject+sep+'No changes made by IMP'+sep+model.impPerson.personId+","+model.impPerson.defaultProfile;
			}
			
			trace("PropertiesPjCommand str :"+str+ '\n');			
			by.writeUTFBytes(str)
			taskData.taskComment = by;
			taskData.taskStatusFK = TaskStatus.WAITING;;
			taskData.tDateCreation = model.currentTime;
			taskData.workflowtemplateFK = getMessageTemplate(getProfileId(profile));	//FAB
			trace("PropertiesPjCommand taskData.workflowtemplateFK :"+taskData.workflowtemplateFK+ '\n');
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
