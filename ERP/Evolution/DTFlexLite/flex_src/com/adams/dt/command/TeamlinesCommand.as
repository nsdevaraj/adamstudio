package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Presetstemplates;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Teamlines;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.rpc.IResponder;
	
	public final class TeamlinesCommand extends AbstractCommand 
	{ 
		private var teamlineEvent : TeamlineEvent;	
		public  var teamline:Teamlines	
		private var _currentDelayed:Projects;
		private var _createTeamlines:ArrayCollection;
		
		override public function execute( event:CairngormEvent ):void {	 
			
			super.execute( event );
			
			teamlineEvent = TeamlineEvent( event );
			this.delegate = DelegateLocator.getInstance().teamlineDelegate;
			this.delegate.responder = new Callbacks( result, fault );
			
			switch( event.type ) {    
		        case TeamlineEvent.EVENT_GET_ALL_TEAMLINE:
		        break;  
		        case TeamlineEvent.EVENT_CREATE_TEAMLINE:
		        	 delegate.responder = new Callbacks( createResult, fault );
			         delegate.bulkUpdate( teamlineEvent.teamlineCollection );
		        break;
		        case TeamlineEvent.EVENT_DELETEALL:
		        	 delegate.responder = new Callbacks(result,fault);
			         delegate.deleteAll();		        
		        break;  
		        case TeamlineEvent.EVENT_UPDATE_TEAMLINE:
		             delegate.responder = new Callbacks( bulkUpdateResult, fault );
		             delegate.bulkUpdate( model.teamLineArrayCollection );
		         break;
		         case TeamlineEvent.EVENT_UPDATE_IMPTEAMLINE:
		        	  delegate.responder = new Callbacks( impUpdateResult, fault );
		         	  delegate.update( model.impTeamlineObj );
		         break; 
		         case TeamlineEvent.EVENT_DELETE_TEAMLINE:
		       		 if( model.teamlLineCollection.length > 0 ) {
		        		 teamline = Teamlines( model.teamlLineCollection.getItemAt( 0 ) );
		        		 _createTeamlines = teamlineEvent.teamlineCollection; 
		        		 deleteSeletedteamLine( teamline );
		        	 }
		         break;
		         case TeamlineEvent.EVENT_DELETE_TEAMLINE_UNSELECTPERSON:
		       		delegate = DelegateLocator.getInstance().teamlineDelegate;
    				delegate.deleteVO( teamlineEvent.teamline ); 	
		         break;
		         case TeamlineEvent.EVENT_PROJECT_TEAMLINE:
		        	 delegate.responder = new Callbacks( getProjectTeamlineResult, fault );
			         delegate.getByProjectId( teamlineEvent.projectId ); 	
		         break; 
		         case TeamlineEvent.EVENT_CURRENT_PROJECT_TEAMLINE:
		        	 delegate.responder = new Callbacks(getProjectCloseResult,fault);
			         delegate.getByProjectId(teamlineEvent.projectId); 
	             break;  
		         case TeamlineEvent.EVENT_SELECT_TEAMLINE:
		        	 delegate.responder = new Callbacks( getTeamLineProjectResult, fault );
		        	 delegate.getByProjectId( TeamlineEvent( event ).projectId ); 
	             break; 
		         case TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE:
		        	 delegate.responder = new Callbacks( createTeamLineResult, fault );
		        	 if( model.createdTask ) {
		       			delegate.findByTeamLinesId( model.createdTask.workflowtemplateFK.profileFK, model.createdTask.projectObject.projectId );
		        	 }
		         break; 
		         case TeamlineEvent.EVENT_PUSH_PROJECT_TEAMLINE:
		        	 delegate.responder = new Callbacks( getTeamLineProjectId, fault );
			         delegate.getByProjectId( teamlineEvent.projectId );			         	
		         break; 
		         case TeamlineEvent.EVENT_PUSH_NEWPROJECT:
		        	 delegate.responder = new Callbacks( getTeamLineNewProjectId, fault );
			         delegate.getByProjectId( teamlineEvent.projectId );			         	
		         break; 
		         case TeamlineEvent.EVENT_PUSH_PROJECTSTATUS_TEAMLINE:
		        	delegate.responder = new Callbacks( getUpdateProjectTeamLine,fault );
			        delegate.getByProjectId( teamlineEvent.projectId );			         	
		         break; 
		         case TeamlineEvent.EVENT_PUSH_DELAYSTATUS_TEAMLINE:
		        	delegate.responder = new Callbacks(getDelayTeamLine,fault);
			        delegate.getByProjectId(teamlineEvent.projectId);			         	
		         break; 
		         case TeamlineEvent.EVENT_PUSH_DELAYEDTASKSTATUS_TEAMLINE:
		        	delegate.responder = new Callbacks( getDelayedTaskTeamLine, fault );
		        	_currentDelayed = teamlineEvent.projectObj;
			        delegate.findByTeamLinesId( teamlineEvent.profileId, teamlineEvent.projectObj.projectId );			         	
		         break;
		         case TeamlineEvent.EVENT_GET_IMP_TEAMLINE:
		        	delegate.responder = new Callbacks( getImpTeamLine, fault );
		        	var impProfileId:int = getProfileId('EPR');
			        delegate.findByTeamLinesId( impProfileId, model.currentProjects.projectId );			         	
		         break;
		         case TeamlineEvent.EVENT_PROJECT_ABORTED_TEAMLINE:
		        	delegate.responder = new Callbacks( getProjectAbortedResult, fault );
		        	delegate.getByProjectId( teamlineEvent.projectId ); 	
		         break; 
		         case TeamlineEvent.EVENT_FINISHED_TASK_TEAMLINE:
		        	delegate.responder = new Callbacks( getTasksFinishResult, fault );
			        delegate.getByProjectId( teamlineEvent.projectId ); 	
		         break; 
			     case TeamlineEvent.EVENT_ORACLE_UPDATE_TEAMLINE:
		       		this.delegate = DelegateLocator.getInstance().pagingDelegate;
		       		this.delegate.responder = new Callbacks(oracleUpdateTeamlineResult,fault);	   
		       		this.delegate.oracleUpdateTeamline(teamlineEvent.oracleprojectId,teamlineEvent.oracleprofileId,teamlineEvent.oraclepersonId,teamlineEvent.oraclepropertiesprojectId,teamlineEvent.oraclepropertiespresetId,teamlineEvent.oraclepropertiesfieldvalue);		       		
		       	 break; 
				case TeamlineEvent.EVENT_ORACLE_REFPROJECT_TEAMLINE:
		       		this.delegate = DelegateLocator.getInstance().pagingDelegate;
		       		this.delegate.responder = new Callbacks(oracleCopyFilesTeamlineResult,fault);			       		
		       		this.delegate.createReferenceFiles(teamlineEvent.refProjectId, teamlineEvent.projectId,
		       			teamlineEvent.currentTaskId, teamlineEvent.refTypeName, teamlineEvent.refCategoryName,
		       			teamlineEvent.txtInputImpLength, teamlineEvent.clientTeamlineId,
		       			teamlineEvent.oraclepropertiesprojectId, teamlineEvent.oraclepropertiespresetId, teamlineEvent.oraclepropertiesfieldvalue);		       		
		       	 break; 		       	 
		         default:
		         break; 
		      } 		      
    	} 
    	private function oracleCopyFilesTeamlineResult( rpcEvent:Object ):void {  
    		super.result( rpcEvent ); 
    		
    		if(rpcEvent.result){
	    		Utils.updatePropertiesPj( ( rpcEvent.result ).getItemAt( 0 ) as Array, ( rpcEvent.result ).getItemAt( 1 ) as Array, ( rpcEvent.result ).getItemAt( 2 ) as Array );
	    		     					
				model.teamlLineCollection = ( rpcEvent.result ).getItemAt( 3 ) as ArrayCollection;
				
				model.impPerson = Utils.getProfilePerson( 'EPR' );
				model.impPersonId = model.impPerson.personId;
				model.indPerson = Utils.getProfilePerson( 'IND' );
				model.indPersonId = model.indPerson.personId;
				model.cltPerson = Utils.getProfilePerson( 'CLT' );
				model.cltPersonId = model.cltPerson.personId; 
				model.CP_Person = Utils.getProfilePerson( 'CHP' );
				model.CPP_Person = Utils.getProfilePerson( "CPP" );
				model.comPerson = Utils.getProfilePerson( 'COM' );
				model.agencyPerson = Utils.getProfilePerson( 'AGN' );
				model.techPerson = Utils.getProfilePerson( 'BAT' );
    		}
    	}
    	
    	private function oracleUpdateTeamlineResult( rpcEvent:Object ):void {  
    		super.result( rpcEvent );  
  		
			Utils.updatePropertiesPj( ( rpcEvent.result ).getItemAt( 0 ) as Array, ( rpcEvent.result ).getItemAt( 1 ) as Array, ( rpcEvent.result ).getItemAt( 2 ) as Array );
    		     					
			model.teamlLineCollection = ( rpcEvent.result ).getItemAt( 3 ) as ArrayCollection;
			
			model.impPerson = Utils.getProfilePerson( 'EPR' );
			model.impPersonId = model.impPerson.personId;
			model.indPerson = Utils.getProfilePerson( 'IND' );
			model.indPersonId = model.indPerson.personId;
			model.cltPerson = Utils.getProfilePerson( 'CLT' );
			model.cltPersonId = model.cltPerson.personId; 
			model.CP_Person = Utils.getProfilePerson( 'CHP' );
			model.CPP_Person = Utils.getProfilePerson( "CPP" );
			model.comPerson = Utils.getProfilePerson( 'COM' );
			model.agencyPerson = Utils.getProfilePerson( 'AGN' );
			model.techPerson = Utils.getProfilePerson( 'BAT' );
    	} 
    	
    	private function getTasksFinishResult( rpcEvent:Object ):void {
    		super.result( rpcEvent );
    		model.teamlTaskFinishCollection = rpcEvent.result as ArrayCollection;
    		var handler:IResponder = new Callbacks( result, fault );
 			var eventproducer:TasksEvent = new TasksEvent( TasksEvent.EVENT_FINISHED_TASK, handler );	
 			eventproducer.finishtasks = teamlineEvent.finishTask;
 			eventproducer.dispatch();
    	}
    	
    	private function getProjectTeamlineResult( rpcEvent:Object ):void {
    		super.result( rpcEvent );
    	}
    	
    	private function getProfileId( str:String ):int {
			for each( var pro:Profiles in model.teamProfileCollection ) {
				if( pro.profileCode == str ) {
					return pro.profileId;
				}
			}
			return 0;
		}
    	
    	private function getImpTeamLine( rpcEvent:Object ):void {
    		model.impTeamlineObj = ArrayCollection( rpcEvent.result ).getItemAt( 0 ) as Teamlines;
    		 super.result( rpcEvent );
    	}
    	
    	private function impUpdateResult( rpcEvent:Object ):void {
    		model.impTeamlineObj = rpcEvent.result as Teamlines;
    		model.impPersonId = model.impTeamlineObj.personID
    		super.result(rpcEvent);
    	}
    	
 		private function getProjectAbortedResult( rpcEvent:Object ):void { 
 			model.teamlLineCollection = rpcEvent.result as ArrayCollection;
 			var eventproducer:TasksEvent = new TasksEvent( TasksEvent.EVENT_GETABORTEDPROJECT_CLOSE );	
 			eventproducer.dispatch();
		}
		
    	private function getDelayTeamLine(rpcEvent : Object) : void { 
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			for each(var curTeam:Teamlines in arrc){ 
				var taskData:Tasks = new Tasks();
				taskData.personDetails = new Persons();
				taskData.projectObject=getProject( curTeam.projectID);
				taskData.personDetails.personId = curTeam.personID;
				var by:ByteArray = new ByteArray()
				var sep:String = "&#$%^!@";
				var str:String = 'DT'+sep+'Project delayed'+sep+''+sep+model.person.personId+","+ model.person.profile.profileId;
				by.writeUTFBytes(str)
				taskData.taskComment = by;
				var status:Status = new Status();
				status.statusId = TaskStatus.WAITING;
				taskData.taskStatusFK = status.statusId;
				taskData.tDateCreation = model.currentTime;
				taskData.workflowtemplateFK = getMessageTemplate(curTeam.profileID,getProject(curTeam.projectID));
				if( taskData.workflowtemplateFK != null ){		
					model.modelDelayTaskArrColl.addItem(taskData);
				}
			} 
			super.result(rpcEvent);
		}
		
		//Added By Deepan to send Alarms for Delayed Tasks on CurrentDate
		private function getDelayedTaskTeamLine( rpcEvent : Object ) : void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			var curTeam:Teamlines = Teamlines( arrc.getItemAt( 0 ) );
			var taskData:Tasks = new Tasks();
			taskData.personDetails = new Persons();
			taskData.projectObject.projectId = curTeam.projectID;
			taskData.personDetails.personId = curTeam.personID;
			var by:ByteArray = new ByteArray();
			var sep:String = "&#$%^!@";
			var str:String = 'DT' + sep + 'Task delayed' + sep+'' + sep+model.person.personId+","+ model.person.profile.profileId;
			by.writeUTFBytes( str );
			taskData.taskComment = by;
			var status:Status = new Status();
			status.statusId = TaskStatus.WAITING;
			taskData.taskStatusFK = status.statusId;
			taskData.tDateCreation = model.currentTime;
			taskData.workflowtemplateFK = getMessageTemplate( curTeam.profileID, _currentDelayed );
			var messageEvent:TasksEvent = new TasksEvent( TasksEvent.CREATE_PROPERTYMSG_TASKS );
			messageEvent.tasks = taskData;
			messageEvent.dispatch();
			super.result( rpcEvent );
		}
		
		private function getProject( prjid:int ):Projects {
			var cursor:IViewCursor = model.delayedProjects.createCursor();
			var prj:Projects = new Projects();
			prj.projectId = prjid;
			var found:Boolean = cursor.findAny( prj ); 
			if( found ) {
				prj = cursor.current as Projects;
			}
			return prj;
		} 
		
		private function getMessageTemplate(pro:int,prj:Projects):Workflowstemplates {
			var messageTemplateCollection:ArrayCollection = Utils.getWorkflowTemplatesCollection(model.messageTemplatesCollection,prj.workflowFK);
			for each(var item:Workflowstemplates in  messageTemplateCollection){
				if(item.profileFK == pro){
					return item;
				}
			}
			return null;
		}
		
		private function getComment() : ByteArray {
			var by : ByteArray = new ByteArray();
			by.writeUTFBytes( 'Project Delayed' );
			return by;
		}

		private function getUpdateProjectTeamLine( rpcEvent:Object ):void { 
			model.teamlLineCollection = rpcEvent.result as ArrayCollection;
			var pevent:TasksEvent = new TasksEvent( TasksEvent.EVENT_PUSH_SEND_STATUSUPDATEPROJECT );
			pevent.taskeventProjectId = model.currentProjects.projectId;
			pevent.dispatch();
		}
    	
    	private function deleteSeletedteamLine( teamentry:Teamlines ):void {
    		delegate = DelegateLocator.getInstance().teamlineDelegate;
    		delegate.responder = new Callbacks( deleteSeletedteamLineResult, fault );
    		delegate.deleteVO( teamentry ); 
    	}
    	
    	private function deleteSeletedteamLineResult( rpcEvent:Object ):void { 
			super.result( rpcEvent );
			model.teamlLineCollection.removeItemAt( 0 );
    		model.teamlLineCollection.refresh();
    		if( model.teamlLineCollection.length > 0 ) {
    			var teamentry1:Teamlines = Teamlines( model.teamlLineCollection.getItemAt( 0 ) ); 
    			deleteSeletedteamLine( teamentry1 );
    		}
    		else{
 		       	var createTeamlineEvent : TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_CREATE_TEAMLINE );
 		       	createTeamlineEvent.teamlineCollection = _createTeamlines;
 		       	createTeamlineEvent.dispatch();
    		}
		}
		
		//add by kumar projectId pass team members only push
		private function getTeamLineProjectId(rpcEvent : Object) : void { 
			var tempPresetTemplate: Presetstemplates = model.currentProjects.presetTemplateFK
			var tempPropPresetColl:ArrayCollection = model.currentProjects.presetTemplateFK.propertiesPresetSet
			super.result(rpcEvent);
			model.currentProjects.presetTemplateFK = tempPresetTemplate
			model.currentProjects.presetTemplateFK.propertiesPresetSet = tempPropPresetColl

			model.teamlLineProjectIdCollection = rpcEvent.result as ArrayCollection;
			//add by kumar   USES for ProjectId send
			var pevent : TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_INITIAL_TASKS);
			pevent.producerPresetTempMessage ='PropPresetTemplateChange'
			pevent.taskeventProjectId = new Number(teamlineEvent.projectId);
			
			if(teamlineEvent.presetTempMessage!='') pevent.producerPresetTempMessage = teamlineEvent.presetTempMessage;
			
			
			var handler:IResponder = new Callbacks(result,fault)
	 		var msgtaskSeq:SequenceGenerator = new SequenceGenerator([pevent],handler)
	  		msgtaskSeq.dispatch();
			
		}
		
		//add by kumar projectId pass team members only push
		private function getTeamLineNewProjectId(rpcEvent : Object) : void { 
			var tempPresetTemplate: Presetstemplates = model.currentProjects.presetTemplateFK
			var tempPropPresetColl:ArrayCollection = model.currentProjects.presetTemplateFK.propertiesPresetSet
			super.result(rpcEvent);
			model.currentProjects.presetTemplateFK = tempPresetTemplate
			model.currentProjects.presetTemplateFK.propertiesPresetSet = tempPropPresetColl

			model.teamlLineProjectIdCollection = rpcEvent.result as ArrayCollection;
			//add by kumar   USES for ProjectId send
			var pevent : TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_INITIAL_TASKS);
			pevent.taskeventProjectId = new Number(teamlineEvent.projectId);
			
			if(teamlineEvent.presetTempMessage!='') pevent.producerPresetTempMessage = teamlineEvent.presetTempMessage;
			
			
			var handler:IResponder = new Callbacks(result,fault)
	 		var msgtaskSeq:SequenceGenerator = new SequenceGenerator([pevent],handler)
	  		msgtaskSeq.dispatch();
			
		}
		private function getTeamLineProjectResult( rpcEvent:Object ):void {
			model.teamlLineCollection = rpcEvent.result as ArrayCollection;
			model.impPerson = Utils.getProfilePerson( 'EPR' );
			model.impPersonId = model.impPerson.personId;
			model.indPerson = Utils.getProfilePerson( 'IND' );
			model.indPersonId = model.indPerson.personId;
			model.cltPerson = Utils.getProfilePerson( 'CLT' );
			model.cltPersonId = model.cltPerson.personId; 
			model.CP_Person = Utils.getProfilePerson( 'CHP' );
			model.CPP_Person = Utils.getProfilePerson( "CPP" );
			model.comPerson = Utils.getProfilePerson( 'COM' );
			model.agencyPerson = Utils.getProfilePerson( 'AGN' );
			model.techPerson = Utils.getProfilePerson( 'BAT' );
			super.result( rpcEvent );
		}
		
		private function getProjectCloseResult( rpcEvent:Object ):void { 
			super.result( rpcEvent );
			model.teamlLineProjectCollection = rpcEvent.result as ArrayCollection;
					
			var eventproducer:TasksEvent = new TasksEvent( TasksEvent.EVENT_GETPROJECT_CLOSE );		
			var handler:IResponder = new Callbacks( result, fault );
	 		var teamlineSeq:SequenceGenerator = new SequenceGenerator( [ eventproducer ], handler );
	  		teamlineSeq.dispatch();
		}
		
		private function createResult( rpcEvent:Object ):void { 
			super.result( rpcEvent );
			model.teamlLineCollection = rpcEvent.result as ArrayCollection;
		} 	
		
    	private function bulkUpdateResult( rpcEvent:Object ):void { 
    		model.teamlLineCollection = rpcEvent.result as ArrayCollection;
			super.result( rpcEvent );
		} 
		
		private function createTeamLineResult( rpcEvent:Object ):void {	 
			super.result( rpcEvent ); 
			model.modelTeamlineCollection = rpcEvent.result as ArrayCollection;
			if( !model.pdfConversion ) {
				var handler:IResponder = new Callbacks( result, fault );
				var eventtask:TasksEvent = new TasksEvent( TasksEvent.EVENT_PUSH_CREATE_TASKS, handler );			
				eventtask.dispatch();
	  		}
		}
	}
}
