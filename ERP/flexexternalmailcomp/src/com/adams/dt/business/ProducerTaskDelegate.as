package com.adams.dt.business
{
	import com.adams.dt.model.vo.*;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator
	
	import mx.messaging.Producer;
	import mx.messaging.events.*;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
		
	public final class ProducerTaskDelegate
	{
		private var responder : IResponder;
		private var service:Producer;
		private var messageI:IMessage;
		private var messageIstatus:IMessage;
		public function ProducerTaskDelegate(responder : IResponder )
		{
			this.service = EnterpriseServiceLocator.getInstance().getProducer("personchatstatus");
			this.responder = responder;					
		}

		public function sendTaskdetails(message:IMessage) : void
		{
			messageI = message;
			this.service.send(message);
		}
		public function sendStatusdetails(message:IMessage) : void
		{
			messageIstatus = message;
			this.service.send(messageIstatus);
		}	
		public function sendMaildetails(message:IMessage) : void    
		{
			this.service.send(message);
		}	 
	}
}
