package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.PersonSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;

	public class PersonViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("personDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("companyDAO")]
		public var companyDAO:AbstractDAO;		
		
		public var changeTeamViewSignal:Signal = new Signal();
		
		/**
		 * the object contains the binded values assigned to 
		 * person properties from the view's form using formProcessor
		 */			 	
		[Form(form="view.personForm")]
		public var personObj:Object;
		
		
		/**
		 * Constructor.
		 */
		public function PersonViewMediator(viewType:Class = null)
		{
			super(PersonSkinView);
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
			view.personCreateBtn.visible = !_editable;
			view.personEditBtn.includeInLayout = _editable;
			view.personEditBtn.visible= _editable;
			
			addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():PersonSkinView
		{
			return _view as PersonSkinView;
		}
		
		[MediateView( "PersonSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
			
		}
		
		
		/**
		 * set the person Object when the ueser changed the person from the 
		 * combo box for Edit.
		 */
		private var _selectedPerson:Persons
		public function get selectedPerson():Persons
		{
			return _selectedPerson;
		}

		public function set selectedPerson(value:Persons):void
		{
			_selectedPerson = value;
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
			viewState = Utils.PERSONVIEW;
			view.companyFk.dataProvider = GetVOUtil.sortArrayCollection(companyDAO.destination,(companyDAO.collection.items));
			view.companyFk.validateNow();			
			showData();
		}
		/**
		 * used to Show/reset the Field when User Clicked 
		 * the edit and Create Button.
		 */
		public function showData() :void
		{
			if(editable == false){
				resetForm();
			}else {
				view.companyFk.dataProvider = GetVOUtil.sortArrayCollection(companyDAO.destination,(companyDAO.collection.items));
				view.companyFk.selectedIndex = view.companyFk.dataProvider.getItemIndex(_selectedPerson.companyObject);
				ObjectUtils.setUpForm(_selectedPerson,view.personForm);
				view.companyFk.validateNow();
			}
		}
		public function resetForm():void{
			view.personFirstname.text = "";
			view.personLastname.text = "";
			view.personLogin.text = "";
			view.personMobile.text = "";
			view.personPassword.text = "";
			view.personPosition.text = "";
			view.companyFk.validateNow();
			view.companyFk.selectedIndex = 0;
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void
		{
			super.setViewListeners();
			view.personCreateBtn.clicked.add( personBtnHandler );
			view.personCancelBtn.clicked.add( personBtnHandler );
			view.personEditBtn.clicked.add( personBtnHandler );
		}
		
		/**
		 * handler for both edit,create and cancel buttons
		 * invokes respective functions
		 */
		private function personBtnHandler( eve:MouseEvent ):void{
			if( eve.currentTarget == view.personCreateBtn ){
				createNewPerson();
			}else if( eve.currentTarget==view.personCancelBtn ){
				changeTeamViewSignal.dispatch(Utils.TEAMSTATE);
			}else if( eve.currentTarget==view.personEditBtn ){
				editPerson();
			}
		}
		private function createNewPerson():void
		{
			var personSignal:SignalVO = new SignalVO(this,personDAO,Action.CREATE);
			var newPerson:Persons = new Persons();
			newPerson = ObjectUtils.getCastObject(personObj,newPerson) as Persons;
			newPerson.activated = 1;
			newPerson = ObjectUtils.getDropListObject(view.companyFk,newPerson) as Persons;
			personSignal.valueObject = newPerson;
			signalSeq.addSignal(personSignal);
		}
		private function editPerson():void
		{
			var editPersonSignal:SignalVO = new SignalVO(this,personDAO,Action.UPDATE);
			var editPerson:Persons =  _selectedPerson;
			editPerson = ObjectUtils.getCastObject(personObj,editPerson) as Persons;
			editPersonSignal.valueObject = editPerson; 
			signalSeq.addSignal(editPersonSignal);
		}
			
		public var oldTimeSpent:int;
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {			
			if(signal.destination == personDAO.destination){
				var addedPersons:Persons = obj as Persons;
				
				var receivers:Array = GetVOUtil.getSprintMembers(currentInstance.currentSprint,currentInstance.currentPerson.personId);
				var pushMessage:PushMessage = new PushMessage( Description.UPDATE, receivers, addedPersons.personId );
				var pushSignal:SignalVO = new SignalVO( this, personDAO, Action.PUSH_MSG, pushMessage );
				signalSeq.addSignal( pushSignal );
				
				changeTeamViewSignal.dispatch(Utils.TEAMSTATE);
			}
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event); 
			view.personCreateBtn.clicked.removeAll();
			view.personCancelBtn.clicked.removeAll();
			view.personEditBtn.clicked.removeAll();
		}
		//@TODO

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.PERSONVIEW)cleanup(event);
		}
	}
}