package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.DateUtils;
	import com.adams.dt.business.util.FileNameSplitter;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.LoginUtils;
	import com.adams.dt.business.util.NavigationUtils;
	import com.adams.dt.business.util.StringUtils;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.PhasesEvent;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.event.PropertiespjEvent;
	import com.adams.dt.event.SMTPEmailEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	import com.adams.dt.model.vo.FileCategory;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Presetstemplates;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.SMTPEmailVO;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adams.dt.view.components.MailConfirmationAlert;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.managers.PopUpManager;
	import mx.rpc.IResponder;
	public final class TasksCommand extends AbstractCommand 
	{ 
		private var tasksEvent : TasksEvent;		
		private var createdTask : Tasks;
		private const WAITING : String = "waiting";
		private const INPROGRESS : String = "in_progress";
		private var filePath:FileDetails;
		private var swfConversion:Boolean=false;				
		private var phaseEventCollection : ArrayCollection = new ArrayCollection();
		private var dtLiteMsgTsks:Array = [];
		
		override public function execute( event:CairngormEvent ):void {	 
			
			super.execute( event );
			tasksEvent = event as TasksEvent;
			delegate = DelegateLocator.getInstance().taskDelegate;
			delegate.responder = new Callbacks( result, fault ); 
		    
		    switch( event.type ) {    
		       case TasksEvent.EVENT_GET_ALL_TASKSS:
		            delegate.findAll();
		       break; 
		       case TasksEvent.EVENT_GET_TASKS:
		            delegate.responder = new Callbacks( getTasksResult, fault );
		            delegate.findById( model.person.personId );
		       break;
		       case TasksEvent.EVENT_DELETEALL_TASKS:
		            delegate.responder = new Callbacks( result, fault );
		            delegate.deleteAll();
		       break; 
		       case TasksEvent.CREATE_AUTO_TASKS:
		            delegate.responder = new Callbacks( taskCreateResult, fault );
		            delegate.create( tasksEvent.tasks );
		       break;
		       case TasksEvent.UPDATE_AUTO_TASKS:
		            delegate.directUpdate( tasksEvent.tasks );
		       break;
			   case TasksEvent.EVENT_GET_TASK:
		       	    if( model.updateFileToTask ) {
		       	    	delegate.responder = new Callbacks( getTaskResult, fault );
		       	    	delegate.findByTaskId( model.updateFileToTask.taskId );
					}
					else {
						var filedetailsBasicEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_GET_BASICFILEDETAILS );
						var handler:IResponder = new Callbacks( result, fault );
				 		var eventSeq:SequenceGenerator = new SequenceGenerator( [ filedetailsBasicEvent ], handler );
				  		eventSeq.dispatch();
					} 
		       break; 
		       case TasksEvent.EVENT_GET_SPECIFIC_TASK:
		      	    delegate.responder = new Callbacks( getSpecificTasksResult, fault );
		       		delegate.findByTaskId( tasksEvent.taskeventtaskId );
		       break;		      
		       case TasksEvent.EVENT_CREATE_TASKS:
		            delegate.responder = new Callbacks( createTasksResult, fault );
		            createdTask = Tasks( tasksEvent.tasks );
		            model.currentProjects.wftFK = createdTask.wftFK;
		            model.currentProjects.finalTask = createdTask; 
		            model.currentProjects.currentTaskDateStart = createdTask.tDateCreation;
		            model.createdTask = Tasks( tasksEvent.tasks );
		            delegate.create( createdTask );
		       break; 
		       case TasksEvent.EVENT_UPDATE_TASKS:
		            delegate.responder = new Callbacks(updateTasksResult,fault);
		            swfConversion = model.currentTasks.swfConversion;
		            if( model.waitingFab )	updateCurrentProject( model.currentTasks );
		            delegate.directUpdate(model.currentTasks);
		       break; 
		       case TasksEvent.EVENT_UPDATE_CLOSETASKS:
		            delegate.responder = new Callbacks( updateCloseTasksResult, fault );		        
		            delegate.directUpdate( model.currentTasks );
		       break;  
		       case TasksEvent.EVENT_UPDATE_TASKFILEPATH:
		            delegate.responder = new Callbacks( updateTasksFilePathResult, fault );
		            delegate.directUpdate( model.updateFileToTask );
		       break;
		       case TasksEvent.EVENT_DELETE_TASKS:
		            delegate.deleteVO( Tasks( tasksEvent.tasks ) );
		       break;  
		       case TasksEvent.EVENT_SELECT_TASKS:
		            delegate.select( Tasks( tasksEvent.tasks ) );
		       break;  
		       case TasksEvent.EVENT_FETCH_TASKS:
		            delegate.responder = new Callbacks( fetchTasksResult, fault );
		            delegate.findTasksList( model.currentProjects.projectId );
		       break;
		       case TasksEvent.CREATE_DTLITE_MSG:		        
		            delegate.responder = new Callbacks( createDTLiteMsgTskResult, fault );
		             if( tasksEvent.tasksCollection.length > 0 ) { 
		            	delegate.create( Tasks( tasksEvent.tasksCollection.getItemAt( 0 ) ) );
		            }
		       break;   
		       case TasksEvent.CREATE_MSG_TASKS:		        
		            delegate.responder = new Callbacks( createMessageTasksResult, fault );
		            if( tasksEvent.tasksCollection.length > 0 ) { 
		            	delegate.create( Tasks( tasksEvent.tasksCollection.getItemAt( 0 ) ) );
		            }	
		       break; 
		       case TasksEvent.CREATE_NWEMSG_TASKS:
		            delegate.responder = new Callbacks(createNewMessageTasksResult,fault);
		            if( tasksEvent.tasksCollection.length > 0 ) { 
		            	delegate.create( Tasks( tasksEvent.tasksCollection.getItemAt( 0 ) ) );
		            }	
		       break; 
		       case TasksEvent.CREATE_PROPERTYMSG_TASKS:
		            delegate.responder = new Callbacks( createPropertyMessageResult, fault );
		            delegate.create( Tasks( tasksEvent.tasks ) );
		       break;  
		       case TasksEvent.CREATE_MSG_TO_OPE_TASKS:
		            delegate.responder = new Callbacks( createMessageToOpeResult, fault );
		            delegate.create( Tasks( tasksEvent.tasks ) );
		       break; 
		       case TasksEvent.EVENT_UPDATE_MSG_TASKS:
		            delegate.responder = new Callbacks( updateMessageTasksResult, fault );
		            delegate.directUpdate( Tasks( tasksEvent.tasks ) );
		       break;  
		       case TasksEvent.CREATE_BULK_TASKS:
		            delegate.responder = new Callbacks( createBulkTasksResult, fault );
		            delegate.create( model.currentTasks );
		       break;
		       case TasksEvent.CREATE_INITIAL_TASKS:
		            model.projectsCollection.addItem( model.currentProjects );
		            model.currentProjects.wftFK = model.currentTasks.wftFK;
		            model.currentProjects.finalTask = model.currentTasks;
		            model.currentProjects.currentTaskDateStart = model.currentTasks.tDateCreation;
		            delegate.responder = new Callbacks( createInitialTasksResult, fault );
		            delegate.create( model.currentTasks );
		       break;
		       case TasksEvent.CREATE_AUTO_INITIAL_TASKS:
		        	model.projectsCollection.addItem( model.currentProjects );
		        	model.currentProjects.wftFK = model.currentTasks.wftFK;
		        	model.currentProjects.finalTask = model.currentTasks;
		            model.currentProjects.currentTaskDateStart = model.currentTasks.tDateCreation;
		            delegate.responder = new Callbacks( taskCreateResult, fault );
		            delegate.create( model.currentTasks );
		        break;
				case TasksEvent.CREATE_MAX_TASKSID:
					delegate.responder = new Callbacks( getMaxTaskResult, fault );
					delegate.findMaxTaskId( model.person.personId );
		        break;
		        case TasksEvent.EVENT_BULKUPDATE_CLOSETASKS:
					delegate.responder = new Callbacks( bulkCloseTaskResult, fault );
					delegate.create( model.closeTaskCollection.getItemAt( 0 )as Tasks );
		        break;
				case TasksEvent.EVENT_BULKUPDATE_DELAYEDTASKS:
					delegate.responder = new Callbacks( bulkDelayedTasksResult,fault );
					delegate.directUpdate( model.modelDelayTaskArrColl.getItemAt( 0 ) as Tasks );
		        break;
		        case TasksEvent.CREATE_STANDBY_TASKS:
					delegate.responder = new Callbacks( standByTasksResult,fault );
					delegate.update( tasksEvent.tasks );
		        break;
		        case TasksEvent.UPDATE_LAST_TASKS:
					delegate.responder = new Callbacks( updateLastTasksResult, fault );
					updateCurrentProject( model.lastTask );
					delegate.directUpdate( model.lastTask );
		        break;
		        case TasksEvent.EVENT_BULKUPDATE_TASKSSTATUS:
					delegate.responder = new Callbacks( bulkUpdateTasksResult, fault );
					if( model.unfinishedTasks.length > 0 ) {
						var item:Tasks = model.unfinishedTasks.getItemAt( 0 )as Tasks;
						item.taskStatusFK= TaskStatus.FINISHED;
						item.tDateEnd = model.currentTime;
						updateCurrentProject( item );
						delegate.directUpdate( item );
					}
		        break;
		        case TasksEvent.EVENT_BULKUPDATE_CLOSEPROJECTTASKS:
					delegate.responder = new Callbacks( bulkCloseProjectTaskResult, fault );
					delegate.create( model.closeTaskCollection.getItemAt( 0 ) as Tasks );
		        break;		      
		        case TasksEvent.CREATE_IMP_IND_MSG_TASKS:
					delegate.responder = new Callbacks( commonWorkFlowBulkMsgResult, fault );
		        	if( tasksEvent.bulkMsgTaskPersonCollection.length > 0 )  {
		        		delegate.create( Tasks( tasksEvent.bulkMsgTaskPersonCollection.getItemAt( 0 ) ) );
		        	}
		        break;
				case TasksEvent.GET_SPRINT_TASKS:
					delegate.responder = new Callbacks( getSprintTasks, fault );
					delegate.findByDate( model.currentTime );
		        break;
		        case TasksEvent.EVENT_UPDATE_PDFREAD_ARCHIVE:
		        	delegate.responder = new Callbacks( updateIndPDFTasksResult, fault );
		        	delegate.directUpdate( Tasks( tasksEvent.tasks ) );
		        break; 
		        case TasksEvent.EVENT_TODO_LASTTASKSCOMMENTS:
			        delegate.responder = new Callbacks(todoLastTasksResult,fault);
			        delegate.findTasksList( tasksEvent.lastTaskProjectId  );
		        break; 
		        case TasksEvent.CREATE_COMMON_PROFILE_MSGTASKS:
					delegate.responder = new Callbacks( commonProfileTaskResult, fault );
		        	if( tasksEvent.bulkMsgTaskPersonCollection.length > 0 ) {
		        		delegate.create( Tasks( tasksEvent.bulkMsgTaskPersonCollection.getItemAt( 0 ) ) );
		        	}
		        break;
		        case TasksEvent.EVENT_CREATE_BULKEMAILTASKS:
			        onCreateBulkEmailTasks();
		        break; 
				case TasksEvent.EVENT_ORACLE_NAV_CREATETASKS:
					this.delegate = DelegateLocator.getInstance().pagingDelegate;					
					this.delegate.responder = new Callbacks(createOracleNavTaskResult,fault);	
					createdTask = Tasks( tasksEvent.tasks );
		            model.currentProjects.wftFK = createdTask.wftFK;
		            model.currentProjects.finalTask = createdTask; 
		            model.currentProjects.currentTaskDateStart = createdTask.tDateCreation;
		            model.createdTask = Tasks( tasksEvent.tasks );
		            //Original
					//this.delegate.createNavigationTasks(createdTask.previousTask.taskId,model.currentTasks.projectObject.workflowFK,createdTask.workflowtemplateFK.workflowTemplateId,createdTask.projectFk,model.person.personId,createdTask.workflowtemplateFK.taskCode,model.currentTaskComment.toString());
					this.delegate.createNavigationTasks(createdTask.previousTask.taskId,model.currentTasks.projectObject.workflowFK,createdTask.workflowtemplateFK.workflowTemplateId,createdTask.projectFk,tasksEvent.personFk,createdTask.workflowtemplateFK.taskCode,model.currentTaskComment.toString());
				break;
				case TasksEvent.EVENT_STATUSCHANGE_TASK:
				 	this.delegate = DelegateLocator.getInstance().pagingDelegate;					
					this.delegate.responder = new Callbacks(createStatusChangeTaskResult,fault);	
					this.delegate.projectStatusChangeTask( tasksEvent.projectId,tasksEvent.workflowFk,tasksEvent.projectStatus, tasksEvent.taskMessage,tasksEvent.personFk );
				break;	
				default:
		        break; 
		    }
		}
		
		private function createStatusChangeTaskResult( rpcEvent :Object ) :void {
			var updateTaskCollColl : ArrayCollection = rpcEvent.result as ArrayCollection;
			model.workflowState = 0;
			if(updateTaskCollColl){		
				var loginUtils:LoginUtils  = new LoginUtils();		
				var updatetasksList:ArrayCollection = updateTaskCollColl.getItemAt(0) as ArrayCollection;
				model.finishedTasks = updatetasksList.getItemAt( 0 ) as Tasks;
				var taskscreateList:ArrayCollection = updateTaskCollColl.getItemAt(1) as ArrayCollection;
				model.createdTask = taskscreateList.getItemAt( 0 ) as Tasks;
				
				var msgtasksList:ArrayCollection = updateTaskCollColl.getItemAt(2) as ArrayCollection;	
				loginUtils.createNewMessageTasksResult(msgtasksList);
			}
			super.result(rpcEvent);
		}		
		private function createOracleNavTaskResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			var resultArrColl : ArrayCollection = new ArrayCollection();
			resultArrColl  = rpcEvent.result as ArrayCollection;
			var navUtils:NavigationUtils  = new NavigationUtils();			
			if(resultArrColl){
				var tasksList:ArrayCollection = resultArrColl.getItemAt(0) as ArrayCollection;
				
				navUtils.getNavigationResult( tasksList );
			} 
		}		
		private function getSpecificTasksResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
		}
		 	
		private  function commonProfileTaskResult( rpcEvent:Object ):void {	
			super.result(rpcEvent);	
			model.createdTaskIND = Tasks( rpcEvent.message.body );
			var tempArrayCollection : ArrayCollection = tasksEvent.bulkMsgTaskPersonCollection; 
			var person:Persons = model.createdTaskIND.personDetails;	
			commonProfileSendMail( model.createdTaskIND, person );
			
			for each( var item:FileDetails in model.currentProjectFiles ) {
				item.taskId  =  model.currentTasks.taskId;
				var filename:String = item.fileName; 
				var splitObject:Object = FileNameSplitter.splitFileName( item.fileName );
					
				if( item.taskId != 0 ) {
					filename = splitObject.filename + item.taskId;
	   			}
	   			if( !item.type ) {
	   				item.type = "Basic";
	   			}
	   			if( item.type=="Tasks" && splitObject.extension == "pdf" ) {
	   				model.pdfConversion = true;
	   			}
	   			
	   			item.storedFileName = filename + DateUtil.getFileIdGenerator() + "." + splitObject.extension;
				item.projectFK = model.currentProjects.projectId;
				item.downloadPath = onUpload( item );
				model.filesToUpload.addItem( item );
			}
			
			if( model.filesToUpload.length>0 ) {
				model.bgUploadFile.idle = true;
				model.bgUploadFile.fileToUpload = model.filesToUpload;
			} 
			tasksEvent.bulkMsgTaskPersonCollection.removeItemAt( 0 );						
		} 
		
		private function commonProfileSendMail( newlyCreatedTask:Tasks, selectPerson:Persons ):void {			
			var message:String ="Messieurs,<div><div><br></div><div>Nous sommes en charge de la photogravure de la reference citee en objet.</div><div>Merci de bien vouloir consulter et valider le fichier de creation en cliquant le lien suivant :</div><div><br></div><div><a href=";
			var postmessage:String  = "</div><div><br></div><div>Nous realiserons les photogravures sur reception de votre validation en ligne.</div><div>Merci de votre collaboration.</div><div><br></div></div>";
			
			var indemailuser:String = StringUtils.replace(escape(model.encryptor.encrypt(selectPerson.personLogin)),'+','%2B');
			var indemailpwd:String = StringUtils.replace(escape(model.encryptor.encrypt(selectPerson.personPassword)),'+','%2B');
							
			var urllinkInd:String = model.serverLocation+"ExternalMail/flexexternalmail.html?type=All%23ampuser="+indemailuser+"%23amppass="+indemailpwd+"%23amptaskId="+newlyCreatedTask.taskId+"%23ampprojId="+newlyCreatedTask.projectObject.projectId
			var urlTextInd:String = message+model.serverLocation+"ExternalMail/flexexternalmail.html?type=All%23ampuser="+indemailuser+"%23amppass="+indemailpwd+"%23amptaskId="+newlyCreatedTask.taskId+"%23ampprojId="+newlyCreatedTask.projectObject.projectId+'>Link -&gt;</a>'+urllinkInd+postmessage;
			openIndLink=urllinkInd;
			
			var eEvent:SMTPEmailEvent = new SMTPEmailEvent( SMTPEmailEvent.EVENT_CREATE_SMTPEMAIL );
			var _smtpvo:SMTPEmailVO = new SMTPEmailVO();
			_smtpvo.msgTo = selectPerson.personEmail;
			_smtpvo.msgSubject = newlyCreatedTask.projectObject.projectName;   
			_smtpvo.msgBody = urlTextInd;
			eEvent.smtpvo = _smtpvo;
			eEvent.dispatch();
			
			commonProfileAlerts(selectPerson, model.commonProfileValidation);           
			EventsUpdateINDUse( urllinkInd, newlyCreatedTask,selectPerson );			
		}
		
		private function commonProfileAlerts(selectPerson:Persons,slectProfileCode:String):void{
			var mailSentProvider:ArrayCollection = new ArrayCollection();
			if(selectPerson.personId!=0){
				var personId:Persons = GetVOUtil.getPersonObject(selectPerson.personId);
				var profileCode:String = slectProfileCode;
				var personeEmail:String = personId.personEmail;
				var obj:Object = { 'formLab':profileCode,'contentLab':personeEmail};					
				mailSentProvider.addItem(obj);	
			}        	
        	//All users (IMP with IND,CP,CPP,COM,AGE) Forward        	
        	var mailConfirmAlert:MailConfirmationAlert = new MailConfirmationAlert();
        	mailConfirmAlert.confirmationProvider = mailSentProvider;
        	PopUpManager.addPopUp( mailConfirmAlert,model.mainClass,true);
			PopUpManager.centerPopUp( mailConfirmAlert);        	
		}		
		
		private function todoLastTasksResult( rpcEvent:Object ):void {	 
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			//unwanted AC
			//model.todoLastTaskCollection = arrc;				
			super.result( rpcEvent );
		}
		
		private var newDate:Date; 
		public function taskCreateResult( rpcEvent:Object ):void {
			var currentTask:Tasks = rpcEvent.result as Tasks
			var createLoopTaskSignal:TasksEvent = new TasksEvent( TasksEvent.CREATE_AUTO_TASKS );
			var createUpdateTaskSignal:TasksEvent = new TasksEvent(TasksEvent.UPDATE_AUTO_TASKS);
			newDate = DateUtils.dateAdd(currentTask.tDateCreation, GetVOUtil.getPhaseTemplateObject(currentTask.workflowtemplateFK.phaseTemplateFK).phaseDurationDays);
			checkPhases( currentTask );
			var eventsArr:Array = [] 
			var phaseEvent : PhasesEvent = new PhasesEvent(PhasesEvent.EVENT_AUTO_UPDATE_PHASES)
			if(phaseEventCollection.length > 0)
			{
				eventsArr.push(phaseEvent);
			}
			if(currentTask.workflowtemplateFK.nextTaskFk && currentTask.workflowtemplateFK.taskCode!=model.AutoProjCode){
				createLoopTaskSignal.tasks = createTask(currentTask,currentTask.projectObject,currentTask.workflowtemplateFK.nextTaskFk, newDate);
				currentTask.taskStatusFK = TaskStatus.FINISHED;
				currentTask.tDateEnd = newDate;
				createUpdateTaskSignal.tasks = currentTask;
				eventsArr.push(createUpdateTaskSignal)
				eventsArr.push(createLoopTaskSignal)
				var taskSeq:SequenceGenerator = new SequenceGenerator(eventsArr)
	  			taskSeq.dispatch();
			}
			else { 
				//var prj:Projects = createProject( "IB" + int( 1000 + model.prjCount ) + "_Project Name" + model.prjCount, currentTask.projectObject.workflowFK, currentTask.projectObject.categories );
				var prj:Projects = createProject( model.projectprefix + int( 1000 + model.prjCount ) + "_Project Name" + model.prjCount, currentTask.projectObject.workflowFK, currentTask.projectObject.categories );
				var createProjectSignal:ProjectsEvent = new ProjectsEvent(ProjectsEvent.CREATE_AUTO_PROJECTS);
				createProjectSignal.projects = prj;
			    ( model.prjCount !=0 ) ? createProjectSignal.dispatch() : model.preloaderVisibility = false;
   				model.prjCount--;	
			}
		} 
		public function createTask(prvTsk:Tasks, prj:Projects, wft:Workflowstemplates, date:Date=null):Tasks{
			var tasks:Tasks = new Tasks();
			tasks.workflowtemplateFK = wft;
			tasks.projectObject = prj;
			tasks.previousTask = prvTsk;
			tasks.taskStatusFK = TaskStatus.WAITING;
			if(!date) date= new Date();
			tasks.tDateCreation = date;
			tasks.tDateEndEstimated = DateUtils.dateAdd(newDate,1); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;
		    return tasks;
		}
		public function createProject(name:String, wrkflw:int, cat:Categories, date:Date=null):Projects{
			var prj:Projects = new Projects();
			prj.projectName = name;
			prj.categories = cat;
			prj.workflowFK = wrkflw;
			if(!date) date= new Date();
			prj.projectStatusFK = ProjectStatus.WAITING;
			prj.projectQuantity = 1;
			prj.projectDateStart = date;
			prj.presetTemplateFK = model.presetTempCollection.getItemAt( 0 ) as Presetstemplates;
			return prj;
		}
        private function updateIndPDFTasksResult(rpcEvent : Object):void{
        	super.result(rpcEvent);
        }
		
		private function updateCurrentProject( task:Tasks ):void {
			model.currentProjects.taskDateEnd = model.currentTime;
			model.currentProjects.taskDateStart = task.tDateCreation;
		} 
        
		private function updateLastTasksResult( rpcEvent:Object ):void {
			
			super.result( rpcEvent );
			
			model.finishedTasks = Tasks( rpcEvent.message.body );	
			
			var eventteamlines:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE );
			
			var eventFinishTask:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_FINISHED_TASK_TEAMLINE );
			eventFinishTask.projectId = model.currentProjects.projectId;
			eventFinishTask.finishTask = model.finishedTasks;
			
			var handler:IResponder = new Callbacks( result, fault );
 			var uploadSeq:SequenceGenerator = new SequenceGenerator( [ eventteamlines, eventFinishTask ], handler );
  			uploadSeq.dispatch();
		}
		
		private function standByTasksResult( rpcEvent:Object ):void {			
			model.createdTask = Tasks( rpcEvent.message.body );		
			model.lastTask.nextTask = model.createdTask;
	  		super.result( rpcEvent );
		}
		 
		private function createNewMessageTasksResult( rpcEvent:Object ):void {
			model.createdTask = Tasks( rpcEvent.message.body );
			model.messageBulkMailCollection.addItem( model.createdTask );
			tasksEvent.tasksCollection.removeItemAt( 0 );
			
			if( tasksEvent.tasksCollection.length > 0 ) {
				delegate.responder = new Callbacks( createNewMessageTasksResult, fault );
		        delegate.create( Tasks( tasksEvent.tasksCollection.getItemAt( 0 ) ) );
			}
			else {
				var phandle:IResponder = new Callbacks( result, fault );
				var teamPush:TasksEvent = new TasksEvent( TasksEvent.EVENT_MAILPUSH, phandle ); 
		  		teamPush.totalMailCollection = model.messageBulkMailCollection;
		  		teamPush.dispatch(); 
			}
			
			super.result( rpcEvent );
		}
		
		private function createPropertyMessageResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
			model.createdTask = Tasks( rpcEvent.result );
			var handler:IResponder = new Callbacks( result, fault );
			var eventteamlines:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE, handler );				
			eventteamlines.dispatch();
		}
		
		private function createMessageToOpeResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
			model.createdTask = Tasks( rpcEvent.result );
			var handler:IResponder = new Callbacks( result, fault );
			var eventtask:TasksEvent = new TasksEvent( TasksEvent.EVENT_PUSH_OPERATOR_MSG, handler );		
			eventtask.msgToOperatorId = Utils.getProfilePerson( 'OPE' ).personId.toString();
			eventtask.dispatch();
		}
		
		private function bulkCloseProjectTaskResult( rpcEvent:Object ):void {
			var closeTask:Tasks = Tasks( rpcEvent.result );
			model.modelCloseTaskArrColl.addItem( closeTask );
			model.closeTaskCollection.removeItemAt( 0 );
			
			if( model.closeTaskCollection.length > 0 ) {
				var updateBulkCloseTask:TasksEvent = new TasksEvent( TasksEvent.EVENT_BULKUPDATE_CLOSEPROJECTTASKS );
				updateBulkCloseTask.dispatch();
			}
			else {
				model.workflowState = 0;
				var eventproducer:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PROJECT_ABORTED_TEAMLINE );
				eventproducer.projectId = model.currentProjects.projectId;
				eventproducer.dispatch();
			}
			super.result( rpcEvent );
		}
		
		private function bulkUpdateTasksResult( rpcEvent:Object ):void {
			model.unfinishedTasks.removeItemAt( 0 );
			if( model.unfinishedTasks.length > 0 ) {
				var updateBulkTask:TasksEvent = new TasksEvent( TasksEvent.EVENT_BULKUPDATE_TASKSSTATUS );
				updateBulkTask.dispatch();
			}
			else {
				var updateClosetask:TasksEvent = new TasksEvent( TasksEvent.EVENT_BULKUPDATE_CLOSEPROJECTTASKS );
				updateClosetask.dispatch();
			}
		}
		
		public function bulkDelayedTasksResult( rpcEvent : Object ): void {
			if( rpcEvent != null ) {
				model.pushDelayedMsg.addItem(  Tasks(rpcEvent.result) );
			}
			model.modelDelayTaskArrColl.removeItemAt(0);
			if(model.modelDelayTaskArrColl.length>0){
				var updateBulkDelayTask:TasksEvent = new TasksEvent(TasksEvent.EVENT_BULKUPDATE_DELAYEDTASKS);
				updateBulkDelayTask.dispatch()
			}else{
				var taskDelay:TasksEvent =new TasksEvent( TasksEvent.EVENT_DELAY_PROJECT ); 
		  		taskDelay.dispatch();
		 	}
	    }
		public function bulkCloseTaskResult(rpcEvent : Object ): void {
			var CloseTask:Tasks = Tasks(rpcEvent.result);
			model.modelCloseTaskArrColl.addItem(CloseTask);			
			model.closeTaskCollection.removeItemAt(0);
			if(model.closeTaskCollection.length>0){
				var updateBulkCloseTask:TasksEvent = new TasksEvent(TasksEvent.EVENT_BULKUPDATE_CLOSETASKS);
				updateBulkCloseTask.dispatch()
			} else {
				var propertyPjEvent:PropertiespjEvent = new PropertiespjEvent(PropertiespjEvent.EVENT_BULKUPDATE_DEPORTPROPERTIESPJ)
				var eventsArr:Array = [propertyPjEvent]  
		 		var handler:IResponder = new Callbacks(result,fault);
		 		var taskSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
		  		taskSeq.dispatch();
			}
			super.result(rpcEvent);			
		}
		public function updateCloseTasksResult(rpcEvent : Object ): void {
			super.result(rpcEvent);
			model.currentTasks = Tasks(rpcEvent.message.body);
			for each(var items : Propertiespj in model.propertiespjCollection)
			{
				items.projectFk = model.currentTasks.projectObject.projectId;
			}
		}
		
		private function onUpload( fileObj:Object ):String {
        	var uploadfile:File = new File( fileObj.downloadPath );
        	var fullPath:String = "DTFlex" + File.separator + String( fileObj.destinationpath + File.separator + fileObj.type ).split( model.parentFolderName )[ 1 ] + "/" + fileObj.storedFileName;
        	var copyToLocation:File = File.userDirectory.resolvePath( fullPath ); 
        	if( uploadfile.exists && !copyToLocation.exists ) {
        		uploadfile.copyTo( copyToLocation, true ); 
        	}	
        	return copyToLocation.nativePath;
  	 	} 
  	 	
		private function createInitialTasksResult( rpcEvent:Object ):void {	 
			model.createdTask = Tasks( rpcEvent.message.body );
			
			for each( var item:FileDetails in model.currentProjectFiles ) {
				item.projectFK = model.currentProjects.projectId;
				item.taskId = model.createdTask.taskId;
				
				var filename:String = item.fileName; 
				var splitObject:Object = FileNameSplitter.splitFileName( item.fileName );
				
				if( item.taskId != 0 ) {
					filename = splitObject.filename + item.taskId;
	   			}
	   			
				item.storedFileName = filename + DateUtil.getFileIdGenerator() + "." + splitObject.extension;
				item.downloadPath = onUpload( item );
				model.filesToUpload.addItem( item );
			}
			
			for each( var refItem:FileDetails in model.refFilesDetails ) {
				refItem.fileId = new FileDetails().fileId;
				refItem.projectFK = model.currentProjects.projectId;
				refItem.taskId = model.createdTask.taskId;
				refItem.fileCategory = FileCategory.REFERENCE;
			}
			
			model.bgUploadFile.idle = true;
			model.bgUploadFile.fileToUpload = model.filesToUpload;			
			
			var tasks : Tasks = new Tasks();
			tasks.workflowtemplateFK = model.workflowstemplates.nextTaskFk;
			tasks.projectObject = model.currentProjects;
			tasks.previousTask = model.createdTask;
			tasks.taskStatusFK = TaskStatus.WAITING;
			tasks.tDateCreation = model.currentTime;
			tasks.tDateEndEstimated = Utils.getCalculatedDate(model.currentTime,tasks.workflowtemplateFK.defaultEstimatedTime); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;
			model.currentTasks = tasks;
			super.result(rpcEvent); 
	  		var eventproducer:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PUSH_NEWPROJECT);
			eventproducer.projectId = model.currentTasks.projectObject.projectId;
	  		
	  		var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
	  		var _events:Events = new Events();
			_events.eventDateStart = model.currentTime;
			_events.eventType = EventStatus.PROJECTCREATED; 
			_events.personFk = model.person.personId;
		    _events.taskFk = (model.currentTasks!=null)?model.createdTask.taskId:0;
			_events.workflowtemplatesFk = (model.currentTasks!=null)?model.createdTask.wftFK:0;
			
			_events.projectFk = model.currentTasks.projectObject.projectId;
			var by:ByteArray = new ByteArray();
			var str:String = "Project Created";
			by.writeUTFBytes(str);
			_events.details = by;
			_events.eventName = "Project";		
			eEvent.events = _events;			
			 
			var eventsArr:Array = [eventproducer,eEvent]  
	 		var handler:IResponder = new Callbacks(result,fault);
	 		var msgtaskSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		msgtaskSeq.dispatch();
		}
		public function createBulkTasksResult(rpcEvent : Object ) : void {	 
			model.createdTask = Tasks(rpcEvent.message.body);
			model.currentTasks = model.createdTask 
			model.currentProjects= Tasks(rpcEvent.message.body).projectObject;
			var arrc : ArrayCollection = model.currentProjects.propertiespjSet;
			for each(var item : Propertiespj in arrc) {
				item.projectFk = model.currentProjects.projectId;
			}
			model.propertiespjCollection =  arrc; 
			super.result(rpcEvent);			
		}
		public function updateMessageTasksResult(rpcEvent : Object ) : void {	 
			model.messageBulkMailCollection = new ArrayCollection();			
			var tevent : TasksEvent = new TasksEvent ( TasksEvent.CREATE_MSG_TASKS);
			tevent.tasksCollection = tasksEvent.tasksCollection;
			super.result(rpcEvent);
			var handler:IResponder = new Callbacks(result,fault)
	 		var msgtaskSeq:SequenceGenerator = new SequenceGenerator([tevent],handler)
	 		if(tasksEvent.tasksCollection)	{
	 			if(tasksEvent.tasksCollection.length>0) { 
	 				msgtaskSeq.dispatch();
	 			}
	 		}
		}
		
		private function createDTLiteMsgTskResult( rpcEvent:Object ):void {
			model.createdTask = Tasks( rpcEvent.message.body );
			dtLiteMsgTsks.push( model.createdTask );
			
			if( tasksEvent.tasksCollection.length != 0 ) {
				tasksEvent.tasksCollection.removeItemAt( 0 );
				tasksEvent.tasksCollection.refresh();
			}
			
			if( tasksEvent.tasksCollection.length > 0 ) {
				var dtLiteMsgEvent:TasksEvent = new TasksEvent ( TasksEvent.CREATE_DTLITE_MSG );	
				dtLiteMsgEvent.tasksCollection = tasksEvent.tasksCollection;
				dtLiteMsgEvent.dispatch();
			}
			else {
				var eventsArray:Array = [];
				for each ( var tsk:Tasks in dtLiteMsgTsks ) {
					var handler:IResponder = new Callbacks( result, fault );
					var eEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_CREATE_EVENTS, handler );
					
					var events:Events = new Events();
					events.eventDateStart = model.currentTime;
					events.eventType = EventStatus.TASKMESSAGESEND;
					events.personFk = model.person.personId;
					events.taskFk = ( tsk ) ? tsk.taskId : 0;
					events.workflowtemplatesFk = ( tsk ) ? tsk.wftFK : 0;
					events.projectFk = tsk.projectObject.projectId;
					
					var by:ByteArray = new ByteArray();
					var returnby:String = '';
					
					if( tsk ) {
						var sep:String = "&#$%^!@";
						returnby = String( tsk.taskComment ) + sep + tsk.personFK;
					}			 
					
					var str:String = "Message Created :" + returnby;	
					by.writeUTFBytes( str );
					events.details = by;
					events.eventName = "Message";	
					eEvent.events = events;
					
					eventsArray.push( eEvent );	
				}
				dtLiteMsgTsks = [];
				var msgtaskSeq:SequenceGenerator = new SequenceGenerator( eventsArray );
	  			msgtaskSeq.dispatch();	
			}
		}
		
		private function createMessageTasksResult( rpcEvent:Object ):void {	 
			super.result( rpcEvent );						
			model.createdTask = Tasks( rpcEvent.message.body );
			var tempTaskId:int = Tasks( rpcEvent.message.body ).taskId;
			model.messageTaskCollection.addItem( model.createdTask ); 
			
			var arrC : ArrayCollection = tasksEvent.tasksCollection; 	
			var eEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_CREATE_EVENTS );
			var _events:Events = new Events();
			
			_events.eventDateStart = model.currentTime;
			_events.eventType = EventStatus.TASKMESSAGESEND;
			_events.personFk = model.person.personId;
			_events.taskFk = ( model.createdTask ) ? model.createdTask.taskId : 0;
			_events.workflowtemplatesFk = ( model.createdTask ) ? model.createdTask.wftFK : 0;
			_events.projectFk = model.createdTask.projectObject.projectId;
			
			var by:ByteArray = new ByteArray();
			var returnby:String = '';
			
			if( model.createdTask ) {
				var sep:String = "&#$%^!@";
				returnby = String( model.createdTask.taskComment ) + sep + model.createdTask.personFK;
			}			 
			
			var str:String = "Message Created :" + returnby;	
			by.writeUTFBytes( str );
			_events.details = by;
			_events.eventName = "Message";	
			eEvent.events = _events;
			var handler:IResponder = new Callbacks( result, fault );
	 		var msgtaskSeq:SequenceGenerator = new SequenceGenerator( [ eEvent ], handler );
	  		msgtaskSeq.dispatch();	
			model.TaskIDAttachArrayColl.addItem( tempTaskId );			
			tasksEvent.tasksCollection.removeItemAt( 0 );	
			
			//sendMail url purpose 
			model.messageBulkMailCollection.addItem( model.createdTask );
		 	
			if( model.onlyEmail == 'EMAIL' ) {
				mailMessageSend( model.createdTask );
			}	
				
			if( tasksEvent.tasksCollection.length > 0 ) {
				var tevent : TasksEvent = new TasksEvent( TasksEvent.CREATE_MSG_TASKS );
				tevent.tasksCollection = arrC;
				var handl:IResponder = new Callbacks( result, fault );
		 		var msgtaskSe:SequenceGenerator = new SequenceGenerator( [ tevent ],handl );
		  		msgtaskSe.dispatch();
			}
			else {
			 	if( model.messageBulkMailCollection.length != 0 ) {
					var teamPush:TasksEvent = new TasksEvent( TasksEvent.EVENT_MAILPUSH ); 
			  		teamPush.totalMailCollection = model.messageBulkMailCollection;
			  		var phandle:IResponder = new Callbacks( result, fault );
			 		var msgtaskSeqp:SequenceGenerator = new SequenceGenerator( [ teamPush ], phandle );
			  		msgtaskSeqp.dispatch();
			 	}
			 	
			 	fileListDetails();
			 	
			 	if( model.basicAttachFileColl.length != 0 && model.FileAttachArrayColl.length == 0 ) {
					var fileCollection:ArrayCollection = new ArrayCollection()
					for( var i:Number = 0; i < model.TaskIDAttachArrayColl.length; i++ ) {
						for(var j:Number = 0; j < model.basicAttachFileColl.length; j++ ) {
							var tempFiledetails:FileDetails= model.basicAttachFileColl.getItemAt( j ) as FileDetails;
							var fileduplicate:FileDetails = new FileDetails();
							fileduplicate.fileId = NaN;
							fileduplicate.fileName = tempFiledetails.fileName;
							fileduplicate.filePath = tempFiledetails.filePath;
							fileduplicate.fileDate = tempFiledetails .fileDate;
							fileduplicate.taskId =  model.TaskIDAttachArrayColl[ i ];	
							fileduplicate.categoryFK = tempFiledetails.categoryFK;
							fileduplicate.type = "Message";						
							fileduplicate.storedFileName = tempFiledetails.storedFileName;
							fileduplicate.projectFK = tempFiledetails.projectFK;
							fileduplicate.visible = tempFiledetails.visible;
							fileduplicate.releaseStatus = tempFiledetails.releaseStatus;
							fileduplicate.miscelleneous = tempFiledetails.miscelleneous;
							fileduplicate.fileCategory = tempFiledetails.fileCategory;
							fileduplicate.page = tempFiledetails.page;
							fileCollection.addItem( fileduplicate ); 
						}
					}
					var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_FILEDETAILS );
					fileEvent.fileDeatils = fileCollection;
					fileEvent.dispatch(); 
				}  	
			}
		}
		
		private function fileListDetails():void {
			model.FileAttachArrayColl = new ArrayCollection();			
			
			for each( var item:FileDetails in model.currentProjectFiles ) {				
				var currProject:Projects = model.createdTask.projectObject;
				var localRoot:String = model.parentFolderName; // c:/temp/
				var domainName:String = model.messageDomain.categoryName; // UNICOPA
				var domainYear:String = currProject.categories.categoryFK.categoryName; // 2009
				var domainMonth:String = currProject.categories.categoryName; // Jul
				var domainProject:String = StringUtils.compatibleTrim( currProject.projectName ); // JHTOOL
				
				item.destinationpath = localRoot + domainName + File.separator + domainYear + File.separator + domainMonth + File.separator + domainProject;
				
				if( model.onlyEmail == 'REEMAIL' ) {
					item.taskId  =  model.TaskIDAttachArrayColl.getItemAt( 0 ) as int;	
				}
				
				var filename:String = item.fileName; 
				var splitObject:Object = FileNameSplitter.splitFileName( item.fileName );
				
				filename = splitObject.filename + model.TaskIDAttachArrayColl.getItemAt( 0 );
				
	   			item.storedFileName = filename + DateUtil.getFileIdGenerator() + "." + splitObject.extension;
				item.projectFK = model.currentProjects.projectId;
				item.downloadPath = onUpload( item );
				item.filePath = item.destinationpath + "/" + item.type + "/" + item.storedFileName;	
	          	
				model.FileAttachArrayColl.addItem( item );
				model.filesToUpload.addItem( item );	
			}
			backUpload();
		}
		
		public function backUpload():void {			
			model.FileIDDetialsAttachColl = new ArrayCollection();
			model.bgUploadFile.idle = true;
			model.bgUploadFile.fileToUpload = model.FileAttachArrayColl;
		}
		
		public function mailMessageSend(mailTasks:Tasks) : void {
			if(mailTasks!=null) {
				if(mailTasks.personDetails!=null) {
					var emailuser:String = StringUtils.replace(escape(model.encryptor.encrypt(mailTasks.personDetails.personLogin)),'+','%2B');
					var emailpwd:String = StringUtils.replace(escape(model.encryptor.encrypt(mailTasks.personDetails.personPassword)),'+','%2B');
					var urlText:String = model.serverLocation+"ExternalMail/flexexternalmail.html?type=Mail%23ampuser="+emailuser+"%23amppass="+emailpwd+"%23ampmsgId="+mailTasks.taskId;
					//var urlText:String = model.serverLocation+"ExternalMail/flexexternalmail.html?type=Mail%23ampuser="+emailuser+"%23amppass="+emailpwd+"%23ampmsgId="+mailTasks.taskId+"%23ampprojId="+mailTasks.projectObject.projectId;
					
					var eEventEmail:SMTPEmailEvent = new SMTPEmailEvent( SMTPEmailEvent.EVENT_CREATE_SMTPEMAIL );
					var _smtpvo:SMTPEmailVO = new SMTPEmailVO();
					_smtpvo.msgTo = model.outerEmailId;
					_smtpvo.msgSubject = mailTasks.projectObject.projectName+" "+mailTasks.personDetails.personFirstname;   
					_smtpvo.msgBody = urlText;
					eEventEmail.smtpvo = _smtpvo;
					eEventEmail.dispatch();
					
					var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
			  		var _events:Events = new Events();
					_events.eventDateStart = model.currentTime;
					_events.eventType = EventStatus.TASKMESSAGESEND;   
					_events.personFk = model.person.personId;
					_events.taskFk = (mailTasks!=null)?mailTasks.taskId:0;			
					_events.workflowtemplatesFk = (mailTasks!=null)?mailTasks.wftFK:0;
					_events.projectFk = mailTasks.projectObject.projectId;
					_events.eventName = "Property Updation";
					var by:ByteArray = new ByteArray();
					var str:String = ' URL: ' +urlText;
					by.writeUTFBytes(str);
					_events.details = by;
					eEvent.events = _events;		
					eEvent.dispatch();
				}
			}
		}
		
		private function getViewerPersonId(personIdstr:int):Persons {
			var resultPerson:Persons;
			for each(var perso:Persons in model.personsArrCollection) {
				if(perso.personId == personIdstr) {
					resultPerson = perso;
				}
			}
			return resultPerson;
		}				
			
		private function fetchTasksResult( rpcEvent:Object ):void {	 
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.taskData.taskEntryCollection = arrc;
			model.currentProjectTasksCollection = arrc;
			model.unfinishedTasks = new ArrayCollection();
			for( var i:int = 0; i < arrc.length; i++ ) {
				var item:Tasks = arrc.getItemAt( i ) as Tasks;
				if( item.taskStatusFK != TaskStatus.FINISHED ) {
					model.unfinishedTasks.addItem( item );
				} 
			} 
			model.unfinishedTasks.refresh();
			super.result( rpcEvent );
		}
		
		private function updateTasksFilePathResult( rpcEvent:Object ):void {
			var tasks:Tasks = Tasks( rpcEvent.message.body );
			if( tasks.taskStatusFK == TaskStatus.FINISHED ) {
				for each( var item:Object in model.taskCollection ) {
					var taskCollection:ArrayCollection = ArrayCollection( item.tasks );
					var sort:Sort = new Sort();
					sort.fields = [ new SortField( "taskId" ) ];
					taskCollection.sort = sort;
					taskCollection.refresh();
					var cursor:IViewCursor = taskCollection.createCursor();
					var removeTask:Tasks = new Tasks();
					removeTask.taskId = tasks.taskId; 
					var found : Boolean = cursor.findAny( removeTask );
					if ( found ) {
						taskCollection.removeItemAt( taskCollection.getItemIndex( Tasks( cursor.current ) ) );
						taskCollection.refresh();
					}
				}
				model.taskCollection.refresh();				
			}
			var seqArr:Array = [];
			var filedetailsBasicEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_GET_BASICFILEDETAILS );
			seqArr.push( filedetailsBasicEvent );
			var handler:IResponder = new Callbacks( result, fault );
	 		var eventSeq:SequenceGenerator = new SequenceGenerator( seqArr, handler );
	  		eventSeq.dispatch();
			super.result( rpcEvent );
		}

		public function updateTasksResult( rpcEvent:Object ):void {	 
			super.result(rpcEvent);
			var tempId:int = model.currentTasks.taskId;
			var tempPrj:Projects = model.currentTasks.projectObject;
			model.currentTasks = Tasks(rpcEvent.message.body);
			if(tempId == model.currentTasks.taskId){ 
				model.currentTasks.projectObject = tempPrj;
		
				if(model.currentTasks.workflowtemplateFK.profileObject.profileCode == "OPE"){
					var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
					for each(var items : Propertiespj in arrc)
					{
						items.projectFk = model.currentTasks.projectObject.projectId;
					}
					model.propertiespjCollection = arrc; 
				}

				if(model.pdfFileCollection.length>0 && model.currentTasks.previousTask){
					model.currentTasks.previousTask.taskFilesPath = model.pdfFileCollection.getItemAt(0).filePath;
					if(Utils.checkTemplateExist(model.indReaderMailTemplatesCollection,model.currentTasks.workflowtemplateFK.workflowTemplateId))
					{
						model.currentTasks.taskFilesPath = model.pdfFileCollection.getItemAt(0).filePath;
					}
				}
			}
			model.currentProfiles = model.currentTasks.workflowtemplateFK.profileObject;
			model.workflowstemplates = model.currentTasks.workflowtemplateFK;
			var eventsArr:Array = [];
			
			var updateProjectEvent : ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_UPDATE_PROJECTS);
			var filedetailsBasicEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_BASICFILEDETAILS);
			var filedetailsTaskEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_TASKFILEDETAILS);
			var updatepropPjEvent : PropertiespjEvent = new PropertiespjEvent(PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ);
			var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
			if(model.currentProjects.projectStatusFK == ProjectStatus.WAITING)
			{
				trace("\n\n COMMAND IF updateTasksResult WAITING calling");
				model.waitingFab = true;
				var projects : Projects = model.currentProjects;
				var projectStatus : Status = new Status();
				projectStatus.statusId = ProjectStatus.INPROGRESS;
				projects.projectStatusFK = projectStatus.statusId;
				model.currentProjects= projects;
						
		  		var _events:Events = new Events();
				_events.eventDateStart = model.currentTime;
				_events.eventType = EventStatus.TASKINPROGRESS; //Task create
				_events.personFk = model.person.personId;
				_events.taskFk = (model.currentTasks!=null)?model.currentTasks.taskId:0;
				_events.workflowtemplatesFk = (model.currentTasks!=null)?model.currentTasks.wftFK:0;
				_events.projectFk = model.currentTasks.projectObject.projectId;
				var by:ByteArray = new ByteArray();
				var str:String = "Tasks Inprogress";
				by.writeUTFBytes(str);
				_events.details = by;
				_events.eventName = "Task";		
				eEvent.events = _events;
				if(model.updateProperty){
					var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
					for each(var items : Propertiespj in arrc)
					{
						items.projectFk = model.currentTasks.projectObject.projectId;
					}
					model.propertiespjCollection = arrc;
					if(model.waitingFab){ 
						trace("COMMAND IF IF updateTasksResult WAITING calling");
			  			eventsArr.push(updatepropPjEvent)
			  		}else{
			  			trace("COMMAND IF ELSE updateTasksResult WAITING calling");
			  			model.waitingFab = true;
			  		}
				}
				eventsArr.push( updateProjectEvent, eEvent, filedetailsTaskEvent, filedetailsBasicEvent );
			}else if(model.updateProperty||model.currentTasks.workflowtemplateFK.profileObject.profileCode == "FAB"||model.currentTasks.workflowtemplateFK.profileObject.profileCode == "CLT")
			{
				trace("\n\n COMMAND ELSE IF updateTasksResult FAB calling");
				var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
				for each(var items : Propertiespj in arrc)
				{
					items.projectFk = model.currentTasks.projectObject.projectId;
				}
				model.propertiespjCollection = arrc;
		  		var _eventss:Events = new Events();
				_eventss.eventDateStart = model.currentTime;
				_eventss.eventType = EventStatus.TASKINPROGRESS; 
				_eventss.personFk = model.person.personId;
				_eventss.taskFk = (model.currentTasks!=null)?model.currentTasks.taskId:0;
				_eventss.workflowtemplatesFk = (model.currentTasks!=null)?model.currentTasks.wftFK:0;
				_eventss.projectFk = model.currentTasks.projectObject.projectId;
				var by:ByteArray = new ByteArray();
				var str:String = "Tasks Inprogress";
				by.writeUTFBytes(str);
				_eventss.details = by;
				_eventss.eventName = "Task";			
				eEvent.events = _eventss;		
				if(model.waitingFab){ 
					trace("COMMAND ELSE IF IF updateTasksResult FAB calling");
		  			eventsArr.push(updatepropPjEvent)
		  		}else{
		  			trace("COMMAND ELSE IF ELSE updateTasksResult FAB calling");
		  			model.waitingFab = true
		  		}
				eventsArr.push(eEvent);
			}else
			{ 
				if(model.waitingFab)
				{	
					trace("\n\n COMMAND FINAL updateTasksResult waitingFab calling");	
					//--PDFPREVIEW forward and backward propertiesspj update--starting---	
					var arrc : ArrayCollection = model.currentTasks.projectObject.propertiespjSet;
					for each(var items : Propertiespj in arrc)
					{
						items.projectFk = model.currentTasks.projectObject.projectId;
					}
					model.propertiespjCollection = arrc;
					//--end----					
		  			var eventteamlines:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE);				  		
		  			var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
			  		var _events:Events = new Events();
					_events.eventDateStart = model.currentTime;
					_events.eventType = EventStatus.TASKLAUNCHED; //Task create
					_events.personFk = model.person.personId;
					//_events.taskFk = model.currentTasks.taskId;
					_events.taskFk = (model.currentTasks!=null)?model.currentTasks.taskId:0;					
					_events.workflowtemplatesFk = (model.currentTasks!=null)?model.currentTasks.wftFK:0;
					_events.projectFk = model.currentTasks.projectObject.projectId;
					//_events.details = "Tasks Created";
					var by:ByteArray = new ByteArray();
					var str:String = "Tasks Created";
					by.writeUTFBytes(str);
					_events.details = by;
					_events.eventName = "Task";		
					eEvent.events = _events;			
					
					var eventArr:Array = [eventteamlines,eEvent] 
					//--PDFPREVIEW forward and backward propertiesspj update--starting---	
					if(model.waitingFab){ 
						trace("COMMAND FINAL IF updateTasksResult waitingFab calling");	
			  			eventArr.push(updatepropPjEvent)
			  		}/* else{
			  			model.waitingFab = true
			  		}  */
			  		//--end----
			 		var handlers:IResponder = new Callbacks(result,fault);
			 		var uploadSeq:SequenceGenerator = new SequenceGenerator(eventArr,handlers)
			  		uploadSeq.dispatch();
		  			
		  			
		  		}else{
		  			model.waitingFab = true;
		  			trace("\n\n COMMAND updateTasksResult OUTER else waitingFab true calling");
		  		}
				
			}
			var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch();
	  		
		}
		
		private function createTasksResult( rpcEvent:Object ):void 	{	 
			
			super.result( rpcEvent );
			model.newTaskCreated = true;
			 
			model.createdTask = Tasks( rpcEvent.message.body );
			
			model.currentProjects= Tasks( rpcEvent.message.body ).projectObject;
			var eventsArr:Array = [];
			
			//Done for the Purpose of  PhaseEnd date by devaraj

			/*if( model.tracTaskContent.tracPhases != null ) {
				model.createdTask.projectObject.phasesSet = model.tracTaskContent.tracPhases;
			}*/
				
			checkPhases( model.createdTask );
			 
			var phaseEvent : PhasesEvent = new PhasesEvent( PhasesEvent.EVENT_UPDATE_PHASES );
			var taskupdateevent : TasksEvent = new TasksEvent( TasksEvent.EVENT_UPDATE_TASKS );
			var historyTasksEvent:TasksEvent = new TasksEvent( TasksEvent.EVENT_FETCH_TASKS );
			  
			if( phaseEventCollection.length > 0 ) {
				eventsArr.push( phaseEvent );
			}
			else if( model.currentTasks ) {
				model.currentTasks.nextTask = model.createdTask;
				model.currentTasks.taskStatusFK = TaskStatus.FINISHED;
				eventsArr.push( taskupdateevent );
			}
			
			eventsArr.push( historyTasksEvent );
			
			for each( var item:FileDetails in model.currentProjectFiles ) {
				item.taskId = model.currentTasks.taskId;
				
				var filename:String = item.fileName; 
				var splitObject:Object = FileNameSplitter.splitFileName( item.fileName );
				
				if( item.taskId != 0 ) {
					filename = splitObject.filename + item.taskId;
	   			}
	   			if( item.type == "Tasks" && splitObject.extension == "pdf" ) {
	   				model.pdfConversion = true;
	   			}
	   			item.storedFileName = filename + DateUtil.getFileIdGenerator() + "." + splitObject.extension;
				item.projectFK = model.currentProjects.projectId;
				item.downloadPath = onUpload( item );
				model.filesToUpload.addItem( item );
			}
			
			if( model.filesToUpload.length > 0 ) {
				model.bgUploadFile.idle = true;
				model.bgUploadFile.fileToUpload = model.filesToUpload;
			}  
			var newProjectSeq:SequenceGenerator = new SequenceGenerator( eventsArr );
	  		newProjectSeq.dispatch(); 
		}  
		
		private function createProfileTaskMessage( profile:String,dynamicPersonId:int ):Tasks {
			var taskData:Tasks = new Tasks();
			taskData.taskId = NaN;
			taskData.previousTask = model.currentTasks;
			
			taskData.projectObject = model.currentProjects;
			var domain:Categories = Utils.getDomains(model.currentProjects.categories);
			model.messageDomain = domain;
			//taskData.personFK = model.indPersonId; 
			taskData.personFK = int(dynamicPersonId);
			 
			for each( var filesvo:FileDetails in model.basicFileCollection)
			{	
				if(filesvo.visible == false){					
					if((tempType!=null) && (tempMiscelleneous!=null)){	
						if((tempType == filesvo.type) && (tempMiscelleneous == filesvo.miscelleneous)){  						
							taskData.fileObj = filesvo;
							break;
						}
					}
				}
			} 
			//--------------------
			var by:ByteArray = new ByteArray()
			var sep:String = "&#$%^!@";
			var replySubject:String = model.currentProjects.projectName;
			//var str:String = model.person.personFirstname+sep+replySubject+sep+profile+" "+'mail reference details'+sep+model.person.personId+","+model.person.defaultProfile;
			var temptask:Tasks; 
			if(model.createdTask!=null){
				temptask = model.createdTask;
			}
			var str:String = model.person.personFirstname+sep+replySubject+sep+profile+" "+getComments(temptask)+sep+model.person.personId+","+model.person.defaultProfile;
			
			by.writeUTFBytes(str)
			taskData.taskComment = by;
			var status:Status = new Status();
			status.statusId = TaskStatus.WAITING;
			taskData.taskStatusFK = status.statusId;
			taskData.tDateCreation = model.currentTime;
			taskData.workflowtemplateFK = getTemplate(getProfileId(profile));	
			taskData.tDateEndEstimated = Utils.getCalculatedDate(model.currentTime,taskData.workflowtemplateFK.defaultEstimatedTime); 
			taskData.estimatedTime = taskData.workflowtemplateFK.defaultEstimatedTime;
			return taskData;
		}	
		private function getComments(currentTaskscommment:Tasks):String{
			var returnStr:String = 'mail reference details';
			if(currentTaskscommment!=null){
				if(currentTaskscommment.previousTask!=null){
					if(currentTaskscommment.previousTask.taskComment!=null){
						returnStr = currentTaskscommment.previousTask.taskComment.toString();
						return returnStr;
					}
				}
			}
			return returnStr;
		}	
		
		private function getProfileId(str:String):int{
			for each(var pro:Profiles in model.teamProfileCollection){
				if(pro.profileCode == str){
					return pro.profileId;
				}
			}
			return 0;
		}
		public function getMessageTemplate(pro:int):Workflowstemplates{
			var messageTemplateCollection:ArrayCollection = Utils.getWorkflowTemplatesCollection(model.messageTemplatesCollection,model.currentProjects.workflowFK);
			for each(var item:Workflowstemplates in  messageTemplateCollection){
				if(item.profileFK== pro){
					return item;
				}
			}
			return null;
		}
		private function getTemplate( pro:int ):Workflowstemplates {
			var indTemplateCollection:ArrayCollection = Utils.getWorkflowTemplatesCollection(model.indReaderMailTemplatesCollection,model.currentProjects.workflowFK);
			for each(var item:Workflowstemplates in  indTemplateCollection){
				if(item.profileFK== pro && item.taskCode =='PDF01A'){
					return item;
				}
			}
			return null;
		}
		
		private function getIndTemplate( pro:int ):Workflowstemplates {
			var indTemplateCollection:ArrayCollection = Utils.getWorkflowTemplatesCollection(model.indReaderMailTemplatesCollection,model.currentProjects.workflowFK);
			for each(var item:Workflowstemplates in  indTemplateCollection){
				if(item.profileFK== pro && item.taskCode =='PDF01A'){
					return item;
				}
			}
			return null;
		}
        
        private function createINDTask():void {			
			var bulkMsgTaskPersonCol:ArrayCollection = new ArrayCollection();	
			assignINDTask();	
			for each(var item:Object in model.selectedPersons_FileAccess){
				if(item.personId!=0){
					var profileId:Profiles = GetVOUtil.getProfileObject(item.profileId);
					var tasksvo:Tasks = createProfileTaskMessage(profileId.profileCode,int(item.personId));
					bulkMsgTaskPersonCol.addItem(tasksvo);
				}
			}
			if(bulkMsgTaskPersonCol.length!=0){
				var messageindEvent:TasksEvent = new TasksEvent(TasksEvent.CREATE_IMP_IND_MSG_TASKS);
				messageindEvent.bulkMsgTaskPersonCollection = bulkMsgTaskPersonCol;
				messageindEvent.dispatch();
			}			
			if( model.preloaderVisibility )	model.preloaderVisibility = false;
		}
		private var tempType:String = null;
		private var tempMiscelleneous:String = null;
		private function assignINDTask():void
		{
			if(model.agenceAttachFileCommon.length!=0)	
			{
				var tempFiledetails:FileDetails = model.agenceAttachFileCommon.getItemAt(0) as FileDetails;
				for each( var filesvo:FileDetails in model.basicFileCollection)
				{
					if(filesvo.visible == true){				
						if((tempFiledetails.projectFK == filesvo.projectFK) && (tempFiledetails.fileId == filesvo.fileId)){
							tempType = tempFiledetails.type;
							tempMiscelleneous = tempFiledetails.miscelleneous;
							break;
						}
					}
				}				
			}			
		}	
		
        private function onCreateBulkEmailTasks():void {
        	var taskstemp:Tasks = new Tasks();
			taskstemp.taskId = 0;
			subProfileFileUpload( taskstemp );
			
        	for each( var item:Object in model.selectedPersons_FileAccess ) {
				commonWorkFlowTask( item );
			}
			commonWorkFlowBulkTask();
		    commonProfileWorkFlowAlerts();
	    } 
		
		private var bulkMsgTaskPersonCol:ArrayCollection = new ArrayCollection();	
		private function commonWorkFlowTask(item:Object):void {			
			assignINDTask();	
			if(item.personId!=0){
				var profileId:Profiles = GetVOUtil.getProfileObject(item.profileId);
				var tasksvo:Tasks = createProfileTaskMessage(profileId.profileCode,int(item.personId));
				bulkMsgTaskPersonCol.addItem(tasksvo);
			}		
		}
		private function commonWorkFlowBulkTask():void{
			if(bulkMsgTaskPersonCol.length!=0){
				var messageindEvent:TasksEvent = new TasksEvent(TasksEvent.CREATE_IMP_IND_MSG_TASKS);
				messageindEvent.bulkMsgTaskPersonCollection = bulkMsgTaskPersonCol;
				messageindEvent.dispatch();
			}			
			if( model.preloaderVisibility )	model.preloaderVisibility = false; 
		}
		
		private  function commonWorkFlowBulkMsgResult( rpcEvent:Object ):void {	
			super.result(rpcEvent);	
			model.createdTaskIND = Tasks( rpcEvent.message.body );

			var tempArrayCollection : ArrayCollection = tasksEvent.bulkMsgTaskPersonCollection; 
			var person:Persons = model.createdTaskIND.personDetails;	
			sendINDMail( model.createdTaskIND, person );			
			
			tasksEvent.bulkMsgTaskPersonCollection.removeItemAt(0);
			
			if(tasksEvent.bulkMsgTaskPersonCollection.length > 0) {
				var messageindEvent:TasksEvent = new TasksEvent(TasksEvent.CREATE_IMP_IND_MSG_TASKS);
				messageindEvent.bulkMsgTaskPersonCollection = tempArrayCollection;
				var handl:IResponder = new Callbacks(result,fault)
		 		var msgindtaskSe:SequenceGenerator = new SequenceGenerator([messageindEvent],handl)
		  		msgindtaskSe.dispatch();
			}				
		}  

		private function commonProfileWorkFlowAlerts():void{
			if(model.selectedPersons_FileAccess!=null){
				if(model.selectedPersons_FileAccess.length!=0){			
					var mailSentProvider:ArrayCollection = new ArrayCollection();
		        	for each(var item:Object in model.selectedPersons_FileAccess){
						if(item.personId!=0){
							var profileId:Profiles = GetVOUtil.getProfileObject(item.profileId);
							var personId:Persons = GetVOUtil.getPersonObject(item.personId);
							var profileCode:String = profileId.profileCode;
							var personeEmail:String = personId.personEmail;
							var obj:Object = { 'formLab':profileCode,'contentLab':personeEmail};					
							mailSentProvider.addItem(obj);	
						}
		        	}	        	
		        	var mailConfirmAlert:MailConfirmationAlert = new MailConfirmationAlert();
		        	mailConfirmAlert.confirmationProvider = mailSentProvider;
		        	PopUpManager.addPopUp( mailConfirmAlert,model.mainClass,true);
					PopUpManager.centerPopUp( mailConfirmAlert);
					
					model.selectedPersons_FileAccess = new ArrayCollection();
				}
			}
		} 
		
		private function subProfileFileUpload( temptask:Tasks ):void {
			for each( var item:FileDetails in model.currentProjectFiles ) {
				item.taskId = temptask.taskId;
				item.type = "Basic";
				item.fileCategory = FileCategory.CREATION;
				
				var filename:String = item.fileName; 
				var splitObject:Object = FileNameSplitter.splitFileName( item.fileName );
				
				if( item.taskId != 0 ) {
					filename = splitObject.filename+item.taskId;
	   			}	   			
	   			if( item.type == "Tasks" && splitObject.extension == "pdf" ) {
	   				model.pdfConversion = true;
	   			}	   			
	   			item.storedFileName = filename + DateUtil.getFileIdGenerator() + "." + splitObject.extension;
				item.projectFK = model.currentProjects.projectId;
				item.downloadPath = onUpload( item );
				model.filesToUpload.addItem( item );
			}
			if( model.filesToUpload.length > 0 ) {
				model.bgUploadFile.idle = true;
				model.bgUploadFile.fileToUpload = model.filesToUpload;
			}  
		}
		
		private  function msgIMPINDTaskResult( rpcEvent:Object ):void {	
			super.result(rpcEvent);	
			model.createdTaskIND = Tasks( rpcEvent.message.body );

			var tempArrayCollection : ArrayCollection = tasksEvent.bulkMsgTaskPersonCollection; 
			var person:Persons = model.createdTaskIND.personDetails;	
			sendINDMail( model.createdTaskIND, person );
			
			tasksEvent.bulkMsgTaskPersonCollection.removeItemAt(0);
			
			if(tasksEvent.bulkMsgTaskPersonCollection.length > 0) {
				var messageindEvent:TasksEvent = new TasksEvent(TasksEvent.CREATE_IMP_IND_MSG_TASKS);
				messageindEvent.bulkMsgTaskPersonCollection = tempArrayCollection;
				var handl:IResponder = new Callbacks(result,fault)
		 		var msgindtaskSe:SequenceGenerator = new SequenceGenerator([messageindEvent],handl)
		  		msgindtaskSe.dispatch();
			}				
		} 
		
		private function commonAlerts():void{
			
			model.impPerson = GetVOUtil.getPersonObject( model.impPersonId );
			var personAlert:String = '';
			var mailSentProvider:ArrayCollection = new ArrayCollection();
        	for each(var item:Object in model.selectedPersons_FileAccess){
				if(item.personId!=0){
					var profileId:Profiles = GetVOUtil.getProfileObject(item.profileId);
					var personId:Persons = GetVOUtil.getPersonObject(item.personId);
					var profileCode:String = profileId.profileCode;
					var personeEmail:String = personId.personEmail;
					var obj:Object = { 'formLab':profileCode,'contentLab':personeEmail};
					
					mailSentProvider.addItem(obj);	
				}
        	}
        	var impPersonStr:String = model.impPerson.personEmail;
        	var impObj:Object = {'formLab':'EPR','contentLab':impPersonStr};
        	mailSentProvider.addItem(impObj);
        	var mailConfirmAlert:MailConfirmationAlert = new MailConfirmationAlert();
        	mailConfirmAlert.confirmationProvider = mailSentProvider;
        	PopUpManager.addPopUp( mailConfirmAlert,model.mainClass,true);
			PopUpManager.centerPopUp( mailConfirmAlert);        	
		}
		
		
		private var openIndLink:String = "";
		private function sendINDMail( newlyCreatedTask:Tasks, selectPerson:Persons ):void {			
			var message:String ="Messieurs,<div><div><br></div><div>Nous sommes en charge de la photogravure de la reference citee en objet.</div><div>Merci de bien vouloir consulter et valider le fichier de creation en cliquant le lien suivant :</div><div><br></div><div><a href=";
			var postmessage:String  = "</div><div><br></div><div>Nous realiserons les photogravures sur reception de votre validation en ligne.</div><div>Merci de votre collaboration.</div><div><br></div></div>";
						
			var indemailuser:String = StringUtils.replace(escape(model.encryptor.encrypt(selectPerson.personLogin)),'+','%2B');
			var indemailpwd:String = StringUtils.replace(escape(model.encryptor.encrypt(selectPerson.personPassword)),'+','%2B');
			
			var urllinkInd:String = model.serverLocation+"ExternalMail/flexexternalmail.html?type=All%23ampuser="+indemailuser+"%23amppass="+indemailpwd+"%23amptaskId="+newlyCreatedTask.taskId+"%23ampprojId="+newlyCreatedTask.projectObject.projectId
			var urlTextInd:String = message+model.serverLocation+"ExternalMail/flexexternalmail.html?type=All%23ampuser="+indemailuser+"%23amppass="+indemailpwd+"%23amptaskId="+newlyCreatedTask.taskId+"%23ampprojId="+newlyCreatedTask.projectObject.projectId+'>Link -&gt;</a>'+urllinkInd+postmessage;
			openIndLink=urllinkInd;
			
			var eEvent:SMTPEmailEvent = new SMTPEmailEvent( SMTPEmailEvent.EVENT_CREATE_SMTPEMAIL );
			var _smtpvo:SMTPEmailVO = new SMTPEmailVO();
			_smtpvo.msgTo = selectPerson.personEmail;
			_smtpvo.msgSubject = newlyCreatedTask.projectObject.projectName;   
			_smtpvo.msgBody = urlTextInd;
			eEvent.smtpvo = _smtpvo;
			eEvent.dispatch();
			
			EventsUpdateINDUse( urllinkInd, newlyCreatedTask,selectPerson );			
		}
		
		private function EventsUpdateINDUse( indURL:String, newlyCreatedTask:Tasks, selectPerson:Persons ):void {
			var eEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_CREATE_EVENTS );
	  		var _events:Events = new Events();
			_events.eventDateStart = model.currentTime;
			_events.eventType = EventStatus.INDMAIL;   
			_events.personFk = model.person.personId;
			_events.taskFk = ( newlyCreatedTask ) ? newlyCreatedTask.taskId : 0;			
			_events.workflowtemplatesFk = ( newlyCreatedTask ) ? newlyCreatedTask.wftFK : 0;
			_events.projectFk = newlyCreatedTask.projectObject.projectId;
			_events.eventName = "Property Updation";
			var by:ByteArray = new ByteArray();
			var str:String = selectPerson.personEmail + "\n" + GetVOUtil.getCompanyObject( selectPerson.companyFk ).companyname +' URL: ' +indURL;
			by.writeUTFBytes( str );
			_events.details = by;
			eEvent.events = _events;		
			eEvent.dispatch();
		}
        
		private function checkPhases( createdTask:Tasks ):void {
			createdTask = setPhase( createdTask );
			var prevTask:Tasks;
			if( createdTask.previousTask ) {
				prevTask= setPhase( createdTask.previousTask );
			} 
			if( createdTask.workflowtemplateFK.phaseTemplateFK != 0 ) {
				if( createdTask.previousTask ) {
					//check the phase of new task is bigger than next task flow in wft
					if( createdTask.workflowtemplateFK.phaseTemplateFK > createdTask.previousTask.workflowtemplateFK.phaseTemplateFK ) {
						// the new task is first of the phase
						createdTask.firstofPhase = true;
					}
				}
				else {
					// the new task is first of the phase, first of the workflow
					createdTask.firstofPhase = true;
				} 
			} 
			
			//first of phase
			if( createdTask.firstofPhase ) {
				if( prevTask ) {
				// to fill phase end of prev task
					if( !prevTask.phase.phaseEnd ) { 
						prevTask.phase.phaseEnd = model.currentTime;
						if( model.AutoProj ) {
							prevTask.phase.phaseEnd = newDate;
						}
						prevTask.phase.phaseDuration = Math.ceil( ( prevTask.phase.phaseEnd.getTime() - prevTask.phase.phaseStart.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
						var planneddelay : Number = Math.ceil( ( prevTask.phase.phaseEndPlanified.getTime() - prevTask.phase.phaseEnd.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
						planneddelay = 0 -( planneddelay );
						prevTask.phase.phaseDelay = planneddelay;  
						phaseEventCollection.addItem( prevTask.phase );
					}
				}
				if(createdTask.phase!=null)	{
					var index:int = createdTask.projectObject.phasesSet.getItemIndex( createdTask.phase );
					for( var i:int = index;i < createdTask.projectObject.phasesSet.length;i++ ) {
						if( i == index ) {
							Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart = model.currentTime; 
							if( model.AutoProj ) {
								Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart = newDate;
							} 
						}
						else {
							Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart = Phases( createdTask.projectObject.phasesSet.getItemAt( i - 1 ) ).phaseEndPlanified;
						}
						if( !Phases( createdTask.projectObject.phasesSet.getItemAt( 0 ) ).phaseEnd ) {
							Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEndPlanified = model.tracTaskContent.getPlanifiedDate( Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart, Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseDuration );
						}	
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
			}
			model.phaseEventCollection = phaseEventCollection;
		}
		
		// set the phase for the provided task
		private function setPhase( task:Tasks ):Tasks {
			var sort : Sort = new Sort();
			sort.fields = [ new SortField( "phaseTemplateFK" ) ];
			if( task.projectObject.phasesSet ) {
				task.projectObject.phasesSet.sort = sort;
				task.projectObject.phasesSet.refresh();
				var cursor : IViewCursor = task.projectObject.phasesSet.createCursor();
				var phase : Phases = new Phases();
				phase.phaseTemplateFK = task.workflowtemplateFK.phaseTemplateFK;
				var found : Boolean = cursor.findAny(phase);
				if( found ) {
					task.phase = Phases( cursor.current );
				}
			}

			return task;
		}
		
		private function getTaskResult( rpcEvent:Object ):void {	 
			super.result( rpcEvent );
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			if( arrc ) {
				if( arrc.length > 0 ) {
					var tasks:Tasks = arrc.getItemAt( 0 ) as Tasks;					
					var tsklbl:String = tasks.workflowtemplateFK.taskLabel;
					var todoTskcode:String = tasks.workflowtemplateFK.taskCode;
					trace("TASKSCOMMAND tsklbl :"+tsklbl+", todoTskcode :"+todoTskcode);

					 if( (todoTskcode == "P1T02A" && tsklbl == "EXECUTION") ||
						(todoTskcode == "P1T02B" && tsklbl == "EXECUTION CORRECTION REQUEST") ||
						(todoTskcode == "P4T01A" && tsklbl == "CHECKING") ||
						(todoTskcode == "P4T01B" && tsklbl == "CHECKING VALIDATION REQUEST")) { 
							trace("\n\n\n TASKSCOMMAND updateFileToTask fileObj:"+model.updateFileToTask.fileObj.fileId+" -fileName- "+model.updateFileToTask.fileObj.fileName+" -currentUserProfileCode- "+model.currentUserProfileCode);
							
							tasks.fileObj = model.updateFileToTask.fileObj;
										  										
							var taskEvent:TasksEvent = new TasksEvent( TasksEvent.EVENT_UPDATE_TASKFILEPATH );
							model.updateFileToTask = tasks;
							var eventsArr:Array = [ taskEvent ]; 							
							  
				 			var handler:IResponder = new Callbacks( result, fault )
				 			var uploadSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
				  			uploadSeq.dispatch();			  			
				  						  			
				 		}

				}
			}
		} 
		
		private function getTasksResult( rpcEvent:Object ):void {	 
			super.result( rpcEvent );
			model.tasks = ArrayCollection( rpcEvent.message.body ); 
			var domainDeatils:Array = [];
			var taskCollection:ArrayCollection = new ArrayCollection();
			var tasks:ArrayCollection;
			var object:Object;
			var domains:Categories;
			var isCLT : Boolean
			model.taskCollection = new ArrayCollection();
			model.taskCollection.refresh();
			if( model.profilesCollection.length > 0 ) {
				if( GetVOUtil.getProfileObject( model.person.defaultProfile ).profileCode == 'CLT' ) { 
					isCLT = true;
				}	
			}   
			for each( var item:Tasks in model.tasks ) {
				item.projectObject = checkItem( item.projectObject, model.projectsCollection );
				if( isCLT && ( model.appDomain != 'Brennus' ) ) {
					domains = item.projectObject.categories;
					model.domainCollection.addItem( Utils.getDomains( item.projectObject.categories ) );
				}
				else {
					domains = Utils.getDomains( item.projectObject.categories );
					model.domainCollection.addItem( domains );
				}
				if( domainDeatils.indexOf( domains ) > - 1 ) {				
					for each( var item2:Object in taskCollection ) {
						if( item2.domain.categoryId == domains.categoryId ) {
							tasks = item2.tasks;
							break;
 						}
					}
					if( ( item.personDetails ) && ( Utils.checkTemplateExist( model.messageTemplatesCollection, item.workflowtemplateFK.workflowTemplateId ) ) ) {
						if( item.personDetails.personId == model.person.personId ) {
							tasks.addItem( item );
						}	
					}
					else {	
						tasks.addItem( item );
					}
				}
				else {
					object = new Object();
					tasks = new ArrayCollection();
					object[ 'domain' ] = domains;
					object[ 'tasks' ] = tasks;
					if( ( item.personDetails ) && ( Utils.checkTemplateExist( model.messageTemplatesCollection, item.workflowtemplateFK.workflowTemplateId ) ) ) {
						if( item.personDetails.personId == model.person.personId ) {
							tasks.addItem( item );
						}
					}
					else {
						tasks.addItem( item );
					}
					taskCollection.addItem( object );
					domainDeatils.push( domains );
				}
				
				if( item.tDateEndEstimated ) {
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
			model.domainCollection = new ArrayCollection( domainDeatils );
			model.workflowState = 0;
		} 
		
		private function getMaxTaskResult( rpcEvent:Object ):void {	 
			super.result( rpcEvent );
			var maxtaskarray:ArrayCollection = rpcEvent.result as ArrayCollection;
			for each( var obj:Array in maxtaskarray ) {
				var projId:int = obj[ 1 ];
				var proj:Projects = GetVOUtil.getProjectObject( projId );
				proj.taskDateStart = obj[ 2 ];
				proj.taskDateEnd = obj[ 3 ];
			}
		}
		
		private function checkItem( item:Object, dp:ArrayCollection ): Projects {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'projectId' ) ];
            if( !dp.sort ) {
            	dp.sort = sort;
            	dp.refresh();
            }	 
			var cursor:IViewCursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				return Projects( cursor.current );
			}
			return Projects( item );
		}
		
		private function getSprintTasks( rpcEvent:Object ):void {
			super.result( rpcEvent );
			var previousTasksCollection : ArrayCollection = rpcEvent.result as ArrayCollection;
			for each( var task:Tasks in model.tasks ) {
				if( !Utils.checkDuplicateItem( task, previousTasksCollection, 'taskId' ) ) {
					previousTasksCollection.addItem( task );
				}
			}
			model.sprintTasksCollection = previousTasksCollection;
		}
	}
}