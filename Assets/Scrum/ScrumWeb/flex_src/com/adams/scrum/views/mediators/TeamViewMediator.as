package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Teams;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.TeamSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TeamViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("teamDAO")]
		public var teamDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;
		
		/**
		 * Constructor.
		 */
		public function TeamViewMediator(viewType:Class = null)
		{
			super(TeamSkinView);
		}
		 
		/** 
		
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():TeamSkinView
		{
			return _view as TeamSkinView;
		}
		
		[MediateView( "TeamSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
		}
		
		private var _sprintState:String;
		
		/**
		 * Getter setter functions to store the current state, thus to manage the in case of opening 
		 * the currentView again using the state the init is called by eventHandler set 
		 * which was removed by cleanup at very first showup instance
		 */		
		public function get sprintState():String {
			return _sprintState;
		}

		public function set sprintState(value:String):void {

			if(value==Utils.TEAMSTATE) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
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
			viewState= Utils.TEAMSTATE;
		}	
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void{
			super.setViewListeners();
			view.domCancelBtn.clicked.add(teamBtnHandler);
			view.domCreateBtn.clicked.add(teamBtnHandler);
		}
		
		/**
		 * handler for both create and cancel buttons
		 * invokes respective functions
		 */
		private function teamBtnHandler(eve:MouseEvent):void{
			if(eve.currentTarget==view.domCreateBtn){
				createNewTeam();
			}else if(eve.currentTarget==view.domCancelBtn){
				currentInstance.sprintState = Utils.BASICSTATE;
			}
		}
		private function createNewTeam():void{
			var teamsSignal:SignalVO = new SignalVO(this,teamDAO,Action.CREATE);
			var newTeam:Teams = new Teams();
			newTeam.teamLabel = view.teamName.text; 
			teamsSignal.valueObject = newTeam; 
			signalSeq.addSignal(teamsSignal);
		}
		
		
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {			
			var currentProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
			var currentSprintId:int = (currentInstance.currentSprint!=null)?currentInstance.currentSprint.sprintId:0;
			var currentStoryId:int = (currentInstance.currentStory!=null)?currentInstance.currentStory.storyId:0;
			if(signal.destination == teamDAO.destination){
				if(signal.action == Action.CREATE){
					var addedTeam:Teams = obj as Teams;
					currentInstance.currentTeam = GetVOUtil.getVOObject(addedTeam.teamId,teamDAO.collection.items,teamDAO.destination,Teams) as Teams;
					
					var eventsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusTeamCreate,addedTeam.teamLabel+" "+Utils.TEAM_CREATE,currentInstance.currentPerson.personId,0,currentProductId,currentSprintId,currentStoryId);
					signalSeq.addSignal(eventsSignal);
					
					var receivers:Array = GetVOUtil.getSprintMembers(currentInstance.currentSprint,currentInstance.currentPerson.personId);
					var pushMessage:PushMessage = new PushMessage( Description.CREATE, receivers, addedTeam.teamId );
					var pushSignal:SignalVO = new SignalVO( this, teamDAO, Action.PUSH_MSG, pushMessage );
					signalSeq.addSignal( pushSignal );
				}
				currentInstance.sprintState = Utils.BASICSTATE;
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
			if(hasEventListener(Event.ADDED_TO_STAGE))removeEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		//@TODO

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.TEAMSTATE)cleanup(event);
		}
	}
}