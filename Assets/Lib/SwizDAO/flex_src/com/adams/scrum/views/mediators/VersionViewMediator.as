package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.VersionSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class VersionViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("versionDAO")]
		public var versionDAO:AbstractDAO;
		
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;

		/**
		 * Constructor.
		 */
		public function VersionViewMediator(viewType:Class = null)
		{
			super(VersionSkinView);
		}
		 
		/**
		 * the object contains the binded values assigned to 
		 * version properties from the view's form using formProcessor
		 */			 	
		[Form(form="view.versionForm")]
		public var VersionObj:Object;
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():VersionSkinView
		{
			return _view as VersionSkinView;
		}
		
		[MediateView( "VersionSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
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
			view.domCreateBtn.includeInLayout = !_editable;
			view.domCreateBtn.visible = !_editable;
			view.domEditBtn.includeInLayout = _editable;
			view.domEditBtn.visible= _editable;
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

		public function set productState(value:String):void {
			if(value==Utils.VERSIONSTATE) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
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
			viewState = Utils.VERSIONSTATE;
			view.versionLbl.text = currentInstance.currentVersion.versionLbl;
			view.versionStatusFk.dataProvider = GetVOUtil.getStatusObject(statusDAO.collection.items,Utils.SQL_TYPE,Utils.VERSION_STATUS,Status);
			view.versionStatusFk.validateNow();
			if(int(currentInstance.currentVersion.versionId)){
				currentInstance.currentVersion.statusObject = GetVOUtil.getVOObject(currentInstance.currentVersion.versionStatusFk, statusDAO.collection.items,statusDAO.destination,Status) as Status;
				view.versionStatusFk.selectedIndex = view.versionStatusFk.dataProvider.getItemIndex(currentInstance.currentVersion.statusObject);
			}else{
				view.versionStatusFk.selectedIndex = 0;
			}
		}	
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void{
			super.setViewListeners();
			view.domCancelBtn.clicked.add(VersionBtnHandler);
			view.domEditBtn.clicked.add(VersionBtnHandler);
			view.domCreateBtn.clicked.add(VersionBtnHandler);
		}
		
		/**
		 * handler for both edit,create and cancel buttons
		 * invokes respective functions
		 */
		private function VersionBtnHandler(eve:MouseEvent):void{
			if(eve.currentTarget==view.domCreateBtn){
				createNewVersion();
			}else if(eve.currentTarget==view.domCancelBtn){
				currentInstance.productState = Utils.BASICSTATE;
			}else if(eve.currentTarget==view.domEditBtn){
				if(int(currentInstance.currentVersion.versionId)){
					editVersion();
				}else{
					currentInstance.productState = Utils.BASICSTATE;	
				}
			}
		}
		private function createNewVersion():void{
			var versionsSignal:SignalVO = new SignalVO(this,versionDAO,Action.CREATE);
			var newVersion:Versions = new Versions();
			newVersion.productFk = currentInstance.currentProducts.productId;
			newVersion = ObjectUtils.getCastObject(VersionObj,newVersion) as Versions;
			newVersion.statusObject = (ObjectUtils.getDropListObject(view.versionStatusFk,newVersion) as Status); 
			versionsSignal.valueObject = newVersion; 
			signalSeq.addSignal(versionsSignal);
		}
		private function editVersion():void{
			var versionsSignal:SignalVO = new SignalVO(this,versionDAO,Action.UPDATE);
			var editVersion:Versions =  currentInstance.currentVersion;
			editVersion.productFk = currentInstance.currentProducts.productId;
			editVersion = ObjectUtils.getCastObject(VersionObj,editVersion) as Versions;
			editVersion.statusObject  = (ObjectUtils.getDropListObject(view.versionStatusFk,editVersion) as Status);
			versionsSignal.valueObject = editVersion; 
			signalSeq.addSignal(versionsSignal);
		}
		
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {			
			var currentProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0; 
			if(signal.destination == versionDAO.destination){
				if(signal.action == Action.CREATE){
					var addedVersion:Versions = obj as Versions;
					currentInstance.currentVersion = GetVOUtil.getVOObject(addedVersion.versionId,versionDAO.collection.items,versionDAO.destination,Versions) as Versions;
					currentInstance.currentProducts.versionSet.addItem(addedVersion);
					
					var eventsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusVersionCreate,addedVersion.versionLbl+" "+Utils.VERSION_CREATE,currentInstance.currentPerson.personId,0,currentProductId);
					signalSeq.addSignal(eventsSignal);
				}
				else if(signal.action == Action.UPDATE){
					var updatedVersion:Versions = obj as Versions;
					var eventsUpdateSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusVersionUpdate,updatedVersion.versionLbl+" "+Utils.VERSION_UPDATE,currentInstance.currentPerson.personId,0,currentProductId);
					signalSeq.addSignal(eventsUpdateSignal);
				}
				
				var pushProductMessage:PushMessage = new PushMessage( Description.UPDATE, [], currentProductId );
				var pushProductSignal:SignalVO = new SignalVO( this, productDAO, Action.PUSH_MSG, pushProductMessage );
				signalSeq.addSignal( pushProductSignal );
				
				currentInstance.productState = Utils.BASICSTATE;
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
			if(viewState!= Utils.VERSIONSTATE)cleanup(event);
		}
	}
}