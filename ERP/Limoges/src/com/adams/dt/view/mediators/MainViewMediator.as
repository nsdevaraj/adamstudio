/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.view.mediators
{ 
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.DateUtil;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.MainSkinView;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.DateUtils;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.events.CloseEvent;
	
	
	public class MainViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject("personsDAO")]
		public var personsDAO:AbstractDAO;
		
		private var _progressWatcher:ChangeWatcher;
		
		private var _homeState:String;
		public function get homeState():String {
			return _homeState;
		}
		public function set homeState( value:String ):void {
			_homeState = value;
			if( value == Utils.MAIN_INDEX ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage );
			} 
		}
		
		private var _progressToggler:Boolean;
		public function get progressToggler():Boolean {
			return _progressToggler;
		}
		public function set progressToggler( value:Boolean ):void {
			_progressToggler = value;
			if( value ) {
				view.progress.visible = true;
			}
			else {
				view.progress.visible = false;
				if( view.progress.view.progressText.text == 'Refreshing...' ) {
					view.progress.view.progressText.text = 'Loading...';
				}
			}
		}
		
		protected function addedtoStage( ev:Event ):void {
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function MainViewMediator( viewType:Class=null )
		{
			super( MainSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():MainSkinView 	{
			return _view as MainSkinView;
		}
		
		[MediateView( "MainSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView( value );	
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
			if( !_progressWatcher ) {
				_progressWatcher = BindingUtils.bindProperty( this, 'progressToggler', currentInstance, 'waitingForServerResponse', false, true );
			}
			else {
				_progressWatcher.reset( this );
			}
			viewState = Utils.MAIN_INDEX;
		} 
		
		public function timerFunction(start:Boolean):void {	
			if( start ) {
				ProcessUtil.startTimerFunction( getRefreshList, currentInstance.mapConfig.autoTimerInterval );	
			}
			else {
				ProcessUtil.stopTimerFunction();
			}
		}		
		
		public function getRefreshList():void {
			var currentTime:Date = new Date();
			var frenchTime:Date = new Date();
			if(ProcessUtil.isIndia)frenchTime = new Date( frenchTime.time - ProcessUtil.timeDiff);
			var dateString:String = DateUtil.dateToString(currentInstance.mapConfig.serverLastAccessedAt).toLowerCase();
 			//controlSignal.getModifiedProjectsSignal.dispatch( null, dateString, currentInstance.mapConfig.currentPerson.personId);
			view.progress.view.progressText.text = 'Refreshing...';
			controlSignal.getCategoryListSignal.dispatch( this );
			controlSignal.getProjectListSignal.dispatch( this, currentInstance.mapConfig.currentPerson.personId, true );
			//if(view.todo.view.tasklist)	controlSignal.getTodoTasksSignal.dispatch( view.todo.view.tasklist, currentInstance.mapConfig.currentPerson.personId );
			currentInstance.mapConfig.serverLastAccessedAt = frenchTime;
		} 
		
		public function isTaskInToDo( collection:ArrayCollection ):Boolean {
			for each( var item:Tasks in currentInstance.mapConfig.currentProject.tasksCollection ) {
				for each( var toDotask:Tasks in currentInstance.mapConfig.taskCollectionOfCurrentPerson ) {
					if( ( item.taskId == toDotask.taskId )  && 
						( toDotask.workflowtemplateFK.taskCode != Utils.MESSAGE_SCREEN ) && 
						( toDotask.taskStatusFK != TaskStatus.FINISHED ) &&
						( toDotask.projectObject.projectStatusFK != ProjectStatus.ABORTED ) && 
						( toDotask.projectObject.projectStatusFK != ProjectStatus.ARCHIVED ) ) {
						currentInstance.mapConfig.currentTasks = toDotask;
						return true;
					}
				}
			}
			return false;
		}
		
		override protected function setViewDataBindings():void 	{
			//remove Effect
		}
		
		public function showAccordingScreen():void {
			
			isTaskAssigned( currentInstance.mapConfig.currentTasks );
			
			switch( currentInstance.mapConfig.currentTasks.workflowtemplateFK.taskCode ) {
				case Utils.NEWORDER_CORRECTION_SCREEN:
					controlSignal.changeStateSignal.dispatch( Utils.PROJECTCORRECTION_INDEX );
					break;
				case Utils.CORRECTIONS_FRONT_SCREEN:
					controlSignal.changeStateSignal.dispatch( Utils.GENERAL_INDEX );
					break;
				case Utils.CORRECTIONS_BACK_SCREEN:
					controlSignal.changeStateSignal.dispatch( Utils.CORRECTION_INDEX ); 
					break;
				case Utils.ARCHIVE_SCREEN:
					controlSignal.changeStateSignal.dispatch( Utils.MESSAGE_INDEX ); 
					break;				
				case Utils.MESSAGE_SCREEN:
					if ( currentInstance.mapConfig.currentTasks.deadlineTime == 1 ) {
						controlSignal.changeStateSignal.dispatch( Utils.DEADLINEMESSAGE_INDEX );
					}
					else if ( currentInstance.mapConfig.currentTasks.deadlineTime == 0  ) {
						controlSignal.changeStateSignal.dispatch( Utils.MESSAGE_INDEX );
					}
					break;
				default:
					controlSignal.changeStateSignal.dispatch( Utils.GENERAL_INDEX ); 
					break;
			}
		}
		
		/**
		 * Do check wheather the task has been taken by othe person, if so show an alert, 
		 * if not update the task with status and current personFK
		 */
		private function isTaskAssigned( assignedTask:Tasks ):void {
			for each( var item:Tasks in currentInstance.mapConfig.currentProject.tasksCollection ) {
				if( item.taskId == assignedTask.taskId ) {
					if( item.taskStatusFK != TaskStatus.WAITING ) {
						var taskPerson:Persons = GetVOUtil.getVOObject( item.personFK, personsDAO.collection.items, personsDAO.destination, Persons ) as Persons;
						if( taskPerson.personId != currentInstance.mapConfig.currentPerson.personId ) {
							controlSignal.showAlertSignal.dispatch( this, ( Utils.STATUSOFTODOTASK + taskPerson.personFirstname ), Utils.APPTITLE, 1, null );
						}
					}
					else {
						assignedTask.taskStatusFK = TaskStatus.INPROGRESS;
						assignedTask.personFK = currentInstance.mapConfig.currentPerson.personId;
						controlSignal.updateTaskSignal.dispatch( this, assignedTask );
					}
					return;
				}
			}
		}
		
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		
		public function showAlert( text:String, title:String,type:int = 0 ):void {
			if( type == 0 ) {
				Alert.show( text, title, Alert.YES|Alert.NO, this, confirmationAlert );
			}
			else {
				Alert.show( text, title, Alert.OK, this, confirmationAlert );
			}
		}
		
		private function confirmationAlert( event:CloseEvent ):void {
			controlSignal.hideAlertSignal.dispatch( event.detail );
		}
		
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {  
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners();  
		}
		
		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			if( _progressWatcher ) {
				_progressWatcher.unwatch();
			}
			super.cleanup( event ); 		
		} 
	}
}