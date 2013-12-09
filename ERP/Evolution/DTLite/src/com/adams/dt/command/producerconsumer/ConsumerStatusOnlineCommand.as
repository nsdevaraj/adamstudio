package com.adams.dt.command.producerconsumer
{
	import com.adams.dt.business.PushConsumerDelegate;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.PresetTemplateEvent;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.view.components.chatscreen.asfile.MessageWindow;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
	
	public final class ConsumerStatusOnlineCommand extends AbstractCommand implements IResponder
	{
		private var AlertWindow:MessageWindow;
		private var cursor:IViewCursor;
		override public function execute( event : CairngormEvent ) : void
		{
			var delegate:PushConsumerDelegate = new PushConsumerDelegate( this );
			var personsEvent : PersonsEvent = PersonsEvent(event);			
			delegate.subscribe(); 
			
			var eventproducer: PersonsEvent = new PersonsEvent( PersonsEvent.EVENT_PUSH_STATUSONLINE);
			eventproducer.OnlineOffline = "Online";
			
      		eventproducer.dispatch();       		    		
      		
		} 		
		public function messageHandler( event:MessageEvent ) : void
		{	
			var message:IMessage = event.message as IMessage;
			 
			if(message.body.onlineuserid!=undefined)
			{
				if(message.body.onlineuserstatus!="Offline")
				{
					model.modelPushOnlineUserId = message.body.onlineuserid;
					model.modelPushOnlineUserName = message.body.onlineusername;
					model.modelPushOnlineUserStatus = message.body.onlineuserstatus;
					model.modelPushOnlineUserUNID = message.body.onlineuserUNIID;
								
					var obj:Object = {};
					obj.modelPushOnlineUserId = message.body.onlineuserid;
					obj.modelPushOnlineUserName = message.body.onlineusername;
					obj.modelPushOnlineUserStatus = message.body.onlineuserstatus;
					obj.modelPushOnlineUserUNID = message.body.onlineuserUNIID;
					if( !Utils.checkDuplicateItem( obj, model.modelLiveUsersArr, 'modelPushOnlineUserId' ) ) {	
						model.modelLiveUsersArr.addItem(obj);									
					} 					
				}
				else
				{
					for( var i : Number = 0; i < model.modelLiveUsersArr.length;i++)
					{
						var str:String = model.modelLiveUsersArr.getItemAt( i ).modelPushOnlineUserId;
						if(new Number(message.body.onlineuserid) == new Number(str))
						{
							if( Utils.checkDuplicateItem( model.modelLiveUsersArr.getItemAt( i ), model.modelLiveUsersArr, 'modelPushOnlineUserId' ) ) {							
								model.modelLiveUsersArr.removeItemAt( i );
							}	
						}					
					} 
					model.modelLiveUsersArr.refresh();
				}				
				
			}  
			else if(message.body.pushTaskId!=undefined)
			{	
				var pushImpMail:String = "";	
				if(message.body.pushImpMail!=undefined) {	
					pushImpMail = message.body.pushImpMail;    //output is 'ExternalMail'
				}		
				model.modelPushCreateTaskId = message.body.pushTaskId;
				
				var pushPersonId:String = "";
				var tempPushId:String = message.body.pushPersonId;
				var tempPushPersonArray:Array = tempPushId.split( "," );
				
				if( tempPushPersonArray.length == 0 ) {
					doConsume( int( tempPushPersonArray[ 0 ] ), int( message.body.pushTaskId ) ); 
				}
				else {
					for( var j:Number = 0; j < tempPushPersonArray.length; j++ ) {
						doConsume( int( tempPushPersonArray[ j ] ), int( message.body.pushTaskId ) ); 
					}
				}
			}
			else if(message.body.pushProjectDelayPersonId!=undefined) {
				var delayPersonId:String = "";
				var tempDelayPushId:String = message.body.pushProjectDelayPersonId;
				for(var ii:Number=0;ii<tempDelayPushId.split(",").length;ii++)
				{
					delayPersonId = tempDelayPushId.split(",")[ii];
					var stringArray:Array = delayPersonId.split('&&&&', 3 );
					var taskId:String = stringArray[1];
					var personId:String = stringArray[0];
					var prjName:String = stringArray[2];
					if(model.person.personId == int(personId))
					{
						var eventTaskDelay:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_GET_TASKS);
						eventTaskDelay.taskeventtaskId = int(taskId);
						eventTaskDelay.alertMessage = "ProjectDelay";
						eventTaskDelay.prjName = "Delayed Projects"+ "\n" + prjName;
						var handlerDelay:IResponder = new Callbacks(result,fault);
				 		var pushDelaySeq:SequenceGenerator = new SequenceGenerator([eventTaskDelay],handlerDelay)
				  		pushDelaySeq.dispatch();
					} 					
				}
			}
			//Project Close
			else if(message.body.pushProjectClosePersonId!=undefined) {
				var closePersonId:String = "";
				var tempClosePushId:String = message.body.pushProjectClosePersonId;
				for(var j:Number=0;j<tempClosePushId.split(",").length;j++)
				{
					closePersonId = tempClosePushId.split(",")[j];
					if(model.person.personId == int(closePersonId))
					{
						//var eventtaskclose:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_CLOSE_TASKS);
						var eventtaskclose:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_GET_TASKS);
						eventtaskclose.taskeventtaskId = int(message.body.pushProjectCloseTaskId);
						eventtaskclose.alertMessage = "ProjectClose";
						var handlerclose:IResponder = new Callbacks(result,fault);
				 		var pushcloseSeq:SequenceGenerator = new SequenceGenerator([eventtaskclose],handlerclose)
				  		pushcloseSeq.dispatch();
					} 					
				}
			}
			
			// Aboretd or Cancelled
			else if(message.body.pushProjectAbortedPersonId!=undefined) {
				var abortedPersonId:String = "";
				var tempAbortPushId:String = message.body.pushProjectAbortedPersonId;
				for(var zz:Number=0;zz<tempAbortPushId.split(",").length;zz++)
				{
					abortedPersonId = tempAbortPushId.split(",")[zz];
					if(model.person.personId == int(abortedPersonId))
					{
						//var eventtaskclose:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_CLOSE_TASKS);
						var eventtaskclose:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_GET_TASKS);
						eventtaskclose.taskeventtaskId = int(message.body.pushProjectAbortedTaskId);
						eventtaskclose.alertMessage = "ProjectAboretd";
						var handlerclose:IResponder = new Callbacks(result,fault);
				 		var pushcloseSeq:SequenceGenerator = new SequenceGenerator([eventtaskclose],handlerclose)
				  		pushcloseSeq.dispatch();
					} 					
				}
			}			
			
			else if(message.body.pushInitialProjectId!=undefined) { 
			  	var pushInitialPersonId:String = "";
				var tempPushPersonId:String = message.body.pushInitialPersonId;

				for(var ii:Number=0;ii<tempPushPersonId.split(",").length;ii++)
				{
					pushInitialPersonId = tempPushPersonId.split(",")[ii];
					
					if(model.person.personId == int(pushInitialPersonId))
					{ 
						var eventprojects:ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_PUSH_SELECT_PROJECTS);
						eventprojects.eventPushProjectsId = int(message.body.pushInitialProjectId);
						if(message.body.propPresetTemplateChange!=undefined)	                    
							eventprojects.propertChange = message.body.propPresetTemplateChange;  //output is 'PropPresetTemplateChange'
										
						var handlers:IResponder = new Callbacks(result,fault)
				 		var pushSeqs:SequenceGenerator = new SequenceGenerator([eventprojects],handlers)
				  		pushSeqs.dispatch();
					} 
				}
			}
			else if(message.body.pushUpdateProjectId!=undefined) {
							  				  	
			  	var pushUpdatePersonId:String = "";
				var tempPushUpdatePersonId:String = message.body.pushUpdatePersonId;
				
				for(var j:Number=0;j<tempPushUpdatePersonId.split(",").length;j++) {
					pushUpdatePersonId = tempPushUpdatePersonId.split(",")[j];
					if(model.person.personId == int(pushUpdatePersonId)){
						AlertWindow = new MessageWindow();					
						AlertWindow.createWindow(model.mainClass,"DT",model.loc.getString('projectStatusUpdate'),"corner");	
						var eventupdateprojects:ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_PUSH_GET_PROJECTSID);
						eventupdateprojects.eventPushProjectsId = int(message.body.pushUpdateProjectId);			
						eventupdateprojects.dispatch();							
					}
				}
			}
			
			else if(message.body.pushMailId!=undefined) {				
				var mailPersonId:String = "";
				var tempMailPushId:String = message.body.pushMailId;
				for(var ii:Number=0;ii<tempMailPushId.split(",").length;ii++) {
					mailPersonId = tempMailPushId.split(",")[ii];
					var stringArray:Array = mailPersonId.split('&&&&', 3 );
					var taskId:String = stringArray[1];
					var personId:String = stringArray[0];
					var profileId:String = stringArray[2];
					
					if(model.person.personId == int(personId)) 	{
						var eventtask:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_GET_TASKS);
						eventtask.taskeventtaskId = int(taskId);
						eventtask.alertMessage = "NewMessage";			
						var handler:IResponder = new Callbacks(result,fault)
				 		var pushSeq:SequenceGenerator = new SequenceGenerator([eventtask],handler)
				  		pushSeq.dispatch();	
					} 					
				}
			}
			
			else if(message.body.mailImpTaskId!=undefined) {	
				var mailpushPersonId:String = "";
				var tempmailPushId:String = message.body.mailImpPersonId;
				var tempmailPushStatus:String = message.body.mailImpStatus;   //output is  'Finished'
				
				for(var s:Number=0;s<tempmailPushId.split(",").length;s++) {
					mailpushPersonId = tempmailPushId.split(",")[s];
					if(model.person.personId == int(mailpushPersonId)) {
						AlertWindow = new MessageWindow();
						AlertWindow.createWindow( model.mainClass,"DT", "Validation Finished","corner");
						removeTasks(int(message.body.mailImpTaskId))						
					} 
				}				
			}
			/**
			 *  PropertiesPreset Template any changes to update the all online user. [No restrections for workflow templates - all users]
			 *  @param presettemplatesId
			 *  @param presettemplatesown message - 'ProjectPresetTemplates'
			 * */
			else if(message.body.projectPresetTemplateId!=undefined) {	
				var presetTempId:int = int(message.body.projectPresetTemplateId);
				var messageProperties:String = message.body.projectPresetStatus;         
				
				var preEvt:PresetTemplateEvent = new PresetTemplateEvent(PresetTemplateEvent.EVENT_GET_PRESET_TEMPLATEID);
	        	preEvt.presetTemplatesId = presetTempId;
	        	preEvt.dispatch();
			}	
			/**
			 *  
			 *  @param message.body.finishPersonId   -  pass projectid to get the persons
			 *  @param message.body.finishTaskId -  finished task id
			 * */
			else if(message.body.finishPersonId!=undefined) {						
				var pushfinishPersonId:String = "";
				var finishPersonId:String = message.body.finishPersonId;
				
				for(var ss:Number=0;ss<finishPersonId.split(",").length;ss++) {
					pushfinishPersonId = finishPersonId.split(",")[ss];
					if(model.person.personId == int(pushfinishPersonId)) {
						removeTasks(int(message.body.finishTaskId))						
					} 
				}				
			}
			
			else if(message.body.pushNotesProjectId!=undefined) {
				var pushNotesPersonId:String = "";
				var tempPushPersonId:String = message.body.pushNotesPersonId;

				for(var ii:Number=0;ii<tempPushPersonId.split(",").length;ii++) {
					pushNotesPersonId = tempPushPersonId.split(",")[ii];
					
					if(model.person.personId == int(pushNotesPersonId)) { 
						var eventprojects:ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_PUSH_SELECT_PROJECTS);
						eventprojects.eventPushProjectsId = int(message.body.pushNotesProjectId);
								
						var handlers:IResponder = new Callbacks(result,fault)
				 		var pushSeqs:SequenceGenerator = new SequenceGenerator([eventprojects],handlers)
				  		pushSeqs.dispatch();
					} 
				}
			}		
			
		}
		
		private function doConsume( personId:int, taskId:int ):void {
			if( model.person.personId == personId ) {
				var handler:IResponder = new Callbacks( result, fault );
				var eventtask:TasksEvent = new TasksEvent( TasksEvent.EVENT_PUSH_GET_TASKS, handler );
				eventtask.taskeventtaskId = taskId;
				eventtask.alertMessage = "NewTasks";			
				eventtask.dispatch();
			} 
		}
		
		public function removeTasks(taskId:int):void{
			var removeTask:Tasks = new Tasks()
			removeTask.taskId = taskId;
			var taskCollection:ArrayCollection = new ArrayCollection();
			taskCollection = model.taskCollection;
			for each( var item:Object in taskCollection ) {
				if( item.domain.categoryId != null ) {
						removeFinishedItem(removeTask,item.tasks);
						removeFinishedItem(removeTask,model.tasks);
						item.tasks.refresh();
						break;
				}
			}
			model.taskCollection.list = taskCollection.list;
			model.taskCollection.refresh();
		}
		
		private function removeFinishedItem( item:Object, dp:ArrayCollection ):void {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField("taskId") ];
            dp.sort = sort;
            dp.refresh(); 
			cursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if(	found ){
				if(model.currentTasks!=null)
				{
					if(model.currentTasks.taskId==item.taskId)model.workflowState=0;
				}
				dp.removeItemAt( dp.getItemIndex( cursor.current ) );
				dp.refresh();
			}
		}
	
	}
}

