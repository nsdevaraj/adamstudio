package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.processor.StatusProcessor;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Files;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.ProfileAccessVO;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.ArrayUtil;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.ProductOpenSkinView;
	import com.adams.scrum.views.components.NativeList;
	import com.adams.scrum.views.components.NativeTileList;
	import com.adams.scrum.views.components.RatingComponent;
	//import com.adams.scrum.views.renderers.ProductStoryRenderer;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.events.ListEvent;
	
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	import spark.skins.spark.DefaultItemRenderer;
	
	public class ProductOpenViewMediator extends AbstractViewMediator
	{
		
		[SkinState(Utils.BASICSTATE)]
		[SkinState(Utils.STORYSTATE)]
		[SkinState(Utils.EDITSTORYSTATE)]
		[SkinState(Utils.BURNDOWNSTATE)]
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;
		
		[Inject("themeDAO")]
		public var themeDAO:AbstractDAO;
		
		[Inject("storyDAO")]
		public var storyDAO:AbstractDAO;
		
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("fileDAO")]
		public var fileDAO:AbstractDAO;	
		
		
		[Bindable]
		private var storyListDp:ArrayCollection = new ArrayCollection(['All','Pending','Done']);
		
		[Bindable]
		private var fileTempCollection:ArrayCollection = new ArrayCollection();		
		/**
		 * Constructor.
		 */
		public function ProductOpenViewMediator(viewType:Class=null)
		{
			super(ProductOpenSkinView); 
		} 
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():ProductOpenSkinView
		{
			return _view as ProductOpenSkinView;
		}
		
		[MediateView( "ProductOpenSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
		}
		override protected function setRenderers():void
		{
			super.setRenderers();
			view.pBlog.itemRenderer = Utils.getCustomRenderer( Utils.PRODUCTSTORYRENDER );
			
			//Scrum master and Product owner only access (SSM/SPO) - No access for(ADM/STM)
			view.showStoryBtn.includeInLayout = currentInstance.currentProfileAccess.storyAccessArr[ ProfileAccessVO.READ ];
			view.showStoryBtn.visible = currentInstance.currentProfileAccess.storyAccessArr[ ProfileAccessVO.READ ];			
			view.storyviewId.includeInLayout = currentInstance.currentProfileAccess.storyAccessArr[ ProfileAccessVO.READ ];
			view.storyviewId.visible = currentInstance.currentProfileAccess.storyAccessArr[ ProfileAccessVO.READ ];
									
			view.letSprintAddColumn.visible = currentInstance.currentProfileAccess.storyAccessArr[ProfileAccessVO.EDIT]
			view.editColumn.visible = currentInstance.currentProfileAccess.storyAccessArr[ProfileAccessVO.EDIT];
			view.deleteColumn.visible = currentInstance.currentProfileAccess.storyAccessArr[ProfileAccessVO.DELETE];
			
			if( !( view.sprintOpenBtn.enabled ) ) {
				view.letSprintAddColumn.visible = false;
			}
		}
		
		private var _productOpenState:String;
		//@TODO
		public function get productOpenState():String {
			return _productOpenState;
		}
		public function set productOpenState( value:String ):void {
			_productOpenState= value;
			invalidateSkinState();
			if( value==Utils.STORYSTATE || value==Utils.EDITSTORYSTATE ) {
				callLater( setStoryState );
			}
			if( value == Utils.BURNDOWNSTATE ) {
				view.burnDownMediator.productOpenState = currentInstance.productOpenState;
			}
		}
		
		private function setStoryState():void{
			view.iwant.text = '';
			view.sotht.text = '';
			view.storyComments.text = '';
			view.storypoints.vpoints = 40;
			
			view.userRoleArr.dataProvider = new ArrayCollection(currentInstance.currentProducts.productRolesArr);			
			view.versionArr.dataProvider = GetVOUtil.sortArrayCollection(Utils.VERSIONKEY,(currentInstance.currentProducts.versionSet));
			view.userRoleArr.validateNow();
			view.userRoleArr.selectedIndex =0;
			view.versionArr.validateNow();
			view.versionArr.selectedIndex = 0;
			view.themeSelector.dataProvider = currentInstance.currentProducts.themeSet;
			
			trace("setStoryState :"+currentInstance.currentProducts.themeSet.length);
			
			
			fileListSettings();
			
			if(_productOpenState == Utils.EDITSTORYSTATE && story) {
				if(fileDAO.collection.items.length!=0)
					fileDAO.collection.items.removeAll();
				
				findFile( story );								
				editStory( story );	
				view.storycancel.clicked.add(editStoryCancelBtnHandler);
				view.edit.clicked.add(storyUpdate);
			}else{
				if(view.themeSelector.themeList.dataProvider.length!=0){
					view.themeSelector.themeList.dataProvider.removeAll();
				}
				if(view.addNewStoryBtn)
					view.addNewStoryBtn.clicked.add(createNewStory);
				
			}
			if(view.browserFileBtn)
				view.browserFileBtn.clicked.add( browseFiles );
		}
		override protected function getCurrentSkinState():String {
			//just return the component's current state to force the skin to mirror it
			return currentInstance.productOpenState;
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
			viewIndex = Utils.PRODUCT_OPEN_INDEX;
			currentInstance.productOpenState=Utils.BASICSTATE;
			view.storyList.dataProvider = storyListDp;	
			var themeDP:ArrayCollection = GetVOUtil.sortArrayCollection(Utils.THEMEKEY,(currentInstance.currentProducts.themeSet)) as ArrayCollection;
			// check to make as enable as false	
			themeDetails = [];
			checkNullItems( themeDP );
			//view.themeList.dataProvider = themeDP;
			view.sprintList.dataProvider = GetVOUtil.sortArrayCollection(sprintDAO.destination,(currentInstance.currentProducts.sprintCollection));
			view.storyList.validateNow();
			view.storyList.selectedIndex =0;
			view.themeList.validateNow();
			view.themeList.selectedIndex =0;
			view.sprintList.validateNow();
			view.sprintList.selectedIndex=0;
			view.pBlog.dataProvider = GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentProducts.storyCollection));
			view.productName.text = currentInstance.currentProducts.productName;
			view.productComments.text = currentInstance.currentProducts.productComment.toString()
			currentSprint = view.sprintList.selectedItem;
			
			//view.addToSprintHeaderLbl.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.EDIT];
			
			currentInstance.currentProducts.storyCollection.filterFunction = storyFilter;
			currentInstance.currentProducts.storyCollection.refresh();
			
			fileListSettings();
		} 
		private function themeRefreshCollection():void
		{
			themeDetails = [];
			checkNullItems( currentInstance.currentProducts.themeSet );
			view.themeList.validateNow();
			view.themeList.selectedIndex = 0;
		}
		private function checkNullItems( themeColl:ArrayCollection  ):void
		{
			currentInstance.currentProducts.storyCollection.refresh();
			for each( var stories :Stories in currentInstance.currentProducts.storyCollection )
			{
				removeTheme(stories,themeColl)
			}	
			var tempArray:Array = removeDuplicatedItems( themeDetails );
			tempArray = setFirstItemAll( tempArray );
			
			if(view.themeList.dataProvider)
				view.themeList.dataProvider.removeAll();
			view.themeList.dataProvider = new ArrayCollection( tempArray );
			
			if(tempArray.length == 1){
				view.themeList.enabled = false;
			}else{
				view.themeList.enabled = true;
			}
		}		
		private function removeDuplicatedItems( source:Array ):Array {
			var returnArray:Array = [];
			var str:String = "";
			for( var i:int = 0;  i < source.length; i++ ) {
				if( str.indexOf( Themes(source[ i ]).themeLbl) == -1 ) {
					returnArray.push( source[ i ] );
					str +=(Themes(source[ i ]).themeLbl+", ");
				}
			}
			return returnArray;
		}		
		private function setFirstItemAll( themeArray :Array ):Array
		{
			var themeArr:Array = new Array();
			var allThemes:Themes = new Themes();
			allThemes.themeLbl='All';
			themeArr = themeArray;			
			ArrayUtil.addElementAt(allThemes,0,themeArr);
			return themeArr;
		}
		private var themeDetails:Array = new Array();
		private function removeTheme(dataStories:Stories , themeColl:ArrayCollection ):void
		{
			var filter:Boolean;
			for each(var currentTheme:Themes in dataStories.themeSet){	
				for each(var theme:Themes in themeColl){
					if(currentTheme.themeId == theme.themeId){
						themeDetails.push(currentTheme);
					}
				}
			}
		}
		
		private function fileListSettings():void{	
			if( view.fileList ){
				view.fileList.resetUploader();
				fileTempCollection = new ArrayCollection();				
				if( fileDAO.collection ){
					if( fileDAO.collection.items ){
						view.fileList.fileListDataProvider = ArrayCollection(GetVOUtil.sortArrayCollection( fileDAO.destination, ( fileDAO.collection.items ) ));
					}
					else{
						view.fileList.fileListDataProvider = fileTempCollection;
					}
				}
				else{
					view.fileList.fileListDataProvider = fileTempCollection;
				}
				view.fileList.renderSignal.add( fileHandler );						
				view.fileList.serverPath = currentInstance.config.serverLocation;
				view.fileList.destinationPath = currentInstance.config.FileServer;				
			}
		}
		private function fileHandler(type:String, obj:Object = null):void{
			if( type == NativeTileList.SHOW_ITEM ){
				var fileRef:FileReference = new FileReference();
				fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, onFileDownloadEvent);
				//fileRef.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onFileDownloadEvent);
				fileRef.addEventListener(IOErrorEvent.IO_ERROR, onFileDownloadEvent);
				fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileDownloadEvent);
				
				var url:String = currentInstance.config.serverLocation+"/downloadHandler";
				var request:URLRequest = new URLRequest( url );	
				request.method = URLRequestMethod.POST;
				
				var variables:URLVariables = new URLVariables();
				variables.saveFilePath = obj.uploadedPath;
				request.data = variables; 
				fileRef.download( request , obj.filename+ "." +obj.extension);
			}
			if( type == NativeTileList.DELETE_ITEM ){
				var fileDeleteSignal:SignalVO = new SignalVO( this, fileDAO, Action.DELETE ); 				
				var filedelete:Files = GetVOUtil.getVOObject(obj.fileId,fileDAO.collection.items,fileDAO.destination,Files) as Files;
				fileDeleteSignal.valueObject = filedelete;
				signalSeq.addSignal( fileDeleteSignal );	
			}			
			if( type == NativeTileList.COMPLETE_ALL_UPLOAD ){
				if((view.fileList.dataProvider as ArrayCollection).length!=0){
					var bulkFileCollection:ArrayCollection = new ArrayCollection();
					for(var i:int=0;i<(view.fileList.dataProvider as ArrayCollection).length;i++){
						if((view.fileList.dataProvider as ArrayCollection).getItemAt(i).fileStatus == view.fileList.NEW_FILE){
							var filesVo:Files= new Files();
							filesVo.filename = ( view.fileList.dataProvider as ArrayCollection ).getItemAt(i).filename;
							filesVo.filepath = ( view.fileList.dataProvider as ArrayCollection ).getItemAt(i).uploadedPath;
							filesVo.filedate = ( view.fileList.dataProvider as ArrayCollection ).getItemAt(i).fileDateTime;
							filesVo.extension = ( view.fileList.dataProvider as ArrayCollection ).getItemAt(i).extension;
							//filesVo.taskFk =
							filesVo.storyFk = ( view.fileList.dataProvider as ArrayCollection ).getItemAt(i).storyFk;
							filesVo.storedfilename = ( view.fileList.dataProvider as ArrayCollection ).getItemAt(i).filename;
							filesVo.productFk = currentInstance.currentProducts.productId;
							bulkFileCollection.addItem( filesVo );
						}
					}
					var fileSignal:SignalVO = new SignalVO( this, fileDAO, Action.BULK_UPDATE ); 
					fileSignal.list = bulkFileCollection;
					signalSeq.addSignal( fileSignal );
				}	
				currentInstance.productOpenState = Utils.BASICSTATE;
			}
		}
		
		private function onFileDownloadEvent(event:Event):void
		{
			var fr:FileReference = event.currentTarget as FileReference;
			if(fr.data==null)
			Alert.show("File does not exist ","Server");
		}
		private function storyFilter(data:Stories):Boolean{
			var filter:Boolean;
			if(themeFilter(data)){
				if(view.storyList.selectedIndex==0){
					filter = true;
				}else if(view.storyList.selectedIndex==1){
					if(data.storyStatusFk == Utils.storyStatusInProgress ||
						data.storyStatusFk == Utils.storyStatusWaiting||
						data.storyStatusFk == Utils.storyStatusStandBy){
						filter = true;
					}
				}else if(view.storyList.selectedIndex==2 && data.storyStatusFk == Utils.storyStatusFinished){
					filter = true;
				}
			}
			return filter;
		}
		private function themeFilter(data:Stories):Boolean{
			var filter:Boolean;
			if(view.themeList.selectedIndex!=0){
				var selectedTheme:Themes = view.themeList.selectedItem;
				if( selectedTheme ){
					for each(var theme:Themes in data.themeSet){
						if(theme.themeId == selectedTheme.themeId){
							filter =true;
							return filter;
						}					
					}
				}
			}else{
				filter =true;
			}
			return filter;
		}
		private var _mainViewStackIndex:int;
		public function get mainViewStackIndex():int
		{
			return _mainViewStackIndex;
		}
		
		public function set mainViewStackIndex(value:int):void
		{
			_mainViewStackIndex = value;
			if(value == Utils.PRODUCT_OPEN_INDEX){
				init();
			}
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners();  
			view.themeList.addEventListener( IndexChangeEvent.CHANGE, filterChangeHandler );
			view.storyList.addEventListener( IndexChangeEvent.CHANGE, filterChangeHandler );
			view.sprintList.addEventListener( IndexChangeEvent.CHANGE, sprintChangeHandler );
			view.showStoryBtn.clicked.add( showStoryForm );
			view.sprintOpenBtn.clicked.add( gotoSprint );
			view.pConfigBtn.clicked.add( openProductConfig );
			view.splPanel.panelSignal.add( closedPanel );
			view.pBlog.renderSignal.add( storyHandler );
			view.burnDownChart.clicked.add( showBurnDownChart );			
		} 
		
		private var currentSprint:Sprints;
		private function filterChangeHandler(ev:IndexChangeEvent):void{
			currentInstance.currentProducts.storyCollection.filterFunction = storyFilter;
			currentInstance.currentProducts.storyCollection.refresh();	
		}
		
		private function sprintChangeHandler( ev:IndexChangeEvent ):void {
			currentSprint = view.sprintList.selectedItem;
			view.pBlog.dataProvider = GetVOUtil.sortArrayCollection( Utils.STORYKEY, ( currentInstance.currentProducts.storyCollection ) );
			if( !view.letSprintAddColumn.visible ) {
				view.letSprintAddColumn.visible = true;
			}
		}
		
		private var story:Stories;
		private function storyUpdate(eve:MouseEvent):void
		{
			var stroyEditSignal:SignalVO = new SignalVO(this,storyDAO,Action.UPDATE);
			var editstory:Stories = story;
			editstory.asLabel = view.userRoleArr.selectedIndex;
			editstory.IWantToLabel = view.iwant.text;
			editstory.soThatICanLabel = view.sotht.text;
			editstory.storyComments = Utils.StrToByteArray(view.storyComments.text);
			editstory.productFk = currentInstance.currentProducts.productId;
			editstory.storypoints = RatingComponent.fibArr[view.storypoints.tenScale]; 
			editstory.themeSet = view.themeSelector.themeDP;
			if(view.versionArr.selectedItem)editstory.versionFk = (view.versionArr.selectedItem as Versions).versionId;
			editstory.storyStatusFk = Utils.storyStatusWaiting;
			stroyEditSignal.valueObject = editstory; 
			signalSeq.addSignal(stroyEditSignal);
			cleapUpEditLayout();
		}
		
		private var deleteSignalsArr:Array = [];
		private function storyHandler(type:String,story:Stories):void{  
			var sprintStorySignal:SignalVO = new SignalVO(this,sprintDAO,Action.UPDATE);
			sprintStorySignal.valueObject = currentSprint;
			if( type == NativeList.STORYDESELECTED && currentSprint ){
				Utils.removeArrcItem(story,currentSprint.storySet,storyDAO.destination);
				signalSeq.addSignal(sprintStorySignal);
			}
			if( type == NativeList.STORYSPRINTSELECTED&& currentSprint ){
				currentSprint.storySet.addItem(story);
				signalSeq.addSignal(sprintStorySignal);
			}
			if( type == NativeList.STORYMODIFY ){
				this.story = story; 
				if(fileDAO.collection.items.length!=0)
					fileDAO.collection.items.removeAll();				
				
				findFile( story );				
				if(_productOpenState ==  Utils.EDITSTORYSTATE){	
					if(view.fileList.fileListDataProvider.length!=0){
						fileTempCollection = new ArrayCollection();	
						if(fileDAO.collection){
							view.fileList.fileListDataProvider = ArrayCollection(GetVOUtil.sortArrayCollection( fileDAO.destination, ( fileDAO.collection.items ) ));
						}
						else{
							view.fileList.fileListDataProvider = fileTempCollection;
						}
					}
					editStory(story);	
				}else{
					currentInstance.productOpenState = Utils.EDITSTORYSTATE;
				}
			}
			if( type == NativeList.STORYDELETE ){
				if( view.storyList.selectedItem ){ 
					this.story = story;
					currentInstance.currentStory = story; 
					
					currentInstance.productOpenState = Utils.BASICSTATE;					
					if( fileDAO.collection ){
						if( fileDAO.collection.items ){
							var tempFileCollect:ArrayCollection = new ArrayCollection();
							for each( var files:Files in fileDAO.collection.items ) {
								if( files.storyFk == story.storyId ){
									tempFileCollect.addItem( files );
								}
							}	
							var fileDeleteSignal:SignalVO; 
							for each( var filevo:Files in tempFileCollect ) {
								fileDeleteSignal = new SignalVO( this, fileDAO, Action.DELETE ); 
								fileDeleteSignal.valueObject = filevo;
								deleteSignalsArr.push( fileDeleteSignal );
							}
						}
					}
					Alert.show( Utils.expandStory( story ), Utils.DELETEITEMALERT, Alert.YES|Alert.CANCEL, null, alrtCloseHandler );
				}
				signalSeq.addSignal( sprintStorySignal );
			}	
			//Not use this file
			//ProductStoryRenderer.currentSprint = currentSprint;
		}
		private function findFile( story:Stories ):void{
			var fileSignal:SignalVO = new SignalVO( this, fileDAO, Action.FIND_ID ); 
			fileSignal.id = story.storyId;
			signalSeq.addSignal( fileSignal );
		}
		
		protected function alrtCloseHandler( evt:CloseEvent ):void {
			if( evt.detail == Alert.YES ) {
				for each( var signal:SignalVO in deleteSignalsArr ) {
					signalSeq.addSignal( signal );
				}
				
				var storySignal:SignalVO = new SignalVO( this, storyDAO, Action.DELETE ); 
				story = GetVOUtil.getVOObject( story.storyId, storyDAO.collection.items, storyDAO.destination, Stories ) as Stories;
				storySignal.valueObject = story;
				signalSeq.addSignal( storySignal );
				
				var sprintsList:ArrayCollection = new ArrayCollection();
				for each( var sprint:Sprints in currentInstance.currentProducts.sprintCollection ) {
					for each( var currentStory:Stories in sprint.storySet ) {
						if( currentStory.storyId == story.storyId ){
							sprint.storySet.removeItemAt( sprint.storySet.getItemIndex( currentStory ) );
							sprintsList.addItem( sprint );
						}
					}
				}
				
				var sprintSignal:SignalVO = new SignalVO( this, sprintDAO, Action.BULK_UPDATE ); 
				sprintSignal.list = sprintsList;
				signalSeq.addSignal( sprintSignal );
			}
			deleteSignalsArr = [];
		}
		
		private function gotoSprint(ev:MouseEvent):void{
			if(currentSprint){
				currentInstance.currentSprint = currentSprint;
				cleanup(null);
				currentInstance.mainViewStackIndex = Utils.SPRINT_OPEN_INDEX;	
			}
		}
		private function editStoryCancelBtnHandler(eve:MouseEvent = null):void{	
			setToBasicState();
		}
		private function cleapUpEditLayout():void { 
			view.storycancel.clicked.removeAll();
			view.edit.clicked.removeAll();
		}
		private function showStoryForm(ev:MouseEvent):void{
			ev.currentTarget.label!='Close' ? currentInstance.productOpenState=Utils.STORYSTATE:setToBasicState(); 
		} 
		private function setToBasicState():void {
			if(_productOpenState == Utils.EDITSTORYSTATE ){
				cleapUpEditLayout();
			}
			currentInstance.productOpenState=Utils.BASICSTATE;	
		}
		private function fileUpload( fileStory:Stories ):void{
			view.fileList.uploadFiles( fileStory );
		}
		
		private function browseFiles( ev:MouseEvent ):void{
			view.fileList.browseFiles();
		}
		
		private function createNewStory( ev:MouseEvent ):void{
			var storySignal:SignalVO = new SignalVO(this,storyDAO,Action.CREATE);
			var newStory:Stories= new Stories();
			newStory.asLabel = view.userRoleArr.selectedIndex;
			newStory.IWantToLabel = view.iwant.text;
			newStory.soThatICanLabel = view.sotht.text;
			newStory.storyComments = Utils.StrToByteArray(view.storyComments.text);
			newStory.productFk = currentInstance.currentProducts.productId;
			newStory.storypoints = RatingComponent.fibArr[view.storypoints.tenScale];
			newStory.themeSet = view.themeSelector.themeDP;
			
			if(view.versionArr.selectedItem)newStory.versionFk = (view.versionArr.selectedItem as Versions).versionId;
			newStory.storyStatusFk = Utils.storyStatusWaiting;
			storySignal.valueObject = newStory; 
			signalSeq.addSignal(storySignal);
		}
		private function editStory( story:Stories ):void{
			view.userRoleArr.selectedIndex = story.asLabel;
			view.iwant.text = story.IWantToLabel;
			view.sotht.text = story.soThatICanLabel;	
			if(story.storyComments)
			view.storyComments.text = story.storyComments.toString();
			view.storypoints.vpoints = story.storypoints;
			view.themeSelector.themeDP = story.themeSet;
			view.versionArr.selectedIndex = currentInstance.currentProducts.versionSet.getItemIndex(story.versionObject);	
			currentTempFileStory = story;
		}
		private function openProductConfig( ev:MouseEvent ):void{
			cleanup(null);
			currentInstance.mainViewStackIndex = Utils.PRODUCT_EDIT_INDEX;
		}
		private function closedPanel():void{
			cleanup(null);
			currentInstance.mainViewStackIndex= Utils.HOME_INDEX;
		}
		
		private function showBurnDownChart( event:MouseEvent ):void {
			currentInstance.productOpenState = Utils.BURNDOWNSTATE;
		}
		
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {
			var currentProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
			if( signal.destination == storyDAO.destination ){
				var createStories:Stories = obj as Stories;	
				if( signal.action == Action.CREATE ){	
					var eventsSignal:SignalVO =  Utils.createEvent(this,eventDAO,Utils.eventStatusStoryCreate,createStories.IWantToLabel+" "+Utils.STORY_CREATE,currentInstance.currentPerson.personId,0,currentProductId,0,createStories.storyId);
					signalSeq.addSignal(eventsSignal);
					
					currentTempFileStory = createStories;
					fileUpload(createStories);
				}else if( signal.action == Action.UPDATE ){
					var eventsStorySignal:SignalVO =  Utils.createEvent(this,eventDAO,Utils.eventStatusStoryUpdate,createStories.IWantToLabel+" "+Utils.STORY_UPDATE,currentInstance.currentPerson.personId,0,currentProductId,0,createStories.storyId);
					signalSeq.addSignal(eventsStorySignal);
					
					currentTempFileStory = createStories;
					fileUpload(createStories);
				}
				if( signal.action == Action.DELETE ){
					var deleteStory:Stories = signal.valueObject as Stories;
					Utils.removeArrcItem(deleteStory, deleteStory.productObject.storyCollection , storyDAO.destination);
					var deleteStoryId:int = (deleteStory) ? deleteStory.storyId: 0;
					var storyEventSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusStoryDelete,Utils.STORY_DELETE,currentInstance.currentPerson.personId,0,currentProductId,0,deleteStoryId);
					signalSeq.addSignal(storyEventSignal);
				}
				if( currentSprint && ( signal.action == Action.CREATE || signal.action == Action.UPDATE ) ){
					var receivers:Array = GetVOUtil.getSprintMembers(currentSprint,currentInstance.currentPerson.personId);
					var pushMessage:PushMessage = new PushMessage( Description.CREATE, receivers, currentSprint.sprintId );
					var pushSignal:SignalVO = new SignalVO( this, sprintDAO, Action.PUSH_MSG, pushMessage );
					signalSeq.addSignal( pushSignal );
				}
				if( view.fileList ){
					if(view.fileList.tempAc.length == 0 )
						currentInstance.productOpenState = Utils.BASICSTATE;
				}
				trace("serviceResultHandler :"+currentInstance.currentProducts.themeSet.length);
				
				themeRefreshCollection();
			}
			if( signal.destination == sprintDAO.destination ){
				var sprintId:int = (currentSprint!=null)?currentSprint.sprintId:0;				
				if( signal.action == Action.UPDATE ){
					if( currentSprint ){
						var eventsUpdateSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusSprintUpdate,currentSprint.sprintLabel+" "+Utils.SPRINT_UPDATE,currentInstance.currentPerson.personId,0,currentProductId,sprintId);
						signalSeq.addSignal(eventsUpdateSignal);
					}
				}else if( signal.action == Action.BULK_UPDATE ){
					if( currentSprint ){
						var eventsBulkUpdateSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusSprintUpdate,currentSprint.sprintLabel+" "+Utils.SPRINT_UPDATE,currentInstance.currentPerson.personId,0,currentProductId,sprintId);
						signalSeq.addSignal(eventsBulkUpdateSignal);
					}
				}
			} 
			if( signal.destination == fileDAO.destination ){
				var createFilescollect:ArrayCollection = obj as ArrayCollection;
				if( signal.action == Action.BULK_UPDATE ){
					if( currentInstance.currentProducts ){
						var eventsBulkUpdatesSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusFileUpdate,currentTempFileStory.IWantToLabel+" "+Utils.FILE_UPDATE,currentInstance.currentPerson.personId,0,currentProductId,0,currentTempFileStory.storyId);
						signalSeq.addSignal(eventsBulkUpdatesSignal);
					}
				}
				if( signal.action == Action.FIND_ID ){	
					view.fileList.fileListDataProvider = ArrayCollection(GetVOUtil.sortArrayCollection( fileDAO.destination, ( fileDAO.collection.items ) ));
					view.fileList.fileListDataProvider.refresh();
					view.fileList.onDataChange();
				}
				if(signal.action == Action.DELETE){
					var deleteFile:Files = signal.valueObject as Files;
				}
			}
		}
		private var currentTempFileStory:Stories;
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event); 
			currentInstance.currentProducts.storyCollection.filterFunction = null;
			currentInstance.currentProducts.storyCollection.refresh();
			
			view.sprintList.removeEventListener(IndexChangeEvent.CHANGE,sprintChangeHandler);
			view.splPanel.panelSignal.removeAll();
			view.pConfigBtn.clicked.removeAll();
			if(view.addNewStoryBtn)view.addNewStoryBtn.clicked.removeAll();
			view.showStoryBtn.clicked.removeAll();
			view.sprintOpenBtn.clicked.removeAll();
			if(view.fileList)view.fileList.renderSignal.removeAll();
		} 
		
		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewIndex!= Utils.PRODUCT_OPEN_INDEX)cleanup(event);
		}
	}
}