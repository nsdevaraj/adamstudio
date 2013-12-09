package com.adams.dam.command
{
	import com.adams.dam.business.DelegateLocator;
	import com.adams.dam.event.AuthenticationEvent;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.so.SharedObjectManager;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.events.PropertyChangeEvent;
	import mx.rpc.IResponder;
	
	public final class AuthenticationCommand extends AbstractCommand implements ICommand, IResponder 
	{
		
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var _authenticationEvent:AuthenticationEvent;
		private var loginStatus:Boolean;
		
		override public function execute( event:CairngormEvent ):void {
			model.preloaderVisibility = true;
			_authenticationEvent = AuthenticationEvent( event );
			delegate = DelegateLocator.getInstance().authenticationDelegate;
			delegate.responder = this; 
			model.userName = _authenticationEvent.loginVO.userName;
			delegate.login( _authenticationEvent.loginVO.userName, _authenticationEvent.loginVO.password );
		}
		
		public function checkLogin( event:PropertyChangeEvent ):void {
			if( event.currentTarget.authenticated ) {
				loginStatus = true;
				
				var SoM:SharedObjectManager = SharedObjectManager.instance;
          		if( SoM.data.filesToUpload ) {
					model.filesToUpload = SoM.data.filesToUpload;
				}
				if( SoM.data.filesToDownload ) {
					model.filesToDownload = SoM.data.filesToDownload;
				}
				if( SoM.data.fileDetailsToUpload ) {
					model.fileDetailsToUpload = SoM.data.fileDetailsToUpload;
				}
				
				model.successfulLogin = true;
			}
			setTimeout( showErrorLogin, 2000 );
		}
		
		private function showErrorLogin():void {
			if( !loginStatus ) {
				model.preloaderVisibility = false;
				Alert.show( "Incorrect UserName and password" );
			}	
		}
	}
}