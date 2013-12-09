package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.OpenToDoListScreenEvent;
	import com.adams.dt.event.PhasesEvent;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.event.PropertiespjEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
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
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.rpc.IResponder;
	
	public final class PropertiesPjCommand extends AbstractCommand 
	{ 
		private var propertiespjEvent : PropertiespjEvent	;
		private var cursor:IViewCursor;			
		
		override public function execute( event:CairngormEvent ):void {	 
			super.execute( event );
			
			propertiespjEvent = PropertiespjEvent( event );
			this.delegate = DelegateLocator.getInstance().propertiespjDelegate;
			this.delegate.responder = new Callbacks( result, fault );
			
			switch( event.type ) {    
				case PropertiespjEvent.EVENT_GET_ALL_PROPERTIESPJS:
			    	delegate.findAll();
			    break;
			    case PropertiespjEvent.EVENT_DELETEALL_PROPERTIESPJ:
			    	delegate.responder = new Callbacks( result, fault );
			        delegate.deleteAll();
			    break; 
			    case PropertiespjEvent.EVENT_GET_PROPERTIESPJ:
			    	delegate.findById( propertiespjEvent.propertiespj.propertyPjId );
			    break; 
			    case PropertiespjEvent.EVENT_CREATE_PROPERTIESPJ:
			    	delegate.create( propertiespjEvent.propertiespj );
			    break; 
			    case PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ:
			    	delegate.responder = new Callbacks( updateResult, fault ); 
			    	delegate.bulkUpdate( model.propertiespjCollection );
			    break; 
			    case PropertiespjEvent.EVENT_AUTO_UPDATE_PROPERTIESPJ:
			    	delegate.bulkUpdate( model.propertiespjCollection );
			    break; 
				case PropertiespjEvent.EVENT_BULKUPDATE_PROPERTIESPJ:
			    	delegate.responder = new Callbacks( bulkUpdateResult, fault );
			    	delegate.bulkUpdate( model.propertiespjCollection );
			    break;
			    case PropertiespjEvent.EVENT_BULKUPDATE_DEPORTPROPERTIESPJ:
			    	delegate.responder = new Callbacks( deportUpdateResult, fault );
			     	delegate.bulkUpdate( model.propertiespjCollection );
			    break;
			    case PropertiespjEvent.EVENT_DELETE_PROPERTIESPJ:
			    	delegate.deleteVO( propertiespjEvent.propertiespj );
			    break; 
			    case PropertiespjEvent.EVENT_SELECT_PROPERTIESPJ:
			    	delegate.select( propertiespjEvent.propertiespj );
			    break;
			    case PropertiespjEvent.EVENT_DEFAULTVALUE_UPDATE_PROPERTIESPJ:
			    	delegate.responder = new Callbacks( updateDefaultValueResult, fault );
			     	delegate.update( propertiespjEvent.propertiespj ); 
			    break; 
			} 
		}
		
		private function updateDefaultValueResult( rpcEvent:Object ):void {
			var tempItem:Propertiespj = Utils.getPropertyPj( Propertiespj( rpcEvent.message.body ).propertyPreset.propertyPresetId, model.currentProjects.propertiespjSet ); 
			if( tempItem ) {
				model.currentProjects.propertiespjSet.removeItemAt( model.currentProjects.propertiespjSet.getItemIndex( tempItem ) );
				model.currentProjects.propertiespjSet.addItem( Propertiespj( rpcEvent.message.body ) ); 
			}
			else {
				model.currentProjects.propertiespjSet.addItem( Propertiespj( rpcEvent.message.body ) );
			}
			super.result( rpcEvent );	
		}
		
		private function deportUpdateResult( rpcEvent:Object ):void {
			model.currentProjects.propertiespjSet = ArrayCollection( rpcEvent.message.body );
			Utils.refreshPendingCollection( model.currentProjects );
			var eventproducer:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_CURRENT_PROJECT_TEAMLINE );
			eventproducer.projectId = model.currentProjects.projectId;
			var eventsArr:Array = [ eventproducer ];  
	 		var handler:IResponder = new Callbacks( result, fault );
	 		var taskSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
	  		taskSeq.dispatch();
		}
		
		private function bulkUpdateResult( rpcEvent:Object ):void {
			if( model.currentProjects.propertiespjSet.length == ArrayCollection( rpcEvent.message.body ).length )
				model.currentProjects.propertiespjSet = ArrayCollection( rpcEvent.message.body );
			else
				model.currentProjects.propertiespjSet = Utils.modifyItems( model.currentProjects.propertiespjSet, ArrayCollection( rpcEvent.message.body ), 'propertyPjId' );
			super.result( rpcEvent );
			
			//send msg & update events
			var eventsArr:Array = [];
			var eEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_CREATE_EVENTS );
	  		var _events:Events = new Events();
			_events.eventDateStart = model.currentTime;
			_events.eventType = EventStatus.TASKMESSAGESEND;
			_events.personFk = model.person.personId;
			_events.taskFk = ( model.currentTasks ) ? model.currentTasks.taskId : 0;
			_events.workflowtemplatesFk = ( model.currentTasks ) ? model.currentTasks.wftFK : 0;
			_events.projectFk = model.currentProjects.projectId;
			
			var by:ByteArray = new ByteArray();
			var str:String = getUpdatedFieldDetails();
			by.writeUTFBytes( str );
			_events.details = by;	
			_events.eventName = "Property Updation";		
			eEvent.events = _events;
			var phaseEvent:PhasesEvent = new PhasesEvent( PhasesEvent.EVENT_BULK_UPDATE_PHASES );
			eventsArr.push( phaseEvent );
			
			if( model.updatedFieldCollection.length > 0 ) {
				if( model.currentUserProfileCode == 'CLT' ) {
					var messageTasks:Tasks = createMessage( 'TRA' );
					var messageEvent:TasksEvent = new TasksEvent( TasksEvent.CREATE_PROPERTYMSG_TASKS );
					messageEvent.tasks = messageTasks;
					eventsArr.push( messageEvent );
				}
				else if( model.currentUserProfileCode == 'EPR' ) {
					var IMPmessageTasks:Tasks = createMessage( 'FAB' );
					var IMPmessageEvent:TasksEvent = new TasksEvent( TasksEvent.CREATE_PROPERTYMSG_TASKS );
					IMPmessageEvent.tasks = IMPmessageTasks;
					eventsArr.push( IMPmessageEvent );
				}
				if( model.currentUserProfileCode != "OPE" ) {
					var taskCode:String = model.currentProjects.finalTask.workflowtemplateFK.taskCode;
					if( taskCode == OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONSCREEN || 
						 taskCode == OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONSCREENCORRECTION || 
						 taskCode == OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONCORRECTIONSCREEN ||
						 taskCode == OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONCORRECTIONINCOMPLETESCREEN ) {
						 	
						 	var messageOperator:Tasks = createMessage( 'OPE' );
						 	messageOperator.personFK = Utils.getProfilePerson( 'OPE' ).personId;
							var messageOperatorEvent:TasksEvent = new TasksEvent( TasksEvent.CREATE_MSG_TO_OPE_TASKS );
							messageOperatorEvent.tasks = messageOperator;
							eventsArr.push( messageOperatorEvent );
					}
				}
			}
			
			model.updatedFieldCollection = new ArrayCollection();
			eventsArr.push( eEvent );
			var handler:IResponder = new Callbacks( result, fault );
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
	 		newProjectSeq.dispatch(); 
		}
		
		private function updateResult( rpcEvent:Object ):void {
			if( model.currentProjects.propertiespjSet.length == ArrayCollection( rpcEvent.message.body ).length )
				model.currentProjects.propertiespjSet = ArrayCollection( rpcEvent.message.body );
			else
				model.currentProjects.propertiespjSet = Utils.modifyItems( model.currentProjects.propertiespjSet, ArrayCollection( rpcEvent.message.body ), 'propertyPjId' );
			
			super.result( rpcEvent );
			
			Utils.refreshPendingCollection( model.currentProjects );
			
			//send msg & update events
			var eventsArr:Array = [];
			if( model.newProjectCreated ) {
				if( model.incrementProjects != '' ) {
					model.currentProjects.projectName = model.incrementProjects;
					model.incrementProjects = '';
				}
				var prjEvent:ProjectsEvent = new ProjectsEvent( ProjectsEvent.EVENT_UPDATE_PROJECTNOTES );
				eventsArr.push( prjEvent ); 
			}
			
			var phaseEvent:PhasesEvent = new PhasesEvent( PhasesEvent.EVENT_BULK_UPDATE_PHASES );	
			var eEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_CREATE_EVENTS );
	  		var _events:Events = new Events();
			_events.eventDateStart = model.currentTime;
			_events.eventType = EventStatus.TASKMESSAGESEND; 
			_events.personFk = model.person.personId;
			
			if( model.newProjectCreated ) {
				_events.taskFk = ( model.createdTask ) ? model.createdTask.taskId : 0;
				_events.workflowtemplatesFk = ( model.currentTasks ) ? model.createdTask.wftFK : 0;
			}
			else {
				_events.taskFk = ( model.currentTasks ) ? model.currentTasks.taskId : 0;
				_events.workflowtemplatesFk = ( model.currentTasks ) ? model.currentTasks.wftFK : 0;
			}
			_events.projectFk = model.currentProjects.projectId;
			
			var by:ByteArray = new ByteArray();
			var str:String = getUpdatedFieldDetails();
			by.writeUTFBytes( str );
			_events.details = by;	
			_events.eventName = "Property Updation";		
			eEvent.events = _events;
			var updateFileDetailsEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_UPDATE_FILEDETAILS );
			
			if( model.updatePhase ) { 
				eventsArr.push( phaseEvent );
			} 
			
			eventsArr.push( updateFileDetailsEvent );
			
			if( model.updatedFieldCollection.length > 0 ) {
				if( model.currentUserProfileCode == 'CLT' && ( !model.newProjectCreated ) ) {
					var messageTasks:Tasks = createMessage( 'TRA' );
					var messageEvent:TasksEvent = new TasksEvent( TasksEvent.CREATE_PROPERTYMSG_TASKS );
					messageEvent.tasks = messageTasks;
					eventsArr.push( messageEvent );
				}
				else if( model.currentUserProfileCode == 'EPR' ) {				
					var impMessageTasks:Tasks = createMessage( 'FAB' );
					var impMessageEvent:TasksEvent = new TasksEvent( TasksEvent.CREATE_PROPERTYMSG_TASKS );
					impMessageEvent.tasks = impMessageTasks;
					eventsArr.push( impMessageEvent );
				}
				if( model.currentUserProfileCode != "OPE" ) {
					var taskCode:String = model.currentProjects.finalTask.workflowtemplateFK.taskCode;
					if( taskCode == OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONSCREEN || 
						 taskCode == OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONSCREENCORRECTION || 
						 taskCode == OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONCORRECTIONSCREEN ||
						 taskCode == OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONCORRECTIONINCOMPLETESCREEN ) {
						 	
						 	var messageOperator:Tasks = createMessage( 'OPE' );
						 	messageOperator.personFK = Utils.getProfilePerson( 'OPE' ).personId;
							var messageOperatorEvent:TasksEvent = new TasksEvent( TasksEvent.CREATE_MSG_TO_OPE_TASKS );
							messageOperatorEvent.tasks = messageOperator;
							eventsArr.push( messageOperatorEvent );
					}
				}
			}
			eventsArr.push( eEvent );
			
			model.updatedFieldCollection = new ArrayCollection();
			
			if( model.newProjectCreated )	model.newProjectCreated = false;
	 		
	 		var handler:IResponder = new Callbacks( result, fault );
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
	  		newProjectSeq.dispatch();
	  	}
		
		private function createMessage( profile:String ):Tasks {
			var taskData:Tasks = new Tasks();
			taskData.taskId = NaN;
			taskData.projectObject = model.currentProjects;
			
			var domain:Categories = Utils.getDomains( model.currentProjects.categories );
			model.messageDomain = domain;
			
			var by:ByteArray = new ByteArray();
			var sep:String = "&#$%^!@";
			var replySubject:String = model.currentProjects.projectName;
			var str:String = model.person.personFirstname + sep + replySubject + sep + details + sep + model.person.personId + "," + model.person.defaultProfile;
			by.writeUTFBytes( str );
			taskData.taskComment = by;
			
			var status:Status = new Status();
			status.statusId = TaskStatus.WAITING;
			taskData.taskStatusFK = status.statusId;
			taskData.tDateCreation = model.currentTime;
			taskData.workflowtemplateFK = getMessageTemplate( getProfileId( profile ) );	
			taskData.tDateEndEstimated = Utils.getCalculatedDate( model.currentTime, taskData.workflowtemplateFK.defaultEstimatedTime ); 
			taskData.estimatedTime = taskData.workflowtemplateFK.defaultEstimatedTime;
			
			return taskData;
		}
		
		private function getProfileId( str:String ):int {
			for each( var pro:Profiles in model.teamProfileCollection ) {
				if( pro.profileCode == str ) {
					return pro.profileId;
				}
			}
			return 0;
		}
		
		private function getMessageTemplate( pro:int ):Workflowstemplates {
			var messageTemplateCollection:ArrayCollection = Utils.getWorkflowTemplatesCollection( model.messageTemplatesCollection, model.currentProjects.workflowFK );
			for each( var item:Workflowstemplates in  messageTemplateCollection ) {
				if( item.profileFK == pro ) {
					return item;
				}
			}
			return null;
		}
		
		private var details:String = '';
		private function getUpdatedFieldDetails():String {
			if( model.updatedFieldCollection.length != 0 ) {
				for each( var obj:Object in model.updatedFieldCollection ) {
					var propertiesPj:Propertiespj = obj[ "propertiesPj" ];
					var propertyPresetTemplate:Proppresetstemplates = obj[ "propertyPresetTemplate" ];
					if( propertiesPj.propertyPreset.fieldType == 'popup' || propertiesPj.propertyPreset.fieldType == 'radio' ) {
						var val:String = String( propertyPresetTemplate.fieldOptionsValue ).split(",")[ Number( propertiesPj.fieldValue ) ];
						details += propertyPresetTemplate.fieldLabel + " value Changed to " + val + "\n";
					}
					else {
						details += propertyPresetTemplate.fieldLabel + " value Changed to " + propertiesPj.fieldValue + "\n";
					}
				}
			}
			else {			
				for each( var propertiesPj:Propertiespj in model.currentProjects.propertiespjSet ) {
					if( propertiesPj.propertyPreset.fieldType == 'popup' || propertiesPj.propertyPreset.fieldType == 'radio' ) {
						var val:String = String( propertiesPj.propertyPreset.fieldOptionsValue ).split( "," )[ Number( propertiesPj.fieldValue ) ];
						details += propertiesPj.propertyPreset.fieldLabel + " value Changed to " + val + "\n";
					}else{
						details += propertiesPj.propertyPreset.fieldLabel + " value Changed to " + propertiesPj.fieldValue + "\n";
					}
				}
			}
			return details;
		}
	}
}
