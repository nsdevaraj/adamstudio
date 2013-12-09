package com.adams.dt.service
{
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.AsyncMessage;
	
	public class DTService extends BaseService implements IDTService
	{
		
		public function DTService()
		{
			super();
		}

		override protected function checkLogin(ev:Object =null) : void
		{
			if(amfChannelSet.authenticated)
			{
				loggedIn.dispatch();  
			}else{
				trace('wrong username / password');
			}
		}
		
		
	}
}