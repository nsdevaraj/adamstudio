/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.view.mediators
{ 
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.ProjectUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.DeadlineMessageSkinView;
	import com.adams.dt.view.GeneralSkinView;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.osflash.signals.Signal;
	
	import spark.utils.TextFlowUtil;
	
	
	public class DeadlineMessageViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		public var selectionCloseSignal:Signal = new Signal();
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		public var genralDeadlineMessage :Boolean 
		private var _homeState:String;
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.DEADLINEMESSAGE_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		private var _suggestedDate:Date;
		[Bindable]
		public function get suggestedDate():Date
		{
			return _suggestedDate;
		}
		public function set suggestedDate(value:Date):void
		{
			_suggestedDate = value;
			view.reqDate.selectedDate = suggestedDate;
		}
		
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function DeadlineMessageViewMediator( viewType:Class=null )
		{
			super( DeadlineMessageSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():DeadlineMessageSkinView 	{
			return _view as DeadlineMessageSkinView;
		}
		
		[MediateView( "DeadlineMessageSkinView" )]
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
			if(currentInstance.mapConfig.currentTasks)
			{
				if(currentInstance.mapConfig.currentTasks.deadlineTime == 1)
				{
					(ProcessUtil.isCLT)?view.currentState = Utils.CLIENT_DEADLINE:view.currentState = Utils.TRAFFIC_DEADLINE;
				}
				if(currentInstance.mapConfig.currentTasks.taskComment){
					view.receivedCommTxt.textFlow = TextFlowUtil.importFromString( Utils.getComments ( currentInstance.mapConfig.currentTasks.taskComment.toString() ) );
				}
			}
			if(view.acceptBtn)view.acceptBtn.addEventListener( MouseEvent.CLICK , onAcceptDateDateHandler )
			if(view.abortedBtn)view.abortedBtn.addEventListener( MouseEvent.CLICK , onAbortDateDateHandler );
			if(view.forwardBtn)view.forwardBtn.addEventListener( MouseEvent.CLICK , replyHandler );
			view.replyCommTxt.editor.text = '';
		}
		
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {  
			if( ( signal.action == Action.CREATE ) && ( signal.destination == Utils.TASKSKEY ) ) {
				var createdTask:Tasks = obj as Tasks;  
				if( currentInstance.mapConfig.currentTasks ) {
					currentInstance.mapConfig.currentTasks.nextTask = createdTask;
					if( createdTask.previousTask.deadlineTime == 1 ) {
						currentInstance.mapConfig.currentTasks.taskStatusFK = TaskStatus.FINISHED;
						controlSignal.updateTaskSignal.dispatch( this, currentInstance.mapConfig.currentTasks );	
					}
				}
				controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
			} 
			if( ( signal.action == Action.CLOSEPROJECT ) && ( signal.destination == ArrayUtil.PAGINGDAO ) ) {
				if( currentInstance.mapConfig.currentTasks ) {
					currentInstance.mapConfig.currentTasks.taskStatusFK = TaskStatus.FINISHED;
				}
				controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
			}
			if( ( signal.action == Action.UPDATE ) && ( signal.destination == Utils.TASKSKEY ) ) {
				controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
			}
		} 
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			
			var _requestedPropertiesPj:Propertiespj =   Utils.propertyPjForFieldName( 'clt_date', currentInstance.mapConfig.currentProject.propertiespjSet );
			var _suggestedPropertiesPj:Propertiespj =   Utils.propertyPjForFieldName( 'tra_date', currentInstance.mapConfig.currentProject.propertiespjSet );
			
			if(_requestedPropertiesPj) view.reqDate.selectedDate = ( _requestedPropertiesPj.fieldValue =="NULL")?new Date():new Date( _requestedPropertiesPj.fieldValue );
			if(_suggestedPropertiesPj) view.suggDate.selectedDate = ( _suggestedPropertiesPj.fieldValue =="NULL")?new Date( _requestedPropertiesPj.fieldValue):new Date( _suggestedPropertiesPj.fieldValue );
		}
		
		protected function replyHandler(event:MouseEvent ):void {
			controlSignal.showAlertSignal.dispatch(this,Utils.REPLY_DEADLINE_MESSAGE+ view.suggDate.selectedDate.toString(),Utils.APPTITLE,0, Utils.REPLYNOTE);
		}
		
		
		
		
		protected function onAbortDateDateHandler ( event :MouseEvent ):void
		{	
			controlSignal.showAlertSignal.dispatch(this,Utils.ABORT_MESSAGE,Utils.APPTITLE,0,Utils.ABORT_MESSAGE);
		}	
		
		override public function alertReceiveHandler(obj:Object):void {
			var messageStatus:String;
			var objArray:Array;
			if( obj==Utils.ABORT_MESSAGE) {
				objArray= ProjectUtil.abortProject(Utils.ABORT,currentInstance.mapConfig.currentProject,currentInstance.mapConfig.closeProjectTemplate,
					currentInstance.mapConfig.currentTasks,currentInstance.mapConfig.currentPerson,view.replyCommTxt.getText);
				currentInstance.mapConfig.closeTaskCollection = objArray[objArray.length-1]
				controlSignal.closeProjectsSignal.dispatch(this,objArray);
			}else if( obj==Utils.REPLYNOTE) {
				onMessageHandler();
			}else if( obj==Utils.ACCEPT_MESSAGE) {
				acceptSuggestedDate();
			}
		}
		
		protected function onAcceptDateDateHandler ( event :MouseEvent ):void
		{
			var _suggestedPropertiesPj:Propertiespj =   Utils.propertyPjForFieldName( 'tra_date', currentInstance.mapConfig.currentProject.propertiespjSet );
			view.suggDate.selectedDate = new Date( _suggestedPropertiesPj.fieldValue );
			controlSignal.showAlertSignal.dispatch(this,Utils.ACCEPT_MESSAGE,Utils.APPTITLE,0,Utils.ACCEPT_MESSAGE);
		}
		
		protected function acceptSuggestedDate():void
		{
			var approvedTask:Tasks = new Tasks();
			approvedTask.deadlineTime = 0;
			approvedTask.projectFk = currentInstance.mapConfig.currentProject.projectId;
			approvedTask.personFK = currentInstance.mapConfig.currentPerson.personId;
			approvedTask.previousTask = currentInstance.mapConfig.currentTasks;
			approvedTask.projectObject = currentInstance.mapConfig.currentProject;
			approvedTask.domainDetails = currentInstance.mapConfig.currentProject.categories.categoryFK.categoryFK;
			approvedTask.taskFilesPath = currentInstance.mapConfig.currentPerson.personId+","+currentInstance.mapConfig.currentPerson.defaultProfile;
			approvedTask.tDateCreation = new Date();
			var msg:String;
			if(ProcessUtil.isCLT){
				msg = Utils.CLIENT_ACCEPTED_DATE
			}else{
				msg = Utils.TRAFFIC_ACCEPTED_DATE
			}
			var approvedComments:String =msg+view.suggDate.selectedDate.toString();
			var str:String = currentInstance.mapConfig.currentPerson.personFirstname+Utils.SEPERATOR+
				approvedComments+Utils.SEPERATOR+
				currentInstance.mapConfig.currentPerson.personId+","+
				currentInstance.mapConfig.currentPerson.defaultProfile;
			approvedTask.taskComment = ProcessUtil.convertToByteArray( str );
			
			approvedTask.wftFK = ProcessUtil.getMessageTemplate( ProcessUtil.getOtherProfileCode(currentInstance.mapConfig.currentProfileCode),currentInstance.mapConfig.messageTemplatesCollection ).workflowTemplateId;
			var status:Status = new Status();
			status.statusId = TaskStatus.WAITING;
			approvedTask.taskStatusFK = status.statusId;
			controlSignal.createTaskSignal.dispatch( this ,approvedTask, Utils.DEADLINEMESSAGE_INDEX );
			var _propertiesPj:Propertiespj =   Utils.propertyPjForFieldName( 'bat_date', currentInstance.mapConfig.currentProject.propertiespjSet );
			controlSignal.bulkUpdatePrjPropertiesSignal.dispatch( this,_propertiesPj.projectFk,_propertiesPj.propertyPresetFk.toString(),view.suggDate.selectedDate.toString(),0,'' );
		}
		protected function onMessageHandler():void
		{
			var createdTask:Tasks = new Tasks();
			createdTask.deadlineTime = 1;
			createdTask.projectFk = currentInstance.mapConfig.currentProject.projectId;
			createdTask.personFK = currentInstance.mapConfig.currentPerson.personId;
			createdTask.previousTask = currentInstance.mapConfig.currentTasks;
			createdTask.projectObject = currentInstance.mapConfig.currentProject;
			createdTask.domainDetails = currentInstance.mapConfig.currentProject.categories.categoryFK.categoryFK;
			createdTask.taskFilesPath = currentInstance.mapConfig.currentPerson.personId+","+currentInstance.mapConfig.currentPerson.defaultProfile;
			createdTask.tDateCreation = new Date();
			
			var str:String = currentInstance.mapConfig.currentPerson.personFirstname+Utils.SEPERATOR+
				view.replyCommTxt.getText+Utils.SEPERATOR+
				currentInstance.mapConfig.currentPerson.personId+","+
				currentInstance.mapConfig.currentPerson.defaultProfile;
			createdTask.taskComment = ProcessUtil.convertToByteArray( str );
			
			createdTask.wftFK = ProcessUtil.getMessageTemplate( ProcessUtil.getOtherProfileCode(currentInstance.mapConfig.currentProfileCode),currentInstance.mapConfig.messageTemplatesCollection ).workflowTemplateId;
			var status:Status = new Status();
			status.statusId = TaskStatus.WAITING;
			createdTask.taskStatusFK = status.statusId;
			controlSignal.createTaskSignal.dispatch( this ,createdTask,Utils.DEADLINEMESSAGE_INDEX );
			
			// update  date  created by client.....
			var _suggestedPropertiesPj:Propertiespj =   Utils.propertyPjForFieldName( 'tra_date', currentInstance.mapConfig.currentProject.propertiespjSet );
			controlSignal.bulkUpdatePrjPropertiesSignal.dispatch( this,_suggestedPropertiesPj.projectFk,_suggestedPropertiesPj.propertyPresetFk.toString(),view.suggDate.selectedDate.toString() ,0,'');
			selectionCloseSignal.dispatch();
			
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