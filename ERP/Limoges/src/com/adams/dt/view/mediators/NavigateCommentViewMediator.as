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
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.NavigateCommentSkinView;
	import com.adams.dt.view.components.FileUploadTileList;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.views.components.NativeButton;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	
	import org.osflash.signals.Signal;
	
	
	public class NavigateCommentViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject("Release")]
		public var fileUploadTileList:FileUploadTileList;
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject("filedetailsDAO")]
		public var filedetailsDAO:AbstractDAO;
		
		public var selectionCloseSignal:Signal = new Signal();
		
		[Bindable]
		private var fileTempCollection:ArrayCollection = new ArrayCollection();	
		
		private var isBackButton:Boolean;
		
		private var _homeState:String;
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if( value == Utils.NAVIGATECOMMENT_INDEX ) addEventListener( Event.ADDED_TO_STAGE,addedtoStage );
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function NavigateCommentViewMediator( viewType:Class=null )
		{
			super( NavigateCommentSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():NavigateCommentSkinView 	{
			return _view as NavigateCommentSkinView;
		}
		
		[MediateView( "NavigateCommentSkinView" )]
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
			viewState = Utils.NAVIGATECOMMENT_INDEX;
			view.fileTile.addElement(fileUploadTileList);
			fileUploadTileList.componentType = "upload";			
			fileUploadTileList.fileType = Utils.TASKFILETYPE;
			resetForm();
			BindingUtils.bindProperty(view.submitBtn,'enabled',fileUploadTileList,'uploadNotInProcess')
		} 
		
		protected function fileProperties():void {
			fileUploadTileList.componentType = "upload";
			fileUploadTileList.fileType = Utils.TASKFILETYPE; 
			fileUploadTileList.resetUploader();
		}
		
		override protected function setRenderers():void {
			super.setRenderers();  
		}
		
		private var _storedNativeButton:NativeButton;
		public function get storedNativeButton():NativeButton
		{
			return _storedNativeButton;
		}
		
		public function set storedNativeButton( value:NativeButton ):void
		{
			_storedNativeButton = value;
			resetForm();
		}
 		
		private function resetForm():void {
			view.replyCommentsId.editor.text = "";
			callLater(fileUploadTileList.resetUploader);
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.submitBtn.clicked.add( submitCommentsHandler );
			view.cancelBtn.clicked.add( cancelCommentsHandler );
			
		}
		
		protected function submitCommentsHandler( event:MouseEvent ):void {
			var workflowtemplates:Workflowstemplates =  Workflowstemplates( currentInstance.mapConfig.currentTasks.workflowtemplateFK );
			var tempCurrentTasks:Tasks = Tasks( currentInstance.mapConfig.currentTasks );
			var tempCurrentProjects:Projects = Projects( currentInstance.mapConfig.currentProject );
			var tempNextWorkflowtemplatesId:int = 0;
			var tasksComments:String = ProcessUtil.convertToByteArray( view.replyCommentsId.getText ).toString();
			var tempNextWorkflowtempCode:String = null;
			if( view.replyCommentsId.editor.text.length > 0 )
			{
				switch( NativeButton( storedNativeButton ).id ) {				
				case 'previousNavigationId':
						isBackButton = false;
						if( workflowtemplates.prevTaskFk ) {
							tempNextWorkflowtemplatesId = workflowtemplates.prevTaskFk.workflowTemplateId;
							tempNextWorkflowtempCode = workflowtemplates.prevTaskFk.taskCode;
							mainViewMediator.view.general.view.department.text = 'CORRECTIONS';
						}
						break;
					case 'nextNavigationId':
						isBackButton = true;
						if( workflowtemplates.nextTaskFk ) {
							tempNextWorkflowtemplatesId = workflowtemplates.nextTaskFk.workflowTemplateId;
							tempNextWorkflowtempCode = workflowtemplates.nextTaskFk.taskCode;
						}
						break;
				}
				var propStr:String =  mainViewMediator.view.general.modifiedProperties();
				controlSignal.createNavigationTaskSignal.dispatch( mainViewMediator.view.general, tempCurrentTasks.taskId, tempCurrentProjects.workflowFK , tempNextWorkflowtemplatesId , tempCurrentProjects.projectId, Persons( currentInstance.mapConfig.currentPerson ).personId , tempNextWorkflowtempCode, tasksComments, propStr);
				selectionCloseSignal.dispatch();
			}
			else {
				controlSignal.showAlertSignal.dispatch(this,Utils.REPORT_ALERT_MESSAGE,Utils.APPTITLE,1,null);
			}
			
		}
		
		protected function cancelCommentsHandler( event:MouseEvent ):void {
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