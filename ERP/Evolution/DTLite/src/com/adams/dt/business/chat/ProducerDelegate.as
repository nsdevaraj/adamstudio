package com.adams.dt.business.chat
{
	import com.adams.dt.model.vo.*;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	
	import mx.messaging.Producer;
	import mx.messaging.events.*;
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
		
	public final class ProducerDelegate
	{
		private var responder : IResponder;
		private var service:Producer;
		private var messageI:IMessage;
		public function ProducerDelegate(responder : IResponder )
		{
			this.service = EnterpriseServiceLocator.getInstance().getProducer("producer");
			this.responder = responder;					
		}

		public function sendMessage(userId:Array,msg:String,projId:int,sender:int) : void
		{
			var message:IMessage = new AsyncMessage();
			message.headers = []; 
			message.headers["action"] = 'CHAT';
			
			message.body.userIdArr = userId;
			message.body.projectId = projId;
			message.body.chatMessage = msg;
			message.body.senderId = sender;
			this.service.send(message);
		}		 
	}
}
