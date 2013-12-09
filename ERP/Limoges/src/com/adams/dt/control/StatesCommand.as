/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.control
{
	import com.adams.dt.BootStrapCommand;
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.mediators.MainViewMediator;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.views.mediators.IViewMediator;
	
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	
	
	public class StatesCommand
	{
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject("proppresetstemplatesDAO")]
		public var propPresettemplateDAO:AbstractDAO;
		
		[Inject("propertiespresetsDAO")]
		public var propertiespresetsDAO:AbstractDAO;
		
		[Inject("personsDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("reportsDAO")]
		public var reportsDAO:AbstractDAO;
		
		[Inject("presetstemplatesDAO")]
		public var presetstemplatesDAO:AbstractDAO;
		
		[Inject("columnsDAO")]
		public var columnsDAO:AbstractDAO;
		
		[Inject("tasksDAO")]
		public var tasksDAO:AbstractDAO;  
		
		[Inject("projectsDAO")]
		public var projectDAO:AbstractDAO;
		
		private var view:Object;
		
		private var alertView:IViewMediator;
		private var alertResponder:Object;
		
		// todo: add listener 
		/**
		 * Whenever an LogoutSignal is dispatched.
		 * MediateSignal initates this logoutAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='logoutSignal')]
		public function logoutAction( obj:IViewMediator ):void {
			controlSignal.changeStateSignal.dispatch( Utils.LOGIN_INDEX );
			currentInstance.mapConfig.firstLoadShow =false;
			if( BootStrapCommand.isDebugMode ) {
				personDAO.controlService.authCS.logout();	
			}
			emptyDAOs();
		}
		
		private function emptyDAOs():void{
			/*if(tasksDAO.collection.items)if(tasksDAO.collection.items.length > 0)tasksDAO.collection.items.removeAll(); 
			if(reportsDAO.collection.items)if(reportsDAO.collection.items.length > 0)reportsDAO.collection.items.removeAll();
			if(reportsDAO.collection.items)if(reportsDAO.collection.items.length > 0)reportsDAO.collection.items.removeAll();
			if(propertiespresetsDAO.collection.items)if(propertiespresetsDAO.collection.items.length > 0)propertiespresetsDAO.collection.items.removeAll();
			if(propPresettemplateDAO.collection.items)if(propPresettemplateDAO.collection.items.length > 0)propPresettemplateDAO.collection.items.removeAll();
			if(presetstemplatesDAO.collection.items)if(presetstemplatesDAO.collection.items.length > 0)presetstemplatesDAO.collection.items.removeAll();
			if(columnsDAO.collection.items)if(columnsDAO.collection.items.length > 0)columnsDAO.collection.items.removeAll();*/
		}
		
		/**
		 * Whenever an LoginSignal is dispatched.
		 * MediateSignal initates this loginAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='loginSignal')]
		public function loginAction( obj:Object, username:String, password:String ):void {
			view = obj;
			personDAO.controlService.authCS.loginAttempt.add( checkLogin ); 
			personDAO.controlService.authCS.login( username, password );
			currentInstance.mapConfig.currentPerson = new Persons();
			currentInstance.mapConfig.currentPerson.personLogin = username;
			currentInstance.mapConfig.currentPerson.personPassword = password;
		}
		
		/**
		 * The handler to check the userlogin credentials
		 */
		protected function checkLogin( event:Object = null ):void {
			if( personDAO.controlService.authCS.authenticated ) {
				controlSignal.getPersonsSignal.dispatch( view );
				personDAO.controlService.authCS.loginAttempt.removeAll();
			}
			else {
				setTimeout( wrongCredentials, 1000 ); 
			}
		}
		
		protected function wrongCredentials():void {
			if( personDAO.controlService.authCS.loginAttempt.numListeners != 0 ) {
				view.wrongCredentialsAlert();
			}
		}
		
		/**
		 * Whenever an hideAlertSignal is dispatched.
		 * MediateSignal initates this hideAlertAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='hideAlertSignal')]
		public function hideAlertAction( state:uint ):void {
			if( state == Alert.YES ) {
				alertView.alertReceiveHandler( alertResponder );
			}
			alertView = null;
			alertResponder = null;
		}
		
		/**
		 * Whenever an showAlertSignal is dispatched.
		 * MediateSignal initates this showAlertAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='showAlertSignal')]
		public function showAlertAction( obj:IViewMediator, text:String, title:String, type:int, responder:Object ):void {
			alertView = obj;
			alertResponder = responder;
			mainViewMediator.showAlert( text, title ,type);
		}
		
		/**
		 * Whenever an ChangeStateSignal is dispatched.
		 * MediateSignal initates this changestateAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='changeStateSignal')]
		public function changestateAction( state:String ):void {
			mainViewMediator.view.currentState = state;
		}
	}
}