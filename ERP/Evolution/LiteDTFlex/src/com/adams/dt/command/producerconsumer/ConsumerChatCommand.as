package com.adams.dt.command.producerconsumer
{
	import com.adams.dt.business.chat.ConsumerChatDelegate;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.view.chartpeople.windows.ChatWindow;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	
	import mx.collections.IViewCursor;
	import mx.events.FlexEvent;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
	
	public final class ConsumerChatCommand extends AbstractCommand implements IResponder
	{
		private var cursor:IViewCursor;
		override public function execute( event : CairngormEvent ) : void
		{
			var delegate:ConsumerChatDelegate = new ConsumerChatDelegate( this );
			var personsEvent : PersonsEvent = PersonsEvent(event);			
			delegate.subscribe();       		
		} 		
		public function chatmessageHandler( event:MessageEvent ) : void
		{	
			var message:IMessage = event.message as IMessage;			 
			if(message.body.chat!=undefined)
			{					
				var receivingPersonAll:String = message.body.personarray;
				var personAll:Array = receivingPersonAll.split(",");
				for( var i:int=0;i<personAll.length;i++ )
				{
					var personIdAll:int = personAll[i];  //int(message.body.receiverId)
					if(model.person.personId == personIdAll)
					{
						var proj:Projects = GetVOUtil.getProjectObject(message.body.projectId);	
						if( model.chatWindowCollection[ message.body.projectId ] == undefined ) {							
							var myWindow:ChatWindow = new ChatWindow();
							model.chatWindowCollection[ message.body.projectId ] = myWindow;
							model.chatWindowCollection[ message.body.projectId ].projectID = message.body.projectId;
							model.chatWindowCollection[ message.body.projectId ].addEventListener(FlexEvent.CREATION_COMPLETE,myWindow.offLineChatData,false,0,true);						
							model.chatWindowCollection[ message.body.projectId ].personReceiverID = message.body.senderId;
							model.chatWindowCollection[ message.body.projectId ].personSenderID = personIdAll;
							model.chatWindowCollection[ message.body.projectId ].title = proj.projectName;

							//model.chatWindowCollection[ message.body.projectId ].commonPageDisplay(message.body.projectId,message.body.senderName,message.body.description,false);
							model.chatWindowCollection[ message.body.projectId ].open( true ); 
						}
						else {
							model.chatWindowCollection[ message.body.projectId ].activate();
							model.chatWindowCollection[ message.body.projectId ].commonPageDisplay(message.body.projectId,message.body.senderName,message.body.description,false);
						} 
					}
				} 				
			} 
		}
	}
}

