package com.adams.dam.business.delegates
{
	import com.adams.dam.business.Services;
	import com.adams.dam.business.interfaces.IDAODelegate;
	import com.adams.dam.command.AuthenticationCommand;
	import com.adams.dam.model.ModelLocator;
	
	import mx.events.PropertyChangeEvent;
	import mx.messaging.ChannelSet;
	import mx.rpc.IResponder;
	
	public final class AuthenticationDelegate extends AbstractDelegate implements IDAODelegate
	{
		
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function AuthenticationDelegate( handlers:IResponder = null, service:String = '' ) 
		{
			super( handlers, Services.PERSON_SERVICE );
		}
		
		override public function login( username:String, password:String ):void {
			var channelSet:ChannelSet = model.channelSet;
			var authenticationCommand:AuthenticationCommand = responder as AuthenticationCommand;
			channelSet.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE , authenticationCommand.checkLogin, false, 0, true );
			channelSet.login( username, password );
		} 
	}
}
