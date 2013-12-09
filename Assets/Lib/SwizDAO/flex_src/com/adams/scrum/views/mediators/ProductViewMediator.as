package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.ProductSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import spark.events.TextOperationEvent;
		
	public class ProductViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance; 
				
		[Inject("domainDAO")]
		public var domainDAO:AbstractDAO;
		
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;	
		
		[Inject("versionDAO")]
		public var versionDAO:AbstractDAO;
		
		[Inject("themeDAO")]
		public var themeDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		/**
		 * the object contains the binded values assigned to 
		 * product properties from the view's form using formProcessor
		 */			 	
		[Form(form="view.productForm")]
		public var productObj:Object;
		
		/**
		 * Constructor.
		 */
		public function ProductViewMediator(viewType:Class=null)
		{
			super(ProductSkinView); 
		} 
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():ProductSkinView
		{
			return _view as ProductSkinView;
		}
		
		[MediateView( "ProductSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
		}
		//@TODO
		private var _productState:String;
		
		public function get productState():String {
			return _productState;
		}
		public function set productState(value:String):void {
			_productState=value;
			if(productState==Utils.PRODUCTSTATE)addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
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
			_scrumState=value;
			if(scrumState==Utils.PRODUCTSTATE)addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
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
			view.createBtn.includeInLayout = !_editable;
			view.createBtn.visible = !_editable;
			view.editBtn.includeInLayout = _editable;
			view.editBtn.visible= _editable;
			checkListener(view.createBtn.visible)
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
			viewState = Utils.PRODUCTSTATE;
			
			/*view.createBtn.enabled = false;*/
			
			ObjectUtils.setUpForm(currentInstance.currentProducts,view.productForm); 
			view.productCode.text = currentInstance.currentProducts.productCode;
			view.productStatusFk.dataProvider = GetVOUtil.getStatusObject(statusDAO.collection.items,Utils.SQL_TYPE,Utils.PRODUCT_STATUS,Status);
			view.productStatusFk.validateNow();
			view.productStatusFk.selectedIndex = view.productStatusFk.dataProvider.getItemIndex(currentInstance.currentProducts.statusObject);
			view.domainFk.dataProvider = GetVOUtil.sortArrayCollection(domainDAO.destination,(domainDAO.collection.items));
			view.domainFk.selectedIndex = view.domainFk.dataProvider.getItemIndex(currentInstance.currentDomain);
			//view.taskComponent.txtArr = currentInstance.currentProducts.productTaskTypeArr;
			//view.roleComponent.txtArr = currentInstance.currentProducts.productRolesArr;
			
			if(int(currentInstance.currentProducts.productId)){
				view.taskComponent.txtArr = currentInstance.currentProducts.productTaskTypeArr;
			}else{				
				view.taskComponent.txtArr = ["Programming"];
			}
			if(int(currentInstance.currentProducts.productId)){
				view.roleComponent.txtArr = currentInstance.currentProducts.productRolesArr;				
			}else{
				view.roleComponent.txtArr = ["Admin"];
			}			
			var versionArr:Array = [];			
			for each(var version:Versions in currentInstance.currentProducts.versionSet){
				versionArr.push(version.versionLbl);
			}			
			if(int(currentInstance.currentProducts.productId)){
				view.versionComponent.newClickEnabled = false;
				view.versionComponent.txtArr = versionArr;
			}else{
				view.productStatusFk.selectedIndex =0;
				view.versionComponent.newClickEnabled = true;				
				view.versionComponent.txtArr = ["V1.0"];
			}
			//view.versionComponent.txtArr = versionArr;			
			var themesArr:Array = [];
			for each(var themes:Themes in currentInstance.currentProducts.themeSet){
				themesArr.push(themes.themeLbl);
			}
			(int(currentInstance.currentProducts.productId))?view.themesComponent.newClickEnabled = false:view.themesComponent.newClickEnabled = true;
			//view.themesComponent.txtArr = themesArr;			
			if(int(currentInstance.currentProducts.productId)){
				view.themesComponent.txtArr = themesArr;				
			}else{
				view.themesComponent.txtArr = ["General"];
			}
		}
		protected function checkListener(createBol:Boolean ):void
		{
			if(createBol)
			{
				view.productName.addEventListener(TextOperationEvent.CHANGE,makeItBindable);
			}else{
				view.productName.removeEventListener(TextOperationEvent.CHANGE,makeItBindable);
			}
		}
		protected function addedtoStage(ev:Event):void{
			init();
		} 
		
		public function validateFunction():void{
			/*if((view.versionComponent.validateBoolean) && (view.themesComponent.validateBoolean)){
				view.createBtn.enabled = true;
			}
			else{
				view.createBtn.enabled = false;
			}*/
			view.createBtn.enabled = true;
		}
		
		private function makeItBindable(event:TextOperationEvent):void {
			view.productCode.text = view.productName.text.toUpperCase().slice( 0, 5 );
			if( (view.productName.text.length)  > 4){
				checkAvailability();
				
			}else{
				view.avilableText.visible = false;
				view.avilableText.includeInLayout = false;
			}
		}
		
		private function checkAvailability( ) :void
		{
			var domainCodeColl:Array = productDAO.collection.items.toArray()
			for each( var productDetails:Products in domainCodeColl)
			{
				if((productDetails.productCode).toLocaleUpperCase() == view.productCode.text){
					view.avilableText.visible = true;
					view.avilableText.includeInLayout = true;
					view.createBtn.enabled= false;
					break;
				}
			}
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void
		{
			super.setViewListeners();			 	
			view.versionComponent.validationSignal.add(validateFunction);
			view.themesComponent.validationSignal.add(validateFunction);
			view.roleComponent.validationSignal.add(validateFunction);
			view.taskComponent.validationSignal.add(validateFunction);
			
			view.createBtn.clicked.add( createBtnClickHandler);
			view.editBtn.clicked.add( editBtnClickHandler); 
			view.cancelBtn.clicked.add( cancelBtnClickHandler);
		}
		 
		/**
		 * Handles the click event from the create,product button 
		 * sends signal to create new product with object created from form object
		 */
		protected function createBtnClickHandler(evt:MouseEvent):void
		{ 
			view.avilableText.visible = false;
			var productsSignal:SignalVO = new SignalVO(this,productDAO,Action.CREATE); 
			var productsvo:Products = new Products();
			productsvo.productCode = view.productCode.text;
			productsvo = ObjectUtils.getCastObject(productObj,productsvo) as Products; 
			productsvo = ObjectUtils.getDropListObject(view.domainFk,productsvo) as Products;
			productsvo = ObjectUtils.getDropListObject(view.productStatusFk,productsvo) as Products;
			productsvo.statusObject = GetVOUtil.getVOObject(productsvo.productStatusFk,statusDAO.collection.items,statusDAO.destination,Status) as Status;
			productsSignal.valueObject = productsvo;
			
			if(view.versionComponent.txtOutput.length==0){			
				Alert.show('Atleast a version should be entered', Utils.ALERTHEADER);
			}else if(view.themesComponent.txtOutput.length==0){			
				Alert.show('Atleast a theme should be entered', Utils.ALERTHEADER);
			}else if(view.productName.text.length >0){
				signalSeq.addSignal(productsSignal);
			}else{
				Alert.show('Atleast a product Name should be entered');
			}
			view.productName.removeEventListener(TextOperationEvent.CHANGE,makeItBindable);
		}
		
		/**
		 * Handles the click event from the create button.
		 * Grabs the new tasks details from the respeective text
		 * input fields and populates a taskDTO, then dispatches the
		 * taskEvent to the Cairngorm framework.
		 */
		protected function editBtnClickHandler(evt:MouseEvent):void
		{
			view.avilableText.visible = false;
			var productsSignal:SignalVO = new SignalVO(this,productDAO,Action.UPDATE); 
			var productsvo:Products = currentInstance.currentProducts;
			productsvo.productCode = view.productCode.text;
			productsvo = ObjectUtils.getCastObject(productObj,productsvo) as Products; 
			productsvo = ObjectUtils.getDropListObject(view.domainFk,productsvo) as Products;
			productsvo = ObjectUtils.getDropListObject(view.productStatusFk,productsvo) as Products;
			productsvo.statusObject = GetVOUtil.getVOObject(productsvo.productStatusFk,statusDAO.collection.items,statusDAO.destination,Status) as Status;
			productsSignal.valueObject = productsvo;
			signalSeq.addSignal(productsSignal);
		}
		private function createUpdateVersions(update:Boolean):void{
			var versionsSignal:SignalVO = new SignalVO(this,versionDAO,Action.BULK_UPDATE);
			var versionArr:Array = view.versionComponent.txtOutput.split(',');
			var versionCollection:ArrayCollection = new ArrayCollection();
			var newVersion:Versions;
			if(!update){
				for each(var str:String in versionArr){
					newVersion = new Versions();
					newVersion.versionLbl = str;
					newVersion.productFk = currentInstance.currentProducts.productId; 
					newVersion.versionStatusFk = Utils.versionStatusWaiting;
					versionCollection.addItem(newVersion);
				}
			}else{
				for (var i:int =0; i<currentInstance.currentProducts.versionSet.length; i++){
					var version:Versions = currentInstance.currentProducts.versionSet.getItemAt(i) as Versions;
					version.versionLbl = versionArr[i];
					versionCollection.addItem(version);
				}
			}
			versionsSignal.list = versionCollection; 
			signalSeq.addSignal(versionsSignal);
		}
		private function createUpdateThemes(update:Boolean):void{			
			var themesSignal:SignalVO = new SignalVO(this,themeDAO,Action.BULK_UPDATE);
			var themeArr:Array = view.themesComponent.txtOutput.split(',');
			var themeCollection:ArrayCollection = new ArrayCollection();
			var newTheme:Themes;
			if(!update){
				for each(var str:String in themeArr){
					newTheme = new Themes();
					newTheme.themeLbl = str;
					newTheme.productFk = currentInstance.currentProducts.productId; 
					themeCollection.addItem(newTheme);
				}
			}else{
				for (var i:int =0; i<currentInstance.currentProducts.themeSet.length; i++){
					var newThemes:Themes = currentInstance.currentProducts.themeSet.getItemAt(i) as Themes;
					newThemes.themeLbl = themeArr[i];
					themeCollection.addItem(newThemes);
				}
			}
			themesSignal.list = themeCollection; 
			signalSeq.addSignal(themesSignal);
		}
		private function cancelBtnClickHandler(eve:MouseEvent):void{
			view.avilableText.visible = false;
			currentInstance.scrumState = Utils.BASICSTATE;
			currentInstance.productState = Utils.BASICSTATE;
			view.productCode.text="";
		}
		
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {
			if(signal.destination == productDAO.destination){
				view.productCode.text = '';		
				view.productName.text = '';		
				view.domainFk.selectedIndex = 0;		
				view.productStatusFk.selectedIndex = 0;	
				view.productDateEnd.text = '';	
				view.productDateStart.text = '';	 	
				if(signal.action == Action.CREATE){
					var addedProduct:Products = obj as Products;
					currentInstance.currentProducts = GetVOUtil.getVOObject(addedProduct.productId,productDAO.collection.items,productDAO.destination,Products) as Products;
					var currentProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
					var sprintId:int = (currentInstance.currentSprint!=null)?currentInstance.currentSprint.sprintId:0;
					var eventsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusProductCreate,addedProduct.productName+" "+Utils.PRODUCT_CREATE,currentInstance.currentPerson.personId,0,currentProductId,sprintId); 
 					signalSeq.addSignal(eventsSignal);
					
					createUpdateVersions(false);
					createUpdateThemes(false);
					view.productCode.text="";
				}
				if(signal.action == Action.UPDATE){
					currentInstance.currentProducts.productRolesArr = currentInstance.currentProducts.productRoles.toString().split(',');
					currentInstance.currentProducts.productTaskTypeArr = currentInstance.currentProducts.productTasktypes.toString().split(',');
					
					var currentProductsId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
					var sprintsId:int = (currentInstance.currentSprint!=null)?currentInstance.currentSprint.sprintId:0;
					
					var eventsUpdateSignal:SignalVO =  Utils.createEvent(this,eventDAO,Utils.eventStatusProductUpdate,currentInstance.currentProducts.productName+" "+Utils.PRODUCT_UPDATE,currentInstance.currentPerson.personId,0,currentProductsId,sprintsId);
					signalSeq.addSignal(eventsUpdateSignal);
					
					createUpdateVersions(true);
					createUpdateThemes(true);
					view.productCode.text="";
				}
				
			}		
			if(signal.destination == versionDAO.destination){
				if(signal.action == Action.BULK_UPDATE){
					currentInstance.currentProducts.versionSet.removeAll();
					for each(var addedVersion:Versions in obj){
						var tempVersions:Versions = GetVOUtil.getVOObject(addedVersion.versionId,versionDAO.collection.items,versionDAO.destination,Versions) as Versions;
						currentInstance.currentProducts.versionSet.addItem(addedVersion);
					}
				}
			}
			if(signal.destination == themeDAO.destination){
				if(signal.action == Action.BULK_UPDATE){
					currentInstance.currentProducts.themeSet.removeAll();					
					for each(var addedThemes:Themes in obj){
						var tempThemes:Themes = GetVOUtil.getVOObject(addedThemes.themeId,themeDAO.collection.items,themeDAO.destination,Themes) as Themes;
						currentInstance.currentProducts.themeSet.addItem(addedThemes);
					}
				}
				currentInstance.scrumState = Utils.BASICSTATE;
				currentInstance.productState = Utils.BASICSTATE;
			}
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event); 
			view.versionComponent.validationSignal.removeAll();
			view.themesComponent.validationSignal.removeAll();
			view.roleComponent.validationSignal.removeAll();
			view.taskComponent.validationSignal.removeAll();
			
			view.createBtn.clicked.removeAll();
			view.editBtn.clicked.removeAll(); 
			view.cancelBtn.clicked.removeAll();
			if(hasEventListener(Event.ADDED_TO_STAGE))removeEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.PRODUCT_STATUS)cleanup(event);
		}
	}
}