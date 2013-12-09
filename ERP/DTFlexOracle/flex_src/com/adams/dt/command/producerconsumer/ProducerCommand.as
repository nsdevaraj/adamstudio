package com.adams.dt.command.producerconsumer
{
	import com.adams.dt.business.ProducerTaskDelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Teamlines;
	import com.adams.dt.view.components.chatscreen.asfile.MessageWindow;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
		
	public final class ProducerCommand extends AbstractCommand implements IResponder
	{	
		private var bulkArrayPerId:String = '';
		private var bulkArrayPersonId:String = '';
		private var bulkArray:String = ''; 
		private var bulkArraystr:String = ''; 	
		private var bulkArrayMail:String = ''; 	
		private var bulkArrayfinish:String = ''; 	
		private var bulkArrayNotesPerId:String = '';	
		
		public function ProducerCommand()
		{
		}
		
		override public function execute( event : CairngormEvent ) : void {	
			
			var delegate:ProducerTaskDelegate = new ProducerTaskDelegate( this );
			var tasksEvent:TasksEvent = TasksEvent( event );	
			
		    switch( event.type ) {   	
		       	case TasksEvent.EVENT_PUSH_INITIAL_TASKS:
		       		var taskInitialProjectId:String = tasksEvent.taskeventProjectId.toString();	
		       		var producerPresetTempMessage:String = tasksEvent.producerPresetTempMessage.toString();	
		       		
		       		if( producerPresetTempMessage != '' ) {
		       			getPropertiesChange( producerPresetTempMessage, taskInitialProjectId, delegate );
		       		}
		       		else {
		       			/**
		       			 * create the new project
						 * new order submit alert
						 * Only CLT and FAB create the new project alert view
						 * after that boolean false
						 * Ref:ModelLocator.as,NewProject.mxml,NewOrderScreen.mxml,ProducerCommand.as	
						 */
		       			if( model.newOrderCLTFAB ) {
			       			var AlertWindow:MessageWindow = new MessageWindow();
							AlertWindow.createWindow( model.mainClass, "DT", model.loc.getString( "newOrderSubmit" ), "corner" );
							model.newOrderCLTFAB = false;
		       			}
		       			getTasksInitialResult( taskInitialProjectId, delegate );
		       		}
		        	break; 
		        case TasksEvent.EVENT_PUSH_CREATE_TASKS:	
		        	getCreateTasks( delegate );
		        	break; 
		        case TasksEvent.EVENT_PUSH_OPERATOR_MSG:	
		        	BulkArrayTaskId( tasksEvent.msgToOperatorId, delegate );
		        	break; 	
		        case TasksEvent.EVENT_PUSH_SEND_STATUSUPDATEPROJECT:	
		        	var taskUpdateProjectId:String = tasksEvent.taskeventProjectId.toString();			
		        	getProjectStatusUpdate( taskUpdateProjectId, delegate );
		        	break; 	
		        case TasksEvent.EVENT_DELAY_PROJECT:	
		        	getDelayProject( delegate );
		        	break;
		        case TasksEvent.EVENT_GETPROJECT_CLOSE:
		        	getCloseProject( delegate );
		        	break;
		        case TasksEvent.EVENT_GETABORTEDPROJECT_CLOSE:	
		        	getAbortedProject( delegate );
		        	break;
		        case TasksEvent.EVENT_MAILPUSH:	
		        	getMailPush( delegate );
		        	break;
		        case TasksEvent.PUSH_ALL_PROJECT_PRESETTEMP:
		        	var projPresetTemplateId:String = '1'; //tasksEvent.projPresetTemplateId.toString();		
		        	getProjectPresetResult( projPresetTemplateId, delegate );
		        	break;
		        case TasksEvent.EVENT_FINISHED_TASK:
		        	var finishTaskId:String = tasksEvent.finishtasks.taskId.toString();		
		        	getFinishTasksResult( finishTaskId, delegate );
		        	break;	
		        case TasksEvent.EVENT_PUSH_PROJECTNOTES:	
		         	var strprojectId:String = model.currentProjects.projectId.toString();
		        	getProjectNotesPush( strprojectId, delegate );
		        	break;
		        default:
		        	break; 
		    }
		}
		
		private function getProjectNotesPush( strProjectId:String, delegate:ProducerTaskDelegate ):void {
			if( model.teamlLineCollection.length != 0 ) {	
				for( var i:Number = 0; i < model.teamlLineCollection.length; i++ ) {	
					
					var teamlinestask:Teamlines = model.teamlLineCollection.getItemAt(i) as Teamlines;
					var teamlinePersonId:String = teamlinestask.personID.toString();
					
					if( bulkArrayNotesPerId == '' ) {
						bulkArrayNotesPerId = teamlinestask.personID.toString();
					}	
					else {
						bulkArrayNotesPerId += "," + teamlinestask.personID.toString();
					}	
				}
				BulkNotesProjectId( bulkArrayNotesPerId, strProjectId, delegate );
			}
		}
		
		private function BulkNotesProjectId( bulkArrayNotesPerId:String, strProjectId:String, delegate:ProducerTaskDelegate ):void {	
			var message:IMessage = new AsyncMessage();			
			message.body.pushNotesProjectId = strProjectId;
			message.body.pushNotesPersonId = bulkArrayNotesPerId;	
			delegate.sendProjectNotesdetails( message );
		}
		
		private function getPropertiesChange( producerPresetTempMessage:String, taskInitialProjectId:String, delegate:ProducerTaskDelegate ):void {
			if( model.teamlLineProjectIdCollection.length != 0 ) {	
				for( var i:Number = 0; i < model.teamlLineProjectIdCollection.length; i++ ) {	
					
					var teamlinestask:Teamlines = model.teamlLineProjectIdCollection.getItemAt( i ) as Teamlines;
					var teamlinePersonId:String = teamlinestask.personID.toString();
					if( bulkArrayPersonId == '' ) {
						bulkArrayPersonId = teamlinestask.personID.toString();
					}	
					else {
						bulkArrayPersonId += "," + teamlinestask.personID.toString();
					}	
				}
				PropertyProjectId( producerPresetTempMessage, bulkArrayPersonId, taskInitialProjectId, delegate );
			}
		}
		
		private function PropertyProjectId( producerPresetTempMessage:String, bulkArrayPersonId:String, taskInitialProjectId:String, delegate:ProducerTaskDelegate ):void 	{
			var message:IMessage = new AsyncMessage();			
			message.body.pushInitialProjectId = taskInitialProjectId;
			message.body.pushInitialPersonId = bulkArrayPersonId;	
			message.body.propPresetTemplateChange = producerPresetTempMessage;
			delegate.sendTaskdetails( message ); 
		}
		
		private function getFinishTasksResult( finishTaskId:String, delegate:ProducerTaskDelegate ):void {
			if( model.teamlTaskFinishCollection.length != 0 ) {	
				for( var i:Number = 0; i < model.teamlTaskFinishCollection.length;i++ ) {	
					var teamlinestask:Teamlines = model.teamlTaskFinishCollection.getItemAt( i ) as Teamlines;
					var teamlinePersonId:String = teamlinestask.personID.toString();
					if( bulkArrayfinish == '' ) {
						bulkArrayfinish = teamlinePersonId;
					}	
					else {
						bulkArrayfinish += "," + teamlinePersonId;
					}	
				}
				BulkArrayfinishTaskId( finishTaskId, bulkArrayfinish, delegate );
			}
		}
		
		private function BulkArrayfinishTaskId( finishTaskId:String, bulkArrayfinish:String, delegate:ProducerTaskDelegate ):void {
			var message:IMessage = new AsyncMessage();			
			message.body.finishPersonId = bulkArrayfinish;
			message.body.finishTaskId = finishTaskId;
			delegate.sendFinishTaskdetails( message ); 
		}
		
		private function getProjectPresetResult( projPresetTemplateId:String, delegate:ProducerTaskDelegate ):void {
			var message:IMessage = new AsyncMessage();
			message.body.projectPresetTemplateId = projPresetTemplateId;
			message.body.projectPresetStatus = "ProjectPresetTemplates";
			delegate.sendProjectPresetTempdetails( message );
		}
		
		private function getMailPush(delegate:ProducerTaskDelegate):void {
			if( model.messageBulkMailCollection.length != 0 ) {	
				for( var i:Number = 0; i < model.messageBulkMailCollection.length; i++ ) {	
					var tasksdetails:Tasks = model.messageBulkMailCollection.getItemAt( i ) as Tasks;
					var senderPersonId:String = tasksdetails.personDetails.personId.toString();
					var senderProfileId:String = tasksdetails.workflowtemplateFK.profileFK.toString();
					var senderTaskId:String = tasksdetails.taskId.toString();
					var senderDetails:String =  senderPersonId + "&&&&" + senderTaskId + "&&&&" + senderProfileId;		
					if( bulkArrayMail == '' ) {
						bulkArrayMail = senderDetails;
					}	
					else {
						bulkArrayMail += "," + senderDetails;
					}	
				}
				BulkArrayMail( bulkArrayMail, delegate );
			}
		}
		
		private function BulkArrayMail( bulkArrayMail:String, delegate:ProducerTaskDelegate ):void {
			var message:IMessage = new AsyncMessage();			
			message.body.pushMailId = bulkArrayMail;
			delegate.sendMaildetails( message ); 
		}
		
		private function getCreateTasks( delegate:ProducerTaskDelegate ):void {
			if( model.modelTeamlineCollection.length != 0 ) {	
				for( var i:Number = 0; i < model.modelTeamlineCollection.length;i++ ) {	
					var teamlinestask:Teamlines = model.modelTeamlineCollection.getItemAt( i ) as Teamlines;
					var teamlinePersonId:String = teamlinestask.personID.toString();
					if( bulkArray == '' ) {
						bulkArray = teamlinePersonId;
					}	
					else {
						bulkArray += ","+teamlinePersonId;
					}	
				}
				BulkArrayTaskId( bulkArray, delegate );
			}
		}
		
		private function BulkArrayTaskId( bulkArray:String, delegate:ProducerTaskDelegate ):void {
			var message:IMessage = new AsyncMessage();			
			message.body.pushTaskId = model.createdTask.taskId;
			message.body.pushPersonId = bulkArray;
			delegate.sendTaskdetails( message ); 
			
			//Update the Main Project View If it is Opened
			if( model.mainProjectState == 1 ) {
				if( model.updateMPV )	model.updateMPV = false;
				else	model.updateMPV = true;
			}
			
			if( model.preloaderVisibility )	{
				model.preloaderVisibility = false;
			}	
		}
		
		private function getTasksInitialResult(taskInitialProjectId:String,delegate:ProducerTaskDelegate):void {
			if(model.teamlLineProjectIdCollection.length!=0) 
			{	
				for( var i : Number = 0; i < model.teamlLineProjectIdCollection.length;i++) 
				{	
					var teamlinestask:Teamlines = model.teamlLineProjectIdCollection.getItemAt(i) as Teamlines;
					var teamlinePersonId:String = teamlinestask.personID.toString();
					
					if(bulkArrayPersonId == '')
						bulkArrayPersonId = teamlinestask.personID.toString();
					else
						bulkArrayPersonId += ","+teamlinestask.personID.toString();
				}
				BulkProjectId(bulkArrayPersonId,taskInitialProjectId,delegate);
			}
		}
		
		private function BulkProjectId( bulkArrayPersonId:String, taskInitialProjectId:String, delegate:ProducerTaskDelegate ):void 	{	
			var message:IMessage = new AsyncMessage();			
			message.body.pushInitialProjectId = taskInitialProjectId;
			message.body.pushInitialPersonId = bulkArrayPersonId;	
			delegate.sendTaskdetails( message );
		}
		
		private function getProjectStatusUpdate( taskUpdateProjectId:String, delegate:ProducerTaskDelegate ):void {
			var totalLength:Number = model.teamlLineCollection.length;
			for( var i : Number = 0; i < totalLength; i++ ) {	
				var teamlinestask:Teamlines = model.teamlLineCollection.getItemAt( i ) as Teamlines;
				var teamlinePersonId:String = teamlinestask.personID.toString();
				if( bulkArrayPerId == '' ) {
					bulkArrayPerId = teamlinestask.personID.toString();
				}	
				else {
					bulkArrayPerId += "," + teamlinestask.personID.toString();
				}	
			}
			if( totalLength != 0 ) {
				BulkProjectStatusId( bulkArrayPerId, taskUpdateProjectId, delegate );
			}
		}
		
		private function BulkProjectStatusId( bulkArrayPerId:String, taskUpdateProjectId:String, delegate:ProducerTaskDelegate ):void {
			var message:IMessage = new AsyncMessage();			
			message.body.pushUpdateProjectId = taskUpdateProjectId;
			message.body.pushUpdatePersonId = bulkArrayPerId;
			delegate.sendTaskdetails( message );
		}
		
		private function getDelayProject( delegate:ProducerTaskDelegate ):void {
			if( model.pushDelayedMsg.length != 0 ) {
				for( var i:Number = 0; i < model.pushDelayedMsg.length; i++ ) {
					var tasks:Tasks =  model.pushDelayedMsg.getItemAt( i ) as Tasks;
					var closetaskId:int = tasks.taskId;
					var teamlinePersonId:String = tasks.personDetails.personId.toString() + "&&&&" + closetaskId.toString() + "&&&&" + tasks.projectObject.projectName;
					if( bulkArraystr == '' ) {
						bulkArraystr = teamlinePersonId;
					}
					else {
						bulkArraystr += "," + teamlinePersonId;
					}	
				}
				BulkArrayDelay( bulkArraystr, delegate );
			}
		}
		
		private function BulkArrayDelay( bulkArray:String, delegate:ProducerTaskDelegate ):void {
			var message:IMessage = new AsyncMessage();			
			message.body.pushProjectDelayPersonId = bulkArray;
			delegate.sendDelaydetails( message ); 
		}
		
		private function getCloseProject( delegate:ProducerTaskDelegate ):void {
			if( model.modelCloseTaskArrColl.length != 0 ) {
				for( var i:Number = 0; i < model.modelCloseTaskArrColl.length; i++ ) {
					var tasks:Tasks = model.modelCloseTaskArrColl.getItemAt( i ) as Tasks;
					var closetaskId:int = tasks.taskId;
					var closeprofileId:int = tasks.workflowtemplateFK.profileFK;
					profileIdCheck( closetaskId, closeprofileId, delegate );
				}
			}
		}
		
		private function profileIdCheck( closetaskId:int, closeprofileId:int, delegate:ProducerTaskDelegate ):void {
			var bulkArraystr:String = ''; 	
			for( var i:Number = 0; i < model.teamlLineProjectCollection.length; i++ ) {	
				var teamlinesproject:Teamlines= model.teamlLineProjectCollection.getItemAt( i ) as Teamlines;
				var teamlineProfileId:int = teamlinesproject.profileID;
				if( closeprofileId == teamlineProfileId ) 	{
					var teamlinePersonId:String = teamlinesproject.personID.toString();
					if( bulkArraystr == '' ) { 
						bulkArraystr = teamlinePersonId;
					}	
					else {
						bulkArraystr += "," + teamlinePersonId;
					}	
				}
			}
			BulkArrayCloseTaskId( closetaskId, bulkArraystr, delegate );
		}
		
		private function BulkArrayCloseTaskId( closetaskId:int, bulkArray:String, delegate:ProducerTaskDelegate ):void {
			var message:IMessage = new AsyncMessage();			
			message.body.pushProjectCloseTaskId = closetaskId;
			message.body.pushProjectClosePersonId = bulkArray;
			delegate.sendProjectClosedetails( message ); 
		}
		
		private function getAbortedProject( delegate:ProducerTaskDelegate ):void {
			if( model.modelCloseTaskArrColl.length != 0 ) {
				for( var i:Number = 0; i < model.modelCloseTaskArrColl.length; i++ ) {
					var tasks:Tasks =  model.modelCloseTaskArrColl.getItemAt( i ) as Tasks;
					var closetaskId:int = tasks.taskId;
					var closeprofileId:int = tasks.workflowtemplateFK.profileFK;
					AbortedprofileIdCheck( closetaskId, closeprofileId, delegate );
				}
			}
		}
		
		private function AbortedprofileIdCheck( closetaskId:int, closeprofileId:int, delegate:ProducerTaskDelegate ):void {
			var bulkArraystr:String = ''; 	
			for( var i:Number = 0; i < model.teamlLineCollection.length; i++ ) {	
				var teamlinesproject:Teamlines= model.teamlLineCollection.getItemAt( i ) as Teamlines;
				var teamlineProfileId:int = teamlinesproject.profileID;
				if( closeprofileId == teamlineProfileId ) {
					var teamlinePersonId:String = teamlinesproject.personID.toString();
					if( bulkArraystr == '' ) {
						bulkArraystr = teamlinePersonId;
					}	
					else {
						bulkArraystr += "," + teamlinePersonId;
					}	
				}
			}
			BulkArrayAbortedTaskId( closetaskId, bulkArraystr, delegate );
		}
		
		//add by kumar July 28 separate taskid push purpose   
		private function BulkArrayAbortedTaskId( closetaskId:int, bulkArray:String, delegate:ProducerTaskDelegate ):void {
			var message:IMessage = new AsyncMessage();	
			message.body.pushProjectAbortedTaskId = closetaskId;
			message.body.pushProjectAbortedPersonId = bulkArray;
			delegate.sendProjectAborteddetails( message ); 
		}
	}
}
