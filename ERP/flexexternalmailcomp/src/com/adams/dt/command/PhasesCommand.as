package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.PhasesEvent;
	import com.adams.dt.model.vo.Phases;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	public final class PhasesCommand extends AbstractCommand 
	{ 
		private var phaseEventCollection : ArrayCollection; 
		private var count:int = 0;
		private var phasesEvent : PhasesEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			var phasesEvent : PhasesEvent = PhasesEvent(event);
			this.delegate = DelegateLocator.getInstance().phaseDelegate;
			this.delegate.responder = new Callbacks(result,fault);     
			   
		  	switch(event.type){
		  		case PhasesEvent.EVENT_UPDATE_PHASES:
		   			delegate.responder = new Callbacks(updatePhaseResult,fault);
		   			updatePhasetest()
		   			delegate.bulkUpdate(model.phaseEventCollection);
		  		break; 			      
		  		default:
		  		break; 
			}			    
		}
		public function updatePhasetest() : void
		{
			for each(var phases:Phases in model.phaseEventCollection)
			{
				trace("\n PhasesCommand updatePhasetest :"+phases.phaseEnd);	  
			}
		}
		public function updatePhaseResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			
			model.delayUpdateTxt = "Phases update";
			
			/* var eventsArr:Array = [];
        	if(model.currentTasks != null)
			{
				trace("\n PhasesCommand updatePhaseResult inner if loop");	  		
				model.currentTasks.nextTask = model.createdTask;
				model.currentTasks.taskStatus.statusId = TaskStatus.FINISHED;
				trace("\n PhasesCommand updatePhaseResult inner if loop EVENT_UPDATE_TASKS update");	
				var taskupdateevent : TasksEvent = new TasksEvent( TasksEvent.EVENT_UPDATE_TASKS );
				eventsArr.push(taskupdateevent);
			}
			var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch(); */
	  			  		
	  		//trace("******PhasesCommand***************updatePhaseResult*********projectId************"+model.currentTasks.projectObject.projectId);
	  		
	  		trace("\n PhasesCommand updatePhaseResult \n");	  			  		
	  		
       }	
	}
}
