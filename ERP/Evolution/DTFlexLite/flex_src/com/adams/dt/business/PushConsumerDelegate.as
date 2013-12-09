package com.adams.dt.business
{
	import com.adams.dt.model.vo.*;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	import mx.messaging.messages.IMessage;	
	import mx.messaging.Consumer;
	
	import com.adams.dt.command.producerconsumer.ConsumerStatusOnlineCommand;
	import mx.rpc.IResponder;
		
	public final class PushConsumerDelegate 
	{
		private var responder : IResponder;
		private var service : Consumer;
		public function PushConsumerDelegate(responder : IResponder )
		{
			this.service = EnterpriseServiceLocator.getInstance().getConsumer("personchatinstatus");
			this.responder = responder;
			
			var consumerStatusOnlineCommand : ConsumerStatusOnlineCommand = responder as ConsumerStatusOnlineCommand;
			this.service.addEventListener(MessageEvent.MESSAGE, consumerStatusOnlineCommand.messageHandler,false,0,true);		
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
