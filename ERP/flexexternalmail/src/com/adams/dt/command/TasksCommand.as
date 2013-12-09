package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.PhasesEvent;
	import com.adams.dt.event.ProfilesEvent;
	import com.adams.dt.event.PropertiespjEvent;
	import com.adams.dt.event.PropertiespresetsEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
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
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.rpc.IResponder;
	public final class TasksCommand extends AbstractCommand 
	{ 
		//import flash.utils.ByteArray;
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
		        	trace("TasksCommand EVENT_GET_TASKS :"+tasksEvent.tasks.taskId);
					//delegate.findByTaskId(tasksEvent.tasks.taskId);	
					delegate.findMailList(tasksEvent.tasks.taskId); 			
		        break; 
		       	case TasksEvent.EVENT_CREATE_TASKS:
		        	delegate.responder = new Callbacks(createTasksResult,fault);
		        	createdTask = Tasks(tasksEvent.tasks);
		        	model.createdTask = Tasks(tasksEvent.tasks);
					delegate.create(createdTask);	
		        break; 
		       	case TasksEvent.EVENT_UPDATE_TASKS:
		       		delegate.responder = new Callbacks(updateTasksResult,fault);
		        	//swfConversion = model.currentTasks.swfConversion;
		        	delegate.directUpdate(model.currentTasks);
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
		        	delegate.create(Tasks(tasksEvent.tasks));
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
			
			var eventArr:Array = [];  
			if(model.typeName == 'Reader')
			{
				model.delayUpdateTxt = "Message Creation";
				trace("createPropertyMessageResult Reader:"+model.currentTasks.taskStatusFK);
				
				if(model.currentTasks.taskStatusFK!=TaskStatus.FINISHED)
				{
					trace("createPropertyMessageResult Reader inner :"+model.currentTasks.taskStatusFK);
					var taskupdateevent : TasksEvent = new TasksEvent( TasksEvent.EVENT_UPDATE_TASKS );
					model.currentTasks.nextTask = model.createdTaskMessage;
					model.currentTasks.taskStatusFK = TaskStatus.FINISHED;
					model.currentTasks.tDateInprogress = model.currentTime;
					model.currentTasks.tDateEnd = model.currentTime;			
					//model.currentTasks.personFK = model.impPerson.personId;
					model.currentTasks.fileObj = null; 
					eventArr.push(taskupdateevent);
				}
			}
			else if(model.typeName == 'All'){				
				if(model.typeSubAllName == 'AllReader'){				
					model.delayUpdateTxt = "Message Creation";
					trace("createPropertyMessageResult All :"+model.currentTasks.taskStatusFK);
					
					if(model.currentTasks.taskStatusFK!=TaskStatus.FINISHED)
					{
						trace("createPropertyMessageResult All inner :"+model.currentTasks.taskStatusFK);
						var taskupdateevent : TasksEvent = new TasksEvent( TasksEvent.EVENT_UPDATE_TASKS );
						model.currentTasks.nextTask = model.createdTaskMessage;
						model.currentTasks.taskStatusFK = TaskStatus.FINISHED;
						model.currentTasks.tDateInprogress = model.currentTime;
						model.currentTasks.tDateEnd = model.currentTime;			
						//model.currentTasks.personFK = model.impPerson.personId;
						model.currentTasks.fileObj = null; 
						eventArr.push(taskupdateevent);
					}
				}
			}			
			var eventteamlines:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE);							
			eventArr.push(eventteamlines);
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
			
			/* var event:TasksEvent = new TasksEvent( TasksEvent.EVENT_MAILUPDATE_TASKS);
	 		var handlers:IResponder = new Callbacks(result,fault);
	 		var creSeq:SequenceGenerator = new SequenceGenerator([event],handlers)
	  		creSeq.dispatch(); */
	  		
	  		model.expiryState = "delaySendState";
			model.delayUpdateTxt = "New task created";
	  		
			var eventsArr:Array = []
			//var event:TasksEvent = new TasksEvent( TasksEvent.EVENT_MAILUPDATE_TASKS);
			//eventsArr.push(event);
						
			if(tasksEvent.taskevtfiledetailsVo!=null)
			{
				var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_UPLOAD_FILE);
				
				fileEvent.storeByteArray = tasksEvent.taskevtstoreByteArray;	
				fileEvent.filePath = tasksEvent.taskevtfilePath;				
				fileEvent.fileName = tasksEvent.taskevtfileName;
				fileEvent.filedetailsVo = tasksEvent.taskevtfiledetailsVo;
				fileEvent.filedetailsVo.taskId = model.createdTask.taskId;	
				fileEvent.filedetailsVo.projectFK = model.project.projectId;			
				eventsArr.push(fileEvent);	
			}
			//Finihsed task message id send to mail
			/* var eventteamlinesstatus:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_TASK_STATUS);
			eventsArr.push(eventteamlinesstatus);
			//*******************
			var event:TasksEvent = new TasksEvent( TasksEvent.EVENT_MAILUPDATE_TASKS);
			eventsArr.push(event);
			var eventteamlines:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_MAILMESSAGE_TEAMLINE);							
			eventsArr.push(eventteamlines); */
			
	 		var handlers:IResponder = new Callbacks(result,fault);
	 		var creSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handlers)
	  		creSeq.dispatch();
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
			trace("TasksCommand getTaskResult:"+arrc.length);
			//june 08 2010
			model.delayUpdateTxt = "Current Tasks";
			if(arrc!=null)
			{
				if(model.typeName == 'Mail')
				{
					if(arrc.length!=0)
					{
						model.currentTasks = ArrayCollection(rpcEvent.result).getItemAt(0) as Tasks;	
						model.currentProjects = model.currentTasks.projectObject;
						trace(model.currentTasks.projectObject.projectName +"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++MODEL.CURRENTPROJECTS")
						model.finishedTempTaskId = model.currentTasks;	
						
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
			   	 					  			
			  			var eventsArr:Array = [eventp,profileevent,fileEvent]
			   	 		
			 			var handler:IResponder = new Callbacks(result,fault)
			 			var fSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
			  			fSeq.dispatch();
					}
					else
			  		{
			  			model.expiryState = "expireState";
			  		}
				}
				else if(model.typeName == 'Prop')
		  		{
					if(arrc.length!=0)
					{
						model.currentTasks = ArrayCollection(rpcEvent.result).getItemAt(0) as Tasks;	
						trace("TasksCommand Prop model.currentTasks :"+model.currentTasks);
						model.finishedTempTaskId = model.currentTasks;			
						model.currentProjects = model.currentTasks.projectObject;
						model.currentPropertiespjSingle = model.currentTasks.projectObject.propertiespjSet;
						trace("\n TasksCommand Prop model.currentProjects :"+model.currentProjects);
						trace("TasksCommand Prop model.currentProjects :"+model.currentProjects.propertiespjSet);
						
					
						/* trace("\n TasksCommand Prop personDetails :"+model.currentTasks.personDetails.personFirstname);
						trace("\n TasksCommand Prop personDetails :"+model.currentTasks.personFK); */
						
						//model.currentProjects.propertiespjSet = model.currentTasks.projectObject.propertiespjSet;
						
						if(model.currentTasks.personDetails!=null)
							model.currentPersons = model.currentTasks.personDetails;
						
						model.expiryState = "impState";
						
						/* var arrc:ArrayCollection = model.currentProjects.propertiespjSet;
						for each(var item:Propertiespj in arrc){
			   	 			item.projectFk = model.currentProjects.projectId;	 	
			   	 		} */
						
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
			  	else if(model.typeName == 'Reader')
		  		{
		  			trace("TasksCommand Reader :"+model.typeName);

		  			if(arrc.length!=0)
					{
						model.currentTasks = ArrayCollection(rpcEvent.result).getItemAt(0) as Tasks;	
						trace("model.currentTasks :"+model.currentTasks);
						model.currentProjects = model.currentTasks.projectObject;
						trace("model.currentProjects :"+model.currentProjects+" , "+model.currentTasks.previousTask.previousTask);
						
						//this is message PersonFK enter into 						
						model.tempIndPreviousTask = model.currentTasks.previousTask;
						
						/* trace("\n personDetails :"+model.currentTasks.personDetails.personFirstname);
						trace("\n personDetails :"+model.currentTasks.personFK);
						
						if(model.currentTasks.personDetails!=null)
							model.currentPersons = model.currentTasks.personDetails;
						
						trace("\n personDetails :"+model.currentPersons.personFirstname); */

						//model.expiryState = "impState";
						
						//OCt 29th
						//var fileEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_SINGLE_SWFFILE);
						var fileEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SELECT_IND_FILE);
						/* var commentevent : CommentEvent = new CommentEvent(CommentEvent.GET_COMMENT);
						commentevent.fileFk = model.modelFileLocalId;
						commentevent.compareFileFk = 0;
						
						var eventsArr:Array = [fileEvents,commentevent] */
						var eventsArr:Array = [fileEvents]
			   	 		
			 			var handler:IResponder = new Callbacks(result,fault)
			 			var pSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
			  			pSeq.dispatch();
						
					}
					else
			  		{		
			  			model.expiryState = "expireState";
			  		}
		  		}
		  		else if(model.typeName == 'All')
		  		{
					if(arrc.length!=0)
					{
						model.currentTasks = ArrayCollection(rpcEvent.result).getItemAt(0) as Tasks;	
						trace("TasksCommand All model.currentTasks :"+model.currentTasks);
						//model.finishedTempTaskId = model.currentTasks;			
						model.currentProjects = model.currentTasks.projectObject;
						trace("\n TasksCommand All model.currentProjects :"+model.currentProjects.propertiespjSet.length);
						var currentWorkflowFk:Workflowstemplates = GetVOUtil.getWorkflowTemplate(model.currentTasks.wftFK);
						trace("TasksCommand All currentWorkflowFk :"+currentWorkflowFk.profileObject.profileCode+" , "+currentWorkflowFk.taskLabel);
						
						/* if(currentWorkflowFk.taskLabel == "VALIDATION CREA"){	
							trace("TasksCommand All IF PRFREADER calling ");							
							//this is message PersonFK enter into 						
							model.tempIndPreviousTask = model.currentTasks.previousTask;
							model.typeSubAllName = "AllReader";
						}else{ */
							trace("TasksCommand All ELSE IMP calling ");
							model.finishedTempTaskId = model.currentTasks;
							if(model.currentTasks.personDetails!=null)
								model.currentPersons = model.currentTasks.personDetails;							
				   	 		trace("WorkflowstemplatesEvent calling :"+model.currentProjects.workflowFK+ '\n');
				   	 		model.typeSubAllName = "AllProp";			   	 			
				 		//}				 		
				 		//model.expiryState = "AllViewState";				 		
				 		
				 		/***
				 		 * EVENT_SELECT_IMP_FILE  - IMP Files View
				 		 * EVENT_SELECT_IND_FILE  - IND PDFreader View
				 		 **/
				 		var fileIMPEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SELECT_IMP_FILE);
				 		var fileINDEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SELECT_IND_FILE);
						var eventsArr:Array = [fileIMPEvents,fileINDEvents]
				   	 		
			 			var handler:IResponder = new Callbacks(result,fault)
			 			var pSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
			  			pSeq.dispatch();
			  			
			  			model.expiryState = "AllViewState";	
					}
					else
			  		{		
			  			model.expiryState = "expireState";
			  		}
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
			trace("createTasksResult model.createdTask :"+model.createdTask.taskId+" , "+model.createdTask.workflowtemplateFK.nextTaskFk+ '\n'); 
			model.project = Tasks(rpcEvent.message.body).projectObject;	
			checkPhases(model.createdTask);		
			var eventsArr:Array = [ ];
			
			//DTFlex taskid and 'Finished' word to sent
			var eventteamlinesstatus:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_TASK_STATUS);
			var phaseEvent : PhasesEvent = new PhasesEvent(PhasesEvent.EVENT_UPDATE_PHASES);
			var taskupdateevent : TasksEvent = new TasksEvent( TasksEvent.EVENT_UPDATE_TASKS );
			
			trace("phaseEventCollection.length :"+phaseEventCollection.length); 
			if(phaseEventCollection.length > 0){
				eventsArr.push(phaseEvent);
			} 
			
			model.currentTasks.nextTask = model.createdTask;
			model.currentTasks.taskStatusFK = TaskStatus.FINISHED;
			model.currentTasks.tDateInprogress = model.currentTime;
			model.currentTasks.tDateEnd = model.currentTime;
		
			model.currentTasks.personFK = model.impPerson.personId;
			if(model.typeName == 'Prop'){
				model.currentTasks.fileObj = null; 
			}
			//if(model.typeSubAllName == 'AllProp'){
				model.currentTasks.fileObj = null; 
			//}
			eventsArr.push(taskupdateevent,eventteamlinesstatus);				
							
			if(model.attachmentsFiles.length!=0){
				attachmentsStart(model.createdTask);
			}				
	 		var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch();
		}
		private function attachmentsStart(temptasks:Tasks):void
	    {
	    	model.attachmentsNo = 0;
			var fileCollection:ArrayCollection = new ArrayCollection();
			var impDoFileUploadCollection:ArrayCollection= new ArrayCollection();
			model.impFileCollection = new ArrayCollection();
			model.impDoFileUploadCollection = new ArrayCollection();
			for(var i:Number=0;i<model.attachmentsFiles.length;i++)
			{
				var tempFiledetails:Object= model.attachmentsFiles.getItemAt(i);
				
				var pathstr:String = categoryDomainAllocate();	
				var myObject:Object= new Object();
				myObject.browseFileName = tempFiledetails.localFileName;
				myObject.storeByteArray = tempFiledetails.byteDetail;
				myObject.storeServerPath = pathstr;
				impDoFileUploadCollection.addItem(myObject);										
									
				var fileduplicate:FileDetails = new FileDetails();
				fileduplicate.fileId = NaN;					
				fileduplicate.fileName = tempFiledetails.localFileName;
				fileduplicate.filePath = pathstr+tempFiledetails.localFileName;
				fileduplicate.fileDate = model.currentTime;
				fileduplicate.taskId =  temptasks.taskId;	
				fileduplicate.categoryFK = 0;
				fileduplicate.type = "Basic";						
				fileduplicate.storedFileName = tempFiledetails.localFileName;					
				fileduplicate.projectFK = temptasks.projectObject.projectId;					
				fileduplicate.visible = 1;
				fileduplicate.releaseStatus = 0;
				//fileduplicate.miscelleneous = tempFiledetails.miscelleneous;
				//fileduplicate.fileCategory = tempFiledetails.fileCategory;
				fileduplicate.page = 0;
				fileCollection.addItem(fileduplicate);
				
			}
			
    		var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_CREATE_FILEDETAILS);
			model.impFileCollection = fileCollection;
			model.impDoFileUploadCollection = impDoFileUploadCollection;
			fileEvent.dispatch(); 			 
	    	
	    }
		private function categoryDomainAllocate():String
		{
				var returnpath:String = '';
				var currProject:Projects = model.currentTasks.projectObject;
				var localRoot:String = model.parentFolderName; // c:/temp/
				var domain:Categories = getDomains(currProject.categories);
				var domainName:String = domain.categoryName; // UNICOPA
				var domainYear:String = currProject.categories.categoryFK.categoryName; // 2009
				var domainMonth:String = currProject.categories.categoryName; // Jul
				var domainProject:String = currProject.projectName; // JHTOOL
				
				//returnpath = localRoot+domainName+File.separator+domainYear+File.separator+domainMonth+File.separator+domainProject;
				returnpath = localRoot+domainName+"/"+domainYear+"/"+domainMonth+"/"+domainProject+"/"+"Basic/";
				
				return returnpath;
		} 
		 		
		
		public function checkPhases(createdTask : Tasks) : void
		{
			
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
					prevTask.phase.phaseDuration = Math.ceil( ( prevTask.phase.phaseEnd.getTime() - prevTask.phase.phaseStart.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
					var planneddelay : Number = Math.ceil( ( prevTask.phase.phaseEndPlanified.getTime() - prevTask.phase.phaseEnd.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
					planneddelay = 0 -( planneddelay );
					prevTask.phase.phaseDelay = planneddelay;  
					phaseEventCollection.addItem(prevTask.phase);
				}
				var index:int = createdTask.projectObject.phasesSet.getItemIndex( createdTask.phase );
				for( var i:int = index;i < createdTask.projectObject.phasesSet.length;i++ ) {
					if( i == index ) {
						Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart = model.currentTime; 
					}
					else {
						Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart = Phases( createdTask.projectObject.phasesSet.getItemAt( i - 1 ) ).phaseEndPlanified;
					}
					if( !Phases( createdTask.projectObject.phasesSet.getItemAt( 0 ) ).phaseEnd ) 
						Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEndPlanified = model.tracTaskContent.getPlanifiedDate( Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart, Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseDuration );
					else {
						var duration:Number = Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseDuration;
						var delay:Number = Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseDelay;
						var diff:Number = duration - delay;
						if( !Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEnd )
							Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEndPlanified = model.tracTaskContent.getPlanifiedDate( Phases( createdTask.projectObject.phasesSet.getItemAt( i -1 ) ).phaseEndPlanified, diff );
						else
							Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEndPlanified = new Date( Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEnd.getTime() - ( delay * DateUtil.DAY_IN_MILLISECONDS ) );
					}
					phaseEventCollection.addItem( Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ) );
				} 
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
			if(model.typeName == 'Reader'){				
			}
			else if(model.typeName == 'All')
			{
				trace("----TasksCommand--updateTasksResult ---->"+model.typeName+" , "+model.typeSubAllName);

				if(model.typeSubAllName == 'AllProp')
				{
					model.currentTasks = Tasks(rpcEvent.message.body);
					model.currentProfiles = model.currentTasks.workflowtemplateFK.profileObject;
					model.workflowstemplates = model.currentTasks.workflowtemplateFK;
					var eventsArr:Array = [];
					
					model.delayUpdateTxt = "Task update";
					
					var updatepropPjEvent : PropertiespjEvent = new PropertiespjEvent(PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ);
					var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
					//Taskid send to profileid and projectid base (New Task Create)
					var eventteamlines:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE);
					
					trace("----TasksCommand--updateTasksResult ----model.waitingFab---->"+model.waitingFab);
					trace("--TasksCommand--updateTasksResult--"+model.currentTasks.workflowtemplateFK.profileObject.profileCode+ '\n'); 
		
					/* if(model.currentTasks.workflowtemplateFK.profileObject.profileCode == "FAB" || model.currentTasks.workflowtemplateFK.profileObject.profileCode == "EPR")
					{ */
						trace("--TasksCommand--updateTasksResult--else if----");				
						/* var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
						for each(var items : Propertiespj in arrc)
						{
							items.projectDetails = model.currentTasks.projectObject;
						}
						model.propertiespjCollection = arrc;  */
						var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
						trace("\n TasksCommand--Tasks PROPERTY LENGTH :"+arrc.length);
						for each(var items : Propertiespj in arrc)
						{
							items.projectFk = model.currentTasks.projectObject.projectId;
						}
						trace("\n TasksCommand-- :"+model.propertiespjCollection.length)
						model.propertiespjCollection = arrc;
						trace("--TasksCommand--updateTasksResult--else if----"+model.propertiespjCollection.length);
						trace("\n TasksCommand--Tasks Inprogress \n");	
						
						var _eventss:Events = new Events();
						_eventss.eventDateStart = model.currentTime;
						_eventss.eventType = EventStatus.TASKINPROGRESS; //Task create
						_eventss.personFk = model.person.personId;
						_eventss.taskFk = (model.currentTasks!=null)?model.currentTasks.taskId:0;
						_eventss.workflowtemplatesFk = (model.currentTasks!=null)?model.currentTasks.wftFK:0;
						_eventss.projectFk = model.currentTasks.projectObject.projectId;
						//_eventss.details = "Tasks Inprogress";
						var by:ByteArray = new ByteArray();
						var str:String = "Tasks Inprogress";
						by.writeUTFBytes(str);
						_eventss.details = by;
						_eventss.eventName = "Task";			
						eEvent.events = _eventss;				
						
						eventsArr.push(updatepropPjEvent,eventteamlines,eEvent);
					//}
					var handler:IResponder = new Callbacks(result,fault)
			 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
			  		newProjectSeq.dispatch();
			 	}	
			 /* 	else if(model.typeSubAllName == 'AllReader')
			 	{
			 		model.currentTasks = Tasks(rpcEvent.message.body);
					model.currentProfiles = model.currentTasks.workflowtemplateFK.profileObject;
					model.workflowstemplates = model.currentTasks.workflowtemplateFK;
					var eventsArr:Array = [];
					
					model.delayUpdateTxt = "Task update";
					
					var updatepropPjEvent : PropertiespjEvent = new PropertiespjEvent(PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ);
					var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
					
					trace("--TasksCommand--updateTasksResult--AllReader :"+model.currentTasks.workflowtemplateFK.profileObject.profileCode+ '\n'); 
		
						trace("--TasksCommand--updateTasksResult--else if--AllReader--");				
					
						var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
						trace("\n TasksCommand--Tasks PROPERTY LENGTH AllReader:"+arrc.length);
						for each(var items : Propertiespj in arrc)
						{
							items.projectFk = model.currentTasks.projectObject.projectId;
						}
						trace("\n TasksCommand-AllReader- :"+model.propertiespjCollection.length)
						model.propertiespjCollection = arrc;
						trace("--TasksCommand--updateTasksResult--else if-AllReader---"+model.propertiespjCollection.length);
						
						var _eventss:Events = new Events();
						_eventss.eventDateStart = model.currentTime;
						_eventss.eventType = EventStatus.TASKINPROGRESS; //Task create
						_eventss.personFk = model.person.personId;
						_eventss.taskFk = (model.currentTasks!=null)?model.currentTasks.taskId:0;
						_eventss.workflowtemplatesFk = (model.currentTasks!=null)?model.currentTasks.wftFK:0;
						_eventss.projectFk = model.currentTasks.projectObject.projectId;
						//_eventss.details = "Tasks Inprogress";
						var by:ByteArray = new ByteArray();
						var str:String = "Tasks Inprogress";
						by.writeUTFBytes(str);
						_eventss.details = by;
						_eventss.eventName = "Task";			
						eEvent.events = _eventss;				
						
						eventsArr.push(updatepropPjEvent,eEvent);
					//}
					var handler:IResponder = new Callbacks(result,fault)
			 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
			  		newProjectSeq.dispatch();
			 	}	 */	 	
			}
			else
			{
				model.currentTasks = Tasks(rpcEvent.message.body);
				model.currentProfiles = model.currentTasks.workflowtemplateFK.profileObject;
				model.workflowstemplates = model.currentTasks.workflowtemplateFK;
				var eventsArr:Array = [];
				
				model.delayUpdateTxt = "Task update";
				
				var updatepropPjEvent : PropertiespjEvent = new PropertiespjEvent(PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ);
				var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
				var eventteamlines:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE);
					
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
			
					eventsArr.push(updateProjectEvent);
					
				}
				else */
				if(model.currentTasks.workflowtemplateFK.profileObject.profileCode == "FAB" || model.currentTasks.workflowtemplateFK.profileObject.profileCode == "EPR")
				{
					trace("--TasksCommand--updateTasksResult--else if----");				
					/* var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
					for each(var items : Propertiespj in arrc)
					{
						items.projectDetails = model.currentTasks.projectObject;
					}
					model.propertiespjCollection = arrc;  */
					var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
					trace("\n TasksCommand--Tasks PROPERTY LENGTH :"+arrc.length);
					for each(var items : Propertiespj in arrc)
					{
						items.projectFk = model.currentTasks.projectObject.projectId;
					}
					trace("\n TasksCommand-- :"+model.propertiespjCollection.length)
					model.propertiespjCollection = arrc;
					trace("--TasksCommand--updateTasksResult--else if----"+model.propertiespjCollection.length);
					model.mainClass.status("--TasksCommand--updateTasksResult--else if----EVENT_UPDATE_PROPERTIESPJ :"+model.propertiespjCollection.length+ '\n'); 
					trace("\n TasksCommand--Tasks Inprogress \n");	
					
					var _eventss:Events = new Events();
					_eventss.eventDateStart = model.currentTime;
					_eventss.eventType = EventStatus.TASKINPROGRESS; //Task create
					_eventss.personFk = model.person.personId;
					_eventss.taskFk = (model.currentTasks!=null)?model.currentTasks.taskId:0;
					_eventss.workflowtemplatesFk = (model.currentTasks!=null)?model.currentTasks.wftFK:0;
					_eventss.projectFk = model.currentTasks.projectObject.projectId;
					//_eventss.details = "Tasks Inprogress";
					var by:ByteArray = new ByteArray();
					var str:String = "Tasks Inprogress";
					by.writeUTFBytes(str);
					_eventss.details = by;
					_eventss.eventName = "Task";			
					eEvent.events = _eventss;				
					
					eventsArr.push(updatepropPjEvent,eventteamlines,eEvent);
		
					
				}
				var handler:IResponder = new Callbacks(result,fault)
		 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
		  		newProjectSeq.dispatch();
		 	}
		}
	}
}
