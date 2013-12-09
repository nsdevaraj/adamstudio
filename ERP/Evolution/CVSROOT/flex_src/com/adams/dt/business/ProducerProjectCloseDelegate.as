package com.adams.dt.business
{
	import com.adams.dt.command.producerconsumer.*;
	import com.adams.dt.model.vo.*;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator
	
	import mx.messaging.Producer;
	import mx.messaging.events.*;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
		
	public final class ProducerProjectCloseDelegate
	{
		private var responder : IResponder;
		private var service:Producer;
		private var messageI:IMessage;
		public function ProducerProjectCloseDelegate(responder : IResponder )
		{
			this.service = EnterpriseServiceLocator.getInstance().getProducer("personchatstatus");
			this.responder = responder;					
		}

		public function sendProjectClosedetails(message:IMessage) : void
		{
			messageI = message;
			this.service.send(message);
		}		 
	}
}
