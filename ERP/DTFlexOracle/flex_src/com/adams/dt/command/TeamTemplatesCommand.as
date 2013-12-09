package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.TeamTemplatesEvent;
	import com.adams.dt.event.TeamlineTemplatesEvent;
	import com.adams.dt.model.vo.TeamTemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	public final class TeamTemplatesCommand extends AbstractCommand 
	{ 
		private var teamTemplatesEvent : TeamTemplatesEvent; 		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			teamTemplatesEvent= TeamTemplatesEvent(event);
			this.delegate = DelegateLocator.getInstance().teamtemplateDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			  switch(event.type){    
			    case TeamTemplatesEvent.EVENT_GET_ALL_TEAMTEMPLATESS:
			     delegate.responder = new Callbacks(getAllResult,fault);
			     delegate.findAll();
			     break; 
			    case TeamTemplatesEvent.EVENT_GET_TEAMTEMPLATES:
			     delegate.responder = new Callbacks(findByIdResult,fault);
			     delegate.findById(model.project.workflowFK);
			     break; 
			    case TeamTemplatesEvent.EVENT_CREATE_TEAMTEMPLATES:
			     delegate.responder = new Callbacks(newCreatedTemplateResult,fault);
			     delegate.create(teamTemplatesEvent.teamtemplates);
			     break; 
			    case TeamTemplatesEvent.EVENT_UPDATE_TEAMTEMPLATES:
			     delegate.update(teamTemplatesEvent.teamtemplates);
			     break; 
			    case TeamTemplatesEvent.EVENT_DELETE_TEAMTEMPLATES:
			     delegate.deleteVO(teamTemplatesEvent.teamtemplates);
			     break; 
			    case TeamTemplatesEvent.EVENT_SELECT_TEAMTEMPLATES:
			     delegate.select(teamTemplatesEvent.teamtemplates);
			     break;  
			    default:
			     break; 
			    } 
		}
		public function getAllResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.getAllTeamTemplatesArr = rpcEvent.result as ArrayCollection;;
		
		}
		public function newCreatedTemplateResult( rpcEvent : Object ) : void
		{
			model.createdTeamTemplate= TeamTemplates(rpcEvent.message.body);
			if(model.teamTemplatesCollection.length != 0){
				var teamlineTempEvent:TeamlineTemplatesEvent = new TeamlineTemplatesEvent(TeamlineTemplatesEvent.EVENT_GETWF_TEAMLINETEMPLATES);
				teamlineTempEvent.teamtemplates = TeamTemplates(model.teamTemplatesCollection.getItemAt(0));
	 			teamlineTempEvent.dispatch()
 			}
			super.result(rpcEvent);
		}
		public function findByIdResult( rpcEvent : Object ) : void
		{
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			model.teamTemplatesCollection = arrc;
			super.result(rpcEvent);
		}
	}
}
