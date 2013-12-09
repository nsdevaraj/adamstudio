package com.adams.dt.command.producerconsumer
{
	import com.adams.dt.business.ProducerTaskDelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Teamlines;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.controls.Alert;
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
		
	import flash.utils.setTimeout;
		
	public final class ProducerCommand extends AbstractCommand implements IResponder
	{			
		private var bulkArray:String = '';
		private var bulkArraymsg:String = ''; 
		private var bulkArrayStatus:String = ''; 
		private var bulkArrayMail:String = ''; 		
		public function ProducerCommand()
		{
		}
		override public function execute( event : CairngormEvent ) : void
		{	
			var delegate:ProducerTaskDelegate = new ProducerTaskDelegate( this );
			var tasksEvent : TasksEvent = TasksEvent(event);	
			//trace(event.type);
		    switch(event.type)
		    {   
		        case TasksEvent.EVENT_PUSH_CREATE_TASKS:	
		        	getCreateTasks(delegate);
		        	break;
		        //Previous Taskid Finished - word to sent
		        case TasksEvent.EVENT_PUSH_STATUS_SEND:	
		        	getStatusSend(delegate);
		        	break;
		         case TasksEvent.EVENT_PUSH_CREATE_MESSAGE_TASKS:	
		        	getCreateMessageTasks(delegate);
		        	break;	        
		        	  
		        default:
		        	break; 
		    }
		}	
		
		/* private function getCreateMessageTasks(delegate:ProducerTaskDelegate):void
		{
			model.mainClass.status("ProducerCommand  messageBulkMailCollection : "+model.messageBulkMailCollection.length+ '\n');
			trace("ProducerCommand ...getCreateMessageTasks .. messageBulkMailCollection : "+model.messageBulkMailCollection.length);
			if(model.messageBulkMailCollection.length!=0)
			{	
				for( var i : Number = 0; i < model.messageBulkMailCollection.length;i++)
				{	
					var tasksdetails:Tasks = model.messageBulkMailCollection.getItemAt(i) as Tasks;
					model.mainClass.status("ProducerCommand  : "+tasksdetails.personDetails+ '\n');
					model.mainClass.status("ProducerCommand  : "+tasksdetails.personDetails+ '\n');

					var senderPersonId:String = tasksdetails.personDetails.personId.toString();
					var senderProfileId:String = tasksdetails.workflowtemplateFK.profileObject.profileId.toString();
					var senderTaskId:String = tasksdetails.taskId.toString();
					
					var senderDetails:String =  senderPersonId+"&&&&"+senderTaskId+"&&&&"+senderProfileId;		
													
					if(bulkArrayMail == '')
						bulkArrayMail = senderDetails;
					else
						bulkArrayMail += ","+senderDetails;
				}
				BulkArrayMail(bulkArrayMail,delegate);
			}
		}
		private function BulkArrayMail(bulkArrayMail:String,delegate:ProducerTaskDelegate):void
		{
			model.mainClass.status("--ProducerCommand--BulkArrayMail--:"+bulkArrayMail+"\n");
			trace("--ProducerCommand--BulkArrayMail--:"+bulkArrayMail);
			var message:IMessage = new AsyncMessage();			
			message.body.pushMailId = bulkArrayMail;
			delegate.sendMaildetails(message); 
		} */
		
		private function getCreateMessageTasks(delegate:ProducerTaskDelegate):void
		{
			if(model.modelTeamlineMessageCollection.length!=0)
			{	
				for( var i : Number = 0; i < model.modelTeamlineMessageCollection.length;i++)
				{	
					var teamlinestask:Teamlines = model.modelTeamlineMessageCollection.getItemAt(i) as Teamlines;
					var teamlinePersonId:String = teamlinestask.personID.toString();
					
					var senderProfileId:String = model.createdTaskMessage.workflowtemplateFK.profileObject.profileId.toString();
					var senderTaskId:String = model.createdTaskMessage.taskId.toString();
					
					var senderDetails:String =  teamlinePersonId+"&&&&"+senderTaskId+"&&&&"+senderProfileId;		
													
					if(bulkArraymsg == '')
						bulkArraymsg = senderDetails;
					else
						bulkArraymsg += ","+senderDetails;
										
					/* if(bulkArraymsg == '')
						bulkArraymsg = teamlinePersonId;
					else
						bulkArraymsg += ","+teamlinePersonId; */
				}
				model.delayUpdateTxt = "Message created";
				BulkArrayMessageTaskId(bulkArraymsg,delegate);
			}
		}
		private function BulkArrayMessageTaskId(bulkArraymsg:String,delegate:ProducerTaskDelegate):void
		{
			//trace("--ProducerCommand--BulkArrayMessageTaskId--:"+bulkArraymsg+" : TaskId :"+model.createdTask.taskId);
			/* var message:IMessage = new AsyncMessage();			
			message.body.pushTaskId = model.createdTaskMessage.taskId;
			message.body.pushPersonId = bulkArraymsg;
			message.body.pushImpMail = "ExternalMail";
			delegate.sendTaskdetails(message); */ 
			
			//model.mainClass.status("--ProducerCommand--BulkArrayMessageTaskId--:"+bulkArraymsg+"\n");
			//trace("--ProducerCommand--bulkArraymsg--:"+bulkArraymsg);
			var message:IMessage = new AsyncMessage();			
			message.body.pushMailId = bulkArraymsg;
			delegate.sendMaildetails(message); 
						
			okResult();
			
		} 
		private function okResult():void
		{
	        model.mainClass.messageSettings();
	    }	
		private function getCreateTasks(delegate:ProducerTaskDelegate):void
		{
			if(model.modelTeamlineCollection.length!=0)
			{	
				for( var i : Number = 0; i < model.modelTeamlineCollection.length;i++)
				{	
					var teamlinestask:Teamlines = model.modelTeamlineCollection.getItemAt(i) as Teamlines;
					var teamlinePersonId:String = teamlinestask.personID.toString();
										
					if(bulkArray == '')
						bulkArray = teamlinePersonId;
					else
						bulkArray += ","+teamlinePersonId;
				}
				BulkArrayTaskId(bulkArray,delegate);
			}
		}
		private function BulkArrayTaskId(bulkArray:String,delegate:ProducerTaskDelegate):void
		{
			trace("--ProducerCommand--BulkArrayTaskId--:"+bulkArray+" : TaskId :"+model.createdTask.taskId);
			var message:IMessage = new AsyncMessage();			
			message.body.pushTaskId = model.createdTask.taskId;
			message.body.pushPersonId = bulkArray;
			message.body.pushImpMail = "ExternalMail";
			delegate.sendTaskdetails(message); 
			
			setTimeout(setTimeoutPropertyUpdate,3000);
			
		}
		public function setTimeoutPropertyUpdate():void
		{
			model.delayUpdateTxt = "Property message";
						      
			var messageEvent:TasksEvent = new TasksEvent(TasksEvent.CREATE_PROPERTYMSG_TASKS);
			messageEvent.tasks = model.modelMessageTasks;
			var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator([messageEvent],handler)
	  		newProjectSeq.dispatch(); 
		}
		private function getStatusSend(delegate:ProducerTaskDelegate):void
		{
			if(model.modelTeamlineStatusCollection.length!=0)
			{	
				for( var i : Number = 0; i < model.modelTeamlineStatusCollection.length;i++)
				{	
					var teamlinestask:Teamlines = model.modelTeamlineStatusCollection.getItemAt(i) as Teamlines;
					var teamlinePersonId:String = teamlinestask.personID.toString();
										
					if(bulkArrayStatus == '')
						bulkArrayStatus = teamlinePersonId;
					else
						bulkArrayStatus += ","+teamlinePersonId;
				}
				BulkArrayStatusId(bulkArrayStatus,delegate);
			}
		}
		private function BulkArrayStatusId(bulkArrayStatus:String,delegate:ProducerTaskDelegate):void
		{
			//model.mainClass.status("--ProducerCommand--BulkArrayStatusId--:"+bulkArrayStatus+" : finishedTempTaskId - TaskId :"+model.finishedTempTaskId.taskId+" : createdTask - TaskId :"+model.createdTask.taskId+ '\n');
			var message:IMessage = new AsyncMessage();			
			//message.body.mailImpTaskId = model.createdTask.taskId;
			message.body.mailImpTaskId = model.finishedTempTaskId.taskId;
			message.body.mailImpPersonId = bulkArrayStatus;
			message.body.mailImpStatus = "Finished";
			delegate.sendStatusdetails(message); 
		}
	}
}
