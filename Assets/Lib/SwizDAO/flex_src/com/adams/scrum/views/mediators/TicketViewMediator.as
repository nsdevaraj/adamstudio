package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Tickets;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.TicketSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.mx_internal;
	
	import org.osflash.signals.Signal;

	use namespace mx_internal;

	public class TicketViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("ticketDAO")]
		public var ticketDAO:AbstractDAO;
		
		[Inject("taskDAO")]
		public var taskDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;
		
		[Inject("personDAO")]
		public var personDAO:AbstractDAO;
		
		public var currentTask:Tasks;
		
		public var updatedTicketSignal:Signal = new Signal();
		/**
		 * the object contains the binded values assigned to 
		 * ticket properties from the view's form using formProcessor
		 */			 	
		[Form(form="view.ticketForm")]
		public var ticketObj:Object;
		
		/**
		 * Constructor.
		 */
		public function TicketViewMediator(viewType:Class = null)
		{
			super(TicketSkinView);
		} 
		
		private var _editable:Boolean;
		public function get editable():Boolean
		{
			return _editable;
		}
		
		/**
		 * the editable property to set the purpose of this double purpose
		 * form intended for both edit or create new object
		 * thus, with editable true the form used for edit otherwise for creation of new object
		 */		
		public function set editable(value:Boolean):void
		{
			_editable = value;
			view.includeInLayout = !_editable;
			view.domCreateBtn.visible = !_editable;
			view.domEditBtn.includeInLayout = _editable;
			view.domEditBtn.visible= _editable;
		}
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():TicketSkinView
		{
			return _view as TicketSkinView;
		}
		
		[MediateView( "TicketSkinView" )]
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
			if(value==Utils.TICKETSTATE) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
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
			viewState = Utils.TICKETSTATE;
			
			view.ticketPersonId.visible = currentInstance.currentProfileAccess.isSSM;
			view.ticketPersonId.includeInLayout = currentInstance.currentProfileAccess.isSSM;
			
			view.personList.dataProvider = GetVOUtil.sortArrayCollection(personDAO.destination,(personDAO.collection.items));
			view.personList.validateNow();
			view.personList.selectedIndex = 0;
			
			resetForm();
		}
		public function resetForm():void{
			view.ticketTimespent.text = "";
			view.ticketTechnical.text = "";
			view.ticketComments.text= "";
			view.ticketDate.selectedDate= null;
			
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void{
			super.setViewListeners();
			view.domCancelBtn.clicked.add(ticketBtnHandler);
			view.domEditBtn.clicked.add(ticketBtnHandler);
			view.domCreateBtn.clicked.add(ticketBtnHandler);
		}
		
		/**
		 * handler for both edit,create and cancel buttons
		 * invokes respective functions
		 */
		private function ticketBtnHandler(eve:MouseEvent):void{
			if(eve.currentTarget==view.domCreateBtn){
				createNewTicket();
			}else if(eve.currentTarget==view.domCancelBtn){
				if(editable){
					visible = false;
					includeInLayout = false;
				}else currentInstance.sprintOpenState = Utils.BASICSTATE;
			}else if(eve.currentTarget==view.domEditBtn){
				editTicket();
			}
		}
		private function createNewTicket():void{
			var ticketsSignal:SignalVO = new SignalVO(this,ticketDAO,Action.CREATE);
			var newTicket:Tickets = new Tickets();
			newTicket = ObjectUtils.getCastObject(ticketObj,newTicket) as Tickets;			
			if(currentInstance.currentProfileAccess.isSSM)
				newTicket.personFk = (view.personList.selectedItem as Persons).personId;
			else
				newTicket.personFk = currentInstance.currentPerson.personId;
			newTicket.taskFk = currentTask.taskId;
			ticketsSignal.valueObject = newTicket;
			signalSeq.addSignal(ticketsSignal);
		}
		private function editTicket():void{
			var ticketsSignal:SignalVO = new SignalVO(this,ticketDAO,Action.UPDATE);
			var editTicket:Tickets =  currentInstance.currentTicket;
			editTicket = ObjectUtils.getCastObject(ticketObj,editTicket) as Tickets;
			if(currentInstance.currentProfileAccess.isSSM)
				editTicket.personFk = (view.personList.selectedItem as Persons).personId;
			ticketsSignal.valueObject = editTicket; 
			signalSeq.addSignal(ticketsSignal);
		}
		public var oldTimeSpent:int;
		
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {		
			var currentProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
			var currentSprintId:int = (currentInstance.currentSprint!=null)?currentInstance.currentSprint.sprintId:0;
			
			if(signal.destination == ticketDAO.destination){
				if(signal.action == Action.CREATE){
					var addedTicket:Tickets = obj as Tickets;
					currentInstance.currentTicket = GetVOUtil.getVOObject(addedTicket.ticketId,ticketDAO.collection.items,ticketDAO.destination,Tickets) as Tickets;

					var taskSignal:SignalVO = new SignalVO(this,taskDAO,Action.UPDATE);
					currentTask.doneTime = currentTask.doneTime + addedTicket.ticketTimespent;
					taskSignal.valueObject = currentTask;
					signalSeq.addSignal(taskSignal);
					
					currentInstance.currentSprint.totalEstimatedTime = Utils.headingTotalStoryEstimated(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
					currentInstance.currentSprint.totalDoneTime = Utils.headingTotalStoryDone(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
					currentInstance.currentSprint.totalRemainingTime = Utils.totalStoryRemainingTime(currentInstance.currentSprint.totalEstimatedTime,currentInstance.currentSprint.totalDoneTime);
					
					/*var currentTaskId:int = (currentInstance.currentTicket!=null)?currentInstance.currentTicket.taskFk:0;
					var currentTicketId:int = (currentInstance.currentTicket!=null)?currentInstance.currentTicket.ticketId:0;
					var eventsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusTicketCreate,addedTicket.ticketComments.substr(0.4)+" "+Utils.TICKET_CREATE,currentInstance.currentPerson.personId,currentTaskId,currentProductId,currentSprintId,0,currentTicketId);
					signalSeq.addSignal(eventsSignal);*/
					
					currentInstance.sprintOpenState = Utils.BASICSTATE;
				}
				if(signal.action == Action.UPDATE){
					var editedTicket:Tickets = obj as Tickets;
					currentInstance.currentTicket = GetVOUtil.getVOObject(editedTicket.ticketId,ticketDAO.collection.items,ticketDAO.destination,Tickets) as Tickets;

					if(oldTimeSpent!=editedTicket.ticketTimespent){
						var editTaskSignal:SignalVO = new SignalVO(this,taskDAO,Action.UPDATE);
						currentTask.doneTime = currentTask.doneTime + editedTicket.ticketTimespent;
						currentTask.doneTime = currentTask.doneTime-oldTimeSpent;
						oldTimeSpent = editedTicket.ticketTimespent;
						editTaskSignal.valueObject = currentTask;
						signalSeq.addSignal(editTaskSignal);
					}
					currentInstance.currentSprint.totalEstimatedTime = Utils.headingTotalStoryEstimated(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
					currentInstance.currentSprint.totalDoneTime = Utils.headingTotalStoryDone(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
					currentInstance.currentSprint.totalRemainingTime = Utils.totalStoryRemainingTime(currentInstance.currentSprint.totalEstimatedTime,currentInstance.currentSprint.totalDoneTime);

					var eventsUpdateSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusTicketUpdate,editedTicket.ticketComments.substr(0.4)+" "+Utils.TICKET_UPDATE,currentInstance.currentPerson.personId,editedTicket.taskFk,currentProductId,currentSprintId,0,editedTicket.ticketId);
					signalSeq.addSignal(eventsUpdateSignal);
					Object(view.owner).updatedTicketSignal.dispatch();
				}
			}
			if(signal.destination == taskDAO.destination){
				if(signal.action == Action.UPDATE){
					var taskupdate:Tasks = obj as Tasks;
					var eventsTaskSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusTaskUpdate,String(taskupdate.taskComment).substr(0,4)+" "+Utils.TASK_UPDATE,currentInstance.currentPerson.personId,taskupdate.taskId,currentProductId,currentSprintId,taskupdate.storyFk);
					signalSeq.addSignal(eventsTaskSignal);
				}				
				currentInstance.sprintOpenState = Utils.BASICSTATE;
			}
			
			var receivers:Array = GetVOUtil.getSprintMembers(currentInstance.currentSprint,currentInstance.currentPerson.personId);
			var pushMessage:PushMessage = new PushMessage( Description.CREATE, receivers, currentInstance.currentSprint.sprintId );
			var pushSignal:SignalVO = new SignalVO( this, sprintDAO, Action.PUSH_MSG, pushMessage );
			signalSeq.addSignal( pushSignal );
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event); 
			view.domCancelBtn.clicked.removeAll();
			view.domCreateBtn.clicked.removeAll();
			view.domEditBtn.clicked.removeAll();
			if(hasEventListener(Event.ADDED_TO_STAGE))removeEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		//@TODO

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.TICKETSTATE)cleanup(event);
		}
	}
}