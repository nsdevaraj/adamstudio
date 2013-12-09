package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Profiles;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.ProfileSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class ProfileViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		public var changeTeamViewSignal:Signal = new Signal();
		
		[Inject("profileDAO")]
		public var profileDAO:AbstractDAO;
		
		/**
		 * the object contains the binded values assigned to 
		 * profile properties from the view's form using formProcessor
		 */			 	
		[Form(form="view.profileForm")]
		public var profileObj:Object;
		
		/**
		 * Constructor.
		 */
		public function ProfileViewMediator(viewType:Class = null)
		{
			super(ProfileSkinView);
		} 
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():ProfileSkinView
		{
			return _view as ProfileSkinView;
		}
		
		[MediateView( "ProfileSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
			
		}
		
		/**
		 * set the person Object when the ueser changed the person from the 
		 * combo box for Edit.
		 */
		private var _selectedProfile:Profiles
		public function get selectedProfile():Profiles
		{
			return _selectedProfile;
		}
		
		public function set selectedProfile(value:Profiles):void
		{
			_selectedProfile = value;
			if( view.profileForm != null )ObjectUtils.setUpForm(value,view.profileForm);
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
			viewState = Utils.PROFILEVIEW;
			ObjectUtils.setUpForm(_selectedProfile,view.profileForm);
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void
		{
			super.setViewListeners();
			view.profileEditBtn.clicked.add( profileBtnHandler );
			view.profileCancelBtn.clicked.add( profileBtnHandler );
		}
		
		/**
		 * handler for both edit,create and cancel buttons
		 * invokes respective functions
		 */
		private function profileBtnHandler( eve:MouseEvent ):void{
			if(eve.currentTarget==view.profileEditBtn){
				editProfile();
			}else{
				changeTeamViewSignal.dispatch(Utils.TEAMSTATE);
			}
		}
		
		private function editProfile():void
		{
			var editPersonSignal:SignalVO = new SignalVO(this,profileDAO,Action.UPDATE);
			var editProfile:Profiles =  _selectedProfile;
			editProfile = ObjectUtils.getCastObject(profileObj,editProfile) as Profiles;
			editPersonSignal.valueObject = editProfile; 
			signalSeq.addSignal(editPersonSignal);
		}
		 
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {			
			if(signal.destination == profileDAO.destination){				
				var addedProfiles:Profiles = obj as Profiles;
				
				var receivers:Array = GetVOUtil.getSprintMembers(currentInstance.currentSprint,currentInstance.currentPerson.personId);
				var pushMessage:PushMessage = new PushMessage( Description.UPDATE, receivers, addedProfiles.profileId );
				var pushSignal:SignalVO = new SignalVO( this, profileDAO, Action.PUSH_MSG, pushMessage );
				signalSeq.addSignal( pushSignal );
				
				if(signal.action == Action.CREATE){
				}
				if(signal.action == Action.UPDATE){
					changeTeamViewSignal.dispatch(Utils.TEAMSTATE);
				}
			}
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event); 
			view.profileCancelBtn.clicked.removeAll();
			view.profileEditBtn.clicked.removeAll();
		}
		//@TODO
		
		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.PROFILEVIEW)cleanup(event);
		}
	}
}