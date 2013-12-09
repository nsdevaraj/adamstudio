package com.adams.dt.business.chat
{
	import com.adams.dt.command.producerconsumer.ConsumerChatCommand;
	import com.adams.dt.model.vo.*;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	
	import mx.messaging.Consumer;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.IResponder;
		
	public final class ConsumerChatDelegate 
	{
		private var responder : IResponder;
		private var service : Consumer;
		public function ConsumerChatDelegate(responder : IResponder )
		{
			this.service = EnterpriseServiceLocator.getInstance().getConsumer("consumer"); //personchatinstatus //consumer
			this.responder = responder;
			
			var consumerChatCommand : ConsumerChatCommand = responder as ConsumerChatCommand;
			this.service.addEventListener(MessageEvent.MESSAGE, consumerChatCommand.chatmessageHandler,false,0,true);		
		}
		public function subscribe():void
		{  
			service.subscribe(); 
		}		
		public function unsubscribe():void
		{  
			service.unsubscribe();
		} 
	}
}
