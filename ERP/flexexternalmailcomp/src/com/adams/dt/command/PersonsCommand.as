package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.CategoriesEvent;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.PhasestemplatesEvent;
	import com.adams.dt.event.ProfilesEvent;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.event.PropertiespresetsEvent;
	import com.adams.dt.event.StatusEvents;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.WorkflowstemplatesEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Persons;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class PersonsCommand extends AbstractCommand 
	{
		private var userName : String;
		private var personsEvent : PersonsEvent   
		private var TeamArr : ArrayCollection;
		override public function execute( event : CairngormEvent ) : void
		{	
			super.execute(event);
			personsEvent = PersonsEvent(event);
			this.delegate = DelegateLocator.getInstance().personDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){				
				case PersonsEvent.EVENT_GETMSG_SENDER:
					delegate.responder = new Callbacks(getMsgSenderResult,fault);
					trace("PersonsCommand pass personId:"+personsEvent.persons.personId);
					delegate.findByMailPersonId(Persons(personsEvent.persons).personId);
					break;
				case PersonsEvent.EVENT_GETIMP_PERSONS:
					delegate.responder = new Callbacks(getImpResult,fault);
					//Alert.show("model.impPersonId :"+model.impPersonId);
					trace("model.impPersonId :"+model.impPersonId);
					delegate.findById(model.impPersonId);
					break;
				case PersonsEvent.EVENT_GET_PERSONS:
					delegate.responder = new Callbacks(getPersonsResult,fault);
					userName = personsEvent.loginName;
					//delegate.findByName(userName);
					delegate.findIMPEmail(userName);								
					break;
				case PersonsEvent.EVENT_GET_PERSONSID:
					delegate.responder = new Callbacks(getPersonsDetailsResult,fault);
					//userName = personsEvent.loginName;
					//delegate.findByName(userName);
					delegate.findById(personsEvent.personId);
					break;
				
				case PersonsEvent.EVENT_GET_ALL_PERSONSS:
					delegate.responder = new Callbacks(getAllPersonsResult,fault);
					delegate.findAll();
					break;
				//Login Authendication persons
				case PersonsEvent.EVENT_GET_AUTH_PERSONS:
					delegate.responder = new Callbacks(getAuthPersonsResult,fault);
					userName = personsEvent.loginName;
					delegate.findByName(userName);
					break;				
				default:
					break; 
			}			
		}
		public function getAllPersonsResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.personsArrCollection = rpcEvent.result as ArrayCollection;
		}
		public function getAuthPersonsResult( rpcEvent : Object ) : void
		{	
			var arrco:ArrayCollection = rpcEvent.result as ArrayCollection;	
			if(arrco.length!=0)
			{
				model.authperson = ArrayCollection(rpcEvent.message.body).getItemAt(0) as Persons;
				//model.businessCard = model.person;
				
				/* var event:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_AUTH_PERSONS);
				event.loginName = model.person.personLogin;
				var evtArr:Array = [event]
			 	var handler:IResponder = new Callbacks(result,fault)
				var seq:SequenceGenerator = new SequenceGenerator(evtArr,handler)
	          	seq.dispatch(); */
			}
			super.result(rpcEvent);

		}
		public function getPersonsDetailsResult( rpcEvent : Object ) : void
		{	
			var arrco:ArrayCollection = rpcEvent.result as ArrayCollection;	
			if(arrco.length!=0)
			{
				model.person = ArrayCollection(rpcEvent.message.body).getItemAt(0) as Persons;
				model.businessCard = model.person;
			}
			super.result(rpcEvent);

		}
		
		public function getPersonsResult( rpcEvent : Object ) : void
		{	
			var arrco:ArrayCollection = rpcEvent.result as ArrayCollection;		

				//var getDomainEvent : CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_GET_DOMAIN);
			var getAllPhaseTemp:PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS,handler);
			
 			var cataEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_GET_ALL_CATEGORIES);
 			var getAllStatus:StatusEvents = new StatusEvents(StatusEvents.EVENT_GET_ALL_STATUS);		 			 	
 			var workflowTemplateEv:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS);
			var projectEvent : ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_GET_PROJECTS);
			var prof_event : ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GET_ALL_PROFILESS);
			var profileevent : ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GETPRJ_PROFILES);

			var tevent:TasksEvent = new TasksEvent(TasksEvent.EVENT_GET_EMAILSEARCH_TASKS);	
			var pevent:PropertiespresetsEvent = new PropertiespresetsEvent(PropertiespresetsEvent.EVENT_GET_ALLPROPERTY);

 			var personEvt:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_ALL_PERSONSS);
		 	
			
			var tp : ArrayCollection 
			try
			{
				if(arrco.length!=0)
				{
					tp = ArrayCollection(rpcEvent.message.body);

					model.person = ArrayCollection(rpcEvent.message.body).getItemAt(0) as Persons;
					model.businessCard = model.person;
					model.expiryState = "loadState";
				}
				else
				{
					model.expiryState = "datafoundState";
				}
			}
			catch(e : Error)
			{
			}
			finally
			{
				if(tp.length > 0)
				{
					//tevent.emailId = taskLocalEmailId;
					tevent.emailId = model.person.personEmail;
					//var eventsArr:Array = [projectEvent,prof_event,profileevent,tevent,pevent];  // correct
					//var eventsArr:Array = [projectEvent,prof_event,profileevent,tevent,pevent,getAllStatus,workflowTemplateEv];  // correct
					
					var eventsArr:Array = [cataEvent,getAllPhaseTemp,getAllStatus,workflowTemplateEv,projectEvent,prof_event,profileevent,tevent,pevent,personEvt];  // new
					
					var handler:IResponder = new Callbacks(result,fault)
	     			var loginSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	      			loginSeq.dispatch();
          			
				}
			}
		}
		public function getMsgSenderResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.messageSender = ArrayCollection(rpcEvent.result).getItemAt(0) as Persons;
			trace("PersonsCommand getMsgSenderResult personId:"+model.messageSender.personId);
			trace("PersonsCommand getMsgSenderResult personFirstname:"+model.messageSender.personFirstname);

			var profileevent : ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_MSGSENDER_PROFILES);
			profileevent.profiles = personsEvent.profiles;
			var handler:IResponder = new Callbacks(result,fault)
 			var createmsgSeq:SequenceGenerator = new SequenceGenerator([profileevent],handler)
  			createmsgSeq.dispatch();
		}
		private function getImpResult( rpcEvent : Object  ):	void {
			model.impPerson = Persons(ArrayCollection(rpcEvent.message.body).getItemAt(0));
			trace("PersonsCommand getImpResult personId:"+model.impPerson.personId+" , personFirstname :"+model.impPerson.personFirstname);
			super.result(rpcEvent);
		}
	}
}
