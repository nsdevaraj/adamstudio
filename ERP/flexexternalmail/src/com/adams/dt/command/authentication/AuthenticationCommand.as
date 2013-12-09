package com.adams.dt.command.authentication
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.CategoriesEvent;
	import com.adams.dt.event.CompaniesEvent;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.LangEvent;
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.PhasestemplatesEvent;
	import com.adams.dt.event.PresetTemplateEvent;
	import com.adams.dt.event.ProfilesEvent;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.event.PropertiespresetsEvent;
	import com.adams.dt.event.StatusEvents;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.WorkflowstemplatesEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.utils.setTimeout;
	
	import mx.events.PropertyChangeEvent;
	import mx.rpc.IResponder;
	
	public final class AuthenticationCommand extends AbstractCommand implements ICommand , IResponder 
	{
		private var userName : String; 
		override public function execute( event : CairngormEvent ) : void
		{
			userName = event.data.userName;
			this.delegate = DelegateLocator.getInstance().authenticationDelegate;
			this.delegate.responder = this; 
			trace("AuthenticationCommand :"+event.data.userName+" , "+event.data.password);
			this.delegate.login(event.data.userName , event.data.password);
		}
		private var personconsumer_evt:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_CONSU_STATUSONLINE);
		private var loginStatus : Boolean;
		public function checkLogin(ev : PropertyChangeEvent) : void
		{
			trace("\n\nAuthenticationCommand checkLogin :"+ev.currentTarget.authenticated);
			if(ev.currentTarget.authenticated)
			{
				loginStatus = true;
				model.loginErrorMesg = "";
				model.person.personLogin = this.userName;
				model.invalideAlertName = "";
				
				model.delayUpdateTxt = "Authentication starts";
				
				trace("AuthenticationCommand userlogin :"+model.person.personLogin);
				
				var getAllLang_evt :LangEvent = new LangEvent(LangEvent.EVENT_GET_ALL_LANGS);
    			var getAllPhasetemp_evt:PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS);
	 			var getAllpresettemp_evt:PresetTemplateEvent = new PresetTemplateEvent(PresetTemplateEvent.EVENT_GETALL_PRESETTEMPLATE,handler);
	 			var getAllcatagory_evt:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_GET_ALL_CATEGORIES);
	   	 		var getAllStatus_evt:StatusEvents = new StatusEvents(StatusEvents.EVENT_GET_ALL_STATUS,handler);
	 			var getAllworkflowTemplate_evt:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS);
				var getAllprof_evt:ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GET_ALL_PROFILESS);
	   	 		var getAllprop_pre_evt:PropertiespresetsEvent = new PropertiespresetsEvent(PropertiespresetsEvent.EVENT_GET_ALLPROPERTY);
				
				var getAllcompEvent:CompaniesEvent = new CompaniesEvent(CompaniesEvent.EVENT_GET_ALL_COMPANIESS);
				
				//Only IMP
	 			var getAllperson_evt:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_ALL_PERSONSS);
    			//var personconsumer_evt:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_CONSU_STATUSONLINE);	    			
		 		
		 		var tasks_event:TasksEvent = new TasksEvent(TasksEvent.EVENT_GET_TASKS);
		 		
		 		var curPersonEvt:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_AUTH_PERSONS);
				var projectEvent : ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_GET_PROJECTSID);
					
				var teamTempEvt:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_SELECT_TEAMLINE);	
				teamTempEvt.projectId = model.modelProjectLocalId;		
				
				if(model.typeName == 'Mail')
				{			
		  			var levent :LangEvent = new LangEvent(LangEvent.EVENT_GET_ALL_LANGS);
	    			var eventconsumer:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_CONSU_STATUSONLINE);
	    			var getAllPhaseTemps:PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS,handler);
		 			var getAllpresetTemps:PresetTemplateEvent = new PresetTemplateEvent(PresetTemplateEvent.EVENT_GETALL_PRESETTEMPLATE,handler);
		 			var cataEvents:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_GET_ALL_CATEGORIES);
		 			var getAllStatus:StatusEvents = new StatusEvents(StatusEvents.EVENT_GET_ALL_STATUS,handler);
		 			var workflowTemplateEv:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS);
	    			var prof_event:ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GET_ALL_PROFILESS);
		
					var personevent:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_AUTH_PERSONS);
					personevent.loginName = model.person.personLogin;
						          		
					var tskevent:TasksEvent = new TasksEvent(TasksEvent.EVENT_GET_TASKS);
					tskevent.tasks = new Tasks();
					tskevent.tasks.taskId = model.modelTaskLocalId;
					
	          		var evtArr:Array = [levent,getAllPhaseTemps,getAllpresetTemps,cataEvents,personevent,tskevent,getAllStatus,workflowTemplateEv,prof_event,eventconsumer]
				 	var handler:IResponder = new Callbacks(maincalssview);
					var seq:SequenceGenerator = new SequenceGenerator(evtArr,handler)
		          	seq.dispatch();
		  		} 
		  		else if(model.typeName == 'Prop')
		  		{
		  			var levent :LangEvent = new LangEvent(LangEvent.EVENT_GET_ALL_LANGS);
	    			var eventconsumer:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_CONSU_STATUSONLINE);
	    			
	    			var getAllPhaseTemp:PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS,handler);
	    			var prof_event:ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GET_ALL_PROFILESS);
		   	 		var pevent:PropertiespresetsEvent = new PropertiespresetsEvent(PropertiespresetsEvent.EVENT_GET_ALLPROPERTY);
		   	 		var getAllStatus:StatusEvents = new StatusEvents(StatusEvents.EVENT_GET_ALL_STATUS,handler);
		 			var workflowTemplateEv:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS);
		 			var cataEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_GET_ALL_CATEGORIES);
		 			var personEvt:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_ALL_PERSONSS);
		 			var getAllpresetTemp:PresetTemplateEvent = new PresetTemplateEvent(PresetTemplateEvent.EVENT_GETALL_PRESETTEMPLATE,handler);
		 			
		 			//var projectEvent : ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_GET_PROJECTS);
		 			
					var event:TasksEvent = new TasksEvent(TasksEvent.EVENT_GET_TASKS);
					event.tasks = new Tasks();
					event.tasks.taskId = model.modelTaskLocalId; //taskLocalId;
	
					var evtArr:Array = [levent,getAllPhaseTemp,getAllpresetTemp,cataEvent,personEvt,event,eventconsumer,getAllStatus,workflowTemplateEv,prof_event,pevent]
					         		
				 	var handler:IResponder = new Callbacks(maincalssview);
					var seq:SequenceGenerator = new SequenceGenerator(evtArr,handler)
		          	seq.dispatch();
		  		}
		  		else if(model.typeName == 'Reader')
		  		{
		  			var levents :LangEvent = new LangEvent(LangEvent.EVENT_GET_ALL_LANGS);
	    			var eventconsumers:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_CONSU_STATUSONLINE);
	    			
	    			var getAllPhaseTemps:PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS,handler);
	    			var prof_events:ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GET_ALL_PROFILESS);
		   	 		var pevents:PropertiespresetsEvent = new PropertiespresetsEvent(PropertiespresetsEvent.EVENT_GET_ALLPROPERTY);
		   	 		var getAllStatuss:StatusEvents = new StatusEvents(StatusEvents.EVENT_GET_ALL_STATUS,handler);
		 			var workflowTemplateEvs:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS);
		 			var cataEvents:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_GET_ALL_CATEGORIES);
		 			var personEvts:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_ALL_PERSONSS);
		 			var getAllpresetTemps:PresetTemplateEvent = new PresetTemplateEvent(PresetTemplateEvent.EVENT_GETALL_PRESETTEMPLATE,handler);
		 			//var fileEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_SWFFILEDETAILS);
		 			/* var filedetail:FileDetails = new FileDetails();
		 			filedetail.fileId = model.modelFileLocalId;
					fileEvents.fileDetailsObj = filedetail; */
					
					var fileEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_SINGLE_SWFFILE);
					
		 			
		 			trace("model.typeName :"+model.typeName);
		 			trace("model.modelTaskLocalId :"+model.modelTaskLocalId);
		 			trace("model.modelProjectLocalId :"+model.modelProjectLocalId);
		 			trace("model.modelFileLocalId :"+model.modelFileLocalId);
		 			
					var events:TasksEvent = new TasksEvent(TasksEvent.EVENT_GET_TASKS);
					events.tasks = new Tasks();
					events.tasks.taskId = model.modelTaskLocalId; 
					
					var teamTempEvt:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_SELECT_TEAMLINE);
	            	trace("getTeamline ProjectId :"+ model.currentProjects.projectId);
				 	teamTempEvt.projectId = model.currentProjects.projectId;
				 	var perEv:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GETIMP_PERSONS);	
				 	
				 	var curPersonEvt:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_AUTH_PERSONS);
					curPersonEvt.loginName = model.person.personLogin;
					
					var commentevent : CommentEvent = new CommentEvent(CommentEvent.GET_COMMENT);
					commentevent.fileFk = model.modelFileLocalId;
					commentevent.compareFileFk = 0;
										
					//var evtArrs:Array = [levents,getAllPhaseTemps,getAllpresetTemps,cataEvents,curPersonEvt,events,getAllStatuss,workflowTemplateEvs,prof_events,pevents,fileEvents,commentevent]
					
					var evtArrs:Array = [levents,getAllPhaseTemps,getAllpresetTemps,cataEvents,curPersonEvt,events,getAllStatuss,workflowTemplateEvs,prof_events,pevents]
					         		
				 	var handlers:IResponder = new Callbacks(maincalssview);
					var seqs:SequenceGenerator = new SequenceGenerator(evtArrs,handlers)
		          	seqs.dispatch();
		  		}
		  		if(model.typeName == 'All')
		  		{
		  			trace("ALLLLLLLLLLL :"+model.modelTaskLocalId+", personLogin:"+model.person.personLogin);
		  			tasks_event.tasks = new Tasks();
					tasks_event.tasks.taskId = model.modelTaskLocalId; 	
					
					curPersonEvt.loginName = model.person.personLogin;			
	
					//var evtArr:Array = [getAllLang_evt,getAllPhasetemp_evt,getAllpresettemp_evt,getAllcatagory_evt,getAllperson_evt,tasks_event,personconsumer_evt,getAllStatus_evt,getAllworkflowTemplate_evt,getAllprof_evt,getAllprop_pre_evt]
					//var evtArr:Array = [getAllLang_evt,getAllPhasetemp_evt,getAllpresettemp_evt,getAllcatagory_evt,getAllperson_evt,getAllStatus_evt,getAllworkflowTemplate_evt,getAllprof_evt,getAllprop_pre_evt,tasks_event,personconsumer_evt]
					
					//var evtArr:Array = [getAllLang_evt,getAllPhasetemp_evt,getAllpresettemp_evt,getAllcatagory_evt,curPersonEvt,getAllStatus_evt,getAllworkflowTemplate_evt,getAllperson_evt,getAllprof_evt,projectEvent,tasks_event,personconsumer_evt,getAllprop_pre_evt]
					
					//original
					////////var evtArr:Array = [getAllLang_evt,getAllPhasetemp_evt,getAllpresettemp_evt,getAllcatagory_evt,curPersonEvt,getAllStatus_evt,getAllworkflowTemplate_evt,getAllperson_evt,getAllprof_evt,projectEvent,tasks_event,getAllprop_pre_evt,personconsumer_evt]
					
					
					//original
					//var evtArr:Array = [getAllLang_evt,getAllPhasetemp_evt,getAllpresettemp_evt,getAllcatagory_evt,curPersonEvt,getAllStatus_evt,getAllworkflowTemplate_evt,getAllperson_evt,getAllprof_evt,projectEvent,tasks_event,getAllprop_pre_evt,personconsumer_evt]
					
					var evtArr:Array = [getAllLang_evt,getAllcompEvent,getAllPhasetemp_evt,getAllpresettemp_evt,getAllcatagory_evt,curPersonEvt,getAllStatus_evt,getAllworkflowTemplate_evt,getAllperson_evt,getAllprof_evt,projectEvent,getAllprop_pre_evt,teamTempEvt,tasks_event] //teamTempEvt
   					         		
				 	var handler:IResponder = new Callbacks(maincalssview);
					var seq:SequenceGenerator = new SequenceGenerator(evtArr,handler)
		          	seq.dispatch();
		  		}
			} 
			
			trace("AuthenticationCommand outer loginStatus :"+loginStatus);
			
			if(loginStatus)	{		
				setTimeout(showErrorLogin , 2000);
			}else{
				setTimeout(showNoErrorLogin , 2000);
			}
		}
		public function showNoErrorLogin() : void	{
			trace("AuthenticationCommand showNoErrorLogin calling :"+loginStatus);
			if(!loginStatus)	{	
				model.expiryState = "invalidState";
			   	model.invalideAlertName = "Authentication Failed";
		   	}	
		}
		public function maincalssview(rpcEvent : Object):void{   
				personconsumer_evt.dispatch();        	
				model.mainClass.Resultsview(rpcEvent);
	   	}
		public function showErrorLogin() : void
		{
			trace("AuthenticationCommand showErrorLogin calling :"+loginStatus);
			if( !loginStatus)
			{
				if(model.loc.language == 'en')
				{
					model.loginErrorMesg = "Incorrect UserName and password"
				}else
				{
					model.loginErrorMesg = "Nom d'utilisateur et votre mot de passe incorrect"		
				}
			}else{
				model.loginErrorMesg = ""
			}
		}
	}
}