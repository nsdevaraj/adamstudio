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
	import com.adams.dt.view.CorrectionSkinView;
	import com.adams.dt.view.components.FileUploadTileList;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.utils.TextFlowUtil;
	
	public class CorrectionViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject("Tasks")]
		public var fileUploadTileList:FileUploadTileList;
		
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
			if(value==Utils.CORRECTION_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function CorrectionViewMediator( viewType:Class=null )
		{
			super( CorrectionSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():CorrectionSkinView 	{
			return _view as CorrectionSkinView;
		}
		
		[MediateView( "CorrectionSkinView" )]
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
			viewState = Utils.CORRECTION_INDEX;
			view.fileTile.addElement(fileUploadTileList);
			fileProperties();
			if(currentInstance.mapConfig.currentProject)
				view.projectNameId.text = currentInstance.mapConfig.currentProject.projectName;
			
			var commentStr:String = ''; 
			if( currentInstance.mapConfig.currentTasks ){
				if( currentInstance.mapConfig.currentTasks.previousTask ){
					if( currentInstance.mapConfig.currentTasks.previousTask.taskComment ){
						commentStr = currentInstance.mapConfig.currentTasks.previousTask.taskComment.toString();
					}
				}
			}	
			
			if( currentInstance.mapConfig.currentTasks ) {
				view.previousNavigationId.label = Tasks( currentInstance.mapConfig.currentTasks ).workflowtemplateFK.optionPrevLabel;
				view.nextNavigationId.label = Tasks( currentInstance.mapConfig.currentTasks ).workflowtemplateFK.optionNextLabel;
			}
			
			view.comments.textFlow = TextFlowUtil.importFromString( commentStr );
			
			controlSignal.getProjectFilesSignal.dispatch(this,currentInstance.mapConfig.currentProject.projectId);
		} 
		
		protected function fileProperties():void {
			fileUploadTileList.componentType = "default";
			fileUploadTileList.fileType = Utils.TASKFILETYPE; 
			callLater(fileUploadTileList.resetUploader);
		}

		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {
			if( signal.destination == ArrayUtil.PAGINGDAO && signal.action == Action.CREATENAVTASK ){
				var resultNavigationCollect : ArrayCollection = obj as ArrayCollection;							
				if( resultNavigationCollect ) {
					controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
				}			
			}
			if( ( signal.action == Action.CLOSEPROJECT ) && ( signal.destination == ArrayUtil.PAGINGDAO ) ) {
				if( currentInstance.mapConfig.currentTasks ) {
					currentInstance.mapConfig.currentTasks.taskStatusFK = TaskStatus.FINISHED;
				}
				controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
			}
			if( signal.destination == Utils.FILEDETAILSKEY ){				
				if( signal.action == Action.FIND_ID ){	
					var projectFileCollection:ArrayCollection = new ArrayCollection();
					for each( var itemFiles:FileDetails in signal.currentProcessedCollection) {
						if(itemFiles.visible){
							projectFileCollection.addItem( itemFiles );
						}
					}
					fileUploadTileList.fileListDataProvider = projectFileCollection;
					fileUploadTileList.fileListDataProvider.refresh();
					fileUploadTileList.onDataChange();
				} 
			}
		}		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.previousNavigationId.clicked.add( backNewProjTask );
			view.nextNavigationId.clicked.add( archiveProjectHandler );
		}
		
		protected function closeTitleHandler( event:Event = null ):void {
			view.currentState = Utils.CORRECTION_INDEX;
		}
		
		override public function alertReceiveHandler(obj:Object):void {
			if( obj==Utils.ARCHIVE) {
				archiveProject();
			}
		}
		
		protected function archiveProjectHandler(event:MouseEvent ):void {
			controlSignal.showAlertSignal.dispatch(this,Utils.ARCHIVE_MESSAGE,Utils.APPTITLE,0, Utils.ARCHIVE);
		}
		
		protected function archiveProject():void {
			var objArray:Array = ProjectUtil.abortProject(Utils.ARCHIVE,currentInstance.mapConfig.currentProject,currentInstance.mapConfig.closeProjectTemplate,
				currentInstance.mapConfig.currentTasks,currentInstance.mapConfig.currentPerson,'');
			currentInstance.mapConfig.closeTaskCollection = objArray[objArray.length-1];
			controlSignal.closeProjectsSignal.dispatch(this,objArray);
		}		
		
		protected function backNewProjTask(event:MouseEvent ):void {
			controlSignal.changeStateSignal.dispatch( Utils.PROJECTCORRECTION_INDEX );
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