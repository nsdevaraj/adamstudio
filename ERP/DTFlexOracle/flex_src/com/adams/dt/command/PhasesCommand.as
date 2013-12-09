package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.PhasesEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.rpc.IResponder;
	
	public final class PhasesCommand extends AbstractCommand 
	{ 
		private var phaseEventCollection:ArrayCollection; 
		private var count:int = 0;
		private var phasesEvent:PhasesEvent;		
		
		override public function execute( event:CairngormEvent ):void {	 
			super.execute( event );
			var phasesEvent : PhasesEvent = PhasesEvent( event );
			this.delegate = DelegateLocator.getInstance().phaseDelegate;
			this.delegate.responder = new Callbacks( result, fault );        
			  switch( event.type ) {    
			      case PhasesEvent.EVENT_GET_ALL_PHASESS:
			      	delegate.findAll();
			      break; 
			      case PhasesEvent.EVENT_GET_PHASES:
			      	delegate.findById( phasesEvent.phases.phaseId );
			      break; 
			      case PhasesEvent.EVENT_CREATE_PHASES:
			      	delegate.create( phasesEvent.phases );
			      break;
			      case PhasesEvent.EVENT_DELETEALL_PHASES:
			      	delegate.responder = new Callbacks( result, fault );
			      	delegate.deleteAll();
			      break;  
			      case PhasesEvent.EVENT_AUTO_UPDATE_PHASES:
			      	delegate.bulkUpdate( model.phaseEventCollection );
			      break; 
			      case PhasesEvent.EVENT_UPDATE_PHASES:
			      	delegate.responder = new Callbacks( updatePhaseResult, fault );
			      	delegate.bulkUpdate( model.phaseEventCollection );
			      break; 
			      case PhasesEvent.EVENT_DELETE_PHASES:
			      	delegate.deleteVO( phasesEvent.phases );
			      break; 
			      case PhasesEvent.EVENT_SELECT_PHASES:
			      	delegate.select( phasesEvent.phases );
			      break;
			      case PhasesEvent.EVENT_UPDATE_LASTPHASE:
			      	delegate.responder = new Callbacks( lastPhaseUpdateResult, fault );
			        if( !model.tracTaskContent.tracPhases ) {
			       		model.tracTaskContent.tracPhases = model.currentProjects.phasesSet;
			       	} 
			       	delegate.bulkUpdate( phasesEvent.phasesCollection );
			      break;			      
			      case PhasesEvent.EVENT_BULK_UPDATE_PHASES:
			      	delegate.responder = new Callbacks( bulkUpdateResult, fault );
			     	if( !model.tracTaskContent.tracPhases ) {
			       		model.tracTaskContent.tracPhases = model.currentProjects.phasesSet;
			       	}
			        if( model.phaseEventCollection.length > 0 ) {
			        	updatePhasesCollection( model.phaseEventCollection );
			        }
			        if( model.tracTaskContent.adjustedStartDate ) {
			        	Phases( model.tracTaskContent.tracPhases.getItemAt( 0 ) ).phaseStart = model.tracTaskContent.adjustedStartDate;
			        	model.tracTaskContent.adjustedStartDate = null;
			        }
			        delegate.bulkUpdate( model.tracTaskContent.tracPhases );
			      break; 
			      case PhasesEvent.EVENT_CREATE_BULK_PHASES:
			      	delegate.responder = new Callbacks( createBulkUpdateResult, fault );
			      	delegate.bulkUpdate( model.phasesCollection );
			      break; 
			      default:
			      break; 
			    }
			    
		}
		
		private function updatePhasesCollection( dataSet:ArrayCollection ):void {
			var limit:int = dataSet.length;
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'phaseId' ) ]; 
			for( var i:int = 0; i < limit; i++ ) {
				model.tracTaskContent.tracPhases.sort = sort;
            	model.tracTaskContent.tracPhases.refresh(); 
				var trackView:IViewCursor = model.tracTaskContent.tracPhases.createCursor();
				var found:Boolean = trackView.findAny( dataSet.getItemAt( i ) );
				if( found ) {
					Phases( trackView.current ).phaseStart = Phases( dataSet.getItemAt( i ) ).phaseStart;
					Phases( trackView.current ).phaseDuration = Phases( dataSet.getItemAt( i ) ).phaseDuration;
					Phases( trackView.current ).phaseEnd = Phases( dataSet.getItemAt( i )).phaseEnd;
					Phases( trackView.current ).phaseEndPlanified = Phases( dataSet.getItemAt( i ) ).phaseEndPlanified;
					Phases( trackView.current ).phaseDelay = Phases( dataSet.getItemAt( i ) ).phaseDelay;
				}
				model.tracTaskContent.tracPhases.refresh(); 
			}  
		}
		
		private function bulkUpdateResult( rpcEvent : Object ) : void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection ;
			if( model.currentTasks ) {
				model.currentTasks.projectObject.phasesSet = arrc;
				if( model.currentProjects.taskDateStart ) {
					model.currentTasks.projectObject.taskDateStart = model.currentProjects.taskDateStart;
				}
				if( model.currentProjects.taskDateEnd )	{
					model.currentTasks.projectObject.taskDateEnd = model.currentProjects.taskDateEnd;
				}
				
				model.currentProjects.phasesSet = model.currentTasks.projectObject.phasesSet;
				
				if( model.currentTasks.projectObject.propertiespjSet.length != model.currentProjects.propertiespjSet.length ) {
					model.currentTasks.projectObject.propertiespjSet = Utils.modifyItems( model.currentProjects.propertiespjSet, model.currentTasks.projectObject.propertiespjSet, 'propertyPjId' );	
				}
				else {
					model.currentTasks.projectObject.propertiespjSet = model.currentProjects.propertiespjSet;
				}  
				model.currentProjects = model.currentTasks.projectObject;
			}
			else {
				model.currentProjects.phasesSet = arrc;
				for each( var item:Object in model.taskCollection ) {
					var tasks:ArrayCollection = item.tasks;
					for each( var obj:Tasks in tasks ) {
						if( obj.projectObject.projectId == model.currentProjects.projectId ) {
							obj.projectObject.phasesSet = model.currentProjects.phasesSet;
						}
					}
				}
			}
			
			super.result( rpcEvent );
			
			var eventproducer:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PUSH_PROJECT_TEAMLINE );
			eventproducer.projectId = model.currentProjects.projectId;
			
	  		var eEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_CREATE_EVENTS );
	  		var _events:Events = new Events();
			_events.eventDateStart = model.currentTime;
			_events.eventType = EventStatus.PROJECTINPROGRESS; 
			_events.personFk = model.person.personId;
			_events.taskFk = ( model.currentTasks ) ? model.currentTasks.taskId : 0;
			_events.workflowtemplatesFk = ( model.currentTasks ) ? model.currentTasks.wftFK : 0;
			_events.projectFk = model.currentProjects.projectId;			
			var by:ByteArray = new ByteArray();
			var str:String = "Properties Update";
			by.writeUTFBytes( str );
			_events.details = by;	
			_events.eventName = "Project";		
			eEvent.events = _events;			
			
			var eventsArr:Array = [ eventproducer, eEvent ];  
	 		var handler:IResponder = new Callbacks( result, fault );
	 		var msgSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
	  		msgSeq.dispatch();			
		}
		
		private function lastPhaseUpdateResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection ;
			if( model.currentTasks ) {
				model.currentTasks.projectObject.phasesSet = arrc;
				if( model.currentProjects.taskDateStart ) {
					model.currentTasks.projectObject.taskDateStart = model.currentProjects.taskDateStart;
				}
				if( model.currentProjects.taskDateEnd )	{
					model.currentTasks.projectObject.taskDateEnd = model.currentProjects.taskDateEnd;
				} 
				model.currentProjects = model.currentTasks.projectObject;
				model.currentProjects.phasesSet = model.currentTasks.projectObject.phasesSet;
				model.currentProjects.propertiespjSet = model.currentTasks.projectObject.propertiespjSet;
			}
			else {
				model.currentProjects.phasesSet = arrc;
				for each( var item:Object in model.taskCollection ) {
					var tasks:ArrayCollection = item.tasks;
					for each( var obj:Tasks in tasks ) {
						if( obj.projectObject.projectId == model.currentProjects.projectId ) {
							obj.projectObject.phasesSet = model.currentProjects.phasesSet;
						}
					}
				}
			}
			super.result( rpcEvent );
		}
		
		public function createBulkUpdateResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.project.phasesSet = arrc;
			var intialTask:Tasks = new Tasks();
			var tasks:Tasks = new Tasks();
			intialTask.workflowtemplateFK = model.workflowstemplates;
			intialTask.projectObject = model.project;
			intialTask.taskComment = model.project.projectComment;
			var status:Status = new Status();
			status.statusId = TaskStatus.FINISHED;
			intialTask.taskStatusFK = status.statusId;
			intialTask.tDateCreation = model.currentTime;
			intialTask.tDateDeadline = model.currentTime;
			intialTask.tDateInprogress = model.currentTime;
			intialTask.tDateEnd = model.currentTime;
			intialTask.deadlineTime = 0;
			intialTask.onairTime = 0;
			intialTask.personDetails = model.person;
			model.currentTasks = intialTask;
			super.result( rpcEvent );		
		} 
		
		public function updatePhaseResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
			var eventsArr:Array = [];
			if( model.currentTasks ) {
				model.currentTasks.nextTask = model.createdTask;
				model.currentTasks.taskStatusFK= TaskStatus.FINISHED;
				var taskupdateevent:TasksEvent = new TasksEvent( TasksEvent.EVENT_UPDATE_TASKS );
				eventsArr.push( taskupdateevent );
			} 
	  			  		
	  		var eventproducer:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PUSH_PROJECT_TEAMLINE );
			eventproducer.projectId = model.currentTasks.projectObject.projectId;
	  		
	  		var eEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_CREATE_EVENTS );
	  		var _events:Events = new Events();
			_events.eventDateStart = model.currentTime;
			_events.eventType = EventStatus.TASKLAUNCHED; 
			_events.personFk = model.person.personId;
			_events.taskFk = ( model.currentTasks ) ? model.currentTasks.taskId : 0;
			_events.workflowtemplatesFk = ( model.currentTasks ) ? model.currentTasks.wftFK : 0;
			_events.projectFk = model.currentTasks.projectObject.projectId;
			
			var by:ByteArray = new ByteArray();
			var str:String = "Task Created";
			by.writeUTFBytes( str );
			_events.details = by;	
			_events.eventName = 'Task';		
			eEvent.events = _events;			
			eventsArr.push( eventproducer );
			eventsArr.push( eEvent );
	 		var handlers:IResponder = new Callbacks( result, fault );
	 		var msgtaskSeqs:SequenceGenerator = new SequenceGenerator( eventsArr, handlers );
	  		msgtaskSeqs.dispatch();
       }	
	}
}
