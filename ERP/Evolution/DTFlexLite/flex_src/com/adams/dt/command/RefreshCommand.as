package com.adams.dt.command
{
	import com.adams.dt.business.IDAODelegate;
	import com.adams.dt.event.CompaniesEvent;
	import com.adams.dt.event.ImpremiurEvent;
	import com.adams.dt.event.PhasestemplatesEvent;
	import com.adams.dt.event.PresetTemplateEvent;
	import com.adams.dt.event.ProfilesEvent;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.event.PropertiespresetsEvent;
	import com.adams.dt.event.ReportEvent;
	import com.adams.dt.event.StatusEvents;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.WorkflowstemplatesEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.commands.Command;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.rpc.IResponder;
	public class RefreshCommand extends Command implements ICommand , IResponder
	{
		public var delegate:IDAODelegate;
		public var model : ModelLocator = ModelLocator.getInstance();
		override public function execute( event : CairngormEvent ) : void
		{
		    var getAllStatus:StatusEvents = new StatusEvents(StatusEvents.EVENT_GET_ALL_STATUS,handler);
			var getAllPhaseTemp:PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS,handler);
			var getAllworkflowTemplate:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS);
			var compEvent:CompaniesEvent = new CompaniesEvent(CompaniesEvent.EVENT_GET_ALL_COMPANIESS);
		    var profileevent : ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GETPRJ_PROFILES);
   			var prof_event:ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GET_ALL_PROFILESS);
			var reportEv:ReportEvent = new ReportEvent(ReportEvent.EVENT_GET_PROFILE_REPORTS);
			reportEv.profileFk = model.person.defaultProfile;
			
			var taskevent:TasksEvent = new TasksEvent( TasksEvent.EVENT_GET_TASKS);
			//var projectEvent : PagingEvent = new PagingEvent(PagingEvent.EVENT_GET_PROJECT_COUNT);
			var projectEvent : ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_GET_PROJECTS);
			var proppevent : PropertiespresetsEvent = new PropertiespresetsEvent(PropertiespresetsEvent.EVENT_GET_ALLPROPERTY);
			var ImpEvt:ImpremiurEvent = new ImpremiurEvent(ImpremiurEvent.EVENT_GET_ALL_IMPREMIUR,handler);
			var getAllStatus:StatusEvents = new StatusEvents(StatusEvents.EVENT_GET_ALL_STATUS,handler);
			var getAllpresetTemp:PresetTemplateEvent = new PresetTemplateEvent(PresetTemplateEvent.EVENT_GETALL_PRESETTEMPLATE,handler);
			var eventsArr:Array = [getAllpresetTemp, projectEvent,taskevent,proppevent,
									ImpEvt,getAllStatus,
									compEvent,getAllPhaseTemp,getAllStatus,
									getAllworkflowTemplate,
								   profileevent,prof_event,reportEv] 
 			var handler:IResponder = new Callbacks(result,fault)
 			var loginSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
  			loginSeq.dispatch();
		 
		}
	}
}
