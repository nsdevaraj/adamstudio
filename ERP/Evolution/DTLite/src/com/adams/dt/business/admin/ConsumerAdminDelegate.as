package com.adams.dt.business.admin
{
	import com.adams.dt.command.adminproducerconsumer.ConsumerAdminCommand;
	import com.adams.dt.model.vo.*;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	
	import mx.messaging.Consumer;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.IResponder;
		
	public final class ConsumerAdminDelegate 
	{
		private var responder : IResponder;
		private var service : Consumer;
		public function ConsumerAdminDelegate(responder : IResponder )
		{
			this.service = EnterpriseServiceLocator.getInstance().getConsumer("adminchannelpushout");
			this.responder = responder;
			
			var consumerAdminCommand:ConsumerAdminCommand = responder as ConsumerAdminCommand;
			this.service.addEventListener(MessageEvent.MESSAGE, consumerAdminCommand.messageHandlerAdmin,false,0,true);		
		}
		public function adminsubscribe():void
		{  
			service.subscribe(); 
		}		
		public function unsubscribe():void
		{  
			service.unsubscribe();
		} 
	}
}
