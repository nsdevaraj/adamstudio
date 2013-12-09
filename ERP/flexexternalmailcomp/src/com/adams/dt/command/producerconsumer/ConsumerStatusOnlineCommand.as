package com.adams.dt.command.producerconsumer
{
	import com.adams.dt.business.PushConsumerDelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.PersonsEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	
	import mx.collections.IViewCursor;
	import mx.controls.Alert;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;  
	
	public final class ConsumerStatusOnlineCommand extends AbstractCommand implements IResponder
	{
		private var cursor:IViewCursor;
		override public function execute( event : CairngormEvent ) : void
		{
			var delegate:PushConsumerDelegate = new PushConsumerDelegate( this );
			var personsEvent : PersonsEvent = PersonsEvent(event);			
			delegate.subscribe(); 			      		    		
      		
		} 
		public function messageHandler( event:MessageEvent ) : void
		{	
			var message:IMessage = event.message as IMessage;
			if(message.body.pushTaskId!=undefined)
			{	
				var pushPersonId:String = "";
				var tempPushId:String = message.body.pushPersonId;
				for(var i:Number=0;i<tempPushId.split(",").length;i++)
				{
					pushPersonId = tempPushId.split(",")[i];
					if(model.person.personId == int(pushPersonId))
					{
						/* var eventtask:TasksEvent = new TasksEvent(TasksEvent.EVENT_PUSH_GET_TASKS);
						eventtask.taskeventtaskId = int(message.body.pushTaskId);
						eventtask.alertMessage = "NewTasks";			
						var handler:IResponder = new Callbacks(result,fault)
				 		var pushSeq:SequenceGenerator = new SequenceGenerator([eventtask],handler)
				  		pushSeq.dispatch(); */
					} 
				}				
			}
		}			
	}
}

