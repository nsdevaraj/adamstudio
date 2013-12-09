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
	import com.adams.dt.view.TaskListSkinView;
	import com.adams.dt.view.components.toDo.ToDoListComponent;
	import com.adams.dt.view.components.toDo.TodoHeader;
	import com.adams.dt.view.renderers.ToDoListRenderer;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.views.components.NativeList;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.events.FlexMouseEvent;
	
	import spark.components.NavigatorContent;
	import spark.events.TextOperationEvent;
	import spark.layouts.VerticalLayout;
	
	public class TaskListViewMediator extends AbstractViewMediator
	{ 		 
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject("tasksDAO")]
		public var tasksDAO:AbstractDAO;
		
		[Inject("propertiespresetsDAO")]
		public var propertiespresetsDAO:AbstractDAO;
		
		private var projectId:int = 0;
		private var selectedDomainLabel:String;
		private var _selectedTaskId:int = -1;
		private var _selectedTaskSet:Boolean;
		private var _onEnter:Boolean;
		
		private var _homeState:String;
		public function get homeState():String 	{
			return _homeState;
		}
		public function set homeState( value:String ):void {
			_homeState = value;
			if( value==Utils.TASKLIST_INDEX ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage, false, 0, true );
			}
		}
		
		protected function addedtoStage( event:Event ):void {
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function TaskListViewMediator( viewType:Class=null )
		{
			super( TaskListSkinView );
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():TaskListSkinView 	{
			return _view as TaskListSkinView;
		}
		
		[MediateView( "TaskListSkinView" )]
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
			viewState = Utils.TASKLIST_INDEX; 
			if( !currentInstance.mapConfig.firstLoadShow ) {
				currentInstance.mapConfig.firstLoadShow = true;
				_onEnter = false;
				view.toDoViewer.removeAllElements(); 
				controlSignal.getTodoTasksSignal.dispatch( this, currentInstance.mapConfig.currentPerson.personId );	
			}
			else {
				if( view.toDoViewer.selectedChild ) {
					var selectedList:ToDoListComponent = isDomainAvailable( view.toDoViewer.selectedChild.label );
					if( selectedList ) {
						getRefreshed( selectedList.dataProvider as ArrayCollection );
						if( selectedList.dataProvider.length == 0 ) {
							view.toDoViewer.removeElement( view.toDoViewer.selectedChild as IVisualElement );
						}
					}
					view.toDoViewer.visible = true;
				}
			}
		} 
		
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		
		override protected function serviceResultHandler( obj:Object, signal:SignalVO ):void {  
			if( signal.destination ==  Utils.TASKSKEY && signal.action == Action.FIND_ID ) {
				if( FlexGlobals.topLevelApplication.parameters.htmlURL.indexOf( 'http' ) != -1 && FlexGlobals.topLevelApplication.parameters.htmlURL.indexOf( '&' ) != -1 && !_selectedTaskSet ) {
					var htmlUrl:String = FlexGlobals.topLevelApplication.parameters.htmlURL; 
					htmlUrl = htmlUrl.split( "#amp" ).join( "&" ); 
					var rootFile:String = htmlUrl.split( ".html?" )[ 1 ];			    									
					var setMessagetask:String = rootFile.split( "&" )[ 3 ];
					_selectedTaskId = setMessagetask.split( "taskId=" )[ 1 ];
					var selectedTask:Tasks = GetVOUtil.getVOObject( _selectedTaskId, tasksDAO.collection.items, tasksDAO.destination, Tasks ) as Tasks;
					selectedDomainLabel = selectedTask.projectObject.categories.categoryFK.categoryFK.categoryName;
					_selectedTaskSet = true;
				}
				makeAccordion( signal.currentProcessedCollection  as ArrayCollection );
			}
			
			if( ( signal.destination == Utils.COMMENTVOKEY ) && ( signal.action == Action.CREATE ) ) {
				closeNotePopup();
			}
			
			if( ( signal.destination == Utils.TASKSKEY )  && ( signal.action == Action.FINDTASKSLIST ) ) {
				if( currentInstance.mapConfig.previousState == Utils.FROM_MPV ) {
					if( mainViewMediator.isTaskInToDo( currentInstance.mapConfig.currentProject.tasksCollection ) ) {
						currentInstance.mapConfig.isTaskInToDo = true;
						mainViewMediator.showAccordingScreen();
					}
					else {
						currentInstance.mapConfig.isTaskInToDo = false;
						controlSignal.changeStateSignal.dispatch( Utils.GENERAL_INDEX );
					}
				}
				else {
					mainViewMediator.showAccordingScreen();
				}
			}
		}
		 
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners();
		} 
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			view.toDoViewer.visible = false;
			super.cleanup( event ); 		
		} 
		
		private function makeAccordion( tasksCollection:ArrayCollection ):void {
			for each( var item:Object in tasksCollection ) {
				var domain:Categories = item.projectObject.categories.domain;
				var taskList:ToDoListComponent = isDomainAvailable ( domain.categoryName ); 
				while( !taskList ) {
					creatNewDomain( item );
					taskList = isDomainAvailable ( domain.categoryName ); 
				}
				taskList.newDataProvider.addItem( item );
			}
			
			setToDoProvider();
			
			setSelectedDomain();
			
			if( !_onEnter ) {
				_onEnter = true;
			}
			
			view.toDoViewer.visible = true;
		}
		
		private function setToDoProvider():void {
			for( var i:int = 0; i < view.toDoViewer.numElements; i++ ) {
				var navContent:NavigatorContent = NavigatorContent( view.toDoViewer.getElementAt( i ) ); 
				for( var j:int = 0; j < navContent.numElements; j++ ) {
					if( navContent.getElementAt( j ) is ToDoListComponent ) {
						ToDoListComponent( navContent.getElementAt( j ) ).commitProvider( _onEnter );
					}
				}
			}
		}
		
		private function creatNewDomain( item:Object ):void {
			var navigator:NavigatorContent = new NavigatorContent();
			navigator.percentWidth = 100;
			navigator.percentHeight = 100;
			navigator.label = item.projectObject.categories.categoryFK.categoryFK.categoryName;
			
			var vl:VerticalLayout = new VerticalLayout();
			vl.gap = 0;
			navigator.layout = vl;
			
			var todoHeader:TodoHeader = new TodoHeader();
			navigator.addElement( todoHeader );
			
			var taskList:ToDoListComponent = new ToDoListComponent();
			taskList.percentWidth = 100;
			taskList.percentHeight = 100;
			taskList.itemRenderer = new ClassFactory( ToDoListRenderer );
			taskList.renderSignal.add( onTaskSelect );
			taskList.dataProvider = new ArrayCollection();
			BindingUtils.bindProperty( todoHeader, 'sourceProvider', taskList, 'dataProvider', true, true );
			navigator.addElement( taskList );
			
			view.toDoViewer.addElement( navigator );
		}
		
		private function isDomainAvailable( domainName:String ):ToDoListComponent {
			for( var i:int = 0; i < view.toDoViewer.numElements; i++ ) {
				var navContent:NavigatorContent = NavigatorContent( view.toDoViewer.getElementAt( i ) ); 
				if( navContent.label == domainName ) {
					for( var j:int = 0; j < navContent.numElements; j++ ) {
						if( navContent.getElementAt( j ) is ToDoListComponent ) {
							return ToDoListComponent( navContent.getElementAt( j ) );
						}
					}
				}
			}
			return null;
		}
		
		private function setSelectedDomain():void {
			if( _selectedTaskId != -1 ) {
				
				for( var i:int = 0; i < view.toDoViewer.numElements; i++ ) {
					if( NavigatorContent( view.toDoViewer.getElementAt( i ) ).label == selectedDomainLabel ) {
						view.toDoViewer.selectedChild = NavigatorContent( view.toDoViewer.getElementAt( i ) );
						break;
					}
				}
				
				var selectedList:NativeList;
				for( var j:int = 0; j < NavigatorContent( view.toDoViewer.selectedChild ).numElements; j++ ) {
					if( NavigatorContent( view.toDoViewer.selectedChild ).getElementAt( j ) is NativeList ) {
						selectedList = NavigatorContent( view.toDoViewer.selectedChild ).getElementAt( j ) as NativeList;
						break;	
					}
				}
				openTaskFromMail( _selectedTaskId, selectedList  );
			}
		}
		
		private function getRefreshed( provider:ArrayCollection ):void {
			for( var i:int = 0; i < provider.length; i++ ) {
				var prjStatus:int = Tasks( provider.getItemAt( i ) ).projectObject.projectStatusFK;
				var tskStatus:int = Tasks( provider.getItemAt( i ) ).taskStatusFK;
				if( ( prjStatus == ProjectStatus.ARCHIVED )  || ( tskStatus == TaskStatus.FINISHED ) ) {
					provider.removeItemAt( i );
				}
			}
			provider.refresh();
		}
		
		private function openTaskFromMail( id:int, selectedList:NativeList ):void {
			for( var i:int = 0; i < selectedList.dataProvider.length; i ++ ) {
				if( Tasks( selectedList.dataProvider.getItemAt( i ) ).taskId == id ) {
					selectedList.selectedItem = selectedList.dataProvider.getItemAt( i );
					break;
				}
			}
			var obj:Tasks = selectedList.selectedItem as Tasks;
			selectedList.renderSignal.dispatch( obj );
		}
		
		private function onTaskSelect( obj:Object ):void {
			if( obj is Projects ) {
				updateStatus( obj as Projects );
			}
			else if( obj is Array ) {
				gotoMPV( obj[ 0 ] as Projects );
			}
			else if( obj is Tasks ) {
				updateTasks( obj as Tasks );
			}
			else if( obj.data is int ) {
				projectId = obj.data;
				var point:Point = globalToLocal( obj.point );
				view.notesBox.x = point.x;
				view.notesBox.y = point.y;
				view.notesBox.displayPopUp = true;
				view.addElement( view.notesBox );
				view.notesBox.resetNote();
				
				view.notesBox.commentTitleId.setFocus();
				view.notesBox.popGroup.addEventListener( FlexMouseEvent.MOUSE_DOWN_OUTSIDE, closeNotePopup, false, 0, true );
				view.notesBox.noteCreateBtn.addEventListener( MouseEvent.CLICK, onSaveAndCloseNote, false, 0, true );
				view.notesBox.commentTitleId.addEventListener( TextOperationEvent.CHANGE, enableSaveButton, false, 0, true );
				view.notesBox.commentDescriptionId.addEventListener( TextOperationEvent.CHANGE, enableSaveButton, false, 0, true );
			}
		}
		
		private function closeNotePopup( event:Event=null ):void {
			view.notesBox.popGroup.removeEventListener( FlexMouseEvent.MOUSE_DOWN_OUTSIDE, closeNotePopup );
			view.notesBox.noteCreateBtn.removeEventListener( MouseEvent.CLICK, onSaveAndCloseNote );
			view.notesBox.commentTitleId.removeEventListener( TextOperationEvent.CHANGE, enableSaveButton );
			view.notesBox.commentDescriptionId.removeEventListener( TextOperationEvent.CHANGE, enableSaveButton );
			view.removeElement( view.notesBox );
		}
		
		private function enableSaveButton( event:TextOperationEvent ):void {
			if( ( view.notesBox.commentTitleId.text != '' ) && ( view.notesBox.commentDescriptionId.text != '' ) ) {
				view.notesBox.noteCreateBtn.enabled = true;
			}
			else {
				view.notesBox.noteCreateBtn.enabled = false;
			}
		}
		
		private function onSaveAndCloseNote( event:MouseEvent ):void {
			var commentvo:CommentVO = new CommentVO();
			commentvo.commentID = NaN;
			commentvo.commentTitle = view.notesBox.commentTitleId.text.toString();
			commentvo.commentX = 0;
			commentvo.commentY = 0;
			commentvo.commentWidth = 0;
			commentvo.commentHeight = 0;
			commentvo.commentColor = 0;
			commentvo.commentDescription = ProcessUtil.convertToByteArray( view.notesBox.commentDescriptionId.text );
			commentvo.creationDate = new Date();
			commentvo.createdby = currentInstance.mapConfig.currentPerson.personId;
			commentvo.filefk = 0;
			commentvo.commentType = projectId; 
			commentvo.commentBoxX = 0;
			commentvo.commentBoxY = 0;
			commentvo.commentMaximize = false;
			commentvo.commentStatus = 'TodoNote';
			commentvo.misc = ' ';
			commentvo.history = 0;	
			
			controlSignal.createCommentSignal.dispatch( this, commentvo );			
		}
		
		private function gotoMPV( prj:Projects ):void {
			currentInstance.mapConfig.previousState = Utils.FROM_MPV;
			currentInstance.mapConfig.currentProject = prj;
			controlSignal.getProjectTasksSignal.dispatch( this, currentInstance.mapConfig.currentProject.projectId );
		}
		
		private function updateStatus( prj:Projects ):void {
			controlSignal.updateProjectSignal.dispatch( this, prj );
		}
		
		private function updateTasks( currentTasks:Tasks ):void {
			currentInstance.mapConfig.previousState = Utils.FROM_TODO;
			currentInstance.mapConfig.isTaskInToDo = true;
			currentInstance.mapConfig.currentTasks = currentTasks;
			currentInstance.mapConfig.currentProject = currentTasks.projectObject;
			controlSignal.getProjectTasksSignal.dispatch( this, currentInstance.mapConfig.currentProject.projectId );
		}
	}
}