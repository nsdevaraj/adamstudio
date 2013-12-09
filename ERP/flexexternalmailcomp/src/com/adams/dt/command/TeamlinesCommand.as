package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Teamlines;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	public final class TeamlinesCommand extends AbstractCommand 
	{ 
		private var teamlineEvent : TeamlineEvent;	
		public  var teamline:Teamlines	
	
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			teamlineEvent = TeamlineEvent(event);
			this.delegate = DelegateLocator.getInstance().teamlineDelegate;
			this.delegate.responder = new Callbacks(result,fault);
		      switch(event.type){    		       
		        case TeamlineEvent.EVENT_SELECT_TEAMLINE:
		        	delegate.responder = new Callbacks(getTeamLineProjectResult,fault);
			        delegate.getByProjectId(TeamlineEvent(event).projectId); 	
		         break;
		         case TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE:
		        	delegate.responder = new Callbacks(createTeamLineResult,fault);
		        	//Alert.show("profileId :"+model.createdTask.workflowtemplateFK.nextTaskFk.profileObject.profileId+" , projectId :"+model.createdTask.projectObject.projectId);
		        	//model.mainClass.status("profileId nextTaskFk:"+model.createdTask.workflowtemplateFK.nextTaskFk.profileObject.profileId+" , projectId :"+model.createdTask.projectObject.projectId+ '\n'); 
		        	//model.mainClass.status("profileId :"+model.createdTask.workflowtemplateFK.profileObject.profileId+ '\n');
		        	if(model.createdTask!=null)
		       		delegate.findByTeamLinesId(model.createdTask.workflowtemplateFK.nextTaskFk.profileObject.profileId,model.createdTask.projectObject.projectId);
		         break;
		         //DTFlex taskid and 'Finished' word to sent
		         case TeamlineEvent.EVENT_TASK_STATUS:
		        	delegate.responder = new Callbacks(createStatusResult,fault);
		        	//model.mainClass.status("profileId :"+model.currentTasks.workflowtemplateFK.profileObject.profileId+" , projectId :"+model.currentTasks.projectObject.projectId+ '\n');
		        	//model.mainClass.status("profileI TESTTTTT :"+model.currentTasks.workflowtemplateFK.nextTaskFk.profileObject.profileId+" , projectId :"+model.currentTasks.projectObject.projectId+ '\n'); 
 
		        	//Alert.show("profileId :"+model.currentTasks.workflowtemplateFK.profileObject.profileId+" , projectId :"+model.currentTasks.projectObject.projectId+ '\n');
		        	//Alert.show(" profileId :"+model.currentTasks.workflowtemplateFK.nextTaskFk.profileObject.profileId+ '\n');
		        	if(model.currentTasks!=null)
		       		delegate.findByTeamLinesId(model.currentTasks.workflowtemplateFK.nextTaskFk.profileObject.profileId,model.currentTasks.projectObject.projectId);
		         break;
		         case TeamlineEvent.EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE:
		        	//model.mainClass.status("EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE profileId :"+model.createdTask.workflowtemplateFK.profileObject.profileId+ '\n');
		        	//delegate.responder = new Callbacks(createTeamLineMessageResult,fault);
		       		//delegate.findByTeamLinesId(model.createdTask.workflowtemplateFK.profileObject.profileId,model.createdTask.projectObject.projectId);
		       		
		       		//model.mainClass.status("EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE profileId :"+model.createdTaskMessage.workflowtemplateFK.profileObject.profileId+ '\n');
		        	delegate.responder = new Callbacks(createTeamLineMessageResult,fault);
		       		delegate.findByTeamLinesId(model.createdTaskMessage.workflowtemplateFK.profileObject.profileId,model.createdTaskMessage.projectObject.projectId);
		       			       		
		         break;
		         	        
		        default:
		         break; 
		      } 
    	} 
    	public function createTeamLineMessageResult(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent); 
			model.modelTeamlineMessageCollection = rpcEvent.result as ArrayCollection;
			
			var eventtask:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_CREATE_MESSAGE_TASKS);			
			var handler:IResponder = new Callbacks(result,fault)
 			var teamlineSeq:SequenceGenerator = new SequenceGenerator([eventtask],handler)
  			teamlineSeq.dispatch();
	  		
		}
    	public function createStatusResult(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent); 
			model.modelTeamlineStatusCollection = rpcEvent.result as ArrayCollection;
			
			var eventtask:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_STATUS_SEND);			
			var handler:IResponder = new Callbacks(result,fault)
 			var teamlineSeq:SequenceGenerator = new SequenceGenerator([eventtask],handler)
  			teamlineSeq.dispatch();
	  		
		}
    	public function createTeamLineResult(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent); 
			model.modelTeamlineCollection = rpcEvent.result as ArrayCollection;
			
			var eventtask:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_CREATE_TASKS);			
			var handler:IResponder = new Callbacks(result,fault)
 			var teamlineSeq:SequenceGenerator = new SequenceGenerator([eventtask],handler)
  			teamlineSeq.dispatch();
	  		
		}
    	public function getTeamLineProjectResult(rpcEvent : Object) : void
		{ 			
			model.teamlLineCollection = rpcEvent.result as ArrayCollection;
			//Alert.show("TeamlinesCommand getTeamLineProjectResult :"+model.teamlLineCollection.length);
			//trace("TeamlinesCommand getTeamLineProjectResult :"+model.teamlLineCollection.length);
			getImp();
			super.result(rpcEvent);
		}
		private function getImp():void{
			for each(var team:Teamlines in model.teamlLineCollection){
				if(team.profileID == model.impProfileId){
					model.impPersonId = team.personID;
					//trace("TeamlinesCommand getImp :"+model.impPersonId);
					//Alert.show("TeamlinesCommand getImp :"+model.impPersonId);
				}
			}
		}
	}
    	
}
