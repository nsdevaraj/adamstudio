package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.Companies;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Profiles;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Teammembers;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.TeamMemberSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.utils.ObjectUtil;
	
	import spark.events.IndexChangeEvent;
	
	public class TeamMemberViewMediator extends AbstractViewMediator
	{
		[SkinState(Utils.PERSONSTATE)]
		[SkinState(Utils.PROFILESTATE)]
		[SkinState(Utils.TEAMSTATE)]
		[SkinState(Utils.COMPANYSTATE)]
		
		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("teammemberDAO")]
		public var teamMemberDAO:AbstractDAO;
		
		[Inject("personDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("profileDAO")]
		public var profileDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;
		
		[Inject("teamDAO")]
		public var teamDAO:AbstractDAO;
		
		[Inject("companyDAO")]
		public var companyDAO:AbstractDAO;
		
		/**
		 * Constructor.
		 */
		public function TeamMemberViewMediator(viewType:Class = null)
		{
			super(TeamMemberSkinView);
		}
		 
		/** 
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():TeamMemberSkinView
		{
			return _view as TeamMemberSkinView;
		}
		
		[MediateView( "TeamMemberSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
		}
		
		private var _teamState:String;
		
		/**
		 * Getter setter functions to store the current state, thus to manage the in case of opening 
		 * the currentView again using the state the init is called by eventHandler set 
		 * which was removed by cleanup at very first showup instance
		 */		
		public function get teamState():String {
			return _teamState;
		}

		public function set teamState(value:String):void {
			_teamState  = value;
			invalidateSkinState();
			if(_teamState == Utils.PERSONSTATE){
				callLater(setPersonState,[setEditable]);
			}
			if(_teamState == Utils.PROFILESTATE){
				callLater(setProfileState,[setEditable]);
			}
			if(_teamState == Utils.COMPANYSTATE){
				callLater(setCompanyState,[setEditable]);
			}
		}
		override protected function getCurrentSkinState():String{
			return teamState;
		}
		private var _sprintState:String

		public function get sprintState():String
		{
			return _sprintState;
		}

		public function set sprintState(value:String):void
		{
			if(value==Utils.TEAMMEMBERSTATE) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}

		protected function addedtoStage(ev:Event):void{
			init();
		}
		//@TODO

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
			viewState = Utils.TEAMMEMBERSTATE;			
			view.personList.dataProvider = GetVOUtil.sortArrayCollection(personDAO.destination,(personDAO.collection.items));
			view.profileList.dataProvider = GetVOUtil.sortArrayCollection(profileDAO.destination,(profileDAO.collection.items));
			view.companyList.dataProvider = GetVOUtil.sortArrayCollection(companyDAO.destination,(companyDAO.collection.items));
			view.profileList.validateNow();
			view.profileList.selectedIndex = 0;
			view.personList.validateNow();
			view.personList.selectedIndex = 0;
			view.companyList.validateNow();
			view.companyList.selectedIndex = 0;
			view.personList.addEventListener(IndexChangeEvent.CHANGE, personDropDown,false,0,true );
			view.profileList.addEventListener(IndexChangeEvent.CHANGE, profileDropDown,false,0,true );
			view.companyList.addEventListener(IndexChangeEvent.CHANGE, companyDropDown,false,0,true );
		}
		/**
		 * Function Triggers when user Changed the Item From The 
		 * drowbDown List for Company.......
		 */
		private function companyDropDown( event:IndexChangeEvent ) :void
		{
			if(view.companyViewMediator)
			{
				view.companyViewMediator.selectedCompany = view.companyList.selectedItem as Companies;
				view.companyViewMediator.editable = true;
			}
		}
		/**
		 * Function Triggers when user Changed the Item From The 
		 * drowbDown List for Person.......
		 */
		private function personDropDown( event:IndexChangeEvent ) :void
		{
			if(view.personViewMediator)
			{
				view.personViewMediator.selectedPerson = view.personList.selectedItem as Persons
				view.personViewMediator.editable = true;
			}
		}
		/**
		 * Function Triggers when user Changed the Item From The 
		 * drowbDown List for Profile.......
		 */
		private function profileDropDown( event:IndexChangeEvent ) :void
		{
			if(view.profileViewMediator)
			{
				view.profileViewMediator.selectedProfile = view.profileList.selectedItem as Profiles
			}
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void{
			super.setViewListeners();
			view.domCancelBtn.clicked.add(teamMemberBtnHandler);
			view.domCreateBtn.clicked.add(teamMemberBtnHandler);
			view.createPerson.clicked.add( personBtnHandler );
			view.EditPerson.clicked.add( personBtnHandler );
			view.EditProfile.clicked.add( profileBtnHandler );
			view.createCompany.clicked.add( companyBtnHandler );
			view.editCompany.clicked.add( companyBtnHandler );
		}
		
		/**
		 * handler for both create and cancel buttons
		 * invokes respective functions
		 */
		private function teamMemberBtnHandler(eve:MouseEvent):void{
			if(eve.currentTarget==view.domCreateBtn){
				createNewTeamMember();
			}else if(eve.currentTarget==view.domCancelBtn){
				currentInstance.sprintState = Utils.BASICSTATE;
				cleanup(null);
			} 
		}
		
		/**
		 * handler for both create and Edit buttons
		 * invokes respective functions for the Person...
		 */
		private var setEditable:Boolean;
		private function personBtnHandler( event : MouseEvent ) :void
		{
			
			if(event.target.label=="Edit"){
				setEditable = true;
				if(view.personViewMediator!=null)view.personViewMediator.editable = setEditable;
			}else{
				setEditable = false;
				if(view.personViewMediator!=null)view.personViewMediator.editable = setEditable;
			}
			teamState = Utils.PERSONSTATE;
		}
		
		/**
		 * handler for both create and Edit buttons
		 * invokes respective functions for the Company...
		 */
		//private var setEditableCompany:Boolean;
		private function companyBtnHandler( event : MouseEvent ) :void
		{			
			if(event.target.label=="Edit"){
				setEditable = true;
				if(view.companyViewMediator!=null)view.companyViewMediator.editable = setEditable;
			}else{
				setEditable = false;
				if(view.companyViewMediator!=null)view.companyViewMediator.editable = setEditable;
			}
			teamState = Utils.COMPANYSTATE;	
		}
		private function setPersonState( setEditable:Boolean ) :void
		{
			view.personViewMediator.changeTeamViewSignal.add( setSprintState );
			view.personViewMediator.selectedPerson = view.personList.selectedItem as Persons;
			view.personViewMediator.editable = setEditable;
		}
		private function setSprintState( val:String ):void{
			teamState = val;
		}
		private function setProfileState( setEditable:Boolean ) :void
		{
			view.profileViewMediator.changeTeamViewSignal.add( setSprintState );
			view.profileViewMediator.selectedProfile = view.profileList.selectedItem as Profiles;
		}
		private function setCompanyState( setEditable:Boolean ) :void
		{
			view.companyViewMediator.changeTeamViewSignal.add( setSprintState );
			view.companyViewMediator.selectedCompany = view.companyList.selectedItem as Companies;
			view.companyViewMediator.editable = setEditable;
		}
		
		private function profileBtnHandler( event : MouseEvent ) :void
		{
			teamState = Utils.PROFILESTATE;	
		}
		private function createNewTeamMember():void{
			var teamMembersSignal:SignalVO = new SignalVO(this,teamMemberDAO,Action.CREATE);
			var newTeamMember:Teammembers = new Teammembers();
			newTeamMember.teamFk = currentInstance.currentTeam.teamId;
			newTeamMember.personFk = (view.personList.selectedItem as Persons).personId;
			newTeamMember.profileFk = (view.profileList.selectedItem as Profiles).profileId;
			teamMembersSignal.valueObject = newTeamMember; 
			signalSeq.addSignal(teamMembersSignal);
		} 
		
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {	
			var currentProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
			var currentSprintId:int = (currentInstance.currentSprint!=null)?currentInstance.currentSprint.sprintId:0;
			var currentStoryId:int = (currentInstance.currentSprint!=null)?currentInstance.currentSprint.sprintId:0;
			if(signal.destination == teamMemberDAO.destination){
				if(signal.action == Action.CREATE){
					var addedTeamMember:Teammembers = obj as Teammembers;
					addedTeamMember.personObject = GetVOUtil.getVOObject(addedTeamMember.personFk,personDAO.collection.items,personDAO.destination,Persons) as Persons; 
					addedTeamMember.profileObject = GetVOUtil.getVOObject(addedTeamMember.profileFk,profileDAO.collection.items,profileDAO.destination,Profiles) as Profiles;
					Utils.addArrcStrictItem(addedTeamMember,currentInstance.currentTeam.teamMemberSet,teamMemberDAO.destination);
					
					var eventsSignal:SignalVO =Utils.createEvent(this,eventDAO,Utils.eventStatusTeamMemberCreate,addedTeamMember.personObject.personFirstname+" "+Utils.TEAMMEMBER_CREATE,currentInstance.currentPerson.personId,0,currentProductId,currentSprintId,currentStoryId);
					signalSeq.addSignal(eventsSignal);
					
					var receivers:Array = GetVOUtil.getSprintMembers(currentInstance.currentSprint,currentInstance.currentPerson.personId);
					var pushMessage:PushMessage = new PushMessage( Description.UPDATE, receivers, currentInstance.currentTeam.teamId );
					var pushSignal:SignalVO = new SignalVO( this, teamDAO, Action.PUSH_MSG, pushMessage );
					signalSeq.addSignal( pushSignal );
				}				
				currentInstance.sprintState = Utils.BASICSTATE;
				cleanup(null);
			}
		}
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event); 
			view.domCancelBtn.clicked.removeAll();
			view.domCreateBtn.clicked.removeAll();
			view.personList.removeEventListener(IndexChangeEvent.CHANGE, personDropDown);
			view.profileList.removeEventListener(IndexChangeEvent.CHANGE, profileDropDown);
			view.companyList.removeEventListener(IndexChangeEvent.CHANGE, companyDropDown);
			if(hasEventListener(Event.ADDED_TO_STAGE))removeEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */		
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.TEAMMEMBERSTATE)cleanup(event);
		}
	}
}