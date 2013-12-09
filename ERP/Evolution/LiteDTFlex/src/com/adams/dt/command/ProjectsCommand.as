package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.FileNameSplitter;
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
	import com.adams.dt.model.vo.FileCategory;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.PhaseStatus;
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
	
	import flash.filesystem.File;
	
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
		       	case ProjectsEvent.EVENT_PUSH_SELECT_PROJECTS:
		      		delegate.responder = new Callbacks( getPushProjectDetails, fault ); 
		      		delegate.findProjectId( projectsEvent.eventPushProjectsId );
		       	break; 
		      	case ProjectsEvent.EVENT_STATUSUPDATE_PROJECTS:
		       		delegate.responder = new Callbacks( updateStatusProjectResult, fault );
		       		delegate.directUpdate( model.currentProjects );
		       	break;
		      	case ProjectsEvent.EVENT_PUSH_GET_PROJECTSID:
		      		delegate.responder = new Callbacks( getPushProjectIDDetails, fault );
		      		delegate.findProjectId( projectsEvent.eventPushProjectsId );
		       	break;   
		       	case ProjectsEvent.EVENT_UPDATE_PROJECTNAME:
		       		delegate.responder = new Callbacks( getProjectUpdateName, fault );
		       		delegate.directUpdate( model.currentProjects );
		       	break; 				
		       case ProjectsEvent.EVENT_ORACLE_NEWPROJECTCALL: 
		       		delegate = DelegateLocator.getInstance().pagingDelegate;					
					delegate.responder = new Callbacks( createOracleProjectResult, fault );	
					var phaseColl:ArrayCollection = Utils.getIntialPhases(Utils.makePhasesSet(1  , model.currentTime) , 1 );
					var projectComments:String = '';
					if( model.newProject.projectComment ) {
						projectComments = model.newProject.projectComment.toString();
					}	
					var categories2:Categories = model.categories2;
					//DIADEM -82/CARAFOUR -2				 
					if(projectsEvent.endTaskCode == 'P3T02A'){
					 	model.categories1.categoryFK.categoryId = 82; //AdminTool default FLEURYMICHON
					}
					Utils.traceLog("ProjectCommand Calling projectprefix :"+model.projectprefix+" , projectName :"+model.newProject.projectName+" , projectComments :"+projectComments.toString()
				     +" , categoryId :"+model.categories1.categoryFK.categoryId+" , projectCreatePersonId :"+projectsEvent.projectCreatePersonId+" , parentFolderName :"+model.parentFolderName+" , domain :"+model.domain
				     +" , categories1 Object :"+model.categories1.categoryName+" , categories2 Object :"+model.categories2.categoryName+" , workflowFK :"+model.newProject.workflowFK+" , codeEAN :"+projectsEvent.codeEAN+" , codeGEST :"+projectsEvent.codeGEST+" , codeIMPRE :"+projectsEvent.codeIMPRE+" , currentImpremiuerID :"+model.currentImpremiuerID
				     +" , phase 0 :"+phaseColl.getItemAt(0).toString()+" , phase 2 :"+phaseColl.getItemAt(2).toString()+" , phase 1 :"+phaseColl.getItemAt(1).toString()
				     +" , phase 3 :"+phaseColl.getItemAt(3).toString()+" , phase 4 :"+ phaseColl.getItemAt(4).toString()+" , phase 5 :"+phaseColl.getItemAt(5).toString()+" , PhaseStatus :"+PhaseStatus.WAITING+" , workflowTemplateId :"+model.workflowstemplates.workflowTemplateId+" , endTaskCode :"+projectsEvent.endTaskCode);//'P1T02A');
     
					this.delegate.createOracleNewProject(model.projectprefix,model.newProject.projectName,projectComments,
					model.categories1.categoryFK.categoryId,projectsEvent.projectCreatePersonId,model.parentFolderName,model.domain,
					model.categories1,model.categories2,model.newProject.workflowFK,projectsEvent.codeEAN,projectsEvent.codeGEST,projectsEvent.codeIMPRE,model.currentImpremiuerID,
					phaseColl.getItemAt(0).toString(),phaseColl.getItemAt(2).toString(),phaseColl.getItemAt(1).toString(),
					phaseColl.getItemAt(3).toString(), phaseColl.getItemAt(4).toString(),phaseColl.getItemAt(5).toString(),PhaseStatus.WAITING,model.workflowstemplates.workflowTemplateId,projectsEvent.endTaskCode);//'P1T02A');  // P1T02A --- DYANMIC pass P5T03A
		       	break;
		       	case ProjectsEvent.EVENT_ORACLE_CLOSEPROJECT:
		       		delegate = DelegateLocator.getInstance().pagingDelegate;	
		      		delegate.responder = new Callbacks( closeProjectResult, fault );
		       		delegate.closeProjects(model.currentProjects.projectId, model.currentTasks.taskId, 
		       			model.currentProjects.workflowFK, model.currentTaskComment, 
		       			projectsEvent.prop_presetId, projectsEvent.prop_fieldvalue, 
		       			projectsEvent.projectclosingMode, model.person.personId); //p_closingMode - Termination mode ('archived' or 'aborted')
		      	break;  
		      	default:
		       	break; 
		      }
		}
		private function closeProjectResult( rpcEvent : Object ) : void {
			super.result( rpcEvent );
			if( rpcEvent.result ) {
				var resultCollection:ArrayCollection = rpcEvent.result as ArrayCollection;
				
				var loginUtils:LoginUtils  = new LoginUtils();
				var closeprojectList:ArrayCollection 			= resultCollection.getItemAt( 0 ) as ArrayCollection;
				var propertyFieldValueList:ArrayCollection 		= resultCollection.getItemAt( 1 ) as ArrayCollection;
				var propertyPresetList:ArrayCollection 			= resultCollection.getItemAt( 2 ) as ArrayCollection;
				var propertyIdList:ArrayCollection 				= resultCollection.getItemAt( 3 ) as ArrayCollection;				
				var phasesList:ArrayCollection 					= resultCollection.getItemAt( 4 ) as ArrayCollection;
				var closeTasksList:ArrayCollection				= resultCollection.getItemAt( 5 ) as ArrayCollection;
				var closeworflowtemplatesList:ArrayCollection 	= resultCollection.getItemAt( 6 ) as ArrayCollection;
				
				loginUtils.closeProjectResult( closeprojectList );
				loginUtils.closePropertiesSPJ(propertyFieldValueList,propertyPresetList,propertyIdList);
				loginUtils.closeLastPhaseResult(phasesList);
				loginUtils.closeBulkTaskResult(closeTasksList);
				loginUtils.closeTasksWorkflowTemplatesResult(closeworflowtemplatesList);
			}
		}
		
		private function createOracleProjectResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
			Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- Before Calling");
			var resultArrColl:ArrayCollection = rpcEvent.result as ArrayCollection;
			if( resultArrColl ) {
				Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- "+resultArrColl.length);
				var loginUtils:LoginUtils  = new LoginUtils();
				var newcategorydomainList:ArrayCollection = resultArrColl.getItemAt( 0 ) as ArrayCollection;
				var newcategory1List:ArrayCollection 	= resultArrColl.getItemAt( 1 ) as ArrayCollection;
				var newcategory2List:ArrayCollection 	= resultArrColl.getItemAt( 2 ) as ArrayCollection;
				var newprojectList:ArrayCollection = resultArrColl.getItemAt( 3 ) as ArrayCollection;
				
				var newteamlineList:ArrayCollection = resultArrColl.getItemAt( 4 ) as ArrayCollection;
				var newphasesList:ArrayCollection	= resultArrColl.getItemAt( 5 ) as ArrayCollection;
				var newtasksList:ArrayCollection = resultArrColl.getItemAt( 6 ) as ArrayCollection;
				var newpropertiesspjList:ArrayCollection = resultArrColl.getItemAt( 7 ) as ArrayCollection;
					
					
			Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- "+newcategorydomainList.length);
			Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- "+newcategory1List.length);
			Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- "+newcategory2List.length);
			Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- "+newprojectList.length);
			Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- "+newteamlineList.length);
			Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- "+newphasesList.length);
			Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- "+newtasksList.length);
			Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result -- "+newpropertiesspjList.length);

					
				loginUtils.getOracleCategoryDomainResult( newcategorydomainList );
				loginUtils.getOracleCategory1Result( newcategory1List );
				loginUtils.getOracleCategory2Result( newcategory2List );
				loginUtils.createOracleNewProjectResult( newprojectList );
				loginUtils.getTeamLineOracleProjectResult( newteamlineList );
				loginUtils.createBulkUpdatePhasesResult( newphasesList );
				loginUtils.createOracleBulkTasksResult( newtasksList );
				loginUtils.createOracleupdateResult( newpropertiesspjList )
				
				var taskArc:ArrayCollection = rpcEvent.result.getItemAt( 6 ) as ArrayCollection;
				var fileTask:Tasks = taskArc.getItemAt( 0 ) as Tasks;
								
				/**
				 * Copied from create Initial task result
				 * Included for file upload
				 * */
				for each( var item:FileDetails in model.currentProjectFiles ) {
					item.projectFK = model.currentProjects.projectId;
					item.taskId = model.createdTask.taskId;
					
					var filename:String = item.fileName; 
					var splitObject:Object = FileNameSplitter.splitFileName( item.fileName );
					
					if( item.taskId ) {
						filename = splitObject.filename + item.taskId;
		   			}
		   			item.storedFileName = filename + DateUtil.getFileIdGenerator() + "." + splitObject.extension;
					item.destinationpath = model.currentDir;
					item.downloadPath = onUpload( item );
					model.filesToUpload.addItem( item );
				}
				
				model.currentProjectFiles.removeAll();
				
				/* if( !model.referenceFiles ) {
					model.referenceFiles = new ArrayCollection();
				}
				
				for each( var refItem:FileDetails in model.refFilesDetails ) {
					if( refItem.type == "Basic" ) {
						var fileduplicate:FileDetails = new FileDetails();
			    		fileduplicate = refItem;
			    		fileduplicate.fileId = 0;
			    		fileduplicate.taskId = fileTask.taskId;
			    		fileduplicate.projectFK = model.currentProjects.projectId;
			    		fileduplicate.fileCategory = FileCategory.REFERENCE;
			    		model.referenceFiles.addItem( fileduplicate);
			    	}
			 	} 

				trace("ProjectCommand Calling..: createOracleProjectResult result OUTER-- ");

				if( model.referenceFiles.length > 0 ){
					Utils.traceLog("ProjectCommand Calling..: createOracleProjectResult result referncefile inner-- ");
	
					var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_REF_FILEDETAILS );
					fileEvent.dispatch();
				}
				else { 
					trace("ProjectCommand Calling..: createOracleProjectResult result referncefile else with file backgroundupload-- ");
	 			*/
					model.bgUploadFile.idle = true;
					model.bgUploadFile.fileToUpload = model.filesToUpload;
					model.refFilesDetails.removeAll(); 
				//}
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
		
		private function getProjectUpdateName( rpcEvent:Object ):void {
			super.result( rpcEvent );
			var eventprjcomments:TasksEvent = new TasksEvent( TasksEvent.EVENT_PUSH_PROJECTNOTES );		
	  		eventprjcomments.dispatch();
		}
		
		private function updateStatusProjectResult( rpcEvent:Object ):void {			
			
			model.currentProjects= Utils.updateCurrentProject(Projects( rpcEvent.message.body ))	
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
				model.currentProjects= model.modifiedProject;
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
				model.currentProjects= model.modifiedProject;
				model.currentProjects.presetTemplateFK = tempprj.presetTemplateFK;
				model.currentProjects.propertiespjSet = model.modifiedProject.propertiespjSet;
				model.currentProjects.wftFK = model.modifiedProject.wftFK;
				model.currentProjects.finalTask = model.modifiedProject.finalTask;
				model.currentProjects.currentTaskDateStart = model.modifiedProject.currentTaskDateStart;
			}
			
			//Extra afftect - for previous Project change
			for each(var prjs:Projects in model.projectsCollection){
				if(prjs.presetTemplateFK.presetstemplateId == model.modifiedProject.presetTemplateFK.presetstemplateId){
					prjs.presetTemplateFK = model.modifiedProject.presetTemplateFK
				}
			}
			
			//model.currentProjects= model.modifiedProject;
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
			model.currentProjects= Utils.updateCurrentProject(tempPrj)	
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
			/*if( model.currentProjects.taskDateStart ) {
				Projects( rpcEvent.message.body ).taskDateStart = model.currentProjects.taskDateStart;
			}	
			if( model.currentProjects.taskDateEnd ) {
				Projects( rpcEvent.message.body ).taskDateEnd = model.currentProjects.taskDateEnd;
			}	
			if( model.currentProjects.finalTask ) {
				Projects( rpcEvent.message.body ).finalTask = model.currentProjects.finalTask;
			}*/
			model.currentProjects= Utils.updateCurrentProject(Projects( rpcEvent.message.body ))	
			
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
				if(proj.categories.categoryFK){					
					proj.categories.domain = proj.categories.categoryFK.categoryFK;
				}
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
			model.currentProjects= Utils.updateCurrentProject(Projects( rpcEvent.message.body ))	
			model.newProjectCreated = true;	
			if( model.catagory1.length == 0 )
			{
				var cat1 : Categories = model.currentProjects.categories.categoryFK;
				var category2 : Categories = model.currentProjects.categories;
				cat1.childCategorySet.addItem( category2 );
				category2.projectSet = new ArrayCollection();
				category2.projectSet.addItem( model.currentProjects  );
				model.catagory1.addItem( cat1 );
			}else
			{
				var cat2 : Categories = model.currentProjects.categories;
				var catagory1_Len:int=model.catagory1.length;
				for( var i : int = 0;i < catagory1_Len;i++)
				{
					var subCat : ArrayCollection = Categories( model.catagory1.getItemAt( i ) ).childCategorySet;
					var subCat_Len:int=subCat.length;
					
					for( var j : int = 0;j < subCat_Len;j++)
					{
						if( Categories( subCat.getItemAt( j ) ).categoryId == cat2.categoryId )
						{
							Categories( subCat.getItemAt( j ) ).projectSet.addItem(model.currentProjects  );
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
			model.currentProjects= Utils.updateCurrentProject(Projects( rpcEvent.message.body ))			
			var eventsArr:Array = []
			var thandler:IResponder = new Callbacks(personIdResult,fault)
			for each(var team:Teamlines in model.teamLineArrayCollection){
				team.projectID = model.currentProjects.projectId;
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
						 newPropPj.projectFk= model.currentProjects.projectId;
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
