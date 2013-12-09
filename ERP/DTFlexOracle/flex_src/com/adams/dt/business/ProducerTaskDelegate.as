package com.adams.dt.business
{
	import com.adams.dt.command.producerconsumer.ProducerStatusOnlineCommand;
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
		private var messageIClose:IMessage;
		private var messageIAbort:IMessage;
		private var messageIDelay:IMessage;
		private var messageIMail:IMessage;
		
		public function ProducerTaskDelegate(responder : IResponder )
		{
			this.service = EnterpriseServiceLocator.getInstance().getProducer("personchatstatus");
			this.responder = responder;					
		}

		public function sendTaskdetails(message:IMessage) : void
		{
			messageI = message;
			this.service.send( message );
		}	
		public function sendProjectClosedetails(message:IMessage) : void    //ProducerProjectCloseDelegate class method
		{
			messageIClose = message;
			this.service.send(messageIClose);
		}
		public function sendProjectAborteddetails(message:IMessage) : void    //ProducerProjectCloseDelegate class method
		{
			messageIAbort = message;
			this.service.send(messageIAbort);
		}
		public function sendDelaydetails(message:IMessage) : void    //ProducerProjectCloseDelegate class method
		{
			messageIDelay = message;
			this.service.send(messageIDelay);
		}
		public function sendMaildetails(message:IMessage) : void    
		{
			messageIMail = message;
			this.service.send(messageIMail);
		}
		public function sendProjectPresetTempdetails(message:IMessage) : void    
		{
			this.service.send(message);
		}
		public function sendFinishTaskdetails(message:IMessage) : void    
		{
			this.service.send(message);
		}
		public function sendProjectNotesdetails(message:IMessage) : void    
		{
			this.service.send(message);
		}	
					 
	}
}
