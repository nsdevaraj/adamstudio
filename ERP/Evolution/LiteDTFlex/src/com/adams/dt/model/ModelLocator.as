package com.adams.dt.model
{
	import com.adams.dt.business.util.EncryptUtil;
	import com.adams.dt.event.OpenToDoListScreenEvent;
	import com.adams.dt.model.scheduler.taskClasses.TaskData;
	import com.adams.dt.model.tracability.TaskContent;
	import com.adams.dt.model.vo.BackGroundDownload;
	import com.adams.dt.model.vo.BackGroundUpload;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Chat;
	import com.adams.dt.model.vo.Companies;
	import com.adams.dt.model.vo.DomainWorkflow;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Groups;
	import com.adams.dt.model.vo.LoginVO;
	import com.adams.dt.model.vo.PDFTool.PDFDetailVO;
	import com.adams.dt.model.vo.PDFTool.SVGDetailVO;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Presetstemplates;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.dt.model.vo.Proppresetstemplates;
	import com.adams.dt.model.vo.Reports;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.TeamTemplates;
	import com.adams.dt.model.vo.Teamlines;
	import com.adams.dt.model.vo.Translate;
	import com.adams.dt.model.vo.Workflows;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adams.dt.model.vo.localize.*;
	import com.adobe.cairngorm.model.IModelLocator;
	
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.ChannelSet;
	[Bindable]
	public final class ModelLocator implements IModelLocator
	{	
		public var encryptor:EncryptUtil = new EncryptUtil();
		public var chatTeamLineCollection:ArrayCollection = new ArrayCollection();
		public var agenceAttachFileCommon:ArrayCollection = new ArrayCollection();
		public var fromConfirmation:String;		
		public var sendSingleBackAlert : Boolean = true;
		public var sendBasicFileArr : Array =[];
		//public var basicAttachFileCommon:ArrayCollection = new ArrayCollection();
		public var prjCollection:ArrayCollection = new ArrayCollection();
		public var prefixProjectName:String;
		public var indValidation:String = 'no';
		public var incrementProjects:String = '';
		public var tempImpTasks:Tasks = new Tasks();
		public var tempRewindImp:Teamlines;
		public var tempImpPerson:Persons;
		public var indProfileId:int;
		public var selectedWFTemplateID:int;
		public var TaskIDAttachArrayColl:ArrayCollection = new ArrayCollection();
		public var FileAttachArrayColl:ArrayCollection = new ArrayCollection();	
		public var FileIDDetialsAttachColl:ArrayCollection = new ArrayCollection();

		public var basicAttachFileColl:ArrayCollection = new ArrayCollection();
		//public var bulkProfileTaskUpdate:ArrayCollection = new ArrayCollection();		
		
		public var ChatPerson:Persons = new Persons();
		// Services VO
		public var pushchannelset : ChannelSet;
		public var langChannelSet : ChannelSet;
		public var currentTranslation : Translate;
		public var serverLastAccessedAt : Date = currentTime;
		public var localeDb:File = File.userDirectory.resolvePath("DTFlexV1.db");
		public var currentSwfFile:FileDetails = new FileDetails();
		public var currentPDFFile:FileDetails = new FileDetails();
		public var pdfTileList:Boolean = true;
		public var pdfloader:Boolean = true;
		
		public var trafficOnly:Boolean = false;
		public var releaseTasksId : int = 0;
		public var extraPropertyCollection:ArrayCollection = new ArrayCollection();

		
		//Client Details
 		public var clientCode:String; 
 		public var allReports:String;
		//Mail Details
		public var SmtpHost : String;
		public var SmtpPort : int;
		public var SmtpUsername : String;
		public var SmtpPassword : String;
		public var SmtpfrmLbl : String;
		public var SmtpTeamEmail:String;
		public var onlyEmail:String = '';
		public var outerEmailId:String;
		public var newOrderCLTFAB:Boolean = false;
		public var dbserver:String;  //mysql,oracle
		public var projectprefix:String;
		public var PopupOpenStatus:Boolean = false;
		
		public var personSelectionVersion:String;		
		public var commonProfileValidation:String;
		
		public var encryptorUserName:String;
		public var encryptorPassword:String;
		
		[ArrayElementType("com.adams.dt.model.vo.Reports")]
		public var reportAllColl:ArrayCollection = new ArrayCollection();
		
		
		// File Details
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var fileDetailsArray:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var basicFileCollection:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var taskFileCollection:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var fileCollectionToUpdate:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Status")]
		public var getAllStatusColl:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Status")]
		public var taskStatusColl:ArrayCollection = new ArrayCollection(); 
		public var currentReport:Reports = new Reports();
		public var parentFolderName:String;
		public var setWorkFlowId :int = 1;
		public var thumbnailSet:Boolean;
		public var filesToUpload:ArrayCollection = new ArrayCollection();
		public var filesToDownload:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var refFilesDetails:ArrayCollection = new ArrayCollection();
		public var referenceFiles:ArrayCollection ;
		public var fileRefDict:Object;
		public var localFileExist:Boolean = false;
		public var bgUploadFile:BackGroundUpload = new BackGroundUpload();
		public var bgDownloadFile:BackGroundDownload = new BackGroundDownload();
		public var currentProjectFiles:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var pdfFileCollection:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Events")]
		public var currentProjectMessages:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Tasks")]
		public var currentProjectTasksCollection:ArrayCollection = new ArrayCollection();
		public var fileUploadStatus:Boolean;
		//[ArrayElementType("com.adams.dt.model.vo.Tasks")]
		//public var todoLastTaskCollection:ArrayCollection = new ArrayCollection();
		public var uploadFileNumbers:Number = 0;
		public var downloadFileNumbers:Number = 0;
		public var pdfConversion:Boolean;
		public var newTaskCreated:Boolean;
		public var impProfileId:int;
		public var Copyright:String;
		public var finishedTasks:Tasks;
		
		public var impPerson:Persons;
		public var impPersonId:int;
		public var indPerson:Persons;
		public var indPersonId:int;
		public var cltPerson:Persons;
		public var cltPersonId:int;
		public var CP_Person:Persons;
		public var CPP_Person:Persons;
		public var comPerson:Persons;
		public var agencyPerson:Persons;
		public var techPerson:Persons;
		public var selectedPersons_FileAccess:ArrayCollection;
		[ArrayElementType("com.adams.dt.model.vo.DefaultTemplate")]
		public var commonDefaultTemplateCollect:ArrayCollection;
		[ArrayElementType("com.adams.dt.model.vo.DefaultTemplate")]
		public var getAllDefaultTemplateCollect:ArrayCollection;
		[ArrayElementType("com.adams.dt.model.vo.DefaultTemplate")]
		public var specificDefaultTemplateCollect:ArrayCollection;
		public var projectDefaultValue:ArrayCollection;
		public var applyProjectDftValue:ArrayCollection;
		public var chatWindowCollection:Dictionary = new Dictionary();
		
		// Commands VO
		public var loc : ILocalizer;
		public var myLoc : Localizer = Localizer.getInstance();
		private static var instance : ModelLocator;
		[ArrayElementType("com.adams.dt.model.vo.LangEntries")]
		public var langEntriesCollection : ArrayCollection;
		//settings VO
		public var settingsPanelVisible:Boolean;
		
		public var userNameTxt:String;
		public var passwordTxt:String;
		public var enableAlertSound:Boolean;
		public var launchOnStartUp:Boolean;
		public var alertDisplayTime:int = 5;
		
		// Search VO
		//public var searchArray : ArrayCollection;
		public var searchLaunchScreen : String;
		public var tabsCollection:ArrayCollection = new ArrayCollection();
		//[ArrayElementType("com.adams.dt.model.vo.Projects")] 
		//public var referenceProjectCollection:ArrayCollection = new ArrayCollection();
		public var referenceProject:Projects;
		public var referenceTeamline:ArrayCollection;
		
		// Categories VO
		[ArrayElementType("com.adams.dt.model.vo.Profiles")] 
		public var profilesCollection : ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Categories")]
		public var domainCollection:ArrayCollection = new ArrayCollection();
       	public var domain:Categories;
       	public var selectedCategory1:Categories;
		public var selectedCategory2:Categories;
		public var currentDir:String = "";
		public var AutoProj:Boolean;
		public var AutoProjCode:String = OpenToDoListScreenEvent.EVENT_OPEN_CLOSEPROJECTSCREEN;
		public var categoryState : String = "noState";
       	public var peopleCollection : ArrayCollection;
       	public var breadArray : Array = [];
       	public var catagoriesState : Boolean;
       	[ArrayElementType("com.adams.dt.model.vo.Categories")]
       	public var catagory1 : ArrayCollection = new ArrayCollection();
       	[ArrayElementType("com.adams.dt.model.vo.Categories")]
		public var catagory2 : ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Categories")]
		public var categories1 : Categories;
		public var categories2 : Categories;
		public var domainCollection1 : ArrayCollection = new ArrayCollection();
		public var catagoryBread : Array = [];
		public var loadMPVFiles:Boolean = false;
		public var loadSwfFiles:Boolean = false;
		public var loadPushedSwfFiles:Boolean = false;
		//fieldChange Boolean
		public var generalFieldChanged:Boolean = false;
		public var technicalPropertyChanged:Boolean = false;
		public var deportChange:Boolean = false;
		// Person VO
		//public var prjprofilesCollection : ArrayCollection;
		//public var currentTeamlineCollection : ArrayCollection;
		public var person:Persons = new Persons();
		public var businessCard:Persons	
		public var messageSender:Persons = new Persons();
		[ArrayElementType("com.adams.dt.model.vo.Persons")]
		public var personsArrCollection:ArrayCollection = new ArrayCollection();
		
		// Profile VO
		public var currentProfiles : Profiles;
		public var senderProfile:Profiles = new Profiles();
		
		
		// Project Vo
		[ArrayElementType("com.adams.dt.model.vo.Projects")]
		public var projectsCollection : ArrayCollection = new ArrayCollection();
		public var currentProjects : Projects = new Projects();
		public var emptyScreen : Boolean;
		public var techCollection: ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Propertiespresets")] 
		public var propertiespresetsCollection : ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Propertiespj")] 
		public var propertiespjCollection : ArrayCollection = new ArrayCollection(); 
		public var updatedPresetId : Array = [];
		public var updatedFieldCollection:ArrayCollection = new ArrayCollection();
		public var newProject:Projects = new Projects();
		[ArrayElementType("com.adams.dt.model.vo.Projects")]
		public var projectSelectionCollection : ArrayCollection;
		
		//admin moodule
		[ArrayElementType("com.adams.dt.model.vo.DomainWorkflow")]
		public var selectedDomainWorkflows:ArrayCollection =  new ArrayCollection();
		public var createCompanyEvents:Array = [];
		public var delayedProjects:ArrayCollection;
		public var delayedTasks:ArrayCollection = new ArrayCollection();
		
		[ArrayElementType("com.adams.dt.model.vo.Modules")]
		public var getAllModules:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.DomainWorkflow")]
		public var getAllDomainWorkflows:ArrayCollection =  new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.GroupPersons")]
		public var selectedGroupArr: ArrayCollection =  new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.TeamTemplates")]
		public var getAllTeamTemplatesArr: ArrayCollection =  new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Teamlinestemplates")]
		public var selecteTeamlineTemplateArr: ArrayCollection =  new ArrayCollection();
		public var createdPerson:Persons;
		// Task VO
		public var currentTasks : Tasks;
		public var currentMainProject:Projects;
		public var compareTask : Tasks;
		[ArrayElementType("com.adams.dt.model.vo.Tasks")]
		public var tasks:ArrayCollection = new ArrayCollection();
		public var taskWaiting:Boolean;
		[ArrayElementType("com.adams.dt.model.vo.Tasks")]
		public var compareTasksCollection:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Tasks")]
		public var taskCollection:ArrayCollection =  new ArrayCollection();
		public var createdTask:Tasks;
		public var createdTaskIMP:Tasks;	
		public var createdTaskIND:Tasks;		
		
		public var currentTaskComment:String = '';
		public var updateProperty:Boolean = false;
		[ArrayElementType("com.adams.dt.model.vo.Tasks")]
		public var messageTaskCollection:ArrayCollection = new ArrayCollection();
		public var tracTaskContent : TaskContent = new TaskContent();
		public var pendingCurrentDomain:Categories;
		public var taskData : TaskData = new TaskData();
		[ArrayElementType("com.adams.dt.model.vo.Tasks")]
		public var unfinishedTasks:ArrayCollection = new ArrayCollection();
		public var lastTask:Tasks;
		public const monthNames:Array = ['Janvier','Février','Mars','Avril','Mai','Juin','Juillet','Août','Septembre','Octobre','Novembre','Décembre'];
		public var modifiedProject:Projects = new Projects();
		public var updateFileToTask:Tasks;
		
		// Template VO
		[ArrayElementType("com.adams.dt.model.vo.TeamTemplates")] 
		public var teamTemplatesCollection : ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Phasestemplates")] 
		public var phasestemplatesCollection:ArrayCollection;
		[ArrayElementType("com.adams.dt.model.vo.Phasestemplates")] 
		public var allPhasestemplatesCollection:ArrayCollection;
		[ArrayElementType("com.adams.dt.model.vo.Phases")] 
		public var phasesCollection:ArrayCollection;
		[ArrayElementType("com.adams.dt.model.vo.Teamlinestemplates")] 
		public var teamLinetemplatesCollection:ArrayCollection = new ArrayCollection();
		[ArrayElementType("com.adams.dt.model.vo.Teamlines")]
		public var teamLineArrayCollection:ArrayCollection;
		[ArrayElementType("com.adams.dt.model.vo.Phases")] 
		public var phaseEventCollection:ArrayCollection= new ArrayCollection();
		public var createdTeamTemplate:TeamTemplates = new TeamTemplates();
		public var impTeamlineObj:Teamlines = new Teamlines();
		
		// Workflow VO
		 public var createdWorkflows:Workflows = new Workflows();
		 public var currentWorkflows:Workflows;
		 public var workflowState:int = 0;
		 public var mainProjectState:int = 0;
		 public var preloaderVisibility:Boolean;
		 public var getPropertiesUpdated:Boolean;
		 public var updateToDo:Boolean;
		 public var updateMPV:Boolean;
		 public var selectedDefaultTemplate:String;
		 
       	 public var workflowstemplates:Workflowstemplates;
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
       	 public var workflowstemplatesCollection:ArrayCollection;
       	 [ArrayElementType("com.adams.dt.model.vo.Workflows")] 
       	 public var workflowsCollection:ArrayCollection = new ArrayCollection();
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
       	 public var versionLoop:ArrayCollection = new ArrayCollection();
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
       	 public var backTask:ArrayCollection = new ArrayCollection();
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
       	 public var alarmTemplatesCollection:ArrayCollection = new ArrayCollection();
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
       	 public var standByTemplatesCollection:ArrayCollection = new ArrayCollection();
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
       	 public var sendImpMailTemplatesCollection:ArrayCollection = new ArrayCollection();
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")]        	       	 
       	 public var messageTemplatesCollection:ArrayCollection = new ArrayCollection();
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
       	 public var fileAccessTemplates:ArrayCollection = new ArrayCollection();
       	 public var fileAccess:Boolean = false;
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
       	 public var firstRelease:ArrayCollection = new ArrayCollection();
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
		 public var otherRelease:ArrayCollection = new ArrayCollection();
		 public var release:int = 0;
		 public var isFrontTask:Boolean;
		 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
		 public var closeTaskCollection:ArrayCollection = new ArrayCollection();
       	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
	   	 public var indReaderMailTemplatesCollection:ArrayCollection = new ArrayCollection();
	   	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
	   	 public var checkImpremiurCollection:ArrayCollection = new ArrayCollection();  
	   	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
	   	 public var indValidCollection:ArrayCollection = new ArrayCollection();
	   	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
	   	 public var impValidCollection:ArrayCollection = new ArrayCollection();
	   	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")]
	   	 public var CPValidCollection:ArrayCollection = new ArrayCollection();
	   	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
	   	 public var CPPValidCollection:ArrayCollection = new ArrayCollection();
	   	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
	   	 public var COMValidCollection:ArrayCollection = new ArrayCollection();
	   	 [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
	   	 public var AGEValidCollection:ArrayCollection = new ArrayCollection();
	   	// [ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")] 
	   	 //public var indReaderArchiveMailTemplatesCollection:ArrayCollection = new ArrayCollection(); 	   	 
              	 
		 // Login VO
		 public var login:LoginVO = new LoginVO();
		 public const LOGIN_SUCCESS:int = 1;
       	 public const LOGIN_FAILED:int = 2;
		 public var logOutApplication:Boolean;
		 public var mainClass:DTFlex;
		 public var loginErrorMesg:String = "";
		 public var dtState:int;
		 public var dataReach:Boolean;
		 public var editForm:Boolean;
		 
		 public var CF:int=1;
		 public var FileServer:String;
		 public var evalMins:String;
		
		 // Channelset
		 public var channelSet:ChannelSet;
		 public var serverLocation:String = '';
		 
		 //pdf locations for conversions  
	  	 public var pdfServerDir : String; 
	  	 
       	 // Phase VO
		 public var currentPhasesSet:ArrayCollection;
		 public var updatePhase:Boolean = false;
		 [ArrayElementType("com.adams.dt.model.vo.Phasestemplates")]
		 public var createdPhaseTemplatesSet:ArrayCollection;
		 //[ArrayElementType("com.adams.dt.model.vo.Phasestemplates")]
		// public var copiedPhaseTemplatesSet:ArrayCollection;
		 public var fileDetailsToUpdate:ArrayCollection = new ArrayCollection();
		 public var thumbFiles:ArrayCollection = new ArrayCollection();
		 
		 [ArrayElementType("com.adams.dt.model.vo.Columns")]
		 public var orderColumns:ArrayCollection = new ArrayCollection();
		// Chat VO
		public var chatvo : Chat = new Chat();
		[ArrayElementType("com.adams.dt.model.vo.Chat")]
		public var chatCollection : ArrayCollection = new ArrayCollection();
		public var peopleReceiverId : Number = 0;
		public var peopleProjectId : Number = 0;
		public var messageState : int;
		public var firstNode : Array;
		public var childNode : Array;
		public var firstProfile : Profiles;
		public var secondPerson : Persons;
		//[ArrayElementType("com.adams.dt.model.vo.Profile")]
		//public var totalprofileCollection : ArrayCollection;
		//[ArrayElementType("com.adams.dt.model.vo.Persons")]
		//public var totalPersonCollection : ArrayCollection;
		public var createdGroup:Groups = new Groups();
		[ArrayElementType("com.adams.dt.model.vo.Groups")]
		public var createdGroupColl:ArrayCollection = new ArrayCollection();
		
		[ArrayElementType("com.adams.dt.model.vo.Groups")]
		public var CollectAllGroupsColl :ArrayCollection = new ArrayCollection();
		
		public var createdCompaniesColl : Companies = new Companies();
		[ArrayElementType("com.adams.dt.model.vo.Categories")]
		public var categoriesCollection : ArrayCollection = new ArrayCollection();
		
		public var messagePanelState : Boolean;
		public var chatState : Boolean;
		//public var messageCollection : ArrayCollection;
		
		public var newProjectCreated:Boolean;
		
		//PDF VO
		public var svgDetailVO :SVGDetailVO = new SVGDetailVO();
		public var pdfDetailVO : PDFDetailVO = new PDFDetailVO();
		public var loadComareTaskFiles:Boolean = false;
		public var comaparePdfFileCollection:ArrayCollection = new ArrayCollection();
		
		// Google Translate VO
		public const GOOGLETEXT : String = "http://ajax.googleapis.com/ajax/services/language/" ;
		public const TSOURCE : String = "translate?v=1.0&q=";
		public const LANPAIR : String = "&langpair=";
		public const PAIRCODE : String = "%7C";
		public const ENGLISH : String = "en";
		public const FRENCH : String = "fr";
		public var textSource : String = '';
		public var destLanguage : String = FRENCH;
		
		public var showFileContainer:Boolean;
		public var showSave:Boolean;
		
		//producerconsumer
		public var modelLiveUsersArr : ArrayCollection = new ArrayCollection();
		public var modelLoginUserName:String;				
		public var modelPushOnlineUserId:String;
		public var modelPushOnlineUserName:String;
		public var modelPushOnlineUserStatus:String;
		public var modelPushOnlineUserUNID:String;
		public var modelPushCreateTaskId:Number;
		
		public var modelPushCreatePersonId:Number;
		public var modelTeamlineCollection:ArrayCollection;
		public var pushadminchannelset:ChannelSet;
		public var chatChannelset:ChannelSet;
		public var teamlLineProjectCollection:ArrayCollection = new ArrayCollection();
		//public var teamlLineAbortedCollection:ArrayCollection = new ArrayCollection();
		public var modelProjectClosePersonId:Number;
		public var currentUserProfileCode:String;
		public var modelAdminMonitorArrColl:ArrayCollection = new ArrayCollection();
		public var teamlTaskFinishCollection:ArrayCollection = new ArrayCollection();
		
		public var modelMainProjectView:String = "";	
		public var modelToDoListView:String = "";
		public var currentProfileIdPush:String = "";
		
		public var waitingFab:Boolean = true;
		public var modelAnnulationWorkflowTemplate : ArrayCollection = new ArrayCollection();
		public var closeProjectTemplate : ArrayCollection = new ArrayCollection();
		public var modelCloseTask : Tasks = new Tasks();
		public var modelCloseTaskArrColl : ArrayCollection = new ArrayCollection();
		public var modelDelayTaskArrColl : ArrayCollection = new ArrayCollection();
		public var pushDelayedMsg : ArrayCollection = new ArrayCollection();
		public var messageDomain:Categories;
		[ArrayElementType("com.adams.dt.model.vo.FileDetails")]
		public var messageFileCollection:ArrayCollection = new ArrayCollection();
		public var messageBulkTaskCollection:ArrayCollection = new ArrayCollection();
		//public var modelSeperateTaskIdCollection : ArrayCollection = new ArrayCollection();
		public var messageBulkMailCollection:ArrayCollection = new ArrayCollection();
		//public var teamLineUpdateProjectStatus : ArrayCollection = new ArrayCollection();
		public var sendBasicMessageFileArr : Array =[];
		public var tempMessageArrColl:ArrayCollection = new ArrayCollection();
		public var modelHistoryColl:ArrayCollection = new ArrayCollection();
		public var modelAdminHistoryColl:ArrayCollection = new ArrayCollection();	
		public var modelBasicMessageCollect : ArrayCollection = new ArrayCollection();
		public var conversationName:String = '';
		public var modelPropertyEventsColl:ArrayCollection = new ArrayCollection();	
				
		//team selection 
	   public var draggingIndex:int // get the childIndex while Dragging
	   public var droppedIndex:int; // call the add function to add the Button
	   public var deleteIndex:int; // call deleteFn to delete the index from personBox
	   public var deleteStatus:int; // make the deleteFn to delete box frm the personBox
	   public var clientCompanyId:int;
	   public var teamProfileCollection:ArrayCollection ;
	   //public var companyPersonColl:ArrayCollection;
	   //public var positionPersonCollection:ArrayCollection;
	   public var personsTotalCollection : ArrayCollection = new ArrayCollection();
	   public var personLogins:Array = [];
	   //public var teamProfileArr:ArrayCollection = new ArrayCollection();
	   //public var teamPersonArr:ArrayCollection = new ArrayCollection();
	   //public var teamPersonLoginColl:ArrayCollection= new ArrayCollection();
	   public var totalPersonColl:ArrayCollection= new ArrayCollection();
	   public var totalCompaniesColl:ArrayCollection = new ArrayCollection();
	   public var totalColumnsColl:ArrayCollection = new ArrayCollection();
	   //public var teamLinePersonObj:ArrayCollection = new ArrayCollection();
	   //public var teamLineProfileObj:ArrayCollection = new ArrayCollection();
	   public var teamlLineCollection:ArrayCollection = new ArrayCollection();
	   //public var currentProjectPropertyCollection:ArrayCollection = new ArrayCollection();
	   public var collectAllDomains:ArrayCollection = new ArrayCollection();
	   public var teamlLineProjectIdCollection:ArrayCollection = new ArrayCollection();
	   //public var propPresetTemplateCollection:ArrayCollection = new ArrayCollection();
	   public var currentPresetTemplates:Presetstemplates = new Presetstemplates()
	   public var presetTemplatesId:int;
	   [ArrayElementType("com.adams.dt.model.vo.Proppresetstemplates")]
	   public var updateTemplateColl:ArrayCollection = new ArrayCollection();
	   public var deleteTemplateColl:ArrayCollection = new ArrayCollection();
	   public var deletepropPresetTemplate :Proppresetstemplates;
	   public var bulkDeletePersons:ArrayCollection = new ArrayCollection();
	   public var bulkUpdatePersons:ArrayCollection = new ArrayCollection();
	  /// for Team Tool ...
	  public var teamLineProfileColl:ArrayCollection = new ArrayCollection();
	  public var teamLinePersonColl:ArrayCollection = new ArrayCollection();
	  
	  public var deleteTeamLineColl:ArrayCollection = new ArrayCollection();
	  public var addedTeamLineColl:ArrayCollection = new ArrayCollection();
	  //companies
	  public var clientCompanies:Companies
	  // chat collection 
	  public var totalChatPerson:ArrayCollection = new ArrayCollection();
	  public var toPerson:Persons
	  public var messageToPerson:Boolean
	  public var techPropPresetCollection:ArrayCollection = new ArrayCollection();
	  public var defaultTempValueColl:ArrayCollection = new ArrayCollection();
	  public var tempValueColl:ArrayCollection = new ArrayCollection();
	  //////////////////////////////////////////////
	  ///	for File Preloading Process
	  //////////////////////////////////////////////
	  
	  public var uploadingFileName:String = "";  
	  public var uploadingFileBytesLoaded:String = "0";
	  public var uploadingFileBytesTotal:String = "0";
	  
	  //////////////////////////////////////////////
	  ///	for File Preloading Process
	  //////////////////////////////////////////////
	  //////////////////////////////////////////////
	  ///	for Sprint
	  //////////////////////////////////////////////	
	   public var sprintTasksCollection:ArrayCollection;
	  
	   public var currentImpremiuerID:int;
	   public var clientTeamlineId:int;
	   public var currentImpremiurLabel:String	
	   public var ImpremiurCollection :ArrayCollection = new ArrayCollection(); 
	   public var presetTempCollection:ArrayCollection = new ArrayCollection(); 
	   
	   //GTALK CHANGES
	   public var onlineUserCollection:ArrayCollection = new ArrayCollection();
	   public var senderChatName:String;
 	   		
		public static function getInstance() : ModelLocator
		{
			if(instance == null)	instance = new ModelLocator();
			return instance;
		}
		public var _sqlConnection:SQLConnection = new SQLConnection();
		public var systemID:String;
		public var appName:String;
		public var appDomain:String;
		public var registeredUser:String;
		public var licensedVersion:Boolean;
		public var evalMinutes:int;
		public var prjCount:int;
		public var tillTime:int;
		public var localdbOpened:Boolean = false;
		public  function openLocalDb():SQLConnection{ 
			if(!localdbOpened){
				this._sqlConnection.open(localeDb);	
				localdbOpened = true;
			}
			return _sqlConnection;
		}
		public var presetTime : Date  
		public var debug:Boolean;
		public var lastInvoked : Date = new Date();
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
 
		public function ModelLocator()
		{
			if(instance != null) throw new Error("Error: Singletons can only be instantiated via getInstance() method!");
			ModelLocator.instance = this;
		} 
		
	}
}