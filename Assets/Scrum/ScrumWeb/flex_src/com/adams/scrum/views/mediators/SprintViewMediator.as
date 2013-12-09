package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Teammembers;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.SprintSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SprintViewMediator extends AbstractViewMediator
	{
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;  
		
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		[Inject("versionDAO")]
		public var versionDAO:AbstractDAO;
		
		[Inject("teamDAO")]
		public var teamDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("domainDAO")]
		public var domainDAO:AbstractDAO;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO; 
		
		[Inject]
		public var currentInstance:CurrentInstance;
		
		/**
		 * the object contains the binded values assigned to 
		 * sprint properties from the view's form using formProcessor
		 */			 	
		[Form(form="view.sprintForm")]
		public var sprintObj:Object;
		
		public function SprintViewMediator( viewType:Class=null ) {
			super( SprintSkinView );
		}
		
		private var _productState:String;
		/**
		 * Getter setter functions to store the current state, thus to manage the in case of opening 
		 * the currentView again using the state the init is called by eventHandler set 
		 * which was removed by cleanup at very first showup instance
		 */		
		public function get productState():String {
			return _productState;
		}
		public function set productState( value:String ):void {
			_productState=value;
			if( productState== Utils.SPRINTSTATE ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage );	
			}
		}
		
		private var _editable:Boolean;
		public function get editable():Boolean {
			return _editable;
		}
		//@TODO
		/**
		 * the editable property to set the purpose of this double purpose
		 * form intended for both edit or create new object
		 * thus, with editable true the form used for edit otherwise for creation of new object
		 */		
		public function set editable( value:Boolean ):void {
			_editable = value;
			view.newSprintBtn.includeInLayout = !_editable;
			view.newSprintBtn.visible = !_editable;
			view.editBtn.includeInLayout = _editable;
			view.editBtn.visible= _editable;
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
			viewState = Utils.SPRINTSTATE;
			ObjectUtils.setUpForm( currentInstance.currentSprint, view.sprintForm );
			view.sprintStatusFk.dataProvider = GetVOUtil.getStatusObject( statusDAO.collection.items, Utils.SQL_TYPE, Utils.SPRINT_STATUS, Status );
			view.sprintStatusFk.validateNow();
			view.sprintStatusFk.selectedIndex = view.sprintStatusFk.dataProvider.getItemIndex( currentInstance.currentSprint.statusObject );

			view.teamFk.dataProvider = GetVOUtil.sortArrayCollection( teamDAO.destination, ( teamDAO.collection.items ) );
			
			view.versionFk.dataProvider = GetVOUtil.sortArrayCollection( Utils.VERSIONKEY, ( currentInstance.currentProducts.versionSet ) );
			view.versionFk.validateNow();
			
			if( currentInstance.currentSprint.sprintId != 0 ) {
				view.versionFk.selectedIndex = view.versionFk.dataProvider.getItemIndex( currentInstance.currentSprint.versionObject );	
			}
			else {
				view.teamFk.selectedIndex =0;
				view.sprintStatusFk.selectedIndex =0; 	
				view.versionFk.selectedIndex = 0;
			}
			
		}
		
		protected function addedtoStage( event:Event ):void {
			init();
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():SprintSkinView 	{
			return _view as SprintSkinView;
		}
		
		[MediateView( "SprintSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView( value );	
		}
		
		private var _scrumState:String;
		
		/**
		 * Getter setter functions to store the current state, thus to manage the in case of opening 
		 * the currentView again using the state the init is called by eventHandler set 
		 * which was removed by cleanup at very first showup instance
		 */		
		public function get scrumState():String {
			return _scrumState;
		}
		public function set scrumState( value:String ):void {
			_scrumState = value;
			if( scrumState == Utils.SPRINTSTATE ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage );	
			}
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners();
			view.newSprintBtn.clicked.add( onCreateNewSprint );
			view.cancelBtn.clicked.add( cancelBtnClickHandler );
			view.editBtn.clicked.add( editBtnClickHandler );
		}
		
		private function onCreateNewSprint( eve:MouseEvent ):void {
			if( eve.currentTarget == view.newSprintBtn ) {
				createNewSprint();
			}
			else if( eve.currentTarget == view.cancelBtn ) {
				currentInstance.scrumState = Utils.BASICSTATE;
				currentInstance.productState = Utils.BASICSTATE;
			} 
		}
		
		private function cancelBtnClickHandler( eve:MouseEvent ):void {
			currentInstance.scrumState = Utils.BASICSTATE;
			currentInstance.productState = Utils.BASICSTATE;
		}
		
		private function editBtnClickHandler( eve:MouseEvent ):void {
			var sprintSignal:SignalVO = new SignalVO( this, sprintDAO, Action.UPDATE );
			var sprintVO:Sprints = currentInstance.currentSprint; 
			sprintVO = ObjectUtils.getCastObject( sprintObj, sprintVO ) as Sprints; 
			sprintVO = ObjectUtils.getDropListObject( view.sprintStatusFk, sprintVO ) as Sprints;
			sprintVO = ObjectUtils.getDropListObject( view.versionFk, sprintVO ) as Sprints;
			sprintVO = ObjectUtils.getDropListObject( view.teamFk, sprintVO ) as Sprints;
			
			currentInstance.currentSprint.versionObject = GetVOUtil.getVOObject( sprintVO.versionFk, versionDAO.collection.items, versionDAO.destination, Versions ) as Versions;
			currentInstance.currentSprint.statusObject = GetVOUtil.getVOObject( sprintVO.sprintStatusFk, statusDAO.collection.items, statusDAO.destination, Status ) as Status;
			
			sprintSignal.valueObject = sprintVO;
			signalSeq.addSignal( sprintSignal ); 
		}
		
		private function createNewSprint():void {
			var sprintSignal:SignalVO = new SignalVO( this, sprintDAO, Action.CREATE );
			var sprintVO:Sprints = new Sprints();
			sprintVO = ObjectUtils.getCastObject( sprintObj, sprintVO ) as Sprints; 
			sprintVO = ObjectUtils.getDropListObject( view.sprintStatusFk, sprintVO ) as Sprints;
			sprintVO = ObjectUtils.getDropListObject( view.versionFk, sprintVO ) as Sprints;
			sprintVO = ObjectUtils.getDropListObject( view.teamFk, sprintVO ) as Sprints;
			sprintVO.versionObject = GetVOUtil.getVOObject( sprintVO.versionFk, versionDAO.collection.items, versionDAO.destination, Versions ) as Versions;
			sprintVO.statusObject = GetVOUtil.getVOObject( sprintVO.sprintStatusFk, statusDAO.collection.items, statusDAO.destination, Status ) as Status;
			sprintVO.productFk = currentInstance.currentProducts.productId;			
			
			sprintSignal.valueObject = sprintVO;
			signalSeq.addSignal( sprintSignal ); 
		}
		
		
		override protected function serviceResultHandler( obj:Object, signal:SignalVO ):void {
			
			var currentProductId:int = ( currentInstance.currentProducts ) ? currentInstance.currentProducts.productId : 0;
			
			if( signal.destination == sprintDAO.destination ) {
				
				if( signal.action == Action.CREATE ) {
					
					var addedSprint:Sprints = obj as Sprints;
					currentInstance.currentSprint = GetVOUtil.getVOObject( addedSprint.sprintId, sprintDAO.collection.items, sprintDAO.destination, Sprints ) as Sprints;
					
					var eventsSignal:SignalVO =Utils.createEvent( this, eventDAO, Utils.eventStatusSprintCreate,addedSprint.sprintLabel+" "+Utils.SPRINT_CREATE, currentInstance.currentPerson.personId, 0, currentProductId, addedSprint.sprintId );
					signalSeq.addSignal( eventsSignal );
					
					var receivers:Array = GetVOUtil.getSprintMembers( addedSprint, currentInstance.currentPerson.personId );
					
					var pushDomainMessage:PushMessage = new PushMessage( Description.CREATE, receivers, currentInstance.currentDomain.domainId );
					var pushDomainSignal:SignalVO = new SignalVO( this, domainDAO, Action.PUSH_MSG, pushDomainMessage );
					signalSeq.addSignal( pushDomainSignal );
					 
					var pushSprintMessage:PushMessage = new PushMessage( Description.CREATE, receivers, Sprints( obj ).sprintId );
					var pushSprintSignal:SignalVO = new SignalVO( this, sprintDAO, Action.PUSH_MSG, pushSprintMessage );
					signalSeq.addSignal( pushSprintSignal );
					
				}
				
				if( signal.action == Action.UPDATE ) {
					var updateSprint:Sprints = obj as Sprints;
					var eventsUpdateSignal:SignalVO = Utils.createEvent( this, eventDAO, Utils.eventStatusSprintUpdate,updateSprint.sprintLabel+" "+Utils.SPRINT_UPDATE, currentInstance.currentPerson.personId, 0, currentProductId, updateSprint.sprintId );
					signalSeq.addSignal( eventsUpdateSignal );
				}
				
				currentInstance.scrumState = Utils.BASICSTATE;
				currentInstance.productState = Utils.BASICSTATE;
			}			
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 
			view.newSprintBtn.clicked.removeAll();
			view.cancelBtn.clicked.removeAll();
			view.editBtn.clicked.removeAll();
			if( hasEventListener( Event.ADDED_TO_STAGE ) ) {
				removeEventListener( Event.ADDED_TO_STAGE, addedtoStage );	
			}
		}

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */		
		override protected function gcCleanup( event:Event ):void {
			if( viewState != Utils.SPRINTSTATE) {
				cleanup( event );	
			}
		}
	}
}