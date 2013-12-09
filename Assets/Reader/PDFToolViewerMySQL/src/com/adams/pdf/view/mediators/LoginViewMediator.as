/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.pdf.view.mediators
{ 
	import com.adams.pdf.BootStrapCommand;
	import com.adams.pdf.model.vo.*;
	import com.adams.pdf.signal.ControlSignal;
	import com.adams.pdf.util.Utils;
	import com.adams.pdf.view.LoginSkinView;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.EncryptUtil;
	import com.adams.swizdao.util.StringUtils;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	
	public class LoginViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		private var _homeState:String;
		private var loginSO:SharedObject;
		private var loginTime:Number;
		[Bindable]
		private var urlvalue:String;
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.LOGIN_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function LoginViewMediator( viewType:Class=null )
		{
			super( LoginSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():LoginSkinView 	{
			return _view as LoginSkinView;
		}
		
		[MediateView( "LoginSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView(value);	
		}  
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void {
			
			super.init();  
			viewState = Utils.LOGIN_INDEX;
			
			view.wrongCredentials.text ='';
			currentInstance.mapConfig.isFileIdAvalable = false; 
			//if(FlexGlobals.topLevelApplication.parameters.htmlURL.indexOf('http')!=-1 && FlexGlobals.topLevelApplication.parameters.htmlURL.indexOf('#amp')!=-1)
			if(FlexGlobals.topLevelApplication.parameters.htmlURL){
				if(FlexGlobals.topLevelApplication.parameters.htmlURL.indexOf('?')!=-1)
				{
					var htmlUrl:String = FlexGlobals.topLevelApplication.parameters.htmlURL; 
					htmlUrl = htmlUrl.split("#amp").join("&"); 
					var rootFile:String = htmlUrl.split(".html?")[1];	
					//var rootFile:String = htmlUrl.split(".jsp?")[1];	
					
					var setMessageuser:String = rootFile.split("&")[0];
					var firstFileID:String = setMessageuser.split("file1Id=")[1];
					//userName = decryptionsUserDetails(userName);
					
					var setMessagepass:String = (rootFile.indexOf("&")!=-1)?rootFile.split("&")[1]:"file2Id=";
					var secondFileID:String = setMessagepass.split("file2Id=")[1];
					//password = decryptionsUserDetails(password);				
					
					currentInstance.mapConfig.firstFileID = (!isNaN(int(firstFileID)) && int(firstFileID) != 0)?int(firstFileID):-1;
					currentInstance.mapConfig.secondFileID = (!isNaN(int(secondFileID)) && int(secondFileID) != 0)?int(secondFileID):-1;
					
					currentInstance.mapConfig.isFileIdAvalable = (currentInstance.mapConfig.firstFileID != -1 || currentInstance.mapConfig.secondFileID != -1);
					
				} 
			}
			/*currentInstance.mapConfig.isFileIdAvalable = true 
			currentInstance.mapConfig.firstFileID = 17;
			currentInstance.mapConfig.secondFileID = 15;*/
		} 
		
		private function decryptionsUserDetails(encryptionName:String):String{
			var decryptionValue:String = EncryptUtil.decrypt((StringUtils.replace(unescape(encryptionName),'%2B','+')));
			return decryptionValue;
		}  
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.login.clicked.add(loginHandler);
			view.passwordTextInput.addEventListener(FlexEvent.ENTER,loginHandler);
		}
		
		protected function loginHandler( event:Event): void { 
			controlSignal.loginSignal.dispatch( this, view.userNameTextInput.text, view.passwordTextInput.text );
			view.login.clicked.removeAll();
			
			// create the Shared Object 
			if( view.rememberLogin.selected && loginSO) {
				var myTimeNow:Date = new Date();
				loginSO.data.loginTime = myTimeNow.time.toString();
				loginSO.data.userName = view.userNameTextInput.text;
				loginSO.data.passWord = view.passwordTextInput.text;
				loginSO.flush();
			}
		} 
		/**
		 * The function to display wrong credential Alert
		 */
		public function wrongCredentialsAlert():void{
			view.login.clicked.add( loginHandler);
			view.wrongCredentials.text ='wrong username / password'; 
		} 
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 		
		} 
	}
}