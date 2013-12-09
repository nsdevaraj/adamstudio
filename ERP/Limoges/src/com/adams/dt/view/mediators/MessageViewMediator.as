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
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.ProjectUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.MessageSkinView;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.Description;
	import com.adams.swizdao.util.ObjectUtils;
	import com.adams.swizdao.views.components.NativeList;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.utils.TextFlowUtil;
	
	
	public class MessageViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		private var _homeState:String;
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.MESSAGE_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function MessageViewMediator( viewType:Class=null )
		{
			super( MessageSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():MessageSkinView 	{
			return _view as MessageSkinView;
		}
		
		[MediateView( "MessageSkinView" )]
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
				if(currentInstance.mapConfig.currentTasks.deadlineTime == 0)
				{
					view.currentState = Utils.MESSAGE_INDEX;
				}
				if(currentInstance.mapConfig.currentTasks.taskComment){
					view.receivedCommTxt.textFlow = TextFlowUtil.importFromString( Utils.getComments ( currentInstance.mapConfig.currentTasks.taskComment.toString() ) );
				}
			}
			if(currentInstance.mapConfig.currentProject.projectStatusFK == ProjectStatus.STANDBY)view.currentState = Utils.MESSAGE_STANDBY;
			if(currentInstance.mapConfig.currentProject.projectStatusFK == ProjectStatus.ARCHIVED)view.currentState = Utils.MESSAGE_PROJECTCLOSE;
			if(view.archiveBtn)view.archiveBtn.addEventListener(MouseEvent.CLICK ,onArchiveHandler );
			if(view.resumeBtn)view.resumeBtn.addEventListener(MouseEvent.CLICK ,onResumeHandler );
			if(view.replyBtn)view.replyBtn.addEventListener(MouseEvent.CLICK ,onReplyHandler );
			if(view.replyCommTxt)view.replyCommTxt.editor.text = '';
			
		}
		protected function onReplyHandler( event :MouseEvent ) :void
		{
			controlSignal.showAlertSignal.dispatch(this,Utils.REPLY_TASK_MESSAGE,Utils.APPTITLE,0,Utils.REPLY_TASK_MESSAGE);
		}
		protected function onArchiveHandler ( event :MouseEvent ):void
		{
			controlSignal.showAlertSignal.dispatch(this,Utils.ARCHIVE_TASK_MESSAGE,Utils.APPTITLE,0,Utils.ARCHIVE_TASK_MESSAGE);
		}
		
		protected function archiveTask():void
		{
			var createdTask:Tasks = currentInstance.mapConfig.currentTasks;
			var str:String = currentInstance.mapConfig.currentPerson.personFirstname+Utils.SEPERATOR+
				view.receivedCommTxt.text+Utils.SEPERATOR+
				currentInstance.mapConfig.currentPerson.personId+","+
				currentInstance.mapConfig.currentPerson.defaultProfile;
			createdTask.taskComment = ProcessUtil.convertToByteArray( str );
			createdTask.deadlineTime = 0;
			createdTask.wftFK = ProcessUtil.getMessageTemplate( ProcessUtil.getOtherProfileCode(currentInstance.mapConfig.currentProfileCode),currentInstance.mapConfig.messageTemplatesCollection ).workflowTemplateId;
			var status:Status = new Status();
			status.statusId = TaskStatus.FINISHED;
			createdTask.taskStatusFK = status.statusId;
			controlSignal.updateTaskSignal.dispatch( this ,createdTask );
		}
		
		protected function onResumeHandler ( event:MouseEvent ):void
		{
			controlSignal.showAlertSignal.dispatch(this,Utils.RESUME_PROJECT,Utils.APPTITLE,0,Utils.RESUME_PROJECT);
		}
		
		override public function alertReceiveHandler(obj:Object):void {
			var messageStatus:String;
			var objArray:Array;
			if( obj==Utils.ARCHIVE_TASK_MESSAGE){
				archiveTask();
			}else if( obj == Utils.RESUME_PROJECT) {
				currentInstance.mapConfig.currentProject.projectStatusFK = ProjectStatus.INPROGRESS;
				messageStatus = currentInstance.mapConfig.currentPerson.personFirstname+
					Utils.SEPERATOR+Utils.PROJECT_RESUME+
					Utils.SEPERATOR+currentInstance.mapConfig.currentPerson.personId+","+
					currentInstance.mapConfig.currentPerson.defaultProfile;;
				objArray = ProjectUtil.standByProject( currentInstance.mapConfig.currentProject ,
					currentInstance.mapConfig.currentProject.workflowFK,
					currentInstance.mapConfig.currentProject.projectStatusFK,messageStatus,
					currentInstance.mapConfig.currentPerson.personId );
				controlSignal.modifyProjectStatusSignal.dispatch(this, objArray );
			}else if( obj == Utils.REPLY_TASK_MESSAGE ){
				var replyTask:Tasks = new Tasks();
				replyTask.projectFk = currentInstance.mapConfig.currentProject.projectId;
				replyTask.projectObject = currentInstance.mapConfig.currentProject;
				replyTask.deadlineTime = 0;
				replyTask.personFK  = currentInstance.mapConfig.currentPerson.personId;
				replyTask.domainDetails = currentInstance.mapConfig.currentProject.categories.categoryFK.categoryFK;
				replyTask.previousTask = currentInstance.mapConfig.currentTasks;
				var str:String = currentInstance.mapConfig.currentPerson.personFirstname+Utils.SEPERATOR+
					view.replyCommTxt.getText+Utils.SEPERATOR+
					currentInstance.mapConfig.currentPerson.personId+","+
					currentInstance.mapConfig.currentPerson.defaultProfile;
				replyTask.taskComment = ProcessUtil.convertToByteArray( str );
				
				var status:Status = new Status();
				status.statusId = TaskStatus.WAITING;
				replyTask.taskStatusFK= status.statusId;
				replyTask.tDateCreation = new Date();
				replyTask.wftFK = ProcessUtil.getMessageTemplate( ProcessUtil.getOtherProfileCode(currentInstance.mapConfig.currentProfileCode),currentInstance.mapConfig.messageTemplatesCollection ).workflowTemplateId;
				replyTask.tDateEndEstimated = new Date(); 
				replyTask.onairTime = 0;
				controlSignal.createTaskSignal.dispatch( this ,replyTask, Utils.MESSAGE_INDEX );
			}
		}
 
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		
		override protected function serviceResultHandler( obj:Object, signal:SignalVO ):void {  
			if( ( signal.action == Action.CREATE ) && ( signal.destination == Utils.TASKSKEY ) ) {
				var createdTask:Tasks = obj as Tasks;
				var updateTask:Tasks = new Tasks();
				var status:Status = new Status();
				status.statusId = TaskStatus.FINISHED;
				updateTask = createdTask.previousTask
				updateTask.taskStatusFK = status.statusId;
				updateTask.nextTask = createdTask;
				controlSignal.updateTaskSignal.dispatch( this, updateTask );	
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