package com.adams.dt.command.producerconsumer
{
	import com.adams.dt.business.ProducerTaskDelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.model.vo.Teamlines;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	
	import mx.controls.Alert;
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
	
	public final class ProducerTaskCreateCommand extends AbstractCommand implements IResponder
	{		
		private var bulkArray:String = ''; 	
		public function ProducerTaskCreateCommand()
		{
		}
		override public function execute( event : CairngormEvent ) : void
		{			
			//add by kumar sep 07
			var delegate:ProducerTaskDelegate = new ProducerTaskDelegate( this );
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
		//add by kumar sep 06
		public function BulkArrayTaskId(bulkArray:String,delegate:ProducerTaskDelegate):void
		{
			//Alert.show("--ProducerTaskCreateCommand--BulkArrayTaskId--:"+bulkArray+" : TaskId :"+model.createdTask.taskId);
			trace("--ProducerTaskCreateCommand--BulkArrayTaskId--:"+bulkArray+" : TaskId :"+model.createdTask.taskId);
			var message:IMessage = new AsyncMessage();			
			message.body.pushTaskId = model.createdTask.taskId;
			message.body.pushPersonId = bulkArray;
			delegate.sendTaskdetails(message); 
		}
	}
}
