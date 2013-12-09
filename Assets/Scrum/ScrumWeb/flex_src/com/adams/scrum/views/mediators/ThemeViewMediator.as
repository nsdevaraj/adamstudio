package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.ThemeSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ThemeViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("themeDAO")]
		public var themeDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;
		
		/**
		 * Constructor.
		 */
		public function ThemeViewMediator(viewType:Class = null)
		{
			super(ThemeSkinView);
		}
		 
		/**
		 * the object contains the binded values assigned to 
		 * theme properties from the view's form using formProcessor
		 */			 	
		[Form(form="view.themeForm")]
		public var themeObj:Object;
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():ThemeSkinView
		{
			return _view as ThemeSkinView;
		}
		
		[MediateView( "ThemeSkinView" )]
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
			if(value==Utils.THEMESTATE) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
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
			viewState = Utils.THEMESTATE;
			view.themeLbl.text = currentInstance.currentTheme.themeLbl; 
		}	
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void{
			super.setViewListeners();
			view.domCancelBtn.clicked.add(ThemeBtnHandler);
			view.domEditBtn.clicked.add(ThemeBtnHandler);
			view.domCreateBtn.clicked.add(ThemeBtnHandler);
		}

		/**
		 * handler for both edit,create and cancel buttons
		 * invokes respective functions
		 */
		private function ThemeBtnHandler(eve:MouseEvent):void{
			if(eve.currentTarget==view.domCreateBtn){
				createNewTheme();
			}else if(eve.currentTarget==view.domCancelBtn){
				currentInstance.productState = Utils.BASICSTATE;
			}else if(eve.currentTarget==view.domEditBtn){
				editTheme();
			}
		}
		private function createNewTheme():void{
			var themesSignal:SignalVO = new SignalVO(this,themeDAO,Action.CREATE);
			var newTheme:Themes = new Themes();
			newTheme.productFk = currentInstance.currentProducts.productId;
			newTheme = ObjectUtils.getCastObject(themeObj,newTheme) as Themes; 
			themesSignal.valueObject = newTheme; 
			signalSeq.addSignal(themesSignal);
		}
		private function editTheme():void{
			var themesSignal:SignalVO = new SignalVO(this,themeDAO,Action.UPDATE);
			var editTheme:Themes =  currentInstance.currentTheme;
			editTheme.productFk = currentInstance.currentProducts.productId;
			editTheme = ObjectUtils.getCastObject(themeObj,editTheme) as Themes;
			themesSignal.valueObject = editTheme; 
			signalSeq.addSignal(themesSignal);
		}
		
		
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {
			var currentProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
			 
			if(signal.destination == themeDAO.destination){
				if(signal.action == Action.CREATE){
					var addedTheme:Themes = obj as Themes;
					currentInstance.currentTheme = GetVOUtil.getVOObject(addedTheme.themeId,themeDAO.collection.items,themeDAO.destination,Themes) as Themes;
					currentInstance.currentProducts.themeSet.addItem(addedTheme);
					
					var eventsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusThemeCreate,addedTheme.themeLbl+" "+Utils.THEME_CREATE,currentInstance.currentPerson.personId,0,currentProductId);
					signalSeq.addSignal(eventsSignal);
				}
				if(signal.action == Action.UPDATE){
					var updatedTheme:Themes = obj as Themes;
					var eventsUpdateSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusThemeUpdate,updatedTheme.themeLbl+" "+Utils.THEME_UPDATE,currentInstance.currentPerson.personId,0,currentProductId);
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
			if(viewState!= Utils.THEMESTATE)cleanup(event);
		}
	}
}