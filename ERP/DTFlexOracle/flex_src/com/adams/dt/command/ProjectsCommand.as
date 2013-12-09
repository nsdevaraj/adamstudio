package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.LoginUtils;
	import com.adams.dt.business.util.StringUtils;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.PhasesEvent;
	import com.adams.dt.event.PhasestemplatesEvent;
	import com.adams.dt.event.PresetTemplateEvent;
	import com.adams.dt.event.ProjectMessageEvent;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.event.PropertiespjEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamTemplatesEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.TeamlineTemplatesEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.mainView.ViewFactory;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Teamlines;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.rpc.IResponder;
	
	public final class ProjectsCommand extends AbstractCommand 
	{ 
		private var tempObj:Object = {};
		private var projectsEvent:ProjectsEvent;		
		private var cursor:IViewCursor;
		private var _viewFactory:ViewFactory = ViewFactory.getInstance();
		
		override public function execute( event:CairngormEvent ):void {	 
			
			super.execute( event );
			
			projectsEvent = event as ProjectsEvent;
			this.delegate = DelegateLocator.getInstance().projectDelegate;
			this.delegate.responder = new Callbacks( result, fault ); 
		 	
		 	switch( event.type ) {   
		    	case ProjectsEvent.EVENT_GET_PROJECTS:
		      		delegate.responder = new Callbacks( getProjectResult, fault );
					delegate.findPersonsList( model.person );
		      	break; 
		      	case ProjectsEvent.EVENT_DELETEALL_PROJECTS:
		      		delegate.responder = new Callbacks( result, fault );
					delegate.deleteAll();
		      	break; 
		      	case ProjectsEvent.CREATE_AUTO_PROJECTS:
		      		delegate.responder = new Callbacks( createAutoProjectResult, fault );
		       		delegate.create( projectsEvent.projects );
		      	break;
		      	case ProjectsEvent.EVENT_CREATE_PROJECTS:
		        	delegate.responder = new Callbacks( createProjectResult, fault );
		      		delegate.create( model.newProject );
		      	break; 
		      	case ProjectsEvent.EVENT_UPDATE_PROJECTS:
		      		delegate.responder = new Callbacks( updateProjectResult, fault );
		       		delegate.directUpdate( model.currentProjects );
		      	break; 
		      	case ProjectsEvent.EVENT_UPDATE_PROJECTNOTES:
		      		delegate.responder = new Callbacks( updateProjectNotesResult, fault );
		      		delegate.directUpdate( model.currentProjects );
		      	break;
		      	case ProjectsEvent.EVENT_DELETE_PROJECTS:
		       		delegate.deleteVO( projectsEvent.projects );
		       	break; 
		      	case ProjectsEvent.EVENT_SELECT_PROJECTS:
		       		delegate.select( projectsEvent.projects );
		       	break; 
		       	case ProjectsEvent. EVENT_MOVE_DIRECTORY:
		       		delegate = DelegateLocator.getInstance().fileutilDelegate;
		       		delegate.responder = new Callbacks( result, fault );
		       		delegate.copyDirectory( projectsEvent.frompath, projectsEvent.topath );
		       	break;
		       
		        //add by kumar Push ProjectId pass and get to the Project Details
		       	case ProjectsEvent.EVENT_PUSH_SELECT_PROJECTS:
		      		delegate.responder = new Callbacks( getPushProjectDetails, fault ); 
		      		delegate.findProjectId( projectsEvent.eventPushProjectsId );
		       	break; 
		       //add by kumar 30th July
		      	case ProjectsEvent.EVENT_STATUSUPDATE_PROJECTS:
		       		delegate.responder = new Callbacks( updateStatusProjectResult, fault );
		       		delegate.directUpdate( model.currentProjects );
		       	break;
		      //add by kumar 30th July
		      	case ProjectsEvent.EVENT_PUSH_GET_PROJECTSID:
		      		delegate.responder = new Callbacks( getPushProjectIDDetails, fault );
		      		delegate.findProjectId( projectsEvent.eventPushProjectsId );
		       	break;   
		       	case ProjectsEvent.EVENT_UPDATE_PROJECTNAME:
		       		delegate.responder = new Callbacks( getProjectUpdateName, fault );
		       		delegate.directUpdate( model.currentProjects );
		       	break; 
				//-----------------------------------
				//New Oracle Conversion by kumar   
		       case ProjectsEvent.EVENT_ORACLE_NEWPROJECTCALL:
		       		this.delegate = DelegateLocator.getInstance().pagingDelegate;					
					this.delegate.responder = new Callbacks(createOracleProjectResult,fault);	
					//this.delegate.createOracleNewProject("GMAIL",2,2);
					var projectComments:String = '';
					if(model.newProject.projectComment)
						projectComments = model.newProject.projectComment.toString();
					trace("EVENT_ORACLE_NEWPROJECTCALL :"+model.newProject.workflowFk.workflowId+" , projectComments :"+projectComments);
					var categories2:Categories = model.categories2;
						
					//DIADEM -82/CARAFOUR -2	
					this.delegate.createOracleNewProject(model.projectprefix,model.newProject.projectName,projectComments,model.categories1.categoryFK.categoryId,model.person.personId,model.parentFolderName,model.domain,model.categories1,model.categories2,model.newProject.workflowFK,projectsEvent.codeEAN,projectsEvent.codeGEST,projectsEvent.codeIMPRE);
		       	break; 
		       //-----------------------------------
		      	default:
		       	break; 
		      }
		}
		private function createOracleProjectResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			var resultArrColl : ArrayCollection = new ArrayCollection();
			resultArrColl  = rpcEvent.result as ArrayCollection;	
			var loginUtils: LoginUtils  = new LoginUtils();		
			if(resultArrColl){
				trace("*******************************************************************************************");
				trace("createOracleProjectResult resultArrColl:"+resultArrColl.length);			
				trace("*******************************************************************************************");
				
				var newcategorydomainList:ArrayCollection = resultArrColl.getItemAt(0) as ArrayCollection;
				var newcategory1List:ArrayCollection 	= resultArrColl.getItemAt(1) as ArrayCollection;
				var newcategory2List:ArrayCollection 	= resultArrColl.getItemAt(2) as ArrayCollection;
				var newprojectList:ArrayCollection 		= resultArrColl.getItemAt(3) as ArrayCollection;
				
				var newteamlineList:ArrayCollection 	= resultArrColl.getItemAt(4) as ArrayCollection;
				var newphasesList:ArrayCollection 		= resultArrColl.getItemAt(5) as ArrayCollection;
				var newtasksList:ArrayCollection 		= resultArrColl.getItemAt(6) as ArrayCollection;
				var newpropertiesspjList:ArrayCollection = resultArrColl.getItemAt(7) as ArrayCollection;
				
				trace("createOracleProjectResult newcategorydomainList:"+newcategorydomainList.length);
				trace("createOracleProjectResult newcategory1List:"+newcategory1List.length);
				trace("createOracleProjectResult newcategory2List:"+newcategory2List.length);
				
				trace("createOracleProjectResult newprojectList:"+newprojectList.length);
				trace("createOracleProjectResult newteamlineList:"+newteamlineList.length);
				trace("createOracleProjectResult newphasesList:"+newphasesList.length);
				trace("createOracleProjectResult newpropertiesspjList:"+newpropertiesspjList.length);
							
					//loginUtils.getOracleCategoryResult( newcategorydomainList );
					loginUtils.getOracleCategoryDomainResult( newcategorydomainList );
					loginUtils.getOracleCategory1Result( newcategory1List );
					loginUtils.getOracleCategory2Result( newcategory2List );
				loginUtils.createOracleNewProjectResult( newprojectList );
				loginUtils.getTeamLineOracleProjectResult( newteamlineList );
				loginUtils.createBulkUpdatePhasesResult( newphasesList );
				loginUtils.createOracleBulkTasksResult( newtasksList );
				loginUtils.createOracleupdateResult( newpropertiesspjList )
			}
}
		
		private function getProjectUpdateName( rpcEvent:Object ):void {
			super.result( rpcEvent );
			var eventprjcomments:TasksEvent = new TasksEvent( TasksEvent.EVENT_PUSH_PROJECTNOTES );		
	  		eventprjcomments.dispatch();
		}
		
		private function updateStatusProjectResult( rpcEvent:Object ):void {			
			
			model.currentProjects = Projects( rpcEvent.message.body );
			Utils.refreshPendingCollection( model.currentProjects );			
			
			var evArr:Array = [];
			
			var handler:IResponder = new Callbacks( getLastTasks, fault );
			var getAllTask:TasksEvent = new TasksEvent( TasksEvent.EVENT_FETCH_TASKS, handler );
			evArr.push( getAllTask );
			
			if( model.currentProjects.projectStatusFK == ProjectStatus.ABORTED ) {
				
				model.currentProjectTasksCollection.filterFunction = null;
				model.currentProjectTasksCollection.refresh(); 
				
				var updatetask:TasksEvent = new TasksEvent( TasksEvent.EVENT_BULKUPDATE_TASKSSTATUS );
				evArr.push( updatetask );
				
	  		}
	  		else {
	  			var eventproducer:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PUSH_PROJECTSTATUS_TEAMLINE );
				eventproducer.projectId = model.currentProjects.projectId;
				evArr.push( eventproducer ); 		
	  		}
	  		
	  		var taskSeq:SequenceGenerator = new SequenceGenerator( evArr );
	  		taskSeq.dispatch();
	  		super.result( rpcEvent );
		}
		
		private function getLastTasks( rpcEvent:Object ):void {
			
			if( model.currentProjects.projectStatusFK != ProjectStatus.ABORTED &&  model.currentProjects.projectStatusFK != ProjectStatus.URGENT ) {
				
				model.currentProjectTasksCollection.filterFunction = checkLastItem;
				model.currentProjectTasksCollection.refresh();		
				
				if( model.currentProjects.projectStatusFK == ProjectStatus.STANDBY ) {     
					
					model.workflowState = 0;
					
					var taskEvent:TasksEvent = new TasksEvent( TasksEvent.CREATE_STANDBY_TASKS );
					taskEvent.tasks = createStandByTask();	
					
					var updatetaskEvent:TasksEvent = new TasksEvent( TasksEvent.UPDATE_LAST_TASKS );
					model.messageBulkMailCollection = new ArrayCollection();
					
					var messageevent:ProjectMessageEvent = new ProjectMessageEvent( ProjectMessageEvent.EVENT_SEND_MESSAGETOALL );
					messageevent.subject = 'Project Changed into Stand By';
					messageevent.body = 'Project Changed into Stand By';
					
					var handler:IResponder = new Callbacks( result, fault );
					var standBySeq:SequenceGenerator = new SequenceGenerator( [ taskEvent, updatetaskEvent, messageevent ], handler );
		  			standBySeq.dispatch();
		 		 }
		 		 else if( model.currentProjects.projectStatusFK == ProjectStatus.INPROGRESS ) {
		 		 	
		 		 	if( model.currentTasks && model.currentTasks.workflowtemplateFK.taskCode == 'SBY' ) {
						
						var inprogressEvent:TasksEvent = new TasksEvent( TasksEvent.CREATE_STANDBY_TASKS );
						inprogressEvent.tasks = getPrevTask();
						model.lastTask = model.currentTasks;
						
						var status:Status = new Status()
						status.statusId = TaskStatus.FINISHED; 
						model.lastTask.taskStatusFK = status.statusId;
						model.lastTask.tDateEnd = model.currentTime;						
						
						var updatestandbyTasEvent:TasksEvent = new TasksEvent( TasksEvent.UPDATE_LAST_TASKS );
						
						var prjMessageevent:ProjectMessageEvent = new ProjectMessageEvent( ProjectMessageEvent.EVENT_SEND_MESSAGETOALL );
						prjMessageevent.subject = 'Project Changed into Inprogress';
						prjMessageevent.body = 'Project Changed into Inprogress';						
						
						var inprogHandler:IResponder = new Callbacks( result, fault );
						var inprogSeq:SequenceGenerator = new SequenceGenerator( [ inprogressEvent, updatestandbyTasEvent, prjMessageevent ], inprogHandler );
		  				inprogSeq.dispatch();
		  			}
		 		 }				
			}
			else {
				//Update the Main Project View If it is Opened
				if( model.mainProjectState == 1 ) {
					if( model.updateMPV )	model.updateMPV = false;
					else	model.updateMPV = true;
				}
			}
		}
		
		private function getPrevTask():Tasks {
			var prevTask:Tasks; 
			prevTask = model.currentTasks.previousTask; 
			
			var tasks:Tasks = new Tasks();
			tasks.workflowtemplateFK = prevTask.workflowtemplateFK;
			tasks.projectObject = prevTask.projectObject;
			
			var status1 : Status = new Status();
			tasks.previousTask =  prevTask.previousTask;
			
			var status : Status = new Status();
			status.statusId = TaskStatus.WAITING;
			tasks.taskStatusFK = status.statusId;
			tasks.personDetails = prevTask.personDetails;
			tasks.tDateCreation = model.currentTime;
			tasks.tDateEndEstimated = Utils.getCalculatedDate( model.currentTime, tasks.workflowtemplateFK.defaultEstimatedTime ); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;
			tasks.onairTime = 54;
			return tasks;
		}
		
		private function createStandByTask():Tasks{
			var tasks:Tasks = new Tasks();
			tasks.workflowtemplateFK = Utils.getWorkflowTemplates( model.standByTemplatesCollection, model.lastTask.workflowtemplateFK.workflowFK );
			tasks.projectObject = model.lastTask.projectObject;
			model.lastTask.tDateEnd = model.currentTime;
			
			var status1 : Status = new Status();
			tasks.previousTask =  model.lastTask;
			
			var status : Status = new Status();
			status.statusId = TaskStatus.WAITING;
			tasks.taskStatusFK = status.statusId;
			tasks.tDateCreation = model.currentTime;
			tasks.tDateEndEstimated = Utils.getCalculatedDate( model.currentTime,tasks.workflowtemplateFK.defaultEstimatedTime ); 
			tasks.estimatedTime = tasks.workflowtemplateFK.defaultEstimatedTime;
			tasks.onairTime = 54;
			model.lastTask.nextTask = tasks;
			status1.statusId = TaskStatus.FINISHED; 
			model.lastTask.taskStatusFK = status1.statusId;
			model.lastTask.tDateEnd = model.currentTime;
			return tasks;	
		}
		
		private function checkLastItem( item:Tasks ):Boolean {
			if( ( item.workflowtemplateFK.taskCode != 'M01' ) && ( item.taskStatusFK != TaskStatus.FINISHED ) ) {
				model.lastTask = item;
			}
			return true;
		}
		
		private var curTsk:Tasks
		public function getPushProjectIDDetails(rpcEvent : Object) : void { 
			super.result(rpcEvent);
			var arr:Array= rpcEvent.result.getItemAt( 0 );
			var prj:Projects = arr[0] as Projects;
			curTsk = arr[1] as Tasks;
			prj.currentTaskDateStart = curTsk.tDateCreation;
			prj.wftFK = curTsk.wftFK;
			prj.finalTask = curTsk;
			model.modifiedProject = prj; 
			if( model.currentProjects.taskDateStart )	model.modifiedProject.taskDateStart = model.currentProjects.taskDateStart;
			if( model.currentProjects.taskDateEnd )	model.modifiedProject.taskDateEnd = model.currentProjects.taskDateEnd;
			if(model.currentProjects.projectId == model.modifiedProject.projectId){
				model.currentProjects = model.modifiedProject;
				model.currentProjects.propertiespjSet = model.modifiedProject.propertiespjSet;
			}
			updateTasksCollection(model.modifiedProject);
			Utils.refreshPendingCollection( model.modifiedProject );
		}
		
		public function getPushProjectDetails(rpcEvent : Object) : void { 
			super.result(rpcEvent);
			var arr:Array= rpcEvent.result.getItemAt( 0 );
			var prj:Projects = arr[0] as Projects;
			curTsk = arr[1] as Tasks;
			prj.currentTaskDateStart = curTsk.tDateCreation;
			prj.wftFK = curTsk.wftFK;
			prj.finalTask = curTsk; 
			var tempprj:Projects = model.currentProjects
			model.modifiedProject = prj; 
			if( model.currentProjects.taskDateStart )	model.modifiedProject.taskDateStart = model.currentProjects.taskDateStart;
			if( model.currentProjects.taskDateEnd )	model.modifiedProject.taskDateEnd = model.currentProjects.taskDateEnd;
			if(model.currentProjects.projectId == model.modifiedProject.projectId){
				model.currentProjects = model.modifiedProject;
				model.currentProjects.presetTemplateFK = tempprj.presetTemplateFK;
				model.currentProjects.propertiespjSet = model.modifiedProject.propertiespjSet;
				model.currentProjects.wftFK = model.modifiedProject.wftFK;
				model.currentProjects.finalTask = model.modifiedProject.finalTask;
				model.currentProjects.currentTaskDateStart = model.modifiedProject.currentTaskDateStart;
			}
			
			//Extra afftect - for previous Project change
			for each(var prj:Projects in model.projectsCollection){
				if(prj.presetTemplateFK.presetstemplateId == model.modifiedProject.presetTemplateFK.presetstemplateId){
					prj.presetTemplateFK = model.modifiedProject.presetTemplateFK
				}
			}
			
			//model.currentProjects = model.modifiedProject;
			//model.currentProjects.propertiespjSet = model.modifiedProject.propertiespjSet;
			updateTasksCollection(model.modifiedProject);
			Utils.refreshPendingCollection( model.modifiedProject );
			if(projectsEvent.propertChange == 'PropPresetTemplateChange'){
				var getPresetTemplate:PresetTemplateEvent = new PresetTemplateEvent(PresetTemplateEvent.EVENT_GET_PRESET_TEMPLATEID)
				getPresetTemplate.presetTemplatesId = model.modifiedProject.presetTemplateID;
				getPresetTemplate.dispatch();
			} 
		} 
		
		private function updateTasksCollection(prj:Projects):void{
				var domain:Categories = getDomains(prj.categories);	
				for each(var item:Object in model.taskCollection){
					if( item.domain.categoryId != null ) {
						if( item.domain.categoryId == domain.categoryId ){
								for each(var taskItem:Tasks in item.tasks){
									if(projectsEvent.propertChange == 'PropPresetTemplateChange'){
										if(taskItem.projectObject.presetTemplateFK.presetstemplateId == prj.presetTemplateFK.presetstemplateId){
											taskItem.projectObject.presetTemplateFK = prj.presetTemplateFK;
										}
									} 
									if(taskItem.projectObject.projectId == prj.projectId){
										taskItem.projectObject = prj;
										taskItem.projectObject.propertiespjSet = prj.propertiespjSet;
										
									}
								}								
							}
						}
				}
				model.taskCollection.refresh();
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
		public function updateProjectResult( rpcEvent : Object ) : void
		{ 
			var tempPrj:Projects = Projects(rpcEvent.message.body);
			tempPrj.presetTemplateFK = model.currentProjects.presetTemplateFK
			model.currentProjects = tempPrj
			var arrc:ArrayCollection = new ArrayCollection();
			arrc.list = model.propertiespresetsCollection.list;
			arrc.refresh();
			model.propertiespresetsCollection.list = arrc.list;
			model.propertiespresetsCollection.refresh();
			if(model.currentProjects.projectStatusFK== ProjectStatus.ARCHIVED){
				var phases:ArrayCollection = model.currentProjects.phasesSet;
				for each(var ph:Phases in phases){
					if(ph.phaseTemplateFK == model.currentTasks.workflowtemplateFK.phaseTemplateFK){
						ph.phaseEnd = model.currentTime;
						ph.phaseDuration = Math.ceil( ( ph.phaseEnd.getTime() - ph.phaseStart.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
						var planneddelay : Number = Math.ceil( ( ph.phaseEndPlanified.getTime() - ph.phaseEnd.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
						planneddelay = 0 -( planneddelay );
						ph.phaseDelay = planneddelay;  
					}
				}
				var updateCloseTask:TasksEvent = new TasksEvent(TasksEvent.EVENT_UPDATE_CLOSETASKS);
				var updatePhase:PhasesEvent = new PhasesEvent(PhasesEvent.EVENT_UPDATE_LASTPHASE);
				updatePhase.phasesCollection = phases;
				var updateBulkCloseTask:TasksEvent = new TasksEvent(TasksEvent.EVENT_BULKUPDATE_CLOSETASKS);
				var eventsArr:Array = [updateCloseTask,updatePhase,updateBulkCloseTask]  
	 			var handler:IResponder = new Callbacks(result,fault)
	 			var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  			newProjectSeq.dispatch(); 
	  			for( var i:int = 0;i < model.catagory2.length;i++ ) {
	  				var projectSet:ArrayCollection = Categories( model.catagory2.getItemAt( i ) ).projectSet;
	  				for( var j:int = 0;j < projectSet.length;j++ ) {
	  					if( Projects( projectSet.getItemAt( j ) ).projectId == model.currentProjects.projectId ) {
	  						Projects( projectSet.getItemAt( j ) ).projectDateEnd = model.currentProjects.projectDateEnd;
	  						break;
	  					}
	  				}
	  			}
	  			model.domainCollection1.refresh();
	  		}		
			super.result(rpcEvent);
		}
		
		private function updateProjectNotesResult( rpcEvent:Object ):void {
			
			if( model.currentProjects.taskDateStart ) {
				Projects( rpcEvent.message.body ).taskDateStart = model.currentProjects.taskDateStart;
			}	
			if( model.currentProjects.taskDateEnd ) {
				Projects( rpcEvent.message.body ).taskDateEnd = model.currentProjects.taskDateEnd;
			}	
			if( model.currentProjects.finalTask ) {
				Projects( rpcEvent.message.body ).finalTask = model.currentProjects.finalTask;
			}
			
			model.currentProjects = Projects( rpcEvent.message.body );	
			
			var eventprjcomments:TasksEvent = new TasksEvent( TasksEvent.EVENT_PUSH_PROJECTNOTES );		
	  		eventprjcomments.dispatch();
	  		
	  		super.result( rpcEvent );
		}
		
		public function getProjectResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			var resultAC:ArrayCollection= rpcEvent.result as ArrayCollection;
			model.projectsCollection.removeAll();
			for each(var arr:Array in resultAC){
				var prj:Projects = arr[0] as Projects;
				curTsk = arr[1] as Tasks;
				prj.currentTaskDateStart = curTsk.tDateCreation;
				prj.wftFK = curTsk.wftFK;
				prj.finalTask = curTsk;
				model.projectsCollection.addItem(prj) 
			}
			model.projectSelectionCollection = new ArrayCollection();
			// cat 2 creation
			var projectsCollection_Len:int=model.projectsCollection.length;
			for(var i : int = 0; i < projectsCollection_Len;i++) {
				var proj : Projects = model.projectsCollection.getItemAt(i) as Projects;
				proj.categories.domain = proj.categories.categoryFK.categoryFK;
				if( !proj.categories.projectSet )	proj.categories.projectSet = new ArrayCollection();
				Utils.checkDuplicateItem( proj, proj.categories.projectSet, "projectId" );
				proj.categories.projectSet.addItem( proj );
				if( !Utils.checkDuplicateItem( proj.categories, model.catagory2, "categoryId" ) ) {
					model.catagory2.addItem( proj.categories );
				}
			}
			// cat 1 creation
			var catagory2_Len:int=model.catagory2.length;
			for(var j : int = 0; j < catagory2_Len;j++) 	{
				var cat2 : Categories = model.catagory2.getItemAt(j) as Categories;
				if( !Utils.checkDuplicateItem( cat2, cat2.categoryFK.childCategorySet, "categoryId" ) )
					cat2.categoryFK.childCategorySet.addItem(cat2);
				if( !Utils.checkDuplicateItem( cat2.categoryFK, model.catagory1, "categoryId" ) )
					model.catagory1.addItem( cat2.categoryFK );
			}
			// dom creation
			var catagory1_Len:int=model.catagory1.length;
			for(var k : int = 0; k < catagory1_Len;k++) {
				var cat1 : Categories = model.catagory1.getItemAt(k) as Categories;
				if( !Utils.checkDuplicateItem( cat1, cat1.categoryFK.childCategorySet, "categoryId" ) )
					cat1.categoryFK.childCategorySet.addItem(cat1);
				if( !Utils.checkDuplicateItem( cat1.categoryFK, model.domainCollection1, "categoryId" ) )
					model.domainCollection1.addItem( cat1.categoryFK );
			}
			model.domainCollection1.refresh();
			model.catagoriesState = true;
		} 
		public function createProjectResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			model.project = Projects(rpcEvent.message.body);
			model.currentProjects = model.project;	
			model.newProjectCreated = true;	
			if( model.catagory1.length == 0 )
			{
				var cat1 : Categories = model.project.categories.categoryFK;
				var category2 : Categories = model.project.categories;
				cat1.childCategorySet.addItem( category2 );
				category2.projectSet = new ArrayCollection();
				category2.projectSet.addItem( model.project );
				model.catagory1.addItem( cat1 );
			}else
			{
				var cat2 : Categories = model.project.categories;
				var catagory1_Len:int=model.catagory1.length;
				for( var i : int = 0;i < catagory1_Len;i++)
				{
					var subCat : ArrayCollection = Categories( model.catagory1.getItemAt( i ) ).childCategorySet;
					var subCat_Len:int=subCat.length;
					
					for( var j : int = 0;j < subCat_Len;j++)
					{
						if( Categories( subCat.getItemAt( j ) ).categoryId == cat2.categoryId )
						{
							Categories( subCat.getItemAt( j ) ).projectSet.addItem( model.project );
						}
					}
				}
			}

			var prjmoveEvent:ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_MOVE_DIRECTORY);
			var dirStr:String = model.parentFolderName+Utils.getDomains(model.currentProjects.categories).categoryName
			+"/"+model.currentProjects.categories.categoryFK.categoryName
			+"/"+model.currentProjects.categories.categoryName+"/";
			prjmoveEvent.frompath = dirStr+StringUtils.compatibleTrim(model.currentProjects.projectName); 
			//model.incrementProjects = model.prefixProjectName+(1000+model.currentProjects.projectId)+"_"+model.currentProjects.projectName;
			model.incrementProjects = model.projectprefix+(1000+model.currentProjects.projectId)+"_"+model.currentProjects.projectName;
			model.currentProjects.projectName = model.incrementProjects;
			prjmoveEvent.topath = dirStr+StringUtils.compatibleTrim(model.currentProjects.projectName); 
			model.currentDir = prjmoveEvent.topath;
				
			//var thandler:IResponder = new Callbacks(personIdResult,fault)
			var teamtempevent : TeamTemplatesEvent = new TeamTemplatesEvent(TeamTemplatesEvent.EVENT_GET_TEAMTEMPLATES);
			var teamlineTemplateEvent : TeamlineTemplatesEvent = new TeamlineTemplatesEvent(TeamlineTemplatesEvent.EVENT_GET_TEAMLINETEMPLATES);
			var teamlineEvent : TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_UPDATE_TEAMLINE);
			var getTeamlineEvent:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_SELECT_TEAMLINE );
			var phasetempleteEvent : PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_GET_PHASESTEMPLATES);
			var phaseEvent : PhasesEvent = new PhasesEvent(PhasesEvent.EVENT_CREATE_BULK_PHASES)
			var taskevent : TasksEvent 
			taskevent= new TasksEvent( TasksEvent.CREATE_INITIAL_TASKS );
			if(model.AutoProj) taskevent= new TasksEvent( TasksEvent.CREATE_AUTO_INITIAL_TASKS );
			
			var bulktaskevent : TasksEvent = new TasksEvent(TasksEvent.CREATE_BULK_TASKS);
			
			var prjNameEvent:ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_UPDATE_PROJECTNAME);
			 
			var eventsArr:Array = [prjmoveEvent,teamtempevent,
									teamlineTemplateEvent,
									teamlineEvent,
									getTeamlineEvent,
								    phasetempleteEvent ,
									phaseEvent,
									prjNameEvent,
									taskevent,
									bulktaskevent ]
			if(model.refFilesDetails.length>0){			
				var dupFileDetails:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_DUPLICATE_FILEDETAILS);
				eventsArr.push(dupFileDetails);
			}
			var propevent : PropertiespjEvent = new PropertiespjEvent(PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ);
			eventsArr.push(propevent);
			
	 		var handler:IResponder = new Callbacks(personIdResult,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch();
		}
		public function createAutoProjectResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			model.project = Projects(rpcEvent.message.body);
			model.currentProjects = model.project;	
			var eventsArr:Array = []
			var thandler:IResponder = new Callbacks(personIdResult,fault)
			for each(var team:Teamlines in model.teamLineArrayCollection){
				team.projectID = model.project.projectId;
			}
			var teamlineEvent : TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_UPDATE_TEAMLINE); 
			var phasetempleteEvent : PhasestemplatesEvent = new PhasestemplatesEvent(PhasestemplatesEvent.EVENT_GET_PHASESTEMPLATES);
			var phaseEvent : PhasesEvent = new PhasesEvent(PhasesEvent.EVENT_CREATE_BULK_PHASES)
 			var propevent : PropertiespjEvent = new PropertiespjEvent(PropertiespjEvent.EVENT_AUTO_UPDATE_PROPERTIESPJ);
			var taskevent : TasksEvent = new TasksEvent( TasksEvent.CREATE_AUTO_INITIAL_TASKS );
				model.propertiespjCollection = new ArrayCollection();
				if(model.referenceProject){
				 	for each(var proppj:Propertiespj in model.referenceProject.propertiespjSet){
						var newPropPj:Propertiespj = new Propertiespj();
						 newPropPj.fieldValue = proppj.fieldValue;
						 newPropPj.projectFk= model.project.projectId;
						 newPropPj.propertyPreset = proppj.propertyPreset;
						 model.propertiespjCollection.addItem(newPropPj);
					} 
				} 
			eventsArr.push( teamlineEvent, 
								    phasetempleteEvent ,
									phaseEvent)
			if(model.propertiespjCollection.length!=0) eventsArr.push(propevent)									
			eventsArr.push(taskevent)
									
			if(model.refFilesDetails.length>0){			
				var dupFileDetails:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_DUPLICATE_FILEDETAILS);
				eventsArr.push(dupFileDetails);
			} 
			
	 		var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch();
		}
        private function personIdResult(rpcEvent:Object):void{  
			Utils.createTaskMail(model.teamLinetemplatesCollection,true);
        }
		
	}
}
