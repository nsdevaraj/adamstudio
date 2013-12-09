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
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.PersonSelectionSkinView;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.FormUtils;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.managers.PopUpManager;
	import mx.validators.StringValidator;
	
	import org.osflash.signals.Signal;
	
	import spark.components.FormItem;
	import spark.components.TextInput;
	import spark.events.GridEvent;
	import spark.events.IndexChangeEvent;
	
	public class PersonSelectionViewMediator extends AbstractViewMediator
	{ 		 
		
		private var _propertyList:IList;
		private var _columnSelectList:IList;
		
		private var _selectedPersonIndex:int
		private var _headerArray:Array;
		public var _sortedPersonCollection:ArrayCollection = new ArrayCollection();
		
		[Inject("personsDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("profilesDAO")]
		public var profileDAO:AbstractDAO;
		
		public var selectionCloseSignal:Signal = new Signal();
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		private var _homeState:String;
		
		private var _stringValidator:StringValidator = new StringValidator();
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.PERSONSELECTION_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function PersonSelectionViewMediator( viewType:Class=null )
		{
			super( PersonSelectionSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():PersonSelectionSkinView 	{
			return _view as PersonSelectionSkinView;
		}
		
		[MediateView( "PersonSelectionSkinView" )]
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
			viewState = Utils.PERSONSELECTION_INDEX;
			
		} 
		protected function onRemovePersonHandler( obj:Persons  ):void
		{
			_selectedPersonIndex =view.personList.dataProvider.getItemIndex( obj );
			controlSignal.showAlertSignal.dispatch(this,Utils.DELETE_PERSON,Utils.APPTITLE,0,Utils.DELETE_PERSON);
		}
		
		protected function onGridDoubleClickHandler ( event :GridEvent ):void
		{
			selectionCloseSignal.dispatch(this,Persons(view.personList.selectedItem ).personFirstname); 
		}
		
		protected function onCloseClickHandler ( event :CloseEvent ):void
		{
			selectionCloseSignal.dispatch(this,''); 
			view.currentState = Utils.PERSON_INDEX;
		}
		
		protected function onClosePersonForm( event:MouseEvent  ):void
		{
			view.currentState = Utils.PERSON_INDEX;
			view.autoSearch.specificText = '';
		}
		protected function onSavePerson( event:MouseEvent ):void
		{
			if(!setFormValidator())
			{
				controlSignal.showAlertSignal.dispatch(this,Utils.REPORT_ALERT_MESSAGE,Utils.APPTITLE,1,null);
				return;
			}
			switch(view.personForm.personAction)
			{
				case Utils.PERSONADD:
					var addPerson:Persons = new Persons()
					addPerson.personPosition = getProfileLabel( sortedProfile );
					addPerson.activated = 1;
					addPerson.defaultProfile = sortedProfile;
					addPerson = FormUtils.getFormObject( view.personForm.personFormDetails , addPerson ) as Persons ;
					controlSignal.createPersonSignal.dispatch( this , addPerson )
					break;
				case Utils.PERSONUPDATE:
					FormUtils.getFormObject( view.personForm.personFormDetails , view.personForm.personObj ) ;
					controlSignal.editPersonSignal.dispatch( this , view.personForm.personObj )
					break;
			}
			
			view.currentState = Utils.PERSON_INDEX;
			_stringValidator.source = null;
		}
		protected function setFormValidator():Boolean
		{
			var result:ValidationResultEvent;
			var retValid:Boolean = false;
			for( var i:int = 0; i < view.personForm.personFormDetails.numElements; i++ ) {
				var formItem:Object = view.personForm.personFormDetails.getElementAt( i );
				if( formItem is FormItem ) {
					for( var j:int = 0; j < formItem.numElements; j++ ) {
						var uiComp:UIComponent = formItem.getElementAt( j ) as UIComponent;
						if(uiComp is TextInput )
						{
							_stringValidator.source = uiComp ;
							_stringValidator.property = "text";
							result = _stringValidator.validate();
							retValid = ( result.type == ValidationResultEvent.VALID )? true : false;
						}
					}
				}
			}
			return retValid;
		}
		
		/**
		 * 
		 **/
		private var _personListCollection:ArrayCollection;
		public function get personListCollection():ArrayCollection
		{
			return _personListCollection;
		}
		public function set personListCollection( value:ArrayCollection ):void
		{
			_personListCollection = value;
			
		}
		
		/**
		 * 
		 **/
		private var _sortedProfile:int;
		public function get sortedProfile():int
		{
			return _sortedProfile;
		}
		public function set sortedProfile(value:int):void
		{
			_sortedProfile = value;
			filteredPersonCollection();
		}
		protected function filteredPersonCollection():void
		{
			_sortedPersonCollection.removeAll();
			for each( var filterPerson:Persons in personListCollection )
			{
				if(filterPerson.defaultProfile ==  sortedProfile )
				{
					_sortedPersonCollection.addItem( filterPerson );
				}
			}
			_sortedPersonCollection.refresh();
			view.personList.dataProvider = _sortedPersonCollection;
			setUpAutoComplete();
			view.autoSearch.dataProvider = _sortedPersonCollection;  
		} 
		protected function setUpAutoComplete( ):void
		{
			_columnSelectList = new ArrayList();
			_columnSelectList.addItem( 'All' );
			_propertyList = new ArrayList();
			_headerArray  = [];
			for( var i:int = 0; i < view.personList.columns.length-1; i++ ) {
				_headerArray.push( view.personList.columns.getItemAt(i).dataField );
				_propertyList.addItem(view.personList.columns.getItemAt(i).dataField );
				_columnSelectList.addItem( view.personList.columns.getItemAt(i).headerText );
			} 
			view.autoSearch.nameProperty = _propertyList;
			view.selector.dataProvider = _columnSelectList
			view.selector.selectedIndex = 0; 
		}
		protected function onCombochange( event:IndexChangeEvent ):void {
			var currentIndex:int = ( event.currentTarget ).selectedIndex;
			view.autoSearch.labelField = currentIndex !=0 ? _headerArray[currentIndex-1] : 'All';
		}
		
		private function selectionControlsEventListener(event:FlexEvent):void{
			view.personForm.saveBtn.addEventListener( MouseEvent.CLICK , onSavePerson );
			view.personForm.cancelBtn.addEventListener( MouseEvent.CLICK , onClosePersonForm );        
		}
		protected function addPersonHandler(event:MouseEvent):void
		{
			view.currentState = Utils.PERSON_VIEW;
			view.personForm.personObj = new Persons();
			view.personForm.addEventListener(FlexEvent.CREATION_COMPLETE,selectionControlsEventListener);
			view.personForm.personAction = Utils.PERSONADD;
		}
		protected function onGridClickHandler(event:GridEvent):void{
			view.modifyBtn.enabled = true;
			if( view.currentState == Utils.PERSON_VIEW ){
				view.personForm.personObj =  view.personList.selectedItem as Persons ;
				view.personForm.personAction = Utils.PERSONUPDATE;	
			}
		}
		
		protected function modifyPersonHandler(event:Event):void{
			if(view.personList.selectedIndex != -1){
				view.currentState = Utils.PERSON_VIEW
				view.personForm.addEventListener(FlexEvent.CREATION_COMPLETE,selectionControlsEventListener);
				view.personForm.personObj =  view.personList.selectedItem as Persons ;
				view.personForm.personAction = Utils.PERSONUPDATE;	
			}else{
				controlSignal.showAlertSignal.dispatch(this,Utils.SELECT_ENTRY,Utils.APPTITLE,1,null);
			}
		}
		protected function onClosePerson( event:MouseEvent ):void
		{
			view.currentState = Utils.PERSON_INDEX
		}
		protected function onCloseHandler(event:CloseEvent):void
		{
			PopUpManager.removePopUp( this );
		}
		
		protected function setDataProviders():void {	    
		}
		
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {  
			if( signal.action == Action.CREATE && signal.destination == Utils.PERSONSKEY )
			{
				personListCollection = ArrayCollection( personDAO.collection.filteredItems );
				refershCollection();
			}
			if(signal.action == Action.DELETE && signal.destination == Utils.PERSONSKEY)
			{
				personListCollection = ArrayCollection( personDAO.collection.filteredItems );
				refershCollection();
			}
			if(signal.action == Action.UPDATE && signal.destination == Utils.PERSONSKEY)
			{
				personListCollection = ArrayCollection( personDAO.collection.filteredItems );
				refershCollection();
			}
		}
		protected function refershCollection():void
		{
			personListCollection.refresh();
			filteredPersonCollection();
			
		}
		protected function getProfileLabel( profId:int ):String
		{
			var retProfileLabel:String;
			var profileArr:ArrayCollection = profileDAO.collection.filteredItems  as ArrayCollection
			for each( var profile:Profiles in profileArr)
			{
				if( profile.profileId == profId )
				{
					retProfileLabel = profile.profileLabel;
					break;
				}
			}
			return retProfileLabel;
		}
		override public function alertReceiveHandler(obj:Object):void {
			if( obj==Utils.DELETE_PERSON) {
				controlSignal.deletePersonSignal.dispatch( this , view.personList.dataProvider.getItemAt( _selectedPersonIndex ) )
				view.personList.dataProvider.removeItemAt( _selectedPersonIndex );
			}
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.personList.addEventListener(GridEvent.GRID_DOUBLE_CLICK , onGridDoubleClickHandler );
			view.personList.addEventListener(GridEvent.GRID_CLICK , onGridClickHandler );
			view.addBtn.addEventListener( MouseEvent.CLICK ,addPersonHandler)
			view.modifyBtn.addEventListener( MouseEvent.CLICK ,modifyPersonHandler)
			view.personList.rendererSignal.add( onRemovePersonHandler );
			view.selector.addEventListener( IndexChangeEvent.CHANGE,onCombochange);
			view.popTitle.addEventListener(CloseEvent.CLOSE,onCloseClickHandler);
			view.modifyBtn.enabled = false;
			
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