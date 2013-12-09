package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.ProfileAccessVO;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Sprintstories;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Teammembers;
	import com.adams.scrum.models.vo.Teams;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.SprintConfigSkinView;
	import com.adams.scrum.views.components.NativeList;
	import com.adams.scrum.views.renderers.SprintRenderer;
	import com.adams.scrum.views.renderers.SprintStoryRenderer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.CloseEvent;
	import mx.events.DateChooserEvent;
	import mx.events.ListEvent;
	
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	import spark.skins.spark.DefaultItemRenderer;

	public class SprintConfigViewMediator extends AbstractViewMediator
	{
		[SkinState(Utils.BASICSTATE)]
		[SkinState(Utils.TEAMSTATE)]
		[SkinState(Utils.TEAMMEMBERSTATE)]
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		 
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO; 
		
		[Inject("storyDAO")]
		public var storyDAO:AbstractDAO; 
		
		[Inject("teamDAO")]
		public var teamDAO:AbstractDAO;
		
		[Inject("teammemberDAO")]
		public var teammemberDAO:AbstractDAO;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;

		/**
		 * the object contains the binded values assigned to 
		 * sprint properties from the view's form using formProcessor
		 */			 	
		[Form(form="view.sprintForm")]
		public var sprintObj:Object;
		
		/**
		 * Constructor.
		 */
		public function SprintConfigViewMediator(viewType:Class=null)
		{
			super(SprintConfigSkinView); 
		}
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():SprintConfigSkinView
		{
			return _view as SprintConfigSkinView;
		}
		
		[MediateView( "SprintConfigSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
		}
		
		private var currentProduct:Products;
		private var currentVersion:Versions;
		
		override protected function getCurrentSkinState():String {
			//just return the component's current state to force the skin to mirror it
			return currentInstance.sprintState;
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
			viewIndex = Utils.SPRINT_EDIT_INDEX;
			ObjectUtils.setUpForm(currentInstance.currentSprint,view.sprintForm);
			view.sprintNameTxt.text = currentInstance.currentSprint.sprintLabel; 
			
			currentInstance.currentProducts = GetVOUtil.getVOObject( currentInstance.currentSprint.productFk,productDAO.collection.items,productDAO.destination,Products) as Products;
			currentProduct = currentInstance.currentProducts;
			currentProduct.storyCollection.filterFunction = storyFilter;
			currentProduct.storyCollection.refresh();
			view.storyList.dataProvider = GetVOUtil.sortArrayCollection(storyDAO.destination,(currentInstance.currentProducts.storyCollection));
			
			view.productVersionSet.dataProvider = GetVOUtil.sortArrayCollection(Utils.VERSIONKEY,(currentInstance.currentProducts.versionSet));
			view.productVersionSet.validateNow();
			if(int(currentInstance.currentSprint.sprintId)) view.productVersionSet.selectedIndex = view.productVersionSet.dataProvider.getItemIndex(currentInstance.currentSprint.versionObject);
			view.gotoProductConfig.label =Utils.GOTOPRODUCT+ currentInstance.currentProducts.productName;
			
			view.teamSelector.dataProvider = GetVOUtil.sortArrayCollection( teamDAO.destination, ( teamDAO.collection.items ) );
			view.teamSelector.validateNow();
			view.teamSelector.selectedItem = currentInstance.currentSprint.teamObject;
			teamChanged( null );
			
			/*view.createTeam.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.ADMIN];
			view.addTeamMember.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.ADMIN];*/
			
			view.createTeam.visible = currentInstance.currentProfileAccess.isSSM;
			view.addTeamMember.visible = currentInstance.currentProfileAccess.isSSM;
			
			SprintStoryRenderer.currentProduct = currentInstance.currentProducts;
			SprintStoryRenderer.currentSprint = currentInstance.currentSprint;
			
			/*view.addStories.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.EDIT]; 
			view.resetSprint.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.EDIT];*/
			
			enabledProfileAccess();				
		} 
		private function enabledProfileAccess():void{
			view.addStories.visible = currentInstance.currentProfileAccess.isSSM;
			view.resetSprint.visible = currentInstance.currentProfileAccess.isSSM;
			
			view.SDateCreation.enabled = currentInstance.currentProfileAccess.isSSM;
			view.SDateEnd.enabled = currentInstance.currentProfileAccess.isSSM;
			view.SDatePreparation.enabled = currentInstance.currentProfileAccess.isSSM;
			view.preparationComments.editable = currentInstance.currentProfileAccess.isSSM;
			view.SDateDemo.enabled = currentInstance.currentProfileAccess.isSSM;
			view.demoComments.editable = currentInstance.currentProfileAccess.isSSM;
		}
		
		private function storyFilter(data:Stories):Boolean{
			var filter:Boolean;
			if(data.productFk == currentProduct.productId ){
				if(currentVersion){
					if(data.versionFk == currentVersion.versionId) 
						filter = true;
				}else{
					filter = true;
				}
			}
			return filter;
		}
		//@TODO
		private function textChanged(ev:Object):void{
			sprintEdited =true;
		}
		private var _mainViewStackIndex:int
		public function get mainViewStackIndex():int
		{
			return _mainViewStackIndex;
		}
		
		public function set mainViewStackIndex(value:int):void
		{
			_mainViewStackIndex = value;
			if(value == Utils.SPRINT_EDIT_INDEX){
				init();
			}
		}
		private var _sprintState:String = new String();
		public function get sprintState():String
		{
			return _sprintState;
		}
		
		public function set sprintState(value:String):void
		{
			_sprintState = value;
			invalidateSkinState();
			if(view.teamMediator) view.teamMediator.sprintState=currentInstance.sprintState;
			if(_sprintState == Utils.TEAMMEMBERSTATE){
				if(view.teamMemberMediator) view.teamMemberMediator.sprintState=currentInstance.sprintState;
				callLater(setTeamState);
			}
		}
		private function setTeamState():void{
			view.teamMemberMediator.sprintState=currentInstance.sprintState;
			view.teamMemberMediator.teamState = Utils.TEAMSTATE;
		}
		override protected function setRenderers():void
		{
			super.setRenderers();
			view.storyList.itemRenderer = Utils.getCustomRenderer(Utils.SPRINTSTORYRENDER);
			view.teamMembersList.itemRenderer = Utils.getCustomRenderer(Utils.TEAMMEMBERRENDER);
			
			/*view.storyList.selectDeselectRendererProperty = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.EDIT]; 
			view.teamMembersList.removeRendererProperty = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.DELETE];*/
			
			view.storyList.selectDeselectRendererProperty = currentInstance.currentProfileAccess.isSSM;
			view.teamMembersList.removeRendererProperty = currentInstance.currentProfileAccess.isSSM;
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void
		{
			super.setViewListeners();
			view.sprintBacklog.clicked.add(gotoSprintBacklog);
			view.splPanel.panelSignal.add(closedPanel);

			view.storyList.renderSignal.add(storyHandler);
			view.teamMembersList.renderSignal.add(teamHandler);

			view.preparationComments.addEventListener(TextOperationEvent.CHANGE, textChanged);
			view.demoComments.addEventListener(TextOperationEvent.CHANGE, textChanged);
			view.SDateDemo.addEventListener(CalendarLayoutChangeEvent.CHANGE, textChanged);
			view.SDatePreparation.addEventListener(CalendarLayoutChangeEvent.CHANGE, textChanged);
			view.SDateCreation.addEventListener(CalendarLayoutChangeEvent.CHANGE, textChanged);
			view.SDateEnd.addEventListener(CalendarLayoutChangeEvent.CHANGE, textChanged);
			
			view.gotoProductConfig.clicked.add(gotoProduct);
			view.productVersionSet.addEventListener(IndexChangeEvent.CHANGE, versionChanged);
			
			view.resetSprint.clicked.add(resetSprintHandler);
			view.addStories.clicked.add(addStoriesHandler);
				
			view.teamSelector.addEventListener(IndexChangeEvent.CHANGE, teamChanged);
			view.createTeam.clicked.add(createTeam);
			view.addTeamMember.clicked.add(createTeamMember);
		}
		private function resetSprintHandler(ev:MouseEvent):void{
			var sprintVO:Sprints = currentInstance.currentSprint;
			var sprintStorySignal:SignalVO;
			var storySignal:SignalVO;
			var storyArr:Array=[];
			for each(var arr_story:Stories in sprintVO.storySet){
				storyArr.push(arr_story);
			}
			
			sprintStorySignal = new SignalVO(this,sprintDAO,Action.UPDATE); 	 
			sprintVO.storySet.removeAll();
			sprintStorySignal.valueObject = sprintVO;
			if(storyArr.length>0) signalSeq.addSignal(sprintStorySignal);
		}
		private function addStoriesHandler(ev:MouseEvent):void{
			var sprintVO:Sprints = currentInstance.currentSprint;
			var sprintStorySignal:SignalVO;
			var storySignal:SignalVO;
			var storyArr:Array=[];
			for each(var arr_story:Stories in currentProduct.storyCollection){
				storyArr.push(arr_story);
			}
			
			sprintStorySignal = new SignalVO(this,sprintDAO,Action.UPDATE); 
			for each(var story:Stories in storyArr){
				Utils.pushNewItem(story,sprintVO.storySet.source,storyDAO.destination);
				sprintStorySignal.valueObject = sprintVO; 
			} 
			if(storyArr.length>0) signalSeq.addSignal(sprintStorySignal);
		}
		private function createTeamMember(ev:MouseEvent):void{
			if(int(currentInstance.currentTeam.teamId))currentInstance.sprintState = Utils.TEAMMEMBERSTATE;
		}
		private function createTeam(ev:MouseEvent):void{
			currentInstance.sprintState = Utils.NEWTEAMSTATE;
		}
		private function gotoProduct(ev:MouseEvent):void{
			currentInstance.currentProducts = currentProduct;
			currentInstance.mainViewStackIndex = Utils.PRODUCT_OPEN_INDEX;
		}
		
		/**
		 * Updates current Sprint's teamFK while the team drop down list gets Changed
		 */
		private function teamChanged( event:IndexChangeEvent ):void {
			if( view.teamSelector.selectedItem ) {
				
				currentInstance.currentTeam = view.teamSelector.selectedItem;
				view.teamMembersList.dataProvider = currentInstance.currentTeam.teamMemberSet;
				
				if( event ) {
					var teamUpdate:SignalVO = new SignalVO( this, sprintDAO, Action.UPDATE );
					currentInstance.currentSprint.teamFk = currentInstance.currentTeam.teamId;
					teamUpdate.valueObject = currentInstance.currentSprint;
					signalSeq.addSignal( teamUpdate );
				}
			}
		}
		
		private function versionChanged(ev:IndexChangeEvent):void{
			if(view.productVersionSet.selectedItem!=null ){
				currentProduct.storyCollection.filterFunction = null;
				currentProduct.storyCollection.refresh();
				currentVersion = view.productVersionSet.selectedItem;
				currentProduct.storyCollection.filterFunction = storyFilter;
				currentProduct.storyCollection.refresh();
				view.storyList.dataProvider = currentProduct.storyCollection;
			}
		} 
		private var selectedTeamMember:Teammembers;
		private function teamHandler( labelType:String):void{
			if(view.teamMembersList.selectedItem!=null ){
				selectedTeamMember= view.teamMembersList.selectedItem;
				if( selectedTeamMember ){
					if(labelType==NativeList.TEAMMEMBERREMOVED){
						Alert.show(Teammembers(selectedTeamMember).personObject.personFirstname,Utils.DELETEITEMALERT,Alert.YES|Alert.CANCEL,null,alrt_closeHandler);
					}
				}
			}		
		}

		/**
		 *  teamMemberSignal added to SignalSequence queue for processing if Yes is selected
		 */
		protected function alrt_closeHandler(evt:CloseEvent):void {
			switch (evt.detail) {
				case Alert.YES:
				case Alert.OK:
					var teamMemberSignal:SignalVO = new SignalVO(this,teammemberDAO,Action.DELETE); 
					teamMemberSignal.valueObject = selectedTeamMember;
					signalSeq.addSignal(teamMemberSignal);
					selectedTeamMember = null;
					break;
			}
		}
		private function storyHandler( labelType:String):void{
			if(view.storyList.selectedItem!=null ){
				var selectedStory:Stories = view.storyList.selectedItem;
				var sprintStorySignal:SignalVO = new SignalVO(this,sprintDAO,Action.UPDATE);
				if(labelType == NativeList.STORYSELECTED){
					currentInstance.currentSprint.storySet.addItem(selectedStory);
				}
				if(labelType == NativeList.STORYDESELECTED){
					Utils.removeArrcItem(selectedStory,currentInstance.currentSprint.storySet,storyDAO.destination);
				}
				SprintStoryRenderer.currentSprint = currentInstance.currentSprint;
				sprintStorySignal.valueObject = currentInstance.currentSprint;
				currentInstance.currentProducts.storyCollection.refresh();
			 	signalSeq.addSignal(sprintStorySignal);
			}		
		}
		private function gotoSprintBacklog(event:MouseEvent):void{
			cleanup(null);
			currentInstance.mainViewStackIndex = Utils.SPRINT_OPEN_INDEX;
		}
		private var sprintEdited:Boolean;
		private function closedPanel():void{
			if(sprintEdited)editSprint();
			cleanup(null);
			currentInstance.mainViewStackIndex= Utils.HOME_INDEX;
		}
		private function editSprint():void{
			var sprintSignal:SignalVO = new SignalVO(this,sprintDAO,Action.UPDATE);
			var sprintVO:Sprints = currentInstance.currentSprint; 
			sprintVO = ObjectUtils.getCastObject(sprintObj,sprintVO) as Sprints;   
			
			sprintSignal.valueObject = sprintVO;
			signalSeq.addSignal(sprintSignal); 
		}
		
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {	
			var currentProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
			var currentSprintId:int = (currentInstance.currentSprint!=null)?currentInstance.currentSprint.sprintId:0;
			
			if(signal.destination == teammemberDAO.destination){
				if(signal.action == Action.DELETE){
					var deletedTeammember:Teammembers = signal.valueObject as Teammembers;
					Utils.removeArrcItem(deletedTeammember,currentInstance.currentTeam.teamMemberSet,teammemberDAO.destination);
					
					var eventsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusTeamMemberDelete,deletedTeammember.personObject.personFirstname+" "+Utils.TEAMMEMBER_DELETE,currentInstance.currentPerson.personId,0,currentProductId,currentSprintId);
					signalSeq.addSignal(eventsSignal);
				}
				currentInstance.sprintState = Utils.BASICSTATE;
			}
			if(signal.destination == sprintDAO.destination){
				if(signal.action == Action.UPDATE){
					var eventsSprintSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusSprintUpdate,currentInstance.currentSprint.sprintLabel+" "+Utils.SPRINT_UPDATE,currentInstance.currentPerson.personId,0,currentProductId,currentSprintId);
					signalSeq.addSignal(eventsSprintSignal);
					
					var receivers:Array = GetVOUtil.getSprintMembers(currentInstance.currentSprint,currentInstance.currentPerson.personId);
					var pushMessage:PushMessage = new PushMessage( Description.UPDATE, receivers, currentInstance.currentSprint.sprintId );
					var pushSignal:SignalVO = new SignalVO( this, sprintDAO, Action.PUSH_MSG, pushMessage );
					signalSeq.addSignal( pushSignal );
				}
			} 
		}
		/**
		 * Remove any listeners we've created.
		 * Stories to sprint/Reset sprint
		 */
		override protected function pushResultHandler( signal:SignalVO ):void {
			if(signal.daoName == teamDAO.daoName){
				var pushedTeam:Teams = GetVOUtil.getVOObject(currentInstance.currentSprint.teamObject.teamId,teamDAO.collection.items,teamDAO.destination,Teams) as Teams;
				if(currentInstance.currentTeam.teamId == signal.description as int){
					currentInstance.currentTeam = pushedTeam;
					view.teamSelector.selectedItem = currentInstance.currentTeam;
					view.teamSelector.validateNow();
					view.teamMembersList.dataProvider = currentInstance.currentTeam.teamMemberSet;
				}
			} 
		}
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event);
			currentProduct.storyCollection.filterFunction = null;
			currentProduct.storyCollection.refresh();
			view.storyList.renderSignal.removeAll();
			view.splPanel.panelSignal.removeAll();
			view.preparationComments.removeEventListener(TextOperationEvent.CHANGE, textChanged);
			view.demoComments.removeEventListener(TextOperationEvent.CHANGE, textChanged);
			view.SDateDemo.removeEventListener(CalendarLayoutChangeEvent.CHANGE, textChanged);
			view.SDatePreparation.removeEventListener(CalendarLayoutChangeEvent.CHANGE, textChanged);
			view.SDateCreation.removeEventListener(CalendarLayoutChangeEvent.CHANGE, textChanged);
			view.SDateEnd.removeEventListener(CalendarLayoutChangeEvent.CHANGE, textChanged);
			
			view.gotoProductConfig.clicked.removeAll();

			view.teamSelector.removeEventListener(IndexChangeEvent.CHANGE, teamChanged);
			view.createTeam.clicked.removeAll();
			view.teamMembersList.renderSignal.removeAll();
			view.addTeamMember.clicked.removeAll();
			view.resetSprint.clicked.removeAll();
			view.addStories.clicked.removeAll();
		}  

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */		
		override protected function gcCleanup( event:Event ):void
		{
			if(viewIndex!= Utils.SPRINT_EDIT_INDEX)cleanup(event);
		}
	}
}