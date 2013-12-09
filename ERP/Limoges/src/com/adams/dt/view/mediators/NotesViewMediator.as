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
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.NotesSkinView;
	import com.adams.dt.view.components.CommentBoxComponent;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.FlexMouseEvent;
	
	import spark.events.GridSelectionEvent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	import spark.utils.TextFlowUtil;
	
	
	public class NotesViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		private var commentCollection:ArrayCollection;
		private var eventsCollection:ArrayCollection;
		private var historyCollection:ArrayCollection;
		private var filteredCollection:ArrayCollection;
		
		private var _homeState:String;
		public function get homeState():String {
			return _homeState;
		}
		public function set homeState( value:String ):void {
			_homeState = value;
			if( value == Utils.NOTES_INDEX ) {
				addEventListener( Event.ADDED_TO_STAGE,addedtoStage );
			} 
		}
		
		protected function addedtoStage( event:Event ):void {
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function NotesViewMediator( viewType:Class=null )
		{
			super( NotesSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():NotesSkinView 	{
			return _view as NotesSkinView;
		}
		
		[MediateView( "NotesSkinView" )]
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
			viewState = Utils.NOTES_INDEX;
			view.tasksButton.selected = true;
			view.notesButton.selected = true;
			view.eventsButton.selected = false;
			controlSignal.getProjectCommentsSignal.dispatch( this, currentInstance.mapConfig.currentProject.projectId );
			controlSignal.getProjectEventsSignal.dispatch( this, currentInstance.mapConfig.currentProject.projectId );
		}
		
		protected function setDataProviders():void {	    
		}
		
		override protected function setRenderers():void {
			view.createNote.clicked.add( createNotes );
			view.searchSelector.addEventListener( IndexChangeEvent.CHANGE, onSearchSelect, false, 0, true );
			view.historyGrid.addEventListener( GridSelectionEvent.SELECTION_CHANGE, frameDetails, false, 0, true );
			super.setRenderers();  
		}  
		
		override protected function serviceResultHandler( obj:Object, signal:SignalVO ):void {  
			if( ( signal.action == Action.FIND_ID ) && ( signal.destination == Utils.COMMENTVOKEY ) ) {
				commentCollection = signal.currentProcessedCollection as ArrayCollection;
				prepareHistoryProvider();
			}
			if( ( signal.action == Action.CREATE ) && ( signal.destination == Utils.COMMENTVOKEY ) ) {
				controlSignal.getProjectCommentsSignal.dispatch( this, currentInstance.mapConfig.currentProject.projectId );
				closeNotePopup();
			}
			if( ( signal.action == Action.FINDTASKSLIST ) && ( signal.destination == Utils.EVENTSKEY ) ) {
				eventsCollection = signal.currentProcessedCollection as ArrayCollection;
				prepareHistoryProvider();
			}
		} 
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.formHeader.addEventListener( MouseEvent.CLICK, closeForm, false, 0, true );
			view.tasksButton.addEventListener( Event.CHANGE, onFilter, false, 0, true );
			view.notesButton.addEventListener( Event.CHANGE, onFilter, false, 0, true );
			view.eventsButton.addEventListener( Event.CHANGE, onFilter, false, 0, true );
		}
		
		private function onFilter( event:Event = null ):void {
			if( !filteredCollection ) {
				filteredCollection = new ArrayCollection();
			}
			else {
				filteredCollection.removeAll();
			}
			for each( var item:Object in historyCollection ) {
				switch( item.type ) {
					case 'Tasks':
						if( view.tasksButton.selected ) {
							filteredCollection.addItem( item );
						}
						break;
					case 'Notes':
						if( view.notesButton.selected ) {
							filteredCollection.addItem( item );
						}
						break;
					case 'Events':
						if( view.eventsButton.selected ) {
							filteredCollection.addItem( item );
						}
						break;
					default:
						break;
				}
			}
			filteredCollection.refresh();
			view.historyGrid.dataProvider = filteredCollection;
		}
		
		private function createNotes( event:MouseEvent ):void {
			view.notesBox.displayPopUp = true;
			view.notesContainer.addElement( view.notesBox );
			view.notesBox.resetNote();
			view.notesBox.commentTitleId.setFocus();
			view.notesBox.popGroup.addEventListener( FlexMouseEvent.MOUSE_DOWN_OUTSIDE, closeNotePopup, false, 0, true );
			view.notesBox.noteCreateBtn.addEventListener( MouseEvent.CLICK, onSaveAndCloseNote, false, 0, true );
			view.notesBox.commentTitleId.addEventListener( TextOperationEvent.CHANGE, enableSaveButton, false, 0, true );
			view.notesBox.commentDescriptionId.addEventListener( TextOperationEvent.CHANGE, enableSaveButton, false, 0, true );
		}
		
		private function closeNotePopup( event:Event=null ):void {
			view.notesBox.popGroup.removeEventListener( FlexMouseEvent.MOUSE_DOWN_OUTSIDE, closeNotePopup );
			view.notesBox.noteCreateBtn.removeEventListener( MouseEvent.CLICK, onSaveAndCloseNote );
			view.notesBox.commentTitleId.removeEventListener( TextOperationEvent.CHANGE, enableSaveButton );
			view.notesBox.commentDescriptionId.removeEventListener( TextOperationEvent.CHANGE, enableSaveButton );
			view.notesContainer.removeElement( view.notesBox );
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
			commentvo.commentType = currentInstance.mapConfig.currentProject.projectId; 
			commentvo.commentBoxX = 0;
			commentvo.commentBoxY = 0;
			commentvo.commentMaximize = false;
			commentvo.commentStatus = 'TodoNote';
			commentvo.misc = ' ';
			commentvo.history = 0;	
			
			controlSignal.createCommentSignal.dispatch( this, commentvo );			
		} 
		
		private function prepareHistoryProvider():void {
			if( !view.autoComplete.nameProperty ) {
				var fields:IList; 
				var searchList:IList; 
				fields = new ArrayList();
				searchList = new ArrayList();
				searchList.addItem( 'All' );
				for( var i:int = 0; i < view.historyGrid.columns.length; i++ ) {
					fields.addItem( view.historyGrid.columns.getItemAt( i ).dataField );
					searchList.addItem( view.historyGrid.columns.getItemAt( i ).headerText );
				}
				view.autoComplete.nameProperty = fields;
				view.searchSelector.dataProvider = searchList;
				view.searchSelector.selectedIndex = 0;
			}
			if( historyCollection ) {
				historyCollection.removeAll();
			}
			else {
				historyCollection = new ArrayCollection();
				historyCollection.sort = makeHistorySort();
				historyCollection.refresh();
			}
			for each( var item:Tasks in currentInstance.mapConfig.currentProject.tasksCollection ) {
				var tasksObj:Object = {};
				tasksObj.title = item.workflowtemplateFK.taskLabel;
				tasksObj.person = item.personDetails.personFirstname;
				if( item.taskComment )	{
					if( item.workflowtemplateFK.taskCode == 'M01' ) {
						tasksObj.message = TextFlowUtil.importFromString( Utils.getComments ( item.taskComment.toString() ) ).getText();
					}
					else {
						tasksObj.message = TextFlowUtil.importFromString( item.taskComment.toString() ).getText();
					}
				}
				else {
					tasksObj.message = '';	
				}
				tasksObj.date = item.tDateCreation.toString();
				tasksObj.type = 'Tasks';
				historyCollection.addItem( tasksObj );
			}
			for each( var comment:CommentVO in commentCollection ) {
				var notesObj:Object = {};
				notesObj.title = comment.commentTitle;
				notesObj.person = comment.personDetails.personFirstname;
				if( comment.commentDescription )	notesObj.message = TextFlowUtil.importFromString( comment.commentDescription.toString() ).getText();
				else	notesObj.message = '';
				notesObj.date = comment.creationDate.toString();
				notesObj.type = 'Notes';
				historyCollection.addItem( notesObj );
			}
			for each( var element:Events in eventsCollection ) {
				var eventsObj:Object = {};
				eventsObj.title = element.eventName;
				eventsObj.person = element.personDetails.personFirstname;
				if( element.details )	eventsObj.message = TextFlowUtil.importFromString( element.details.toString() ).getText();
				else	eventsObj.message = '';
				eventsObj.date = element.eventDateStart.toString();
				eventsObj.type = 'Events';
				historyCollection.addItem( eventsObj );
			}
			historyCollection.refresh();
			onFilter();
			view.historyGrid.selectedIndex = 0;
			showDetails();
		}
		
		private function makeHistorySort():Sort {
			var dataSortField:SortField = new SortField();
			dataSortField.name = "date";
			
			var dataSort:Sort = new Sort();
			dataSort.fields = [ dataSortField ];
			dataSort.compareFunction = sortCompareFunction;
			return dataSort;
		}
		
		private function sortCompareFunction( objectA:Object, objectB:Object, fields:Array = null ):int {
			var aTime:Number = new Date( objectA.date ).getTime();
			var bTime:Number = new Date( objectB.date ).getTime();
			if( aTime > bTime ) {
				return -1;
			}
			else if( aTime < bTime ) {
				return 1;
			}
			return 0;
		}
		
		private function frameDetails( event:GridSelectionEvent ):void {
			showDetails();
		}
		
		private function showDetails():void {
			view.formPanel.visible = true;
			view.formPanel.height = 200;
			var selectedHistory:Object = view.historyGrid.selectedItem;
			if( selectedHistory ) {
				//view.detailHead.text = currentInstance.mapConfig.currentProject.projectName;
				view.detailTitle.text = selectedHistory.title;
				view.detailMessage.text = selectedHistory.message;
				view.detailPerson.text = selectedHistory.person;
				view.detailDate.text = selectedHistory.date;
				view.detailType.text = selectedHistory.type;
			}
		}
		private function closeForm(event:MouseEvent):void{
			view.formPanel.visible = false;
			view.formPanel.height = 0;
		}
		
		/**
		 * On Selecting the search item for assigning labelField of the autoComplete component
		 */
		private function onSearchSelect( event:IndexChangeEvent ):void {
			var selectedIndex:int = view.searchSelector.selectedIndex;
			if( selectedIndex == 0 ) {
				view.autoComplete.labelField = 'All';
			}
			else {
				view.autoComplete.labelField = view.autoComplete.nameProperty.getItemAt( selectedIndex - 1 ) as String;
			}
		}
		
		override protected function pushResultHandler( signal:SignalVO ): void { 
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			view.formHeader.removeEventListener( MouseEvent.CLICK, closeForm );
			view.tasksButton.removeEventListener( Event.CHANGE, onFilter );
			view.notesButton.removeEventListener( Event.CHANGE, onFilter );
			view.eventsButton.removeEventListener( Event.CHANGE, onFilter );
			super.cleanup( event ); 		
		} 
	}
}