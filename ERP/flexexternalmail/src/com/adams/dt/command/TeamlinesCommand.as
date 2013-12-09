package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Teamlines;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
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
		        	trace("TeamlinesCommand getTeamLineProjectResult projectId:"+TeamlineEvent(event).projectId);
			        delegate.getByProjectId(TeamlineEvent(event).projectId); 	
		         break;
		         case TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE:
		        	delegate.responder = new Callbacks(createTeamLineResult,fault);
		        	//Alert.show("profileId :"+model.createdTask.workflowtemplateFK.nextTaskFk.profileObject.profileId+" , projectId :"+model.createdTask.projectObject.projectId);
		        	//model.mainClass.status("profileId nextTaskFk:"+model.createdTask.workflowtemplateFK.nextTaskFk.profileObject.profileId+" , projectId :"+model.createdTask.projectObject.projectId+ '\n'); 
		        	//model.mainClass.status("profileId :"+model.createdTask.workflowtemplateFK.profileObject.profileId+ '\n');
		        	
		        	trace("\n--TEAMLINE TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE profileId :"+model.currentTasks.workflowtemplateFK.profileObject.profileId+" , projectId :"+model.currentTasks.projectObject.projectId+ '\n');
		        	trace("--TEAMLINE TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE profileId :"+model.currentTasks.workflowtemplateFK.nextTaskFk.profileObject.profileId+ '\n');
		        	
		        	if(model.currentTasks!=null)
		       		delegate.findByTeamLinesId(model.currentTasks.workflowtemplateFK.nextTaskFk.profileObject.profileId,model.currentTasks.projectObject.projectId);
		         break;
		         //DTFlex taskid and 'Finished' word to sent
		         case TeamlineEvent.EVENT_TASK_STATUS:
		        	delegate.responder = new Callbacks(createStatusResult,fault);
		        	trace("TeamlineEvent.EVENT_TASK_STATUS ");	        	
		        	if(model.typeName == 'Mail')
		        	{
		        		trace("profileId :"+model.currentTasks.workflowtemplateFK.profileObject.profileId+" , projectId :"+model.currentTasks.projectObject.projectId+ '\n');
						
		        		if(model.currentTasks!=null)
			       		delegate.findByTeamLinesId(model.currentTasks.workflowtemplateFK.profileObject.profileId,model.currentTasks.projectObject.projectId);
		        	}
		        	else
		        	{
		        		trace("\n--TEAMLINE TeamlineEvent.EVENT_TASK_STATUS profileId :"+model.currentTasks.workflowtemplateFK.profileObject.profileId+" , projectId :"+model.currentTasks.projectObject.projectId+ '\n');
		        		trace("--TEAMLINE TeamlineEvent.EVENT_TASK_STATUS profileId :"+model.currentTasks.workflowtemplateFK.nextTaskFk.profileObject.profileId+ '\n');
		        	
			        	if(model.currentTasks!=null)
			       		delegate.findByTeamLinesId(model.currentTasks.workflowtemplateFK.nextTaskFk.profileObject.profileId,model.currentTasks.projectObject.projectId);
			       	}
		         break;
		         case TeamlineEvent.EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE:
		        	//model.mainClass.status("EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE profileId :"+model.createdTask.workflowtemplateFK.profileObject.profileId+ '\n');
		        	//delegate.responder = new Callbacks(createTeamLineMessageResult,fault);
		       		//delegate.findByTeamLinesId(model.createdTask.workflowtemplateFK.profileObject.profileId,model.createdTask.projectObject.projectId);
		       		
		       		trace("EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE profileId :"+model.createdTaskMessage.workflowtemplateFK.profileObject.profileId+ '\n');
		        	delegate.responder = new Callbacks(createTeamLineMessageResult,fault);
		       		delegate.findByTeamLinesId(model.createdTaskMessage.workflowtemplateFK.profileObject.profileId,model.createdTaskMessage.projectObject.projectId);
		       			       		
		         break;
		         
		         case TeamlineEvent.EVENT_MAILMESSAGE_TEAMLINE:		        	
		       		trace("\n EVENT_MAILMESSAGE_TEAMLINE profileId :"+model.createdTask.workflowtemplateFK.profileObject.profileId+ '\n');
		       		trace("EVENT_MAILMESSAGE_TEAMLINE projectId :"+model.createdTask.projectObject.projectId+ '\n');

		        	delegate.responder = new Callbacks(createTeamLineMailReply,fault);
		       		delegate.findByTeamLinesId(model.createdTask.workflowtemplateFK.profileObject.profileId,model.createdTask.projectObject.projectId);
		       			       		
		         break;
		         	        
		        default:
		         break; 
		      } 
    	} 
    	/**    	
    	 * Mail - message task create after that teamline based reply for corresponding user(Single user only)
    	 * 		
    	**/
    	public function createTeamLineMailReply(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent); 
			model.modelTeamlineMailColl = rpcEvent.result as ArrayCollection;
			
			if(model.typeName == 'Mail')
				model.delayUpdateTxt = "Message Reply details process";
			
			var eventtask:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_MAIL_REPLY_MSG);			
			var handler:IResponder = new Callbacks(result,fault)
 			var teamlineSeq:SequenceGenerator = new SequenceGenerator([eventtask],handler)
  			teamlineSeq.dispatch();
	  		
		}
    	public function createTeamLineMessageResult(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent); 
			model.modelTeamlineMessageCollection = rpcEvent.result as ArrayCollection;
			
			if(model.typeName == 'Reader')
				model.delayUpdateTxt = "Message Receiver details process";
			else if(model.typeName == 'All')
				model.delayUpdateTxt = "Message Receiver details process";
			
			var eventtask:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_CREATE_MESSAGE_TASKS);			
			var handler:IResponder = new Callbacks(result,fault)
 			var teamlineSeq:SequenceGenerator = new SequenceGenerator([eventtask],handler)
  			teamlineSeq.dispatch();
	  		
		}
    	public function createStatusResult(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent); 
			model.modelTeamlineStatusCollection = rpcEvent.result as ArrayCollection;
			
			trace("\n createStatusResult "+model.modelTeamlineStatusCollection.length);
			
			if(model.typeName == 'Mail')
				model.delayUpdateTxt = "Message Receiver details process";
			
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
			trace("TeamlinesCommand getTeamLineProjectResult LENGTH:"+model.teamlLineCollection.length);
			getImp();
			super.result(rpcEvent);
		}
		private function getImp():void{
			trace("TeamlinesCommand getImp :"+model.teamlLineCollection.length);
			for each(var team:Teamlines in model.teamlLineCollection){
				if(team.profileID == model.impProfileId){
					model.impPersonId = team.personID;
					trace("TeamlinesCommand inner getImp :"+model.impPersonId);
				}
			}	
			//model.impPersonId = model.person.personId;		
		}
	}
    	
}
