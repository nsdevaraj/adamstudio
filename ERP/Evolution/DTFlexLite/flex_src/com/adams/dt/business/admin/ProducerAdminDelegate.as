package com.adams.dt.business.admin
{
	import com.adams.dt.command.producerconsumer.ProducerStatusOnlineCommand;
	import com.adams.dt.model.vo.*;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator
	
	import mx.messaging.Producer;
	import mx.messaging.events.*;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
		
	public final class ProducerAdminDelegate
	{
		private var responder : IResponder;
		private var service:Producer;
		private var messageI:IMessage;
		public function ProducerAdminDelegate(responder : IResponder )
		{
			this.service = EnterpriseServiceLocator.getInstance().getProducer("adminchannelpushin");
			this.responder = responder;					
		}

		public function adminsenddetails(message:IMessage) : void
		{
			messageI = message;
			this.service.send(message);
		}		 
	}
}
