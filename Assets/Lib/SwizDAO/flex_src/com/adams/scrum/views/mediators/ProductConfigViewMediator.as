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
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.HomeSkinView;
	import com.adams.scrum.views.ProductConfigSkinView;
	import com.adams.scrum.views.components.NativeList;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.events.CloseEvent;
	
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	import spark.skins.spark.DefaultItemRenderer;

	public class ProductConfigViewMediator extends AbstractViewMediator
	{
		[SkinState(Utils.BASICSTATE)]
		[SkinState(Utils.THEMESTATE)]
		[SkinState(Utils.VERSIONSTATE)]

		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;
		
		[Inject("versionDAO")]
		public var versionDAO:AbstractDAO;
		
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;
		
		[Inject("themeDAO")]
		public var themeDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
				
		/**
		 * Constructor.
		 */
		public function ProductConfigViewMediator(viewType:Class=null)
		{
			super(ProductConfigSkinView); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():ProductConfigSkinView
		{
			return _view as ProductConfigSkinView;
		}
		private var _mainViewStackIndex:int
		public function get mainViewStackIndex():int
		{
			return _mainViewStackIndex;
		}
		
		public function set mainViewStackIndex(value:int):void
		{
			_mainViewStackIndex = value;
			if(value == Utils.PRODUCT_EDIT_INDEX){
				init();
			}
		}
		
		private var _productState:String;
		//@TODO
		public function get productState():String {
			return _productState;
		}
		public function set productState(value:String):void {
			_productState= value;
			invalidateSkinState();
			callLater(setEditState);
			if(view.versionMediator) view.versionMediator.productState=currentInstance.productState;
			if(view.themeMediator) view.themeMediator.productState=currentInstance.productState;
			if(view.productMediator) view.productMediator.productState=currentInstance.productState;
			if(view.sprintMediator) view.sprintMediator.productState=currentInstance.productState;
		}
		private function setEditState():void{
			if(view.versionMediator){
				view.versionMediator.editable=edit;
			}
			if(view.themeMediator){
				view.themeMediator.editable = edit;
			} 
			if(view.sprintMediator) {
				view.sprintMediator.editable = edit;
			}
			if(view.productMediator) {
				view.productMediator.editable = edit;
			}
		}
		override protected function getCurrentSkinState():String {
			//just return the component's current state to force the skin to mirror it
			return currentInstance.productState;
		}
		
		[MediateView( "ProductConfigSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
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
			viewIndex = Utils.PRODUCT_EDIT_INDEX;			
			view.versionsList.dataProvider = GetVOUtil.sortArrayCollection(Utils.VERSIONKEY,(currentInstance.currentProducts.versionSet));
			view.themesList.dataProvider = GetVOUtil.sortArrayCollection(Utils.THEMEKEY,(currentInstance.currentProducts.themeSet));
			view.sprintList.dataProvider = GetVOUtil.sortArrayCollection(Utils.SPRINTKEY,(currentInstance.currentProducts.sprintCollection));
				
			view.productNameTxt.text = currentInstance.currentProducts.productName;
			view.productCodeTxt.text = currentInstance.currentProducts.productCode;
			if(currentInstance.currentProducts.productComment)view.productCommentsTxt.text = currentInstance.currentProducts.productComment.toString();
			
			view.taskArr.txtInputEditable = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			view.taskArr.txtInputSelectable = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			view.taskArr.addTxtBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			
			view.roleArr.txtInputEditable = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			view.roleArr.txtInputSelectable = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			view.roleArr.addTxtBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			
			
			view.roleArr.txtArr = currentInstance.currentProducts.productRolesArr; 
			view.taskArr.txtArr = currentInstance.currentProducts.productTaskTypeArr;
			
			setHomeScreenVisible();
			
		} 
		override protected function setRenderers():void
		{
			super.setRenderers();
			view.versionsList.itemRenderer = Utils.getCustomRenderer(Utils.VERSIONRENDER);
			view.themesList.itemRenderer = Utils.getCustomRenderer(Utils.THEMERENDER);
			view.sprintList.itemRenderer = Utils.getCustomRenderer(Utils.SPRINTRENDER);
			
			view.versionsList.removeRendererProperty = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.DELETE];
			view.themesList.removeRendererProperty = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.DELETE];
			view.sprintList.removeRendererProperty = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.DELETE];
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void
		{
			super.setViewListeners();
			
			view.productOpenBtn.clicked.add(openPBLog);
			view.productCommentsTxt.addEventListener(TextOperationEvent.CHANGE, textChanged);
			view.versionsList.renderSignal.add(VersionsHandler);
			view.versionsList.addEventListener(IndexChangeEvent.CHANGE,VersionsSelectHandler);
			
			view.themesList.renderSignal.add(ThemesHandler);
			view.themesList.addEventListener(IndexChangeEvent.CHANGE,ThemeSelectHandler);
			
			view.productDeleteBtn.clicked.add(ProductDeleteHandler);
			view.productCreateBtn.clicked.add(addEditBtnHandler);

			view.newThemeBtn.clicked.add(addEditBtnHandler);
			view.newVersionBtn.clicked.add(addEditBtnHandler);
			view.editThemeBtn.clicked.add(addEditBtnHandler);
			view.editVersionBtn.clicked.add(addEditBtnHandler);
			
			view.splPanel.panelSignal.add(closedPanel);
			
			view.sprintList.renderSignal.add(SprintHandler);  
			view.sprintList.addEventListener(IndexChangeEvent.CHANGE,SprintSelectHandler);
			
			view.createSprintBtn.clicked.add(addEditBtnHandler);
			view.editSprintBtn.clicked.add(addEditBtnHandler);
		} 
		
		private function setHomeScreenVisible(): void { 
			//view.taskArr.txtInputEditable = false;//currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			//view.taskArr.txtInputSelectable = false;//currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			//view.taskArr.addTxtBtn.visible = false;//currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			
			//view.roleArr.txtInputEditable = false;//currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			//view.roleArr.txtInputSelectable = false;//currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			//view.roleArr.addTxtBtn.visible = false;//currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			
			view.productCommentsTxt.editable = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			view.productCommentsTxt.selectable = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.ADMIN];
			
			view.productCreateBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.CREATE];
			view.productDeleteBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.DELETE];
			
			view.newVersionBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.CREATE];
			view.editVersionBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.CREATE];
			view.newThemeBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.CREATE];
			view.editThemeBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.CREATE];
			
			view.createSprintBtn.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.CREATE];
			view.editSprintBtn.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.EDIT];
		}
		private var descChanged:Boolean;
		private function textChanged(ev:Object):void{
			descChanged =true;
		} 
		private var stateIndex:int;
		private var tempSprintCollection:ArrayCollection;
		private var tempStoryCollection:ArrayCollection;
		private function modifiedValues():void{
			if(descChanged || view.roleArr.valueChanged || view.taskArr.valueChanged){
				var productSignal:SignalVO = new SignalVO(this,productDAO,Action.UPDATE);
				var editProduct:Products =  currentInstance.currentProducts;
				editProduct.productComment =  Utils.StrToByteArray(view.productCommentsTxt.text);
				editProduct.productRoles = Utils.StrToByteArray(view.roleArr.txtOutput);
				editProduct.productTasktypes = Utils.StrToByteArray(view.taskArr.txtOutput);
				productSignal.valueObject = editProduct;
				tempSprintCollection = editProduct.sprintCollection;
				tempStoryCollection = editProduct.storyCollection;
				signalSeq.addSignal(productSignal);
			}else{
				currentInstance.mainViewStackIndex= stateIndex;
				cleanup(null);
			}
		}
		private function closedPanel():void{
			stateIndex = Utils.HOME_INDEX;
			modifiedValues();
		}
		private function openPBLog( event:MouseEvent ):void{
			stateIndex = Utils.PRODUCT_OPEN_INDEX;
			modifiedValues();
		}
		private var edit:Boolean;

		/**
		 * handler for both edit,create for theme, version and sprint
		 * invokes respective functions
		 */
		private function addEditBtnHandler( event:MouseEvent ):void{
			edit =false;
			switch(event.currentTarget){
				case view.newThemeBtn:
					currentInstance.productState = Utils.THEMESTATE;
					break;
				case view.editThemeBtn:
					edit =true;
					if(int(currentInstance.currentTheme.themeId)){
						currentInstance.productState = Utils.THEMESTATE;
					}else{
						Alert.show('select any theme to edit',Utils.ALERTHEADER);
					}
					break; 
				case view.newVersionBtn:
					currentInstance.productState = Utils.VERSIONSTATE;
					break;
				case view.editVersionBtn:
					edit =true;
					if(int(currentInstance.currentVersion.versionId)){
						currentInstance.productState = Utils.VERSIONSTATE;
					}else{
						Alert.show('select any version to edit',Utils.ALERTHEADER);
					}
					break; 
				case view.productCreateBtn:
					currentInstance.productState = Utils.PRODUCTSTATE;
					break; 
				case view.createSprintBtn:
					if(int(currentInstance.currentProducts.productId)){
						currentInstance.currentSprint = new Sprints();
						view.sprintList.selectedIndex = -1;
						currentInstance.productState = Utils.SPRINTSTATE;
					}else{
						Alert.show('select any product to add Sprint',Utils.ALERTHEADER);	
					}
					break;
				case view.editSprintBtn:
					edit =true;
					if(int(currentInstance.currentSprint.sprintId)){
						currentInstance.productState = Utils.SPRINTSTATE;
					}else{
						Alert.show('select any sprint to edit',Utils.ALERTHEADER);
					}
					break; 
			}
		}
		private function SprintHandler( labelType:String ):void{
			if(view.sprintList.selectedItem!=null){
				var selectedSprints:Sprints = view.sprintList.selectedItem;
				currentInstance.currentSprint= selectedSprints;
				if( labelType ){
					if(labelType == NativeList.SPRINTEDITED){ 	
						currentInstance.mainViewStackIndex = Utils.SPRINT_EDIT_INDEX;
					}else if(labelType == NativeList.SPRINTOPENED){
						currentInstance.mainViewStackIndex = Utils.SPRINT_OPEN_INDEX;
					}else if(labelType == NativeList.SPRINTDELETED){ 		
						Alert.show(Sprints(selectedSprints).sprintLabel,Utils.DELETEITEMALERT,Alert.YES|Alert.CANCEL,null,alrtCloseHandler);
						var sprintSignal:SignalVO = new SignalVO(this,sprintDAO,Action.DELETE); 
						sprintSignal.valueObject = selectedSprints;
						deleteSignalsArr.push(sprintSignal);
					}
				}
			}
		} 
		private var deleteSignalsArr:Array=[];

		/**
		 *  signals were added to SignalSequence queue for processing if Yes is selected
		 */
		protected function alrtCloseHandler(evt:CloseEvent):void {
			switch (evt.detail) {
				case Alert.YES:
				case Alert.OK: 
					for each(var signal:SignalVO in deleteSignalsArr){
						signalSeq.addSignal(signal);
					}
					break;
			}
			deleteSignalsArr = [];
		}
		private function SprintSelectHandler( event:IndexChangeEvent ):void{
			var selectedSprints:Sprints = view.sprintList.selectedItem;
			if( selectedSprints ){
				currentInstance.currentSprint = selectedSprints;		
			}
		}
		private function VersionsHandler( labelType:String ):void{
			if(view.versionsList.selectedItem!=null && view.versionsList.dataProvider.length>1){
				var selectedVersions:Versions = view.versionsList.selectedItem;
				if( selectedVersions ){
					currentInstance.currentVersion = selectedVersions;
					if(labelType == NativeList.VERSIONDELETED){
						Alert.show(Versions(selectedVersions).versionLbl,Utils.DELETEITEMALERT,Alert.YES|Alert.CANCEL,null,alrtCloseHandler);
						var versionSignal:SignalVO = new SignalVO(this,versionDAO,Action.DELETE); 
						versionSignal.valueObject = selectedVersions;
						deleteSignalsArr.push(versionSignal);
					}
				}
			}else{
				Alert.show('Atleast a version should be there in a Product', Utils.ALERTHEADER);
			}			
		}
		
		private function ProductCreateHandler( message:String ):void{
			
		}
		private function ProductDeleteHandler( message:String ):void{  
			var selectedProducts:Products =  currentInstance.currentProducts;
			var sprintSignal:SignalVO; 
			for each(var sprint:Sprints in selectedProducts.sprintCollection){
				sprintSignal = new SignalVO(this,sprintDAO,Action.DELETE); 
				sprintSignal.valueObject = sprint;
				deleteSignalsArr.push(sprintSignal);
			}
			Alert.show(Products(selectedProducts).productName,Utils.DELETEITEMALERT,Alert.YES|Alert.CANCEL,null,alrtCloseHandler);
			var productSignal:SignalVO = new SignalVO(this,productDAO,Action.DELETE); 
			productSignal.valueObject = selectedProducts;
			deleteSignalsArr.push(productSignal);
		} 
		
		private function VersionsSelectHandler( event:IndexChangeEvent ):void{
			var selectedVersions:Versions = view.versionsList.selectedItem;
			if( selectedVersions ){
				currentInstance.currentVersion = selectedVersions;
			}
		}
		private function ThemeSelectHandler( event:IndexChangeEvent ):void{
			var selectedTheme:Themes= view.themesList.selectedItem;
			if( selectedTheme ){
				currentInstance.currentTheme= selectedTheme;
			}
		}
		
		private function ThemesHandler( labelType:String):void{
			if(view.themesList.selectedItem!=null && view.themesList.dataProvider.length>1 ){
				var selectedTheme:Themes= view.themesList.selectedItem;
				if( selectedTheme ){
					currentInstance.currentTheme= selectedTheme;
					if(labelType == NativeList.THEMEDELETED){
						Alert.show(Themes(selectedTheme).themeLbl,Utils.DELETEITEMALERT,Alert.YES|Alert.CANCEL,null,alrtCloseHandler);		
						var themeSignal:SignalVO = new SignalVO(this,themeDAO,Action.DELETE); 
						themeSignal.valueObject = selectedTheme;
						deleteSignalsArr.push(themeSignal);
					}
				}
			}else{
				Alert.show('Atleast a theme should be there in a Product', Utils.ALERTHEADER);
			}		
		}
		
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {			
			var deletedProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
			if(signal.destination == versionDAO.destination){
				if(signal.action == Action.DELETE){
					var deletedVersion:Versions = signal.valueObject as Versions;
					Utils.removeArrcItem(deletedVersion,currentInstance.currentProducts.versionSet, versionDAO.destination);
					var eventsVersionSignal:SignalVO =  Utils.createEvent(this,eventDAO,Utils.eventStatusVersionDelete,deletedVersion.versionLbl+" "+Utils.VERSION_DELETE,currentInstance.currentPerson.personId,0,deletedProductId);
					signalSeq.addSignal(eventsVersionSignal);
				}
				currentInstance.productState = Utils.BASICSTATE;
			}
			if(signal.destination == themeDAO.destination){
				if(signal.action == Action.DELETE){
					var deletedTheme:Themes = signal.valueObject as Themes;
					Utils.removeArrcItem(deletedTheme,currentInstance.currentProducts.themeSet, themeDAO.destination);
					
					var eventsThemeSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusThemeDelete,deletedTheme.themeLbl+" "+Utils.THEME_DELETE,currentInstance.currentPerson.personId,0,deletedProductId);
					signalSeq.addSignal(eventsThemeSignal);
				}
				currentInstance.productState = Utils.BASICSTATE;
			}
			if(signal.destination == sprintDAO.destination){
				if(signal.action == Action.DELETE){
					var deletedSprint:Sprints = signal.valueObject as Sprints;
					Utils.removeArrcItem(deletedSprint,deletedSprint.productObject.sprintCollection, sprintDAO.destination);
					
					var deletedSprintId:int = (deletedSprint!=null)?deletedSprint.sprintId:0;
					var eventsSprintSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusSprintDelete,deletedSprint.sprintLabel+" "+Utils.SPRINT_DELETE,currentInstance.currentPerson.personId,0,deletedProductId,deletedSprintId);
					signalSeq.addSignal(eventsSprintSignal);
				}
			}
			if(signal.destination == productDAO.destination){
				if(signal.action == Action.UPDATE){
					currentInstance.currentProducts.productRolesArr = currentInstance.currentProducts.productRoles.toString().split(',');
					currentInstance.currentProducts.productTaskTypeArr = currentInstance.currentProducts.productTasktypes.toString().split(',');
					currentInstance.currentProducts.sprintCollection = tempSprintCollection;
					currentInstance.currentProducts.storyCollection = tempStoryCollection;
					var eventsProductsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusProductUpdate,currentInstance.currentProducts.productName+" "+Utils.PRODUCT_UPDATE,currentInstance.currentPerson.personId,0,deletedProductId);
					signalSeq.addSignal(eventsProductsSignal);
					
					currentInstance.mainViewStackIndex= stateIndex;
					cleanup(null);
				}
				if(signal.action == Action.DELETE){
					var deletedProduct:Products = signal.valueObject as Products;
					Utils.removeArrcItem(deletedProduct,deletedProduct.domainObject.productSet,productDAO.destination);
					
					var eventsProductSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusProductDelete,deletedProduct.productName+" "+Utils.PRODUCT_DELETE,currentInstance.currentPerson.personId,0,deletedProductId);
					signalSeq.addSignal(eventsProductSignal);
					
					cleanup(null);
					currentInstance.mainViewStackIndex= Utils.HOME_INDEX;
				}
			}
		}
		/**
		 * Remove any listeners we've created.
		 * Stories to sprint/Reset sprint
		 */
		override protected function pushResultHandler( signal:SignalVO ):void {			
			if(signal.daoName == productDAO.daoName){
				var pushedProducts:Products = GetVOUtil.getVOObject(currentInstance.currentProducts.productId,productDAO.collection.items,productDAO.destination,Products) as Products;
				 
				if(currentInstance.currentProducts.productId == signal.description as int){
					currentInstance.currentProducts = pushedProducts;	
					view.versionsList.dataProvider = currentInstance.currentProducts.versionSet;
					currentInstance.currentProducts.versionSet.refresh();
					
					view.themesList.dataProvider = currentInstance.currentProducts.themeSet;
					currentInstance.currentProducts.themeSet.refresh();
					
					view.sprintList.dataProvider = currentInstance.currentProducts.sprintCollection;
					currentInstance.currentProducts.sprintCollection.refresh();
				}	 
			}			
		}
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event); 
			view.versionsList.renderSignal.removeAll();
			view.themesList.renderSignal.removeAll();
			view.versionsList.removeEventListener(IndexChangeEvent.CHANGE,VersionsSelectHandler);
			view.themesList.removeEventListener(IndexChangeEvent.CHANGE,ThemeSelectHandler);
			view.newThemeBtn.clicked.removeAll();
			view.newVersionBtn.clicked.removeAll();
			view.editThemeBtn.clicked.removeAll();
			view.editVersionBtn.clicked.removeAll();
			view.productDeleteBtn.clicked.removeAll();
			view.productCreateBtn.clicked.removeAll();
			view.productOpenBtn.clicked.removeAll();
		}

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewIndex!= Utils.PRODUCT_EDIT_INDEX)cleanup(event);
		}
	}
}