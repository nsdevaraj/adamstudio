package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.Companies;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.DomainSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
 
	public class DomainViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("domainDAO")]
		public var domainDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("companyDAO")]
		public var companyDAO:AbstractDAO;
		
		/**
		 * Constructor.
		 */
		public function DomainViewMediator(viewType:Class = null)
		{
			super(DomainSkinView);
		}

		/**
		 * the object contains the binded values assigned to 
		 * domain properties from the view's form using formProcessor
		 */		 
		[Form(form="view.domainForm")]
		public var domainObj:Object;
		
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

		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():DomainSkinView
		{
			return _view as DomainSkinView;
		}
		
		[MediateView( "DomainSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
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
		public function set scrumState(value:String):void {
			if(value==Utils.DOMAINSTATE) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
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
		 * the form values were assigned
		 */
		override protected function init():void
		{
			super.init();
			viewState = Utils.DOMAINSTATE;
			view.domainName.text = currentInstance.currentDomain.domainName;
			view.domainCode.dataProvider = GetVOUtil.sortArrayCollection( companyDAO.destination,( companyDAO.collection.items ));
			view.domainCode.selectedIndex = 0;
			if( currentInstance.currentDomain ){
				var arrayCompanyColl:ArrayCollection = ArrayCollection( companyDAO.collection.items );
				for each( var itemsCpy:Companies in arrayCompanyColl){
					if( currentInstance.currentDomain.domainCode == itemsCpy.companycode ){
						view.domainCode.selectedIndex = view.domainCode.dataProvider.getItemIndex( itemsCpy );
						break;
					}
				}
			}
			view.domainCode.validateNow();
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void{
			super.setViewListeners();
			view.domCancelBtn.clicked.add(domainBtnHandler);
			view.domEditBtn.clicked.add(domainBtnHandler);
			view.domCreateBtn.clicked.add(domainBtnHandler);
		} 
		/**
		 * handler for both edit,create and cancel buttons
		 * invokes respective functions
		 */
		private function domainBtnHandler(eve:MouseEvent):void{
			if(eve.currentTarget==view.domCreateBtn){
				createNewDomain();
			}else if(eve.currentTarget==view.domCancelBtn){
				currentInstance.scrumState = Utils.BASICSTATE;
			}else if(eve.currentTarget==view.domEditBtn){
				editDomain();
			}
		}
		
		/**
		 *  Creates new domain and passes signal to SignalSequence  queue for processing
		 */
		private function createNewDomain():void{
			var domainsSignal:SignalVO = new SignalVO(this,domainDAO,Action.CREATE);
			var newDomain:Domains = new Domains();
			newDomain.domainCode = view.domainCode.selectedItem.companycode.toString();
			newDomain = ObjectUtils.getCastObject(domainObj,newDomain) as Domains; 
			domainsSignal.valueObject = newDomain; 
			signalSeq.addSignal(domainsSignal);
			
			var eventsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusDomainCreate,newDomain.domainName+" "+Utils.DOMAIN_CREATE,currentInstance.currentPerson.personId); 
			signalSeq.addSignal(eventsSignal);
		}
		
		/**
		 *  edits selected domain and passes signal to SignalSequence  queue for processing
		 */
		private function editDomain():void{
			var domainsSignal:SignalVO = new SignalVO(this,domainDAO,Action.UPDATE);
			var editDomain:Domains =  currentInstance.currentDomain;
			editDomain.domainCode = view.domainCode.selectedItem.companycode.toString();
			editDomain = ObjectUtils.getCastObject(domainObj,editDomain) as Domains;
			domainsSignal.valueObject = editDomain; 
			signalSeq.addSignal(domainsSignal);
			
			var eventsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusDomainUpdate,editDomain.domainName+" "+Utils.DOMAIN_UPDATE,currentInstance.currentPerson.personId); 
			signalSeq.addSignal(eventsSignal);
		}
		
		/**
		 * Handler for service results of service requests sent from this view.
		 */
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {			
			if(signal.destination == domainDAO.destination){
				if(signal.action == Action.CREATE){
					var addedDomain:Domains = obj as Domains;
					currentInstance.currentDomain = GetVOUtil.getVOObject(addedDomain.domainId,domainDAO.collection.items,domainDAO.destination,Domains) as Domains;
					currentInstance.currentProducts= new Products();
				}
				currentInstance.scrumState = Utils.BASICSTATE;
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
		
		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.DOMAINSTATE)cleanup(event);
		}
	}
}