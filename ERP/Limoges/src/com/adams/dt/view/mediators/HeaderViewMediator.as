/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.view.mediators
{ 
	import com.adams.dt.BootStrapCommand;
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.HeaderSkinView;
	import com.adams.dt.view.components.SettingsPanel;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.EncryptUtil;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.util.StringUtils;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.containers.Box; 
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.graphics.SolidColor;
	import mx.managers.PopUpManager;
	
	import spark.components.PopUpAnchor;
	import spark.components.ToggleButton;
	
	public class HeaderViewMediator extends AbstractViewMediator
	{ 		 
		[Bindable]
		private var fullScreenState:String;
		
		[Bindable]
		public var simpleDP:Array = ['0x303030','0x797979','0x525311', '0x115311', '0x115253',
			'0x191153', '0x531151', '0x092cff', '0x00ffae', '0xe4ff00',
			'0xffc000', '0xff0000'];
		
		private var cInt:int=0;
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject("companiesDAO")]
		public var companyDAO:AbstractDAO;
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		private var prevSelection:ToggleButton;
		private var _homeState:String;
		private var settingsPanel:SettingsPanel
		private var settingPanelCanvas:Box = new Box();
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.HEADER_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function HeaderViewMediator( viewType:Class=null )
		{
			super( HeaderSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():HeaderSkinView 	{
			return _view as HeaderSkinView;
		}
		
		[MediateView( "HeaderSkinView" )]
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
			viewState = Utils.HEADER_INDEX;
			view.newProjectBtn.visible = ProcessUtil.isCLT;
			setDataProviders();
			fullScreenState = stage.displayState;
			if( !hasEventListener( Event.ADDED_TO_STAGE ) ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage );
			}
		} 
		
		protected function setDataProviders():void {
			var currPerson:Persons = currentInstance.mapConfig.currentPerson;
			view.userNameText.text = currPerson.personFirstname;
			view.userNameText.text += " "+currPerson.personLastname;
			view.companyNameText.text = currPerson.personPosition;
			if( BootStrapCommand.isDebugMode ) {
				view.companyNameText.text += " " + Companies( GetVOUtil.getVOObject( currPerson.companyFk, companyDAO.collection.items, companyDAO.destination, Companies ) ).companyname;
			}
			view.userPic.source = currPerson.personPict;
		}

		protected function themeHandler( event:MouseEvent ):void {
			if( simpleDP.length == cInt ) {
				cInt=0;
			}
			FlexGlobals.topLevelApplication.setStyle( 'chromeColor' , simpleDP[ cInt ] );
			cInt++;
		}
		 
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners();
			view.todoBtn.addEventListener( Event.CHANGE, onMenuChange );
			view.newProjectBtn.addEventListener( Event.CHANGE, onMenuChange );
			view.dashboardBtn.addEventListener( Event.CHANGE, onMenuChange );
			view.refreshBtn.clicked.add( manualRefresh );
			view.settingsBtn.clicked.add( showSettingsPanel );
			view.fullScreenBtn.clicked.add( swapState );
			view.logoutBtn.clicked.add( logOutHandler )
		}
		
		private function swapState( event:MouseEvent ):void {
			if( fullScreenState == StageDisplayState.NORMAL) {
				fullScreenState = StageDisplayState.FULL_SCREEN;
			} 
			else {
				fullScreenState = StageDisplayState.NORMAL;
			}
			try {
				stage.displayState = fullScreenState;
			} 
			catch( any:* ) {
				// ignore
			}
		}
		
		override protected function setViewDataBindings():void 	{
			//remove effect
		}
		private function adminHandler( event:MouseEvent ):void {
			controlSignal.changeStateSignal.dispatch(Utils.ADMIN_INDEX);
		}		
		
		private function rssHandler( event:MouseEvent ):void {
			var encryptorUserName:String = StringUtils.replace(escape(EncryptUtil.encrypt(currentInstance.mapConfig.currentPerson.personLogin)),'+','%2B');
			var encryptorPassword:String = StringUtils.replace(escape(EncryptUtil.encrypt(currentInstance.mapConfig.currentPerson.personPassword)),'+','%2B');
						
			var encryptorUrl:String = "Limoges/Limoges.html";			
			var rssUrl:String = currentInstance.config.serverLocation+"todolistfeeder?"+"&eun="+ encryptorUserName+"&eps="+ encryptorPassword+"&eurl="+encryptorUrl;
			
			var requestUrl:URLRequest = new URLRequest( rssUrl );	
			navigateToURL( requestUrl ); 
		}
		
		private function showSettingsPanel(event:MouseEvent):void{
			if(!settingsPanel){
				settingsPanel = new SettingsPanel();
				settingsPanel.percentHeight = 100;
				settingsPanel.percentWidth = 100;
				settingsPanel.addEventListener(FlexEvent.CREATION_COMPLETE,onSettingPanelComplete);
			}
			settingPanelCanvas.x = FlexGlobals.topLevelApplication.width - 330;
			settingPanelCanvas.y = 35;
			settingPanelCanvas.addChild(settingsPanel);
			PopUpManager.addPopUp(settingPanelCanvas,view);
		}
		
		private function onSettingPanelComplete(event:FlexEvent):void{
			settingPanelCanvas.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,closePopup);
			settingsPanel.rssBtn.addEventListener(MouseEvent.CLICK,rssHandler);
			settingsPanel.adminBtn.addEventListener(MouseEvent.CLICK,adminHandler);
			settingsPanel.deleteAllProjectsBtn.addEventListener(MouseEvent.CLICK,deleteAllProjects);
		}
		
		private function closePopup(event:FlexMouseEvent):void{  
			PopUpManager.removePopUp(settingPanelCanvas);
		}
		
		private function deleteAllProjects(event:MouseEvent ):void{
			controlSignal.showAlertSignal.dispatch(this,'Do you want to delete all projects?',Utils.APPTITLE,0,null)
		}
		
		override public function alertReceiveHandler(obj:Object):void {
			resetMaster();
		}
		
		private function resetMaster():void{
			controlSignal.deleteAllProjectsSignal.dispatch(this);
		}
		
		protected function manualRefresh( event:MouseEvent ):void {
			mainViewMediator.timerFunction(false);
			mainViewMediator.getRefreshList();
			mainViewMediator.timerFunction(true);
		}
		
		protected function logOutHandler( event:MouseEvent ):void {
			controlSignal.logoutSignal.dispatch( this  );
		}
		
		[ControlSignal(type='changeStateSignal')]
		public function setButtonSelection( state:String ):void { 
			makeEnable();
			switch( state ) {
				case Utils.TASKLIST_INDEX:
					view.headerLbl.text = "To Do";
					makeDisable( view.todoBtn );
					break;
				case Utils.REPORT_INDEX:
					view.headerLbl.text = "Dashboard";
					makeDisable( view.dashboardBtn );
					break;
				case Utils.NEWPROJECT_INDEX:
					view.headerLbl.text = "New Project";
					makeDisable( view.newProjectBtn );
					break;
				default:
					view.headerLbl.text = "";
					break;
			} 
		}
		
		private function makeEnable():void {
			if( !view.todoBtn.enabled ) {
				view.todoBtn.enabled = true;
				view.todoBtn.selected = false;
				view.todoBtn.buttonMode = true;
			}
			if( !view.dashboardBtn.enabled ) {
				view.dashboardBtn.enabled = true;
				view.dashboardBtn.selected = false;
				view.dashboardBtn.buttonMode = true;
			}
			if( !view.newProjectBtn.enabled ) {
				view.newProjectBtn.enabled = true;
				view.newProjectBtn.selected = false;
				view.newProjectBtn.buttonMode = true;
			}
		}
		
		private function makeDisable( target:ToggleButton ):void {
			target.enabled = false;
			target.selected = true;
			target.buttonMode = false;
		}
		
		protected function onMenuChange( event:Event ):void {
			switch( event.currentTarget ) {
				case view.todoBtn:
					controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
					break;
				case view.newProjectBtn:
					controlSignal.changeStateSignal.dispatch( Utils.NEWPROJECT_INDEX );
					break;
				case view.dashboardBtn:
					controlSignal.changeStateSignal.dispatch( Utils.REPORT_INDEX );
					break;
			}
		}
		
		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 		
		} 
	}
}