package com.adams.dt.model
{
	import com.adams.dt.model.tracability.TaskContent;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Companies;
	import com.adams.dt.model.vo.Events;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Groups;
	import com.adams.dt.model.vo.LoginVO;
	import com.adams.dt.model.vo.PDFTool.PDFDetailVO;
	import com.adams.dt.model.vo.PDFTool.SVGDetailVO;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Phasestemplates;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.TeamTemplates;
	import com.adams.dt.model.vo.Translate;
	import com.adams.dt.model.vo.Workflows;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adams.dt.model.vo.localize.ILocalizer;
	import com.adams.dt.model.vo.localize.Localizer;
	import com.adobe.cairngorm.model.IModelLocator;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.ChannelSet;
	
	[Bindable]
	public class ModelLocator implements IModelLocator 
	{
		public var invalideAlertName:String = "";
		public var attachmentsFiles:ArrayCollection = new ArrayCollection();
		public var impFileCollection:ArrayCollection = new ArrayCollection();
		public var impDoFileUploadCollection:ArrayCollection = new ArrayCollection();		
		public var attachmentsNo:Number =0;
		
		public var loc : ILocalizer;
		public var myLoc : Localizer = Localizer.getInstance();
		[ArrayElementType("com.adams.dt.model.vo.LangEntries")]
		public var langEntriesCollection : ArrayCollection;
		
		// Google Translate VO
		public const GOOGLETEXT : String = "http://ajax.googleapis.com/ajax/services/language/" ;
		public const TSOURCE : String = "translate?v=1.0&q=";
		public const LANPAIR : String = "&langpair=";
		public const PAIRCODE : String = "%7C";
		public const ENGLISH : String = "en";
		public const FRENCH : String = "fr";
		public var textSource : String = '';
		public var destLanguage : String = FRENCH;
		public var langChannelSet : ChannelSet;
		public var currentTranslation : Translate;
		//settings VO
		public var settingsPanelVisible:Boolean;
		public var enableAlertSound:Boolean;
		public var launchOnStartUp:Boolean;
		public var alertDisplayTime:int = 5;
		public var tracTaskContent : TaskContent = new TaskContent();				
		public var serverLocation : String='';
		public var finishedTempTaskId:Tasks;
		
		public var authperson:Persons = new Persons(); 
		public var typeName:String;
		public var typeSubAllName:String;
		public var typeINDFilefound:Boolean = true;
		
		public var delayUpdateTxt:String = "Starting Update";
		public var modelMessageTasks:Tasks = new Tasks();
		
		public var tempIndPreviousTask:Tasks;
		public var modelIndFileName:String; 
		public var currentSwfFile:FileDetails = new FileDetails();
		public var pdfTileList:Boolean = true;
		public var pdfloader:Boolean = true;
		
		public var compareTask : Tasks;
		public var appDomain:String;
		
		public var totalCompaniesColl:ArrayCollection = new ArrayCollection();
		
		//PDF VO
		public var svgDetailVO :SVGDetailVO = new SVGDetailVO();
		public var pdfDetailVO : PDFDetailVO = new PDFDetailVO();
		public var loadComareTaskFiles:Boolean = false;
		public var comaparePdfFileCollection:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Tasks")]
		public var compareTasksCollection:ArrayCollection = new ArrayCollection();
		public var pdfFileCollection:ArrayCollection = new ArrayCollection();
			
		public var modelTeamlineCollectionReader : ArrayCollection;
		public var modelTileFileCollection:ArrayCollection;
		public var modelTeamlineCollection : ArrayCollection;
		public var modelTeamlineStatusCollection : ArrayCollection;	
		public var modelTeamlineMessageCollection : ArrayCollection;
		public var messageBulkMailCollection:ArrayCollection = new ArrayCollection();	
		public var modelTeamlineMailColl : ArrayCollection;
		
		
		public var technicalPropertyChanged:Boolean = false;
		public var updatedPresetId : Array = [];
		public var pendingCurrentDomain:Categories;
		public var updatedFieldCollection:ArrayCollection = new ArrayCollection();
		public var alarmTemplatesCollection:ArrayCollection = new ArrayCollection();
		public var delayedTasks:ArrayCollection = new ArrayCollection();
		
		public var getAllStatusColl:ArrayCollection = new ArrayCollection();
		public var taskStatusColl:ArrayCollection = new ArrayCollection(); 
		public var taskStatus:String=''
		public var presetTempCollection:ArrayCollection = new ArrayCollection(); 
		[ArrayElementType("com.adams.dt.model.vo.Phasestemplates")] 
		public var allPhasestemplatesCollection:ArrayCollection;
			
		private static var instance:ModelLocator;
		public var serverLastAccessedAt : Date = currentTime;	
		public var pushchannelset : ChannelSet;	
		public var currentDir:String = "";
		public var pdfConversion:Boolean;
		public var newTaskCreated:Boolean;
		public var release:int = 0;
		public var waitingFab:Boolean = true;
		public var updateProperty:Boolean = false;
		public var messageTemplatesCollection:ArrayCollection = new ArrayCollection();
		public var indReaderMailTemplatesCollection:ArrayCollection = new ArrayCollection(); 
		public var checkImpremiurCollection:ArrayCollection = new ArrayCollection(); 	  
		public var teamlLineCollection:ArrayCollection = new ArrayCollection();
		public var impPersonId:int;
		public var impProfileId:int;
		public var impPerson:Persons;
		public var teamProfileCollection:ArrayCollection;
		
		public var updateFileToTask:Tasks;
		public var bgAlpha:int=1;
		public var constWidth:String = 'contsWidth';
		
		[ArrayElementType("com.adams.dt.model.vo.Phases")] 
		public var phaseEventCollection:ArrayCollection;
		
		public var searchArray:Array;
		public var categoriesCollection:ArrayCollection;		
		public var currentCategories:Categories;
		public var companiesCollection:ArrayCollection;
		public var currentCompanies:Companies;
 		public var eventsCollection:ArrayCollection;
		public var currentEvents:Events;
 		public var groupsCollection:ArrayCollection;
		public var currentGroups:Groups;
		public var personsCollection:ArrayCollection;
		public var currentPersons:Persons;
		public var phasesCollection:ArrayCollection;
		public var currentPhases:Phases;
		public var currentPhasestemplates:Phasestemplates;
		public var profilesCollection:ArrayCollection;
		
		public var prjprofilesCollection:ArrayCollection;
		public var currentProfiles:Profiles;
		public var projectsCollection:ArrayCollection = new ArrayCollection();
		public var currentProjects:Projects = new Projects();
		public var currentPropertiespjSingle:ArrayCollection = new ArrayCollection();
		public var currentTempProjects:Projects = new Projects();
		[ArrayElementType("com.adams.dt.model.vo.Propertiespj")] 
		public var propertiespjCollection : ArrayCollection = new ArrayCollection(); 
		public var currentPropertiespj:Propertiespj;
		[ArrayElementType("com.adams.dt.model.vo.Propertiespresets")] 
		public var propertiespresetsCollection:ArrayCollection = new ArrayCollection();
		public var currentPropertiespresets:Propertiespresets;
		public var statusCollection:ArrayCollection;
		public var currentStatus:Status;
		public var currentTasks:Tasks; 
		public var teamTemplatesCollection:ArrayCollection;
		public var currentTeamTemplates:TeamTemplates;
		public var currentWorkflowTemplate:Workflowstemplates;
		public var currentWorkflows:Workflows;
		public var historyScheduleViewCollection:ArrayCollection;
		public var currentTeamlineCollection:ArrayCollection;
		
		 public var login:LoginVO = new LoginVO();
		 public var person:Persons = new Persons(); 
		 public var tasks:ArrayCollection = new ArrayCollection();
		 public var channelSet:ChannelSet;
		 public var taskCollection:ArrayCollection =  new ArrayCollection();
		 public var orderScreenData:IValueObject;
		 public const LOGIN_SUCCESS:int = 1;
       	 public const LOGIN_FAILED:int = 2;
       	 public var workflowState:int = 0;
       	 public var domainCollection:ArrayCollection = new ArrayCollection();
       	 public var workflowstemplates:Workflowstemplates;
       	 public var workflowstemplatesCollection:ArrayCollection;
       	 public var workflowsCollection:ArrayCollection = new ArrayCollection();
       	 public var project:Projects;
       	 public var nextTaskWorkflowTemplate:Workflowstemplates;
       	 public var createdTask:Tasks;
       	 public var createdTaskMessage:Tasks;
       	 public var domain:Categories;
		 public var businessCard:Persons	
       	 public var currentTaskComment:String = '';
       	 public var messageSender:Persons = new Persons();
       	 public var senderProfile:Profiles = new Profiles();
		 public var newProject:Projects = new Projects();
		 public var phasestemplatesCollection:ArrayCollection;
		 public var teamLinetemplatesCollection:ArrayCollection;
		 public var selectedCategory1:Categories;
		 public var selectedCategory2:Categories;
		 public var currentPhasesSet:ArrayCollection;		
		
		/**
		 * used By kumar
		 */
		 public var loginErrorMesg:String = "";		 
		 public var dtState:String = "loginState";
		 public var categoryState:String = "noState";
       	 public var personsArrCollection:ArrayCollection = new ArrayCollection(); 
       	 public var chatCollection:ArrayCollection = new ArrayCollection();  
       	 public var dataReach:Boolean;
       	                                
		 public var peopleReceiverId:Number = 0;
		 public var peopleProjectId:Number = 0;
		 public var peopleChatState:Boolean;
		 public var peopleChatShowHide:String = "hideMesg";
		 		 
		 public var messageDomain:Categories;
		 //public var mainClass:flexexternalmailcomponent;
		 public var mainClass:flexexternalmail;
		 public var logOutApplication:Boolean;
		 
		 //public var serverLocation:String = 'http://localhost:8181/'; 
		 //public var serverLocation:String = 'http://192.168.1.11:8181/';
		
	
		  public var projectSelectionCollection:ArrayCollection;
		  public var peopleCollection:ArrayCollection;       
	      public var breadCrumbClickedName : String;
	      public var breadArray:Array = new Array();
	      public var peopleSelectionData : String;
	      public var seletedView:int  // TO chage the state fromm the people to chart viewer..
		  public var catagoriesState:Boolean; // To call the spring graph function
		  public var messageState :int; // To Hide the open the panel state.
		  public var catagory1:ArrayCollection;
	      public var catagory2:ArrayCollection;
	       public var searchCollection:ArrayCollection;
	      //chart selection by senthil	
	      
	      
	      public var firstNode : Array;
	      public var childNode : Array;
	      public var firstProfile:Profiles;
	      public var secondPerson:Persons;
	      public var totalprofileCollection:ArrayCollection;
	      public var totalPersonCollection:ArrayCollection;
 		  public var domainCollection1:ArrayCollection;
 		  public var messagePanelState:Boolean;
 		  public var messageCollection:ArrayCollection; 
 		  public var searchLaunchScreen:String;
 		  public var mailListCollection:ArrayCollection; 
 		  public var editForm : Boolean;
 		  public var modifiedProject:Projects;
 		  
 		  // catagorySelection by senthil
 		  public var catagoryBread:Array = new Array();
 		  
 		  
 		  public var modelTaskLocalId:Number;
 		  public var modelFileLocalId:Number;
 		  public var modelProjectLocalId:Number;
 		  public var expiryState:String = "datafoundState";//"inBoxState";
 		  
 		  public var HeaderDetails:String; 
 		  public var windowsCloseConfirmation:String="Yes"; 		  
 		  
 		  
 	  	// File Details
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var fileDetailsArray:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var basicFileCollection:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var taskFileCollection:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var fileCollectionToUpdate:ArrayCollection = new ArrayCollection();
		public var parentFolderName:String;
		public var filesToUpload:ArrayCollection = new ArrayCollection();
		public var filesToDownload:ArrayCollection = new ArrayCollection();
		public var localFileExist:Boolean = false;
		//public var bgUploadFile:BackGroundUpload = new BackGroundUpload();
		//public var bgDownloadFile:BackGroundDownload = new BackGroundDownload();
		public var currentProjectFiles:ArrayCollection = new ArrayCollection();
 	  
 	  	public var modelFileDetailsPDFVo:FileDetails;
 	  	public var modelFileDetailsVo:FileDetails;
 	  	public var modelFileCollection:ArrayCollection;
 	  	public var modelLinkName:String; 
 	  	public var modelByteArrray:ByteArray;
 	  	public var modelIMPByteArrray:ByteArray;
 	  	public var saveRefFilename:String = ''; 
 	  	public var modelINDByteArrray:ByteArray;
 	  	
 	  	public var modelINDPreviewByteArrray:ByteArray;	
 	  	public var modelINDPreviewFileVo:FileDetails;	
 	  			  	
 	  	
 	  	public var messageFileCollection:ArrayCollection = new ArrayCollection();
 		  	
 		public var presetTime : Date  
		public var debug:Boolean;
		private var _currentTime : Date = new Date();
		public function set currentTime (value : Date) : void
		{
			_currentTime = value;
		}

		public function get currentTime () : Date
		{  
			debug ? _currentTime = presetTime : _currentTime = new Date();
			return _currentTime;
		}
 		  
		public static function getInstance():ModelLocator
		{
			if(instance==null)	instance = new ModelLocator();
			return instance;
		
		}	
		
		public function ModelLocator()
		{	
			if(instance!=null) throw new Error("Error: Singletons can only be instantiated via getInstance() method!");
			ModelLocator.instance = this;
		}
		
	}
}