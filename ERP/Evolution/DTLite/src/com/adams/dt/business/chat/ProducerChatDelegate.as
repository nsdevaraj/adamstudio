package com.adams.dt.business.chat
{
	import com.adams.dt.command.producerconsumer.ProducerStatusOnlineCommand;
	import com.adams.dt.model.vo.*;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator
	
	import mx.messaging.Producer;
	import mx.messaging.events.*;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
		
	public final class ProducerChatDelegate
	{
		private var responder : IResponder;
		private var service:Producer;
		private var messageI:IMessage;
		public function ProducerChatDelegate(responder : IResponder )
		{
			this.service = EnterpriseServiceLocator.getInstance().getProducer("producer"); //personchatstatus //producer
			this.responder = responder;					
		}

		public function senddetails(message:IMessage) : void
		{
			messageI = message;
			this.service.send(message);
		}		 
	}
}
