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
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.models.vo.Tickets;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.ArrayUtil;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.HomeSkinView;
	import com.adams.scrum.views.components.NativeList;
	import com.adams.scrum.views.renderers.ProductRenderer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	
	import spark.events.IndexChangeEvent;
	import spark.skins.spark.DefaultItemRenderer;
	

	public class HomeViewMediator extends AbstractViewMediator
	{ 		
		[SkinState(Utils.BASICSTATE)]
		[SkinState(Utils.DOMAINSTATE)]
		[SkinState(Utils.PRODUCTSTATE)]
		[SkinState(Utils.SPRINTSTATE)] 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		 
		[Inject("personDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("profileDAO")]
		public var profileDAO:AbstractDAO;

		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;

		[Inject("storyDAO")]
		public var storyDAO:AbstractDAO;
		
		[Inject("domainDAO")]
		public var domainDAO:AbstractDAO;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;	
		
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;	
		
		[Inject("teamDAO")]
		public var teamDAO:AbstractDAO;	
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("companyDAO")]
		public var companyDAO:AbstractDAO;
		
		[Inject("themeDAO")]
		public var themeDAO:AbstractDAO;
		
		[Inject("versionDAO")]
		public var versionDAO:AbstractDAO;
		
		[Inject("taskDAO")]
		public var taskDAO:AbstractDAO;	
		
		[Inject("ticketDAO")]
		public var ticketDAO:AbstractDAO;
		
		private var _scrumState:String;
		public function get scrumState():String {
			return _scrumState;
		}
		public function set scrumState( value:String ):void {
			_scrumState= value;
			invalidateSkinState();
			callLater( setEditState );
			
			if( view.newDomainMediator ) {
				view.newDomainMediator.scrumState = currentInstance.scrumState;
			}
			
			if( view.newProductMediator ) {
				view.newProductMediator.scrumState = currentInstance.scrumState;
			} 
			
			if( view.newSprintMediator ) {
				view.newSprintMediator.scrumState = currentInstance.scrumState;
			}
			if(_scrumState == Utils.BASICSTATE){
				setPreviousHomeView(false);
			}
		}
		
		private function setEditState():void {
			if( view.newDomainMediator ) {
				view.newDomainMediator.editable = edit;
			}
			
			if( view.newProductMediator ) {
				view.newProductMediator.editable = edit;
			} 
			
			if( view.newSprintMediator ) {
				view.newSprintMediator.editable = edit;
			}
		}
		
		private var edit:Boolean; 
		
		private var _mainViewStackIndex:int
		public function get mainViewStackIndex():int {
			return _mainViewStackIndex;
		}
		public function set mainViewStackIndex( value:int ):void {
			_mainViewStackIndex = value;
		}
		
		override protected function getCurrentSkinState():String {
			//just return the component's current state to force the skin to mirror it
			return currentInstance.scrumState;
		}
		
		/**
		 * Constructor.
		 */
		public function HomeViewMediator( viewType:Class=null )
		{
			super( HomeSkinView ); 
		}

		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():HomeSkinView 	{
			return _view as HomeSkinView;
		}
		
		[MediateView( "HomeSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView(value);	
		}
		
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void {
			super.init();  
			viewIndex = Utils.HOME_INDEX;
			
			view.domainPanel.includeInLayout = false;
			view.domainPanel.visible = false;
			
			//load all company
			if( !companyDAO.collection.findAll ) {
				var companySignal:SignalVO = new SignalVO( this, companyDAO, Action.GET_LIST ); 
				signalSeq.addSignal( companySignal );
			}
			
			//load all persons
			if( !personDAO.collection.findAll ) {
				var persignal:SignalVO = new SignalVO( this, personDAO, Action.GET_LIST );
				signalSeq.addSignal( persignal );
			}
			else {
				currentInstance.currentPerson = GetVOUtil.getPersonObject( currentInstance.currentPerson.personLogin, currentInstance.currentPerson.personPassword, personDAO.collection.items as ArrayCollection );
			}
			
			//load all profiles
			if( !profileDAO.collection.findAll ) {
				var prosignal:SignalVO = new SignalVO( this, profileDAO, Action.GET_LIST ); 
				signalSeq.addSignal( prosignal );
			}
			
			//load all teams
			if( !teamDAO.collection.findAll ) {
				var teamSignal:SignalVO = new SignalVO( this, teamDAO, Action.GET_LIST ); 
				signalSeq.addSignal( teamSignal ); 
			}
			
			//load all status
			if( !statusDAO.collection.findAll ) {
				var statusSignal:SignalVO = new SignalVO( this, statusDAO, Action.GET_LIST ); 
				signalSeq.addSignal( statusSignal );
			}
			
			if( domainDAO.collection ){
				view.domainList.dataProvider = GetVOUtil.sortArrayCollection( domainDAO.destination, ( domainDAO.collection.items ) );
			}	
			
			setPreviousHomeView(); 
			
		} 
		override protected function setRenderers():void {
			super.setRenderers();
			view.productList.itemRenderer = Utils.getCustomRenderer( Utils.PRODUCTRENDER );
			view.sprintList.itemRenderer = Utils.getCustomRenderer( Utils.SPRINTRENDER );
			
			view.productList.removeRendererProperty = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.DELETE];
			view.sprintList.removeRendererProperty = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.DELETE];
			setHomeScreenVisible();
		}
		
		private var companyColl:ArrayCollection; 
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {	
			if( signal.destination == companyDAO.destination ) {
				companyColl = GetVOUtil.sortArrayCollection( companyDAO.destination, ( companyDAO.collection.items ) ) as ArrayCollection;
				trace("companyColl :"+companyColl.length);
			}
			
			if( signal.destination == personDAO.destination ) {
				if( signal.action == Action.GET_LIST ){
					currentInstance.currentPerson = GetVOUtil.getPersonObject( currentInstance.currentPerson.personLogin, currentInstance.currentPerson.personPassword, personDAO.collection.items as ArrayCollection );
					trace("currentPerson :"+currentInstance.currentPerson.personId+" , "+currentInstance.currentPerson.personFirstname);
					
					var profileAcessSignal:SignalVO = new SignalVO(this,profileDAO,Action.FIND_ID);
					profileAcessSignal.id = currentInstance.currentPerson.personId;
					signalSeq.addSignal(profileAcessSignal);
					
					if( currentInstance.currentPerson.companyObject.companyCategory.toLowerCase() == Utils.SCRUM_CATEGORY.toLowerCase() ){
						trace("SCRUM_CATEGORY ADAMS call if");
						var domainAllSignal:SignalVO = new SignalVO( this, domainDAO, Action.GET_LIST ); 
						signalSeq.addSignal( domainAllSignal );						
					}else{
						trace("SCRUM_CATEGORY ADAMS call else "+currentInstance.currentPerson.companyObject.companycode);
						var domainSignal:SignalVO = new SignalVO( this, domainDAO, Action.FINDBY_NAME ); 
						domainSignal.name = currentInstance.currentPerson.companyObject.companycode;
						signalSeq.addSignal( domainSignal );
					}	
				}
			}
			if( signal.destination == profileDAO.destination ){				
				if( signal.action == Action.FIND_ID ){
					var tempIList:ArrayCollection = obj as ArrayCollection;
					trace("profileDAO - FIND_ID :"+tempIList.length);

					var tempProfileAccessVO:ProfileAccessVO = Utils.profileAccess( currentInstance.currentProfileAccess ,tempIList );
					currentInstance.currentProfileAccess = tempProfileAccessVO;
					setHomeScreenVisible();
				}				
			}
			if( signal.destination == domainDAO.destination ) {
				if( signal.action == Action.GET_LIST ){
					view.domainList.dataProvider = GetVOUtil.sortArrayCollection( domainDAO.destination, ( domainDAO.collection.items ) );
					
					if( currentInstance.currentProfileAccess.isSPO ){
						if( view.domainList ){
							view.domainList.selectedIndex = 0;
							var selectedDomains:Domains = view.domainList.selectedItem;
							trace("SPO/STM selectedDomains  :"+selectedDomains.domainId+" , "+selectedDomains.domainCode+" , "+selectedDomains.domainName);
							if( selectedDomains ) {
								trace("SPO/STM selectedDomains - productSet :"+currentInstance.currentDomain.productSet.length);
								currentInstance.currentDomain = selectedDomains;							
								view.productList.dataProvider = GetVOUtil.sortArrayCollection( Utils.PRODUCTKEY, ( currentInstance.currentDomain.productSet ) );
							}
						} 
					}
				}
				if( signal.action == Action.FINDBY_NAME ){					
					view.domainList.dataProvider = GetVOUtil.sortArrayCollection( domainDAO.destination, ( domainDAO.collection.items ) );
					trace("domainDAO - FINDBY_NAME :"+view.domainList.dataProvider.length);
					if( view.domainList ){
						view.domainList.selectedIndex = 0;
						var selectedDomains:Domains = view.domainList.selectedItem;
						trace("selectedDomains  :"+selectedDomains.domainId+" , "+selectedDomains.domainCode+" , "+selectedDomains.domainName);
						if( selectedDomains ) {
							trace("selectedDomains - productSet :"+currentInstance.currentDomain.productSet.length);
							currentInstance.currentDomain = selectedDomains;							
							view.productList.dataProvider = GetVOUtil.sortArrayCollection( Utils.PRODUCTKEY, ( currentInstance.currentDomain.productSet ) );
						}
					} 
				}
			}				
			
			if( signal.destination == productDAO.destination ) {
				if( signal.action == Action.DELETE ) {
					var deletedProduct:Products = signal.valueObject as Products;
					Utils.removeArrcItem( deletedProduct, deletedProduct.domainObject.productSet, productDAO.destination );
					var deletedProductId:int = ( deletedProduct ) ? deletedProduct.productId : 0;
					var eventsSignal:SignalVO = Utils.createEvent( this, eventDAO,Utils.eventStatusProductDelete, Utils.PRODUCT_DELETE, currentInstance.currentPerson.personId, 0, deletedProductId );
					signalSeq.addSignal( eventsSignal );
					currentInstance.currentProducts = new Products();
					var pushProductMessage:PushMessage = new PushMessage( Description.DELETE, [], deletedProductId );
					var pushProductSignal:SignalVO = new SignalVO( this, productDAO, Action.PUSH_MSG, pushProductMessage );
					signalSeq.addSignal( pushProductSignal );
				}
			}
			
			if( signal.destination == sprintDAO.destination ) {
				
				if( signal.action == Action.FIND_ID ) {  
					view.sprintList.dataProvider = GetVOUtil.sortArrayCollection( sprintDAO.destination, ( currentInstance.currentProducts.sprintCollection ) );
				}
				
				if( signal.action == Action.DELETE ) {
					var deletedSprint:Sprints = signal.valueObject as Sprints;
					Utils.removeArrcItem( deletedSprint, deletedSprint.productObject.sprintCollection, sprintDAO.destination );
					var deletedProductsId:int = ( deletedSprint ) ? deletedSprint.productFk : 0;
					var deletedSprintId:int = ( deletedSprint ) ? deletedSprint.sprintId : 0;
					var eventsSprintSignal:SignalVO =  Utils.createEvent( this, eventDAO, Utils.eventStatusSprintDelete, Utils.SPRINT_DELETE, currentInstance.currentPerson.personId, 0, deletedProductsId, deletedSprintId );
					signalSeq.addSignal( eventsSprintSignal );
					currentInstance.currentSprint = new Sprints();
					
					var receivers:Array = GetVOUtil.getSprintMembers(deletedSprint,currentInstance.currentPerson.personId);
					var pushSprintMessage:PushMessage = new PushMessage( Description.DELETE, receivers, deletedSprintId );
					var pushSprintSignal:SignalVO = new SignalVO( this, sprintDAO, Action.PUSH_MSG, pushSprintMessage );
					signalSeq.addSignal( pushSprintSignal );
				}
			}
			
			if( signal.destination == storyDAO.destination ) {
				if( signal.action == Action.FIND_ID ) { 
					currentInstance.mainViewStackIndex = Utils.PRODUCT_OPEN_INDEX;
				}
				if( signal.action == Action.DELETE ) {
					var deleteStory:Stories = signal.valueObject as Stories;
					Utils.removeArrcItem(deleteStory, deleteStory.productObject.storyCollection , storyDAO.destination);
					var deleteStoryId:int = (deleteStory) ? deleteStory.storyId: 0;
					var storyEventSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusStoryDelete,Utils.STORY_DELETE,currentInstance.currentPerson.personId,0,currentInstance.currentProducts.productId,0,deleteStoryId);
					signalSeq.addSignal(storyEventSignal);
				}
			}
		}  


		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners();
			
			view.domainList.addEventListener( IndexChangeEvent.CHANGE, DomainSelectHandler );
			view.newDomainBtn.clicked.add( addEditBtnHandler );
			view.editDomainBtn.clicked.add( addEditBtnHandler );
				
			view.productList.renderSignal.add( ProductHandler );  			
			view.productList.addEventListener( IndexChangeEvent.CHANGE, ProductSelectHandler );
			
			view.newProductBtn.clicked.add( addEditBtnHandler );	
			view.editProductBtn.clicked.add( addEditBtnHandler );
			view.sprintList.renderSignal.add( SprintHandler );  
			view.sprintList.addEventListener( IndexChangeEvent.CHANGE, SprintSelectHandler );
			
			view.createSprintBtn.clicked.add( addEditBtnHandler );
			view.editSprintBtn.clicked.add( addEditBtnHandler );
			
			view.openHistoryBtn.clicked.add( addEditBtnHandler );
		}

		/**
		 * handler for both edit,create of sprint, domain and product
		 */
		private function addEditBtnHandler( event:MouseEvent ):void {
			edit = false;
			switch( event.currentTarget ) {
				case view.newDomainBtn: 
					currentInstance.currentDomain = new Domains();
					view.domainList.selectedIndex = -1;
					currentInstance.scrumState = Utils.DOMAINSTATE;
				break;
				case view.editDomainBtn:
					edit = true;
					if( currentInstance.currentDomain.domainId != 0  ) {
						currentInstance.scrumState = Utils.DOMAINSTATE;
					}
					else {						
						if(( currentInstance.currentProfileAccess.isADM ) || ( currentInstance.currentProfileAccess.isSSM ) )
						Alert.show( 'select any domain to edit', Utils.ALERTHEADER );
					}
				break; 
				case view.newProductBtn:
					if( currentInstance.currentDomain.domainId != 0 ) {
						currentInstance.currentProducts = new Products();
						view.productList.selectedIndex = -1;
						currentInstance.scrumState = Utils.PRODUCTSTATE;
					}
					else {
						if(( currentInstance.currentProfileAccess.isADM ) || ( currentInstance.currentProfileAccess.isSSM ) )
						Alert.show( 'select any domain to create', Utils.ALERTHEADER );
					}
				break;
				case view.editProductBtn:
					edit = true;
					if( currentInstance.currentProducts.productId != 0 ) {
						currentInstance.scrumState = Utils.PRODUCTSTATE;
					}
					else {
						Alert.show( 'select any product to edit', Utils.ALERTHEADER );	
					}
				break; 
				case view.createSprintBtn:
					if( currentInstance.currentProducts.productId != 0 ) {
						currentInstance.currentSprint = new Sprints();
						view.sprintList.selectedIndex = -1;
						currentInstance.scrumState = Utils.SPRINTSTATE;
					}
					else {
						Alert.show( 'select any product to add Sprint', Utils.ALERTHEADER );	
					}
				break;
				case view.editSprintBtn:
					edit = true;
					if( currentInstance.currentSprint.sprintId != 0 ) {
						currentInstance.scrumState = Utils.SPRINTSTATE;
					}
					else {
						Alert.show( 'select any sprint to edit', Utils.ALERTHEADER );
					}
				break; 
				case view.openHistoryBtn:	
					//currentInstance.scrumState = Utils.HISTORY_INDEX;	
					if( !eventDAO.collection.findAll ) {
						var eventSignal:SignalVO = new SignalVO(this,eventDAO,Action.GET_LIST); 
						signalSeq.addSignal(eventSignal); 
					} 
					currentInstance.mainViewStackIndex = Utils.HISTORY_INDEX;
				break;
				default:
				break;	
			}
		}	
		
		private function DomainSelectHandler( event:IndexChangeEvent ):void {
			view.sprintList.dataProvider = new ArrayCollection();
			currentInstance.currentSprint = new Sprints();
			currentInstance.currentProducts = new Products();
			var selectedDomains:Domains = view.domainList.selectedItem;
			if( selectedDomains ) {
				currentInstance.currentDomain = selectedDomains;
				view.productList.dataProvider = GetVOUtil.sortArrayCollection( Utils.PRODUCTKEY, ( currentInstance.currentDomain.productSet ) );
			}
		}
		
		private function ProductSelectHandler( event:IndexChangeEvent ):void {
			currentInstance.currentSprint = new Sprints();
			var selectedProducts:Products = view.productList.selectedItem;
			trace("ProductSelectHandler productId:"+selectedProducts.productId+" , productName : "+selectedProducts.productName);
			sprintCollection( selectedProducts );
		}

		/**
		 *  list of sprints for selected product is queried by passing signal to SignalSequence  queue for processing
		 */
		private function sprintCollection( selectedProducts:Products ):void {
			if( selectedProducts ) {
				trace("sprintCollection productId:"+selectedProducts.productId+" , productName : "+selectedProducts.productName);
				currentInstance.currentProducts = selectedProducts;
				view.sprintList.dataProvider = GetVOUtil.sortArrayCollection( Utils.SPRINTKEY, ( currentInstance.currentProducts.sprintCollection ) );
				trace("sprintCollection sprintList:"+view.sprintList.dataProvider.length);

				if( sprintDAO.collection.findByIdArr.indexOf( selectedProducts.productId ) == -1 ) { 
					trace("sprintCollection sprintList inner:"+selectedProducts.productId);
					var sprintSignal:SignalVO = new SignalVO( this, sprintDAO, Action.FIND_ID ); 
					sprintSignal.id = selectedProducts.productId;
					signalSeq.addSignal( sprintSignal );				
				}
			}
		}
		
		/**
		 *  list of stories for selected product is queried by passing signal to SignalSequence queue for processing
		 */
		private function storyCollection( selectedProducts:Products ):void {
			if( selectedProducts ) {
				currentInstance.currentProducts = selectedProducts;
				if( storyDAO.collection.findByIdArr.indexOf( selectedProducts.productId ) == -1 ) {
					var storySignal:SignalVO = new SignalVO( this, storyDAO, Action.FIND_ID ); 
					storySignal.id = selectedProducts.productId;
					signalSeq.addSignal( storySignal );
				}
			}
		}
		
		private var deleteSignalsArr:Array = [];
		private function ProductHandler( message:String ):void {
			if( view.productList.selectedItem ) {
				var selectedProducts:Products = view.productList.selectedItem;
				currentInstance.currentProducts = selectedProducts;
				if( message == NativeList.PRODUCTEDITED ) {
					sprintCollection( selectedProducts );
					currentInstance.mainViewStackIndex = Utils.PRODUCT_EDIT_INDEX;
				}
				else if( message == NativeList.PRODUCTOPENED ) { 		
					storyCollection( selectedProducts );
					if( storyDAO.collection.findByIdArr.indexOf( selectedProducts.productId ) != -1 ) {
						currentInstance.mainViewStackIndex = Utils.PRODUCT_OPEN_INDEX;
					}
				}
				else if( message == NativeList.PRODUCTDELETED ) {  
					var themeSignal:SignalVO; 
					for each( var themesdelete:Themes in selectedProducts.themeSet ) {
						themeSignal = new SignalVO( this, themeDAO, Action.DELETE ); 
						themeSignal.valueObject = themesdelete;
						deleteSignalsArr.push( themeSignal );
					}
					var versionSignal:SignalVO; 
					for each( var versionsdelete:Versions in selectedProducts.versionSet ) {
						versionSignal = new SignalVO( this, versionDAO, Action.DELETE ); 
						versionSignal.valueObject = versionsdelete;
						deleteSignalsArr.push( versionSignal );
					}
					
					var storiesSignal:SignalVO;
					var tasksSignal:SignalVO;
					var ticketsSignal:SignalVO;
					
					for each( var storiesdelete:Stories in selectedProducts.storyCollection ) {
						for each( var taskdelete:Tasks in storiesdelete.taskSet ) {
							for each( var ticketdelete:Tickets in taskdelete.ticketCollection ) {
								ticketsSignal = new SignalVO( this, ticketDAO, Action.DELETE ); 
								ticketsSignal.valueObject = ticketdelete;
								deleteSignalsArr.push( ticketsSignal );	
							}
						}
					}
					
					for each( var storiesdelete:Stories in selectedProducts.storyCollection ) {
						for each( var taskdelete:Tasks in storiesdelete.taskSet ) {
							tasksSignal = new SignalVO( this, taskDAO, Action.DELETE ); 
							tasksSignal.valueObject = taskdelete;
							deleteSignalsArr.push( tasksSignal );
						}
					}
					
					for each( var storiesdelete:Stories in selectedProducts.storyCollection ) {
						storiesSignal = new SignalVO( this, storyDAO, Action.DELETE ); 
						storiesSignal.valueObject = storiesdelete;
						deleteSignalsArr.push( storiesSignal );	
					}
					
					var sprintSignal:SignalVO; 
					for each( var sprint:Sprints in selectedProducts.sprintCollection ) {
						sprintSignal = new SignalVO( this, sprintDAO, Action.DELETE ); 
						sprintSignal.valueObject = sprint;
						deleteSignalsArr.push( sprintSignal );
					}
					
					var productSignal:SignalVO = new SignalVO( this, productDAO, Action.DELETE ); 
					productSignal.valueObject = selectedProducts;
					deleteSignalsArr.push( productSignal );
					Alert.show( Products( selectedProducts ).productName, Utils.DELETEITEMALERT, Alert.YES|Alert.CANCEL, null, alrtCloseHandler );
				}
			}			
		}
		

		/**
		 *  signals were added to SignalSequence queue for processing if Yes is selected
		 */
		protected function alrtCloseHandler( evt:CloseEvent ):void {
			switch( evt.detail ) {
				case Alert.YES:
					for each( var signal:SignalVO in deleteSignalsArr ) {
						signalSeq.addSignal( signal );
					}
				break;	
			}
			deleteSignalsArr = [];
		}
		
		private function SprintHandler( labelType:String ):void {
			if( view.sprintList.selectedItem ) {
				var selectedSprints:Sprints = view.sprintList.selectedItem;
				currentInstance.currentSprint = selectedSprints;
				
				if( labelType ) {
					if( labelType == NativeList.SPRINTEDITED ) { 	
						storyCollection( selectedSprints.productObject );
						currentInstance.mainViewStackIndex = Utils.SPRINT_EDIT_INDEX;
					}
					else if( labelType == NativeList.SPRINTOPENED ) {
						storyCollection( selectedSprints.productObject );
						currentInstance.mainViewStackIndex = Utils.SPRINT_OPEN_INDEX;
					}
					else if( labelType == NativeList.SPRINTDELETED ) { 	
						Alert.show( Sprints( selectedSprints ).sprintLabel, Utils.DELETEITEMALERT, Alert.YES|Alert.CANCEL, null, alrtCloseHandler );
						var sprintSignal:SignalVO = new SignalVO( this, sprintDAO, Action.DELETE ); 
						sprintSignal.valueObject = selectedSprints;
						deleteSignalsArr.push( sprintSignal );
					}
					
				}
			}
		}
		
		private function SprintSelectHandler( event:IndexChangeEvent ):void {
			var selectedSprints:Sprints = view.sprintList.selectedItem;
			if( selectedSprints ) {
				currentInstance.currentSprint = selectedSprints;		
			}
		}
		
		override protected function pushResultHandler( signal:SignalVO ): void {
			if( signal.daoName == Utils.DOMAINDAO ) {
				if( currentInstance.currentDomain.domainId == signal.description as int ) {
					currentInstance.currentDomain =  GetVOUtil.getVOObject( currentInstance.currentDomain.domainId, signal.collection.items, domainDAO.destination, Domains ) as Domains;
				}
			} 
			
			if( signal.daoName == Utils.SPRINTDAO ) {		
				view.domainList.selectedItem = null;
				setPreviousHomeView();
			}
		}
	   
		private function setPreviousHomeView(setProvider:Boolean =true): void {
			if( currentInstance.currentDomain ) {
				view.domainList.selectedItem = currentInstance.currentDomain;
				if(setProvider)view.productList.dataProvider = GetVOUtil.sortArrayCollection( Utils.PRODUCTKEY, ( currentInstance.currentDomain.productSet ) );
				if( currentInstance.currentProducts ) {
					view.productList.selectedItem = currentInstance.currentProducts;
					view.productList.validateNow();
					view.sprintList.dataProvider = GetVOUtil.sortArrayCollection( Utils.SPRINTKEY, ( currentInstance.currentProducts.sprintCollection ) );
					if( currentInstance.currentSprint ) {
						view.sprintList.selectedItem = currentInstance.currentSprint;
						view.sprintList.validateNow();
					}
				}
			}
		}
		private function setHomeScreenVisible(): void {  	 
			view.domainPanel.includeInLayout = currentInstance.currentProfileAccess.domainAccessArr[ProfileAccessVO.READ];
			view.domainPanel.visible = currentInstance.currentProfileAccess.domainAccessArr[ProfileAccessVO.READ];
			
			view.newDomainBtn.visible = currentInstance.currentProfileAccess.domainAccessArr[ProfileAccessVO.CREATE];
			view.editDomainBtn.visible = currentInstance.currentProfileAccess.domainAccessArr[ProfileAccessVO.EDIT];
			view.newProductBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.CREATE];
			view.editProductBtn.visible = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.EDIT];
			view.createSprintBtn.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.CREATE];
			view.editSprintBtn.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.EDIT];
			
			view.openHistoryBtn.visible = currentInstance.currentProfileAccess.eventAccessArr[ProfileAccessVO.READ]; 
			
			rendererEnabled();
		}
		private function rendererEnabled():void{
			view.productList.removeRendererProperty = currentInstance.currentProfileAccess.productAccessArr[ProfileAccessVO.DELETE];
			view.sprintList.removeRendererProperty = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.DELETE];
		}
				
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 		
			
			view.domainList.removeEventListener( IndexChangeEvent.CHANGE, DomainSelectHandler );
			view.productList.removeEventListener( IndexChangeEvent.CHANGE, ProductSelectHandler );
			view.sprintList.removeEventListener( IndexChangeEvent.CHANGE, SprintSelectHandler );

			view.editDomainBtn.clicked.removeAll();
			view.sprintList.renderSignal.removeAll();  
			view.editSprintBtn.clicked.removeAll();
			view.newDomainBtn.clicked.removeAll();
			view.productList.renderSignal.removeAll();
			view.newProductBtn.clicked.removeAll();	
			view.createSprintBtn.clicked.removeAll();
			view.editProductBtn.clicked.removeAll();
		}
		//@TODO

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */		
		override protected function gcCleanup( event:Event ):void {
			if( viewIndex != Utils.HOME_INDEX ) {
				cleanup( event );	
			}
		}
	}
}