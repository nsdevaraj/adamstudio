package com.adams.dam.view.hosts.login
{
	import com.adams.dam.event.AuthenticationEvent;
	import com.adams.dam.event.CategoriesEvent;
	import com.adams.dam.event.FileDetailsEvent;
	import com.adams.dam.event.PersonsEvent;
	import com.adams.dam.event.ProjectsEvent;
	import com.adams.dam.event.SequenceGenerator;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.LoginVO;
	import com.adams.dam.view.skins.login.LoginSkin;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.messaging.messages.ErrorMessage;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class LoginView extends SkinnableComponent
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var skinComponent:LoginSkin;
		
		private var _loggedIn:Boolean;
		public function set loggedIn( value:Boolean ):void {
			_loggedIn = value;
			if( value ) {
				onSuccessfulLogin();
			}
		} 
		
		public function LoginView()
		{
			super();
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true );
		}
		
		protected function onCreationComplete( event:FlexEvent ):void {
			if( skin ) {
				skinComponent = LoginSkin( skin );
				skinComponent.loginButton.addEventListener( MouseEvent.CLICK, onLogin, false, 0, true );
			}
		}
		
		protected function onLogin( event:MouseEvent ):void {
			var loginVO:LoginVO = new LoginVO();
			loginVO.userName = skinComponent.username.text;
			loginVO.password = skinComponent.pwrd.text;
			
			var loginEvent:AuthenticationEvent = new AuthenticationEvent( loginVO );
			loginEvent.dispatch();
		}
		
		protected function onSuccessfulLogin():void {
			var handler:IResponder = new Callbacks( onGetAllPersonsResult, onServiceCallFault );
			var getPersonsEvent:PersonsEvent = new PersonsEvent( PersonsEvent.EVENT_GET_ALL_PERSONS, handler );
			getPersonsEvent.dispatch();
		}
		
		protected function onGetAllPersonsResult( callResult:Object ):void {
			var handler:IResponder = new Callbacks( onGetAllFilesResult, onServiceCallFault );
			var getPersonsEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.GET_ALL_FILES, handler );
			getPersonsEvent.dispatch();
		}
		
		protected function onGetAllFilesResult( callResult:Object ):void {
			var sequence:Array = [];
			
			var getCategoriesEvent:CategoriesEvent = new CategoriesEvent( CategoriesEvent.EVENT_GET_ALL_CATEGORIES );
			sequence.push( getCategoriesEvent );
			
			var getProjectsEvent:ProjectsEvent = new ProjectsEvent( ProjectsEvent.EVENT_GET_ALL_PROJECTS );
			sequence.push( getProjectsEvent );
			
			var sequenceEvent:SequenceGenerator = new SequenceGenerator( sequence );
			sequenceEvent.dispatch();
		}
		
		protected function onServiceCallFault( faultInfo:Object ):void {
			var faultEvt:FaultEvent = faultInfo as FaultEvent;
			var errorMessage:ErrorMessage = faultEvt.message as ErrorMessage;
			Alert.show( errorMessage.faultString );
		}
	}
}