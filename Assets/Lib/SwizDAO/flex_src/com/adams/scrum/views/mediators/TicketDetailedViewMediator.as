package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Tickets;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.TicketDetailedSkinView;
	import com.adams.scrum.views.components.NativeList;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	
	import spark.events.IndexChangeEvent;

	public class TicketDetailedViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("personDAO")]
		public var personDAO:AbstractDAO;
		
		public var currentTask:Tasks;
		 
		private var _dataProvider:ArrayCollection;
		[Bindable]
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:ArrayCollection):void
		{
			_dataProvider = value;
			if(value){
				view.ticketsList.dataProvider = value;
				view.ticketsList.collection = personDAO.collection.items;
			}
		}

		/**
		 * Constructor.
		 */
		public function TicketDetailedViewMediator (viewType:Class = null)
		{
			super(TicketDetailedSkinView);
		}
		  
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():TicketDetailedSkinView
		{
			return _view as TicketDetailedSkinView;
		}
		
		[MediateView( "TicketDetailedSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
		}
		
		private var _sprintOpenState:String;

		/**
		 * Getter setter functions to store the current state, thus to manage the in case of opening 
		 * the currentView again using the state the init is called by eventHandler set 
		 * which was removed by cleanup at very first showup instance
		 */		
		public function get sprintOpenState():String {
			return _sprintOpenState;
		}

		public function set sprintOpenState(value:String):void {
			if(value==Utils.TICKETDETAIL) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}

		protected function addedtoStage(ev:Event):void{
			init();
		}

		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void
		{
			super.init();  	 
			viewState = Utils.TICKETDETAIL;
			view.newTicketMediator.editable =true;

		}	
		override protected function setRenderers():void{
			view.ticketsList.itemRenderer = Utils.getCustomRenderer(Utils.TICKETDETAILRENDERER);			
			view.ticketsList.editRendererProperty = currentInstance.currentProfileAccess.isSSM;
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void{
			super.setViewListeners(); 
			view.cancelBtn.clicked.add(ticketDetailBtnHandler);
			view.ticketsList.renderSignal.add(ticketHandler);
			view.newTicketMediator.updatedTicketSignal.add(ticketDetailBtnHandler);
		}
		private var selectedTicket:Tickets;
		private function ticketHandler(labelType:String):void{
			view.newTicketMediator.visible = true;
			view.newTicketMediator.includeInLayout = true;
			selectedTicket = Tickets(view.ticketsList.selectedItem); 
			currentInstance.currentTicket = selectedTicket;
			ObjectUtils.setUpForm(currentInstance.currentTicket,Object(view.newTicketMediator.view).ticketForm);
			Object(view.newTicketMediator).oldTimeSpent = selectedTicket.ticketTimespent;
			view.newTicketMediator.editable =true;
			view.newTicketMediator.currentTask = currentTask; 
		}
		
		/**
		 * handler for both edit,create and cancel buttons
		 * invokes respective functions
		 */ 
		private function ticketDetailBtnHandler(eve:MouseEvent = null):void{
			if(eve){
				currentInstance.sprintOpenState = Utils.BASICSTATE;
				cleanup(null);
			}
			view.newTicketMediator.visible = false;
			view.newTicketMediator.includeInLayout = false;
		}   
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void{
			super.cleanup(event); 
			view.cancelBtn.clicked.removeAll();
			view.newTicketMediator.updatedTicketSignal.removeAll();
			if(hasEventListener(Event.ADDED_TO_STAGE))removeEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		//@TODO

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.TICKETDETAIL)cleanup(event);
		}
	}
}