package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.CategoriesEvent;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.PhasesEvent;
	import com.adams.dt.event.ProfilesEvent;
	import com.adams.dt.event.PropertiespjEvent;
	import com.adams.dt.event.PropertiespresetsEvent;
	import com.adams.dt.event.StatusEvents;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.WorkflowstemplatesEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	public final class TasksCommand extends AbstractCommand 
	{ 
		private var tasksEvent : TasksEvent;		
		private var createdTask : Tasks;
		private const WAITING : String = "waiting";
		private const INPROGRESS : String = "in_progress";
		private var filePath:FileDetails;
		//private var swfConversion:Boolean=false;
		private var phaseEventCollection : ArrayCollection = new ArrayCollection();
		
		private var sep:String = "&#$%^!@";	
		
		private function getSubject(str:String):String{
				return str.split(sep)[1];
		}			
		private function getBody(str:String):String{
			return String(str.split(sep)[2]);
		} 
		private function getFromName(str:String):String{
			return str.split(sep)[0];
		}
		private function getReplyID(str:String):String{
			return str.split(sep)[3];
		}
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			tasksEvent = event as TasksEvent; 
			this.delegate = DelegateLocator.getInstance().taskDelegate;
			this.delegate.responder = new Callbacks(result,fault);
		    switch(event.type){
		    	case TasksEvent.EVENT_GETMAILTASKID_TASKS:
		        	delegate.responder = new Callbacks(getMailTaskResult,fault);
					delegate.findMailList(tasksEvent.tasks.taskId); 				
		        break;
		       	case TasksEvent.EVENT_GET_TASKS:
		        	delegate.responder = new Callbacks(getTaskResult,fault);
					//delegate.findByTaskId(tasksEvent.tasks.taskId);	
					delegate.findMailList(tasksEvent.tasks.taskId); 			
		        break; 
		       	case TasksEvent.EVENT_CREATE_TASKS:
		        	delegate.responder = new Callbacks(createTasksResult,fault);
		        	createdTask = Tasks(tasksEvent.tasks);
		        	model.createdTask = Tasks(tasksEvent.tasks);
					delegate.update(createdTask);	
		        break; 
		       	case TasksEvent.EVENT_UPDATE_TASKS:
		       		delegate.responder = new Callbacks(updateTasksResult,fault);
		        	//swfConversion = model.currentTasks.swfConversion;
		        	delegate.update(model.currentTasks);
		       	break;
		       	case TasksEvent.EVENT_MAILUPDATE_TASKS:
		        	delegate.responder = new Callbacks(mailUpdateTaskResult,fault);
					delegate.update(model.currentTasks); 		
		        break;
		       	case TasksEvent.CREATE_MSG_TASKS:
		        	delegate.responder = new Callbacks(getMSGTaskResult,fault);
		        	trace("CREATE_MSG_TASKS :"+Tasks(tasksEvent.tasks));
					delegate.update(Tasks(tasksEvent.tasks));	
					//delegate.create(Tasks(tasksEvent.tasks)); 			
		        break;
		        case TasksEvent.EVENT_GET_EMAILSEARCH_TASKS:
		        	delegate.responder = new Callbacks(emailSearchResult,fault);
		        	if(tasksEvent.emailId!=null)
						delegate.findByEmailId(tasksEvent.emailId); 		
		        break;
		        case TasksEvent.EVENT_UPDATE_TODO_TASKS:
		       		delegate.responder = new Callbacks(updateTodoTasksResult,fault);
		        	delegate.update(model.currentTasks);
		       	break;
		        case TasksEvent.CREATE_PROPERTYMSG_TASKS:
		        	delegate.responder = new Callbacks(createPropertyMessageResult,fault);
		        	delegate.update(Tasks(tasksEvent.tasks));
		        break;
		       	default:
		        break; 
		    }
		}
		public function createPropertyMessageResult(rpcEvent : Object ):void
		{
			super.result(rpcEvent);
			model.createdTaskMessage = Tasks(rpcEvent.result);
			model.messageBulkMailCollection.addItem(model.createdTaskMessage);
			//model.createdTask = Tasks(rpcEvent.result);
			//var eventteamlines:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE);
			var eventteamlines:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE);							
			var eventArr:Array = [eventteamlines]  
			var handlers:IResponder = new Callbacks(result,fault);
			var msgSeq:SequenceGenerator = new SequenceGenerator(eventArr,handlers)
			msgSeq.dispatch();
		}
		public function updateTodoTasksResult(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent);
			model.currentTasks = Tasks(rpcEvent.message.body);
			model.currentProfiles = model.currentTasks.workflowtemplateFK.profileObject;
			model.workflowstemplates = model.currentTasks.workflowtemplateFK;
			
			model.finishedTempTaskId = model.currentTasks;	
			
			var eventsArr:Array = [];			
			var prof_event : ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GET_ALL_PROFILESS);
			var pevent:PropertiespresetsEvent = new PropertiespresetsEvent(PropertiespresetsEvent.EVENT_GET_ALLPROPERTY);
			var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SELECT_IMP_FILE);
			if(model.currentProjects.projectStatusFK == ProjectStatus.WAITING)
			{
			}
			eventsArr.push(prof_event,pevent,fileEvent);
			//eventsArr.push(prof_event,pevent);
			var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch();
		}
		public function emailSearchResult(rpcEvent : Object ) : void 
		{
			super.result(rpcEvent);
			model.tasks = ArrayCollection(rpcEvent.message.body);	
			//model.taskCollection = ArrayCollection(rpcEvent.message.body); 
			var arrco:ArrayCollection = rpcEvent.result as ArrayCollection;
			var domains : Categories;
			var project : Projects;
			var person : Persons;
			var taskCollection : ArrayCollection = new ArrayCollection();
			var domainDeatils : Array = [];
			var tasks : ArrayCollection;
			var object : Object;
			var domains : Categories;
			var isCLT : Boolean;
			model.taskCollection = new ArrayCollection();
			model.taskCollection.refresh();
			
			if(arrco.length!=0)
			{	
				
				/* if(model.profilesCollection.length>0){
					if(getProfile(model.person.defaultProfile).profileCode == 'CLT') isCLT = true
				}  */ 
				for each(var item : Tasks in model.tasks) 
				{
					item.projectObject = checkItem(item.projectObject, model.projectsCollection );
					if(isCLT) {
						domains = item.projectObject.categories;
						model.domainCollection.addItem(getDomains(item.projectObject.categories))
					}
					else {
						domains = getDomains(item.projectObject.categories);
						model.domainCollection.addItem(domains)
					}
					if(domainDeatils.indexOf(domains) > - 1) {				
						for each(var item2:Object in taskCollection ) {
							if(item2.domain.categoryId == domains.categoryId) {
								tasks = item2.tasks;
								break;
	 						}
						}
						if(item.personDetails!=null&&(Utils.checkTemplateExist(model.messageTemplatesCollection,item.workflowtemplateFK.workflowTemplateId))) {
							if(item.personDetails.personId == model.person.personId)tasks.addItem(item);
						}
						else {	
							tasks.addItem(item);
						}
					}
					else {
						object = new Object();
						tasks = new ArrayCollection();
						object['domain'] = domains;
						object['tasks'] = tasks;
						if((Utils.checkTemplateExist(model.messageTemplatesCollection,item.workflowtemplateFK.workflowTemplateId))) {
							if(item.personDetails.personId == model.person.personId)tasks.addItem(item);
						}
						else {
							tasks.addItem(item);
						}
						taskCollection.addItem(object);
						domainDeatils.push(domains);
					}
					
					
					if( item.tDateEndEstimated != null ) {
						var previousDate:Date = model.currentTime;
						var nextDate:Date = new Date( model.currentTime.getTime() + DateUtil.DAY_IN_MILLISECONDS );
						var previousCompare:Number = new Date( previousDate.getFullYear(),  previousDate.getMonth(), previousDate.getDate() ).getTime();
						var nextCompare:Number = new Date( nextDate.getFullYear(), nextDate.getMonth(), nextDate.getDate() ).getTime();
						if( ( item.tDateEndEstimated.getTime() >= previousCompare ) && ( item.tDateEndEstimated.getTime() < nextCompare ) ) {
							if( Utils.checkTemplateExist( model.alarmTemplatesCollection, item.workflowtemplateFK.workflowTemplateId ) ) {
								if( !Utils.checkDuplicateItem( item, model.delayedTasks, 'taskId' ) ) {
									model.delayedTasks.addItem( item );
								}
							}
						}
					}
				}
				model.taskCollection = taskCollection;
				model.domainCollection = new ArrayCollection(domainDeatils);
				model.expiryState = "todoState";
				model.workflowState = 0;				
			}
			else
			{
				model.expiryState = "datafoundState";
			}						
						
		}  
		/* public function getProfile(prof_id:int):Profiles	
		{
			var currProf:Profiles;
			for each (var profile:Profiles in model.teamProfileCollection)
			{
			 	profile.profileId == prof_id ? currProf = profile : null;	
			}
			return currProf;
		} */
		/* public function emailSearchResult(rpcEvent : Object ) : void 
		{	 
			super.result(rpcEvent);
			model.tasks = ArrayCollection(rpcEvent.message.body); 
			Alert.show("emailSearchResult :"+model.tasks.length);
			var domainDeatils : Array = [];
			var taskCollection : ArrayCollection = new ArrayCollection();
			var tasks : ArrayCollection;
			var object : Object;
			var domains : Categories;
			var isCLT : Boolean
			model.taskCollection = new ArrayCollection();
			model.taskCollection.refresh();
			if(model.profilesCollection.length>0){
				if(getProfile(model.person.defaultProfile).profileCode == 'CLT') isCLT = true
			}   
			for each(var item : Tasks in model.tasks) {
				item.projectObject = checkItem(item.projectObject, model.projectsCollection );
				if(isCLT) {
					domains = item.projectObject.categories;
					model.domainCollection.addItem(getDomains(item.projectObject.categories))
				}
				else {
					domains = getDomains(item.projectObject.categories);
					model.domainCollection.addItem(domains)
				}
				if(domainDeatils.indexOf(domains) > - 1) {				
					for each(var item2:Object in taskCollection ) {
						if(item2.domain.categoryId == domains.categoryId) {
							tasks = item2.tasks;
							break;
 						}
					}
					if(item.personDetails!=null&&(Utils.checkTemplateExist(model.messageTemplatesCollection,item.workflowtemplateFK.workflowTemplateId))) {
						if(item.personDetails.personId == model.person.personId)tasks.addItem(item);
					}
					else {	
						tasks.addItem(item);
					}
				}
				else {
					object = new Object();
					tasks = new ArrayCollection();
					object['domain'] = domains;
					object['tasks'] = tasks;
					if((Utils.checkTemplateExist(model.messageTemplatesCollection,item.workflowtemplateFK.workflowTemplateId))) {
						if(item.personDetails.personId == model.person.personId)tasks.addItem(item);
					}
					else {
						tasks.addItem(item);
					}
					taskCollection.addItem(object);
					domainDeatils.push(domains);
				}
				
				//Added By Deepan to take delayed tasks
				
				if( item.tDateEndEstimated != null ) {
					var previousDate:Date = model.currentTime;
					var nextDate:Date = new Date( model.currentTime.getTime() + DateUtil.DAY_IN_MILLISECONDS );
					var previousCompare:Number = new Date( previousDate.getFullYear(),  previousDate.getMonth(), previousDate.getDate() ).getTime();
					var nextCompare:Number = new Date( nextDate.getFullYear(), nextDate.getMonth(), nextDate.getDate() ).getTime();
					if( ( item.tDateEndEstimated.getTime() >= previousCompare ) && ( item.tDateEndEstimated.getTime() < nextCompare ) ) {
						if( Utils.checkTemplateExist( model.alarmTemplatesCollection, item.workflowtemplateFK.workflowTemplateId ) ) {
							if( !Utils.checkDuplicateItem( item, model.delayedTasks, 'taskId' ) ) {
								model.delayedTasks.addItem( item );
							}
						}
					}
				}
			}
			model.taskCollection = taskCollection;
			model.domainCollection = new ArrayCollection(domainDeatils);
			model.workflowState = 0;
		} */
		public function getProfile(prof_id:int):Profiles	{
			var currProf:Profiles;
			for each (var profile:Profiles in model.teamProfileCollection){
			 profile.profileId == prof_id ? currProf = profile : null;	
			}
			return currProf;
		}
		private function checkItem( item:Object, dp:ArrayCollection ): Projects 
		{
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'projectId' ) ];
            dp.sort = sort;
            dp.refresh(); 
			var cursor:IViewCursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				return Projects( cursor.current );
			}
			return Projects( item );
		}
		public function getDomains(categories : Categories) : Categories
		{
			var tempCategories : Categories = new Categories();
			if(categories.categoryFK != null)
			{
				tempCategories = getDomains(categories.categoryFK);
			}else
			{
				return categories;
			}

			return tempCategories;
		}
		
		public function getMSGTaskResult(rpcEvent : Object ) : void{
			super.result(rpcEvent);
			trace("CREATE_MSG_TASKS result:"+rpcEvent.message.body);
			model.createdTask = Tasks(rpcEvent.message.body);
			model.project = Tasks(rpcEvent.message.body).projectObject;
			
			var event:TasksEvent = new TasksEvent( TasksEvent.EVENT_MAILUPDATE_TASKS);
	 		var handlers:IResponder = new Callbacks(result,fault);
	 		var creSeq:SequenceGenerator = new SequenceGenerator([event],handlers)
	  		creSeq.dispatch();
		} 
		public function getMailTaskResult(rpcEvent : Object ) : void
		{
			var arrco:ArrayCollection = rpcEvent.result as ArrayCollection;
			if(arrco.length!=0)
			{
				model.currentTasks = ArrayCollection(rpcEvent.result).getItemAt(0) as Tasks;
				
				model.currentProjects = model.currentTasks.projectObject;
				var arrc:ArrayCollection = model.currentProjects.propertiespjSet;
				for each(var item:Propertiespj in arrc){
	   	 			item.projectFk = model.currentProjects.projectId;	 	
	   	 		}
	   	 		model.expiryState = "mailState";
	   	 		
	   	 		var eventp:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_PERSONSID);
				//eventp.loginName = getFromName(String(model.currentTasks.taskComment));
				//eventp.personId = (getReplyID(String(model.currentTasks.taskComment)).split(",")[0]);
				eventp.personId = model.currentTasks.personDetails.personId;
	   	 		var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SELECT_FILEDETAILS);
	   	 		var profileevent : ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GETPRJ_PROFILES);
	   	 		
	 			var handler:IResponder = new Callbacks(result,fault)
	 			var fSeq:SequenceGenerator = new SequenceGenerator([eventp,profileevent,fileEvent],handler)
	  			fSeq.dispatch();
	  		}
	  		else
	  		{
	  			model.expiryState = "expireState";
	  		}
	  		super.result(rpcEvent);
		}
		public function getTaskResult(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent);
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			if(arrc!=null)
			{
				if(arrc.length!=0)
				{
					model.currentTasks = ArrayCollection(rpcEvent.result).getItemAt(0) as Tasks;	
					trace("model.currentTasks :"+model.currentTasks);
					model.finishedTempTaskId = model.currentTasks;			
					model.currentProjects = model.currentTasks.projectObject;
					trace("model.currentProjects :"+model.currentProjects);
					
					trace("\n personDetails :"+model.currentTasks.personDetails.personFirstname);
					trace("\n personDetails :"+model.currentTasks.personFK);
					
					if(model.currentTasks.personDetails!=null)
						model.currentPersons = model.currentTasks.personDetails;
					
					model.expiryState = "impState";
					
					/* var arrco:ArrayCollection = model.currentProjects.propertiespjSet;
					for each(var item:Propertiespj in arrco){
		   	 			item.projectDetails = model.currentProjects;	 	
		   	 		} */
		   	 		
		   	 		/* var prof_event:ProfilesEvent = new ProfilesEvent(ProfilesEvent.EVENT_GET_ALL_PROFILESS);
		   	 		var pevent:PropertiespresetsEvent = new PropertiespresetsEvent(PropertiespresetsEvent.EVENT_GET_ALLPROPERTY);
		   	 		var getAllStatus:StatusEvents = new StatusEvents(StatusEvents.EVENT_GET_ALL_STATUS,handler);
		 			var workflowTemplateEv:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS);		   	 				   	 		
	 				var cataEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_GET_ALL_CATEGORIES);
	 				var personEvt:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_ALL_PERSONSS); */
	 				
	 				var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SELECT_IMP_FILE);

		   	 		model.mainClass.status("WorkflowstemplatesEvent calling :"+model.currentProjects.workflowFK+ '\n');
	   	 			
	   	 			//old model
		   	 		//var eventsArr:Array = [pevent,prof_event,fileEvent,getAllStatus,workflowTemplateEv] 
		   	 		
		   	 		//var eventsArr:Array = [getAllStatus,workflowTemplateEv,prof_event,fileEvent,pevent,personEvt]
		   	 		
		   	 		var eventsArr:Array = [fileEvent]
		   	 		
		 			var handler:IResponder = new Callbacks(result,fault)
		 			var pSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
		  			pSeq.dispatch();
				}
				else
		  		{		
		  			model.expiryState = "expireState";
		  		}
			} 
		}	
		public function createTasksResult(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent);
			
			model.expiryState = "delaySendState";
			model.delayUpdateTxt = "Processing Start";
			
			model.newTaskCreated = true;
			model.createdTask = Tasks(rpcEvent.message.body);
			model.mainClass.status("model.createdTask :"+model.createdTask.taskId+" , "+model.createdTask.workflowtemplateFK.nextTaskFk+ '\n'); 
			trace("createTasksResult -- :"+model.createdTask)
			model.project = Tasks(rpcEvent.message.body).projectObject;	
			
			checkPhases(model.createdTask);		
			var eventsArr:Array = [ ];
			
			//DTFlex taskid and 'Finished' word to sent
			var eventteamlinesstatus:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_TASK_STATUS);
			//eventsArr.push(eventteamlinesstatus);
			var phaseEvent : PhasesEvent = new PhasesEvent(PhasesEvent.EVENT_UPDATE_PHASES);
			var taskupdateevent : TasksEvent = new TasksEvent( TasksEvent.EVENT_UPDATE_TASKS );
			
			trace("phaseEventCollection.length :"+phaseEventCollection.length); 
			if(phaseEventCollection.length > 0)
			{
				eventsArr.push(phaseEvent);
			} 
			//else if(model.currentTasks != null)
			//{
				//Alert.show("else taskupdateevent calling EVENT_UPDATE_TASKS");
				model.currentTasks.nextTask = model.createdTask;
				model.currentTasks.taskStatusFK = TaskStatus.FINISHED;
				model.currentTasks.tDateInprogress = model.currentTime;
				model.currentTasks.tDateEnd = model.currentTime;
			
				//eventsArr.push(taskupdateevent);
				
				eventsArr.push(taskupdateevent,eventteamlinesstatus);
				
				//old model
				//eventsArr.push(taskupdateevent,eventteamlinesstatus);
			//}
					
			trace("SequenceGenerator calling");
	 		var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch();
		}		
		public function checkPhases(createdTask : Tasks) : void
		{
			model.delayUpdateTxt = "Phases Checking";
			
			createdTask = setPhase(createdTask);
			var prevTask : Tasks = setPhase(createdTask.previousTask);
			if(createdTask.workflowtemplateFK.phaseTemplateFK != 0)
			{
				if(createdTask.previousTask != null)
				{
					//check the phase of new task is bigger than next task flow in wft
					if(createdTask.workflowtemplateFK.phaseTemplateFK > createdTask.previousTask.workflowtemplateFK.phaseTemplateFK)
					{
						// the new task is first of the phase
						createdTask.firstofPhase = true;
					}
				}else
				{
					// the new task is first of the phase, first of the workflow
					createdTask.firstofPhase = true;
				} 
			} 
			//first of phase
			if(createdTask.firstofPhase)
			{
				// to fill phase end of prev task
				if(prevTask.phase.phaseEnd == null)
				{ 
					prevTask.phase.phaseEnd = model.currentTime;
					prevTask.phase.phaseDuration = Math.round(( prevTask.phase.phaseEnd.getTime() - prevTask.phase.phaseStart.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
					var planneddelay : Number = Math.round(( prevTask.phase.phaseEndPlanified.getTime() - prevTask.phase.phaseStart.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
					prevTask.phase.phaseDelay = prevTask.phase.phaseDuration - planneddelay;
					phaseEventCollection.addItem(prevTask.phase);
				}
				// fill start phase
				createdTask.phase.phaseStart = model.currentTime;
				phaseEventCollection.addItem(createdTask.phase);
			}
			model.phaseEventCollection = phaseEventCollection;
		}
		// set the phase for the provided task
		public function setPhase(task : Tasks) : Tasks
		{
			var sort : Sort = new Sort();
			sort.fields = [new SortField("phaseTemplateFK")];
			if(task.projectObject.phasesSet)
			{
				task.projectObject.phasesSet.sort = sort;
				task.projectObject.phasesSet.refresh();
				var cursor : IViewCursor = task.projectObject.phasesSet.createCursor();
				var phase : Phases = new Phases();
				phase.phaseTemplateFK = task.workflowtemplateFK.phaseTemplateFK;
				var found : Boolean = cursor.findAny(phase);
				if (found)
				{
					task.phase = Phases(cursor.current);
				}
			}

			return task;
		}
		
		public function updateTasksResult(rpcEvent : Object ) : void
		{	 
			super.result(rpcEvent);
			model.currentTasks = Tasks(rpcEvent.message.body);
			model.currentProfiles = model.currentTasks.workflowtemplateFK.profileObject;
			model.workflowstemplates = model.currentTasks.workflowtemplateFK;
			var eventsArr:Array = [];
			
			model.delayUpdateTxt = "Task update";
			
			//var updateProjectEvent : ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_UPDATE_PROJECTS);
			//var filedetailsBasicEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_BASICFILEDETAILS);
			//var filedetailsTaskEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_TASKFILEDETAILS);
			var updatepropPjEvent : PropertiespjEvent = new PropertiespjEvent(PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ);
			//var updatecommentEvent : CommentEvent = new CommentEvent(CommentEvent.BULK_UPDATE_COMMENT);
			//add by kumar 31 July Events
			var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
			//Taskid send to profileid and projectid base (New Task Create)
			var eventteamlines:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE);
			
			trace("----TasksCommand--updateTasksResult ----model.waitingFab---->"+model.waitingFab);
			model.mainClass.status("--TasksCommand--updateTasksResult--"+model.currentTasks.workflowtemplateFK.profileObject.profileCode+ '\n'); 

			//Alert.show("--TasksCommand--updateTasksResult--"+model.currentTasks.workflowtemplateFK.profileObject.profileCode);
			/* if(model.currentProjects.projectStatus.statusId == ProjectStatus.WAITING)
			{
				trace("--TasksCommand--updateTasksResult--if----");
				//Alert.show("--TasksCommand--updateTasksResult--if----EVENT_UPDATE_PROJECTS ");
				//model.waitingFab = true;
				var projects : Projects = model.currentProjects;
				var projectStatus : Status = new Status();
				projectStatus.statusId = ProjectStatus.INPROGRESS;
				projects.projectStatus = projectStatus;
				model.currentProjects = projects;
				
				trace("\n TasksCommand--Tasks Inprogress \n");
		
				//eventsArr.push(updateProjectEvent,filedetailsBasicEvent,filedetailsTaskEvent,eEvent);
				eventsArr.push(updateProjectEvent);
				
			}else */ 
			if(model.currentTasks.workflowtemplateFK.profileObject.profileCode == "FAB" || model.currentTasks.workflowtemplateFK.profileObject.profileCode == "EPR")
			{
				trace("--TasksCommand--updateTasksResult--else if----");				
				/* var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
				for each(var items : Propertiespj in arrc)
				{
					items.projectDetails = model.currentTasks.projectObject;
				}
				model.propertiespjCollection = arrc; */
				trace("--TasksCommand--updateTasksResult--else if----"+model.propertiespjCollection.length);
				model.mainClass.status("--TasksCommand--updateTasksResult--else if----EVENT_UPDATE_PROPERTIESPJ :"+model.propertiespjCollection.length+ '\n'); 
				trace("\n TasksCommand--Tasks Inprogress \n");	
				
				var _eventss:Events = new Events();
				_eventss.eventDateStart = model.currentTime;
				_eventss.eventType = EventStatus.TASKINPROGRESS; //Task create
				_eventss.personFk = model.person.personId;
				_eventss.taskFk = model.currentTasks.taskId;
				_eventss.projectFk = model.currentTasks.projectObject.projectId;
				_eventss.details = "Tasks Inprogress";
				_eventss.eventName = "Task";			
				eEvent.events = _eventss;				
				
				eventsArr.push(updatepropPjEvent,eventteamlines,eEvent);
	
				
			}
			var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch();
		}
		public function mailUpdateTaskResult(rpcEvent : Object ) : void
		{	
			super.result(rpcEvent);		
			model.currentTasks = Tasks(rpcEvent.message.body);	
			trace("mailUpdateTaskResult :"+model.currentTasks.taskId);
			model.currentProjects = model.currentTasks.projectObject;
			model.currentProfiles = model.currentTasks.workflowtemplateFK.profileObject;
			model.workflowstemplates = model.currentTasks.workflowtemplateFK;
			model.taskCollection.refresh();
			
			model.expiryState = "loadState";
		}
				
	}
}
