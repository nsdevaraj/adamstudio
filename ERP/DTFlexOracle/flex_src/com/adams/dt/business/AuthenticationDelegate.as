package com.adams.dt.business
{
	import com.adams.dt.command.authentication.AuthenticationCommand;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	
	import mx.events.PropertyChangeEvent;
	import mx.messaging.ChannelSet;
	import mx.rpc.IResponder;
	public final class AuthenticationDelegate extends AbstractDelegate implements IDAODelegate
	{
		private var userName : String;
		public function AuthenticationDelegate(handlers:IResponder = null, service:String='') 
		{
			super(handlers, Services.PERSON_SERVICE);
			
			
		}
		/**
         * authenticate the user by using @username and @password  
         * 
         */ 
		override public function login(username : String , password : String) : void
		{
			this.userName = username;
			var channelSet : ChannelSet = model.channelSet;
			var authenticationCommand : AuthenticationCommand = responder as AuthenticationCommand
			channelSet.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE , authenticationCommand.checkLogin,false,0,true);
			channelSet.login(username , password);
		} 
	}
}
