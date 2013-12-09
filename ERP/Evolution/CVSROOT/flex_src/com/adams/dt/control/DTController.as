package com.adams.dt.control
{
	import com.adams.dt.command.*;
	import com.adams.dt.command.adminproducerconsumer.ConsumerAdminCommand;
	import com.adams.dt.command.adminproducerconsumer.ProducerAdminCommand;
	import com.adams.dt.command.authentication.*;
	import com.adams.dt.command.filedetails.*;
	import com.adams.dt.command.producerconsumer.*;
	import com.adams.dt.event.*;
	import com.adams.dt.event.PDFTool.*;
	import com.adams.dt.event.chartpeople.ChartDataEvent;
	import com.adams.dt.event.chatevent.ChatDBEvent;
	import com.adams.dt.event.loginevent.LogOutEvent;
	import com.adams.dt.event.scheduler.CurrentProjectEvent;
	import com.universalmind.cairngorm.control.FrontController;
	
	public final class DTController extends FrontController
	{
		public function DTController()
		{
			super();
			
			addCommand(SMTPEmailEvent.EVENT_CREATE_SMTPEMAIL , SMTPEmailCommand);
			
			//Chat
			addCommand(PersonsEvent.EVENT_CHAT_CONSUMER , ConsumerChatCommand);
			addCommand(PersonsEvent.EVENT_CHAT_PRODUCER , ProducerChatCommand);
			addCommand(ChatDBEvent.EVENT_GET_CHAT , ChartPeopleCommand);

			//refresh event
			addCommand(RefreshEvent.REFRESH,RefreshCommand)
			addCommand(PropertiespjEvent.EVENT_AUTO_UPDATE_PROPERTIESPJ,PropertiesPjCommand);
			addCommand(ProjectsEvent.CREATE_AUTO_PROJECTS,ProjectsCommand)
			addCommand(TasksEvent.CREATE_AUTO_TASKS,TasksCommand)
			addCommand(TasksEvent.UPDATE_AUTO_TASKS,TasksCommand)
			addCommand(TasksEvent.CREATE_AUTO_INITIAL_TASKS,TasksCommand)

			addCommand(ColumnsEvent.EVENT_GET_ALL_COLUMNS,ColumnsCommand)
			//Authentication
			addCommand(AuthenticationEvent.EVENT_AUTHENTICATION , AuthenticationCommand);
			addCommand(PersonsEvent.EVENT_PUSH_STATUSONLINE , ProducerStatusOnlineCommand);
			addCommand(PersonsEvent.EVENT_CONSU_STATUSONLINE , ConsumerStatusOnlineCommand);							
			addCommand(TasksEvent.EVENT_PUSH_GET_TASKS , ConsumerGetTaskCommand);
			addCommand(TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE , TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_DELETEALL , TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_CURRENT_PROJECT_TEAMLINE , TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_PUSH_PROJECT_TEAMLINE , TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_PUSH_NEWPROJECT, TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_PROJECT_TEAMLINE , TeamlinesCommand);					
			addCommand(TeamlineEvent.EVENT_GET_TEAMLINE , TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_CREATE_TEAMLINE_SELECTION,TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_DELETE_TEAMLINE_SELECTION , TeamlinesCommand);
			
			//sendMessage
			addCommand(ProjectMessageEvent.EVENT_SEND_MESSAGETOALL , ProjectMessageCommand);
			
			addCommand(TeamlineEvent.EVENT_PROJECT_ABORTED_TEAMLINE , TeamlinesCommand);	
			
			addCommand(TasksEvent.EVENT_PUSH_INITIAL_TASKS , ProducerCommand); 	  			//ProducerTaskDelegate
			addCommand(TasksEvent.EVENT_PUSH_CREATE_TASKS , ProducerCommand);     	//ProducerTaskDelegate
			addCommand( TasksEvent.EVENT_PUSH_OPERATOR_MSG, ProducerCommand ); 		//ProducerTaskDelegate
			addCommand(TasksEvent.EVENT_PUSH_SEND_STATUSUPDATEPROJECT , ProducerCommand);   //ProducerTaskDelegate
			addCommand(TasksEvent.EVENT_DELAY_PROJECT , ProducerCommand);   				//ProducerTaskDelegate
			addCommand(TasksEvent.EVENT_GETPROJECT_CLOSE , ProducerCommand);                //ProducerTaskDelegate
			addCommand(TasksEvent.EVENT_GETABORTEDPROJECT_CLOSE , ProducerCommand);         //ProducerTaskDelegate
			
			addCommand(TasksEvent.EVENT_MAILPUSH , ProducerCommand);
			addCommand(TasksEvent.PUSH_ALL_PROJECT_PRESETTEMP , ProducerCommand); 
			addCommand(TasksEvent.EVENT_FINISHED_TASK , ProducerCommand); 	
					
			addCommand(TasksEvent.EVENT_PUSH_PROJECTNOTES , ProducerCommand); 	
								
			addCommand(PresetTemplateEvent.EVENT_GET_PRESET_TEMPLATEID,PresetTemplateCommand);
			addCommand(PresetTemplateEvent.EVENT_GETALL_PRESETTEMPLATE,PresetTemplateCommand);
			
			
			//addCommand(TasksEvent.EVENT_PUSH_INITIAL_TASKS , ProducerInitialTaskCommand); //old
			//addCommand(TasksEvent.EVENT_PUSH_CREATE_TASKS , ProducerTaskCreateCommand);   //old
			//addCommand(TasksEvent.EVENT_PUSH_SEND_STATUSUPDATEPROJECT , ProducerStatusUpdateCommand); //old
			//addCommand(TasksEvent.EVENT_DELAY_PROJECT ,ProducerProjectDelayCommand);  //old
			//addCommand(TeamlineEvent.EVENT_GETPROJECT_CLOSE , ProducerProjectCloseCommand);  //old
			//addCommand(TeamlineEvent.EVENT_GETABORTEDPROJECT_CLOSE , ProducerAbortedCloseCommand);
						
			addCommand(ProjectsEvent.EVENT_PUSH_SELECT_PROJECTS , ProjectsCommand);
			addCommand(ProjectsEvent.EVENT_CLOSE_PRJ_TASKCOMPLETE, ProjectsCommand);
			addCommand(TeamlineEvent.EVENT_CLOSE_PROJECT_TEAMLINE , TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_FINISHED_TASK_TEAMLINE , TeamlinesCommand);
			
			addCommand(ProjectsEvent.EVENT_STATUSUPDATE_PROJECTS , ProjectsCommand);
			addCommand(TeamlineEvent.EVENT_PUSH_PROJECTSTATUS_TEAMLINE , TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_PUSH_DELAYSTATUS_TEAMLINE , TeamlinesCommand);
			addCommand( TeamlineEvent.EVENT_PUSH_DELAYEDTASKSTATUS_TEAMLINE, TeamlinesCommand );			
			addCommand(ProjectsEvent.EVENT_PUSH_GET_PROJECTSID , ProjectsCommand);
			
			//AdminControl			
			addCommand(PersonsEvent.EVENT_CONSU_ADMIN , ConsumerAdminCommand);	
			addCommand(PersonsEvent.EVENT_PRODU_ADMIN , ProducerAdminCommand);
			
			//addCommand(PersonsEvent.EVENT_PRODUCER,  ChatProducerCommand);
			addCommand( PersonsEvent.EVENT_PERSON_LOGOUT, ProducerLogout );	
			
			/**
			 * IND Profile & person select
			 * IND Teamline Event
			 **/
			//IND Profile & person select			
			//addCommand(TeamlineEvent.EVENT_SELECT_TEAMLINE_IND,TeamlinesCommand);
					
			/**			
			 * IND Person Event
			 * IND personid pass
			 **/
			addCommand(PersonsEvent.EVENT_GETIND_PERSONS , PersonsCommand);				
			
								
			//Persons		
			addCommand(PersonsEvent.EVENT_UPDATE_ONLINE_PERSONS , PersonsCommand);
			addCommand(PersonsEvent.EVENT_GET_ONLINE_PERSONS , PersonsCommand);
			addCommand(PersonsEvent.EVENT_UPDATE_STRATUS_PERSONS , PersonsCommand);
			addCommand(PersonsEvent.EVENT_CREATE_SINGLE_PERSONS,PersonsCommand);
			//Categories Event
 			addCommand(CategoriesEvent.EVENT_CREATE_CATEGORIES,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_DELETE_CATEGORIES,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_GET_ALL_CATEGORIESS,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_GET_CATEGORIES,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_SELECT_CATEGORIES,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_UPDATE_CATEGORIES,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_GET_DOMAIN,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CHECK_CATEGORIES,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATE_CATEGORIES1,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATE_CATEGORIES2,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CHECK_CATEGORIES2,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATE_CATEGORIES1FOLDER,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATE_CATEGORIES2FOLDER,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATE_PROJECTFOLDER, CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATE_CATEGORIESFOLDER, CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATE_BASICFOLDER, CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATE_TASKSFOLDER, CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATE_DOMAIN,CategoriesCommand);
 			addCommand(CategoriesEvent.EVENT_CREATENEW_DOMAIN,CategoriesCommand);
 			
			//Companies Event
			addCommand(CompaniesEvent.EVENT_CREATE_COMPANIES , CompaniesCommand);
			addCommand(CompaniesEvent.EVENT_CREATE_COMPANIES_SEQ, CompaniesCommand);
			addCommand(CompaniesEvent.EVENT_DELETE_COMPANIES , CompaniesCommand);
			addCommand(CompaniesEvent.EVENT_GET_ALL_COMPANIESS , CompaniesCommand);
			addCommand(CompaniesEvent.EVENT_GET_COMPANIES , CompaniesCommand);
			addCommand(CompaniesEvent.EVENT_SELECT_COMPANIES , CompaniesCommand);
			addCommand(CompaniesEvent.EVENT_UPDATE_COMPANIES , CompaniesCommand);
			//Events Event
			addCommand(EventsEvent.EVENT_CREATE_EVENTS , EventsCommand);
			addCommand(EventsEvent.EVENT_DELETEALL_EVENTS , EventsCommand);
			addCommand(EventsEvent.EVENT_DELETE_EVENTS , EventsCommand);
			addCommand(EventsEvent.EVENT_GET_ALL_EVENTSS , EventsCommand);
			addCommand(EventsEvent.EVENT_GET_EVENTS , EventsCommand);
			addCommand(EventsEvent.EVENT_SELECT_EVENTS , EventsCommand);
			addCommand(EventsEvent.EVENT_UPDATE_EVENTS , EventsCommand);
			addCommand(EventsEvent.EVENT_GETCURRENTPROJECT_EVENTS , EventsCommand);
			addCommand(EventsEvent.EVENT_GETCURRENTPROJECT_PROPERTY , EventsCommand);			
			
			//Persons Event
			addCommand(PersonsEvent.EVENT_CREATE_PERSONS , PersonsCommand);
			addCommand(PersonsEvent.EVENT_DELETE_PERSONS , PersonsCommand);
			addCommand(PersonsEvent.EVENT_GET_PERSONS , PersonsCommand);
			addCommand( PersonsEvent.EVENT_GET_ALL_PERSONS, PersonsCommand );
			addCommand(PersonsEvent.EVENT_UPDATE_PERSONS , PersonsCommand);
			addCommand(PersonsEvent.EVENT_GETPRJ_PERSONS , PersonsCommand);
			addCommand(PersonsEvent.EVENT_GETMSG_SENDER , PersonsCommand);
			addCommand(PersonsEvent.EVENT_BULK_DELETE_PERSONS , PersonsCommand);
			addCommand(PersonsEvent.EVENT_BULK_UPDATE_PERSONS , PersonsCommand);
			addCommand( PersonsEvent.EVENT_UPDATE_ALL_PERSONS, PersonsCommand );
			//Groups Event
			addCommand(GroupsEvent.EVENT_CREATE_GROUPS , GroupsCommand);
			addCommand(GroupsEvent.EVENT_DELETE_GROUPS , GroupsCommand);
			addCommand(GroupsEvent.EVENT_GET_ALL_GROUPSS , GroupsCommand);
			addCommand(GroupsEvent.EVENT_GET_GROUPS , GroupsCommand);
			addCommand(GroupsEvent.EVENT_SELECT_GROUPS , GroupsCommand);
			addCommand(GroupsEvent.EVENT_UPDATE_GROUPS , GroupsCommand);
			//Phases Event 			
			addCommand(PhasesEvent.EVENT_CREATE_PHASES , PhasesCommand);
			addCommand(PhasesEvent.EVENT_DELETEALL_PHASES , PhasesCommand);
			addCommand(PhasesEvent.EVENT_DELETE_PHASES , PhasesCommand);
			addCommand(PhasesEvent.EVENT_GET_ALL_PHASESS , PhasesCommand);
			addCommand(PhasesEvent.EVENT_GET_PHASES , PhasesCommand);
			addCommand(PhasesEvent.EVENT_SELECT_PHASES , PhasesCommand);
			addCommand(PhasesEvent.EVENT_UPDATE_PHASES , PhasesCommand);
			addCommand(PhasesEvent.EVENT_AUTO_UPDATE_PHASES, PhasesCommand);
			addCommand(PhasesEvent.EVENT_BULK_UPDATE_PHASES , PhasesCommand);
			addCommand(PhasesEvent.EVENT_CREATE_BULK_PHASES , PhasesCommand);
			addCommand(PhasesEvent.EVENT_UPDATE_LASTPHASE , PhasesCommand);
			
			//PhaseTemplates Event 			
			addCommand(PhasestemplatesEvent.EVENT_CREATE_PHASESTEMPLATES , PhaseTemplatesCommand);
			addCommand(PhasestemplatesEvent.EVENT_DELETE_PHASESTEMPLATES , PhaseTemplatesCommand);
			addCommand(PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS , PhaseTemplatesCommand);
			addCommand(PhasestemplatesEvent.EVENT_GET_PHASESTEMPLATES , PhaseTemplatesCommand);
			addCommand(PhasestemplatesEvent.EVENT_SELECT_PHASESTEMPLATES , PhaseTemplatesCommand);
			addCommand(PhasestemplatesEvent.EVENT_UPDATE_PHASESTEMPLATES , PhaseTemplatesCommand);
			//Profiles Event 			
			addCommand(ProfilesEvent.EVENT_CREATE_PROFILES , ProfilesCommand);
			addCommand(ProfilesEvent.EVENT_DELETE_PROFILES , ProfilesCommand);
			addCommand(ProfilesEvent.EVENT_GET_ALL_PROFILESS , ProfilesCommand);
			addCommand(ProfilesEvent.EVENT_GET_PROFILES , ProfilesCommand);
			addCommand(ProfilesEvent.EVENT_SELECT_PROFILES , ProfilesCommand);
			addCommand(ProfilesEvent.EVENT_UPDATE_PROFILES , ProfilesCommand);
			addCommand(ProfilesEvent.EVENT_GETPRJ_PROFILES , ProfilesCommand);
			addCommand(ProfilesEvent.EVENT_MSGSENDER_PROFILES , ProfilesCommand);
			//Projects Event 			
			addCommand(ProjectsEvent.EVENT_CREATE_PROJECTS , ProjectsCommand);
			addCommand(ProjectsEvent.EVENT_DELETE_PROJECTS , ProjectsCommand);
			addCommand(ProjectsEvent.EVENT_GET_PROJECTS , ProjectsCommand);
			
			addCommand(ProjectsEvent.EVENT_SELECT_PROJECTS , ProjectsCommand);
			addCommand(ProjectsEvent.EVENT_UPDATE_PROJECTS , ProjectsCommand);
			addCommand(ProjectsEvent.EVENT_DELETEALL_PROJECTS , ProjectsCommand);
			addCommand(ProjectsEvent.EVENT_UPDATE_PROJECTNOTES , ProjectsCommand);
			addCommand(ProjectsEvent.EVENT_UPDATE_PROJECTNAME , ProjectsCommand);
			
			
			//PropertiesPj Event 			
			addCommand(PropertiespjEvent.EVENT_CREATE_PROPERTIESPJ , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_DELETEALL_PROPERTIESPJ , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_DELETE_PROPERTIESPJ , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_GET_ALL_PROPERTIESPJS , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_GET_PROPERTIESPJ , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_SELECT_PROPERTIESPJ , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_BULKUPDATE_PROPERTIESPJ , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_BULKUPDATE_DEPORTPROPERTIESPJ , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_DEFAULTVALUE_UPDATE_PROPERTIESPJ , PropertiesPjCommand);
			addCommand(PropertiespjEvent.EVENT_GET_PROPERTIESPJ_BY_PROJECT , PropertiesPjCommand);
			
			
			//PropertiesPresets Event 			
			addCommand(PropertiespresetsEvent.EVENT_CREATE_PROPERTIESPRESETS , PropertiesPresetsCommand);
			addCommand(PropertiespresetsEvent.EVENT_DELETE_PROPERTIESPRESETS , PropertiesPresetsCommand);
			addCommand(PropertiespresetsEvent.EVENT_SELECT_PROPERTIESPRESETS , PropertiesPresetsCommand);
			addCommand(PropertiespresetsEvent.EVENT_UPDATE_PROPERTIESPRESETS , PropertiesPresetsCommand);
			addCommand(PropertiespresetsEvent.EVENT_GET_ALLPROPERTY , PropertiesPresetsCommand);
			//Status Event 			
			addCommand(StatusEvents.EVENT_CREATE_STATUS , StatusCommand);
			addCommand(StatusEvents.EVENT_DELETE_STATUS , StatusCommand);
			addCommand(StatusEvents.EVENT_GET_ALL_STATUS , StatusCommand);
			addCommand(StatusEvents.EVENT_GET_STATUS , StatusCommand);
			addCommand(StatusEvents.EVENT_SELECT_STATUS , StatusCommand);
			addCommand(StatusEvents.EVENT_UPDATE_STATUS , StatusCommand);
			//Tasks Event 			
			addCommand(TasksEvent.EVENT_CREATE_TASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_DELETE_TASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_DELETEALL_TASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_GET_ALL_TASKSS , TasksCommand);
			addCommand(TasksEvent.EVENT_GET_TASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_SELECT_TASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_UPDATE_TASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_UPDATE_TASKS_STATUS , TasksCommand);
			addCommand(TasksEvent.EVENT_FETCH_TASKS , TasksCommand);
			addCommand(TasksEvent.CREATE_MSG_TASKS , TasksCommand);
			addCommand(TasksEvent.CREATE_BULK_TASKS , TasksCommand);
			addCommand(TasksEvent.CREATE_INITIAL_TASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_UPDATE_MSG_TASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_GET_TASK , TasksCommand);
			addCommand(TasksEvent.EVENT_UPDATE_TASKFILEPATH , TasksCommand);
			addCommand(TasksEvent.CREATE_MAX_TASKSID , TasksCommand);
			addCommand(TasksEvent.EVENT_UPDATE_CLOSETASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_BULKUPDATE_CLOSETASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_BULKUPDATE_DELAYEDTASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_BULKUPDATE_TASKSSTATUS , TasksCommand);
			addCommand(TasksEvent.EVENT_BULKUPDATE_CLOSEPROJECTTASKS , TasksCommand);
			addCommand(TasksEvent.CREATE_PROPERTYMSG_TASKS , TasksCommand);
			addCommand( TasksEvent.CREATE_MSG_TO_OPE_TASKS, TasksCommand );
			addCommand(TasksEvent.CREATE_NWEMSG_TASKS , TasksCommand);
			addCommand(TasksEvent.CREATE_STANDBY_TASKS , TasksCommand);
			addCommand(TasksEvent.UPDATE_LAST_TASKS , TasksCommand);
			addCommand(TasksEvent.EVENT_STATUSCHANGE_TASK , TasksCommand);
			
			addCommand(TasksEvent.CREATE_IMP_IND_MSG_TASKS , TasksCommand);	
			addCommand(TasksEvent.EVENT_UPDATE_PDFREAD_ARCHIVE , TasksCommand);	
			addCommand(TasksEvent.EVENT_TODO_LASTTASKSCOMMENTS , TasksCommand);	
			
			addCommand(TasksEvent.CREATE_COMMON_PROFILE_MSGTASKS , TasksCommand);
			addCommand( TasksEvent.EVENT_GET_SPECIFIC_TASK, TasksCommand );
			addCommand( TasksEvent.EVENT_CREATE_BULKEMAILTASKS, TasksCommand );

			//TeamTemplates Event 			
			addCommand(TeamTemplatesEvent.EVENT_CREATE_TEAMTEMPLATES , TeamTemplatesCommand);
			addCommand(TeamTemplatesEvent.EVENT_DELETE_TEAMTEMPLATES , TeamTemplatesCommand);
			addCommand(TeamTemplatesEvent.EVENT_GET_ALL_TEAMTEMPLATESS , TeamTemplatesCommand);
			addCommand(TeamTemplatesEvent.EVENT_GET_TEAMTEMPLATES , TeamTemplatesCommand);
			addCommand(TeamTemplatesEvent.EVENT_SELECT_TEAMTEMPLATES , TeamTemplatesCommand);
			addCommand(TeamTemplatesEvent.EVENT_UPDATE_TEAMTEMPLATES , TeamTemplatesCommand);
			//Workflows Event 			
			addCommand(WorkflowsEvent.EVENT_CREATE_WORKFLOWS , WorkFlowsCommand);
			addCommand(WorkflowsEvent.EVENT_DELETE_WORKFLOWS , WorkFlowsCommand);
			addCommand(WorkflowsEvent.EVENT_GET_ALL_WORKFLOWSS , WorkFlowsCommand);
			addCommand(WorkflowsEvent.EVENT_GET_WORKFLOWS , WorkFlowsCommand);
			addCommand(WorkflowsEvent.EVENT_GET_WORKFLOW , WorkFlowsCommand);
			addCommand(WorkflowsEvent.EVENT_SELECT_WORKFLOWS , WorkFlowsCommand);
			addCommand(WorkflowsEvent.EVENT_UPDATE_WORKFLOWS , WorkFlowsCommand);
			addCommand(WorkflowsEvent.EVENT_TEAMLINETEMPLATE ,WorkFlowsCommand);
			//WorkflowTemplates Event 			
		 	addCommand(WorkflowstemplatesEvent.EVENT_CREATE_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_DELETE_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GET_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_SELECT_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_UPDATE_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GETMSG_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GETBYSTOPLABEl_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GETFILEACCESS_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GETFIRSTRELEASE_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GETOTHERRELEASE_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GET_ANNULATION_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GET_CLOSE_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);					
			
            // Domain Event
            addCommand(DomainWorkFlowEvent.EVENT_CREATE_DOMAIN_WORKLFLOW,InitializeDTCommand);
            addCommand(DomainWorkFlowEvent.BULK_UPDATE_DOMAIN_WORKLFLOW,InitializeDTCommand);
            addCommand(DomainWorkFlowEvent.EVENT_GET_ALL_DOMAIN_WORKLFLOW,InitializeDTCommand);
            
           
			//Screen Open Events
			/**
			* new Order Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_ORDERSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_ORDERSCREENWITHCORRECTION , ToDoListScreenCommand);
			/**
			* Order Reception Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_ORDERRECEPTIONSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_ORDERRECEPTIONSCREENCORRECTION , ToDoListScreenCommand);
			/**
			* Technical preparations Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_TECHNICALPREPARATIONSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_TECHNICALPREPARATIONSCREENCORRECTION , ToDoListScreenCommand);
			/**
			* Process validation Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_PROCESSVALIDATIONSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_PROCESSVALIDATIONSCREENCORRECTION , ToDoListScreenCommand);
			/**
			* preparation technique Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_PREPARATIONTECHNIQUESCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_PREPARATIONTECHNIQUESCREENCORRECTION , ToDoListScreenCommand);
			/**
			* realisation Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONSCREENCORRECTION , ToDoListScreenCommand);
			/**
			* control Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_CONTOLSCREEN , ToDoListScreenCommand);
			/**
			* relecture Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_RELECTURESCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_RELECTURESCREENCORRECTION , ToDoListScreenCommand);
			/**
			* lancement correction Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_LANCEMENTCORRECTIONSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_LANCEMENTCORRECTIONSCREENCORRECTION , ToDoListScreenCommand);
			/**
			* realisation correction Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONCORRECTIONSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONCORRECTIONINCOMPLETESCREEN , ToDoListScreenCommand);
			/**
			* Control correction Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_CONTROLCORRECTIONSCREEN , ToDoListScreenCommand );
			/**
			* Relecture correction Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_RELECTURECORRECTIONSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_RELECTURECORRECTIONINCOMPLETESCREEN , ToDoListScreenCommand);
			/**
			* Lancenment Livraison Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_LANCEMENTLIVRAISONSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_LANCEMENTLIVRAISONSCREENCORRECTION , ToDoListScreenCommand);
			
			/**
			* Depart Livraison Events
			*/
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_DEPARTLIVRAISONSCREEN , ToDoListScreenCommand);
			/**
			* Close Project Events
			*/	
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_CLOSEPROJECTSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_VIEWMESSAGSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_VIEWCLOSESCREEN, ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_STANDBYSCREEN, ToDoListScreenCommand);
			/**
			* IND PDFReader View screen Events
			*/ 
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_VIEWINDPDFSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_VIEWINDPDFSCREENB , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_VIEWFABPDFSCREEN , ToDoListScreenCommand);
			addCommand(OpenToDoListScreenEvent.EVENT_OPEN_VIEWFABPDFSCREENB , ToDoListScreenCommand);
		 
			/**
			* Pdf Events
			*/
			addCommand(PDFInitEvent.PDF_INIT, NotesCommand);
			addCommand(CommentEvent.ADD_COMMENT , NotesCommand);
			addCommand(CommentEvent.DELETEALL_COMMENT , NotesCommand);
			addCommand(CommentEvent.REMOVE_COMMENT , NotesCommand);
			addCommand(CommentEvent.UPDATE_COMMENT , NotesCommand);

			addCommand(CommentEvent.GET_COMMENT , NotesCommand); 
			addCommand(updateSVGDataEvent.UPDATE_SVGDATA,NotesCommand);
			//ChannelSet
			addCommand(ChannelSetEvent.SET_CHANNEL , InitializeDTCommand);
			addCommand(ReportEvent.EVENT_ORDER_COLUMNS , InitializeDTCommand);
			addCommand(ReportEvent.EVENT_UPDATE_COLUMNS , InitializeDTCommand);
			
			//LogOut
			addCommand(LangEvent.EVENT_GET_ALL_LANGS , InitializeDTCommand);
			addCommand(TranslationEvent.GOOGLE_TRANSLATE , InitializeDTCommand);
			addCommand(LogOutEvent.EVENT_LOGOUT , InitializeDTCommand);
			//Scheduler Events
			addCommand( CurrentProjectEvent.GOTO_CURRENTPROJECT , InitializeDTCommand );
			//chart events 
			addCommand(ChartDataEvent.EVENT_CHART_MESSAGE , ChartPeopleCommand );
			addCommand(ChartDataEvent.EVENT_GETPROFILE_MESSAGE , ChartPeopleCommand  );  
			addCommand(ChatDBEvent.EVENT_CREATE_CHAT , ChartPeopleCommand);
			addCommand(ChatDBEvent.EVENT_BULK_UPDATE_CHAT, ChartPeopleCommand);
			addCommand(ChatDBEvent.EVENT_DELETEALL_CHAT , ChartPeopleCommand);
			addCommand(ChatDBEvent.EVENT_GET_ALL_CHATS , ChartPeopleCommand);
			
			//teamLineTemplate
			addCommand(TeamlineTemplatesEvent.EVENT_GET_TEAMLINETEMPLATES , TeamlineTemplatesCommand);
			addCommand(TeamlineEvent.EVENT_UPDATE_TEAMLINE , TeamlinesCommand);
			addCommand(TeamlineTemplatesEvent.EVENT_BULK_UPDATE_TEAMLINETEMPLATES,TeamlineTemplatesCommand);
			addCommand(TeamlineTemplatesEvent.EVENT_CREATE_TEAMLINETEMPLATES,TeamlineTemplatesCommand);
			addCommand(TeamlineTemplatesEvent.EVENT_DELETE_ALL_TEAMLINETEMPLATES,TeamlineTemplatesCommand);
			//file details
			addCommand(FileDetailsEvent.EVENT_CREATE_FILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_DELETEALL_FILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GET_BASICFILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GET_TASKFILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_BGUPLOAD_FILE ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_BGDOWNLOAD_FILE ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_UPDATE_FILEDETAILS , FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_UPDATE_DETAILS , FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GET_SWFFILEDETAILS , FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GET_INDFILEDETAILS, FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_SELECT_FILEDETAILS , FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GET_MESSAGEFILEDETAILS ,FileDetailsCommand); //Messagedownload
			addCommand(FileDetailsEvent.EVENT_GET_MESSAGE_BASICFILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_CREATE_MSG_DUPLI_FILE ,FileDetailsCommand);  
			addCommand(FileDetailsEvent.EVENT_CREATE_SWFFILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GET_FILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GET_REFFILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_DUPLICATE_FILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GETPROJECT_FILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_CREATE_REF_FILEDETAILS ,FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GET_FILEDETAILSBYID ,FileDetailsCommand);
			

			addCommand(LocalDataBaseEvent.EVENT_CREATE_FILEDETAILS ,CreateLocalFileDetailsCommand);
			addCommand(LocalDataBaseEvent.EVENT_GET_FILEDETAILS ,SearchLocalFileDetailsCommand);
			
			addCommand(TeamlineEvent.EVENT_SELECT_TEAMLINE,TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_CREATE_TEAMLINE,TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_DELETE_TEAMLINE,TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_DELETE_TEAMLINE_UNSELECTPERSON,TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_GET_IMP_TEAMLINE,TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_UPDATE_IMPTEAMLINE,TeamlinesCommand);
			
						
			addCommand(PagingEvent.EVENT_GET_SQL_QUERY,PagingCommand);
			addCommand(PagingEvent.EVENT_GET_PROJECT_COUNT,PagingCommand);
			addCommand(PagingEvent.EVENT_GET_PROJECT_PAGED,PagingCommand);
			// 
			addCommand(GroupPersonsEvent.EVENT_BULKUPDATE_GROUPPERSONS , GroupPersonsCommand);
			addCommand(GroupPersonsEvent.EVENT_CREATE_GROUPPERSONS , GroupPersonsCommand);
			
			addCommand(PhasestemplatesEvent.EVENT_GETWORKFLOW_PHASESTEMPLATES , PhaseTemplatesCommand);
			addCommand(PhasestemplatesEvent.EVENT_BULKUPDATE_PHASESTEMPLATES, PhaseTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_BULK_UPDATE_WORKFLOWSTEMPLATES, WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GET_WF_WORKFLOWSTEMPLATES, WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GETBYWFID_WORKFLOWSTEMPLATES, WorkflowTemplatesCommand);
			addCommand(PropertiespresetsEvent.EVENT_BULK_UPDATE_PROPERTIESPRESETS, PropertiesPresetsCommand);
			addCommand(TeamlineTemplatesEvent.EVENT_GETWF_TEAMLINETEMPLATES, TeamlineTemplatesCommand);
			addCommand(ModuleEvent.EVENT_GET_ALL_MODULES, InitializeDTCommand);
			
			addCommand(ReportEvent.EVENT_GET_ALL_REPORTS, InitializeDTCommand);
			addCommand(ReportEvent.EVENT_GET_PROFILE_REPORTS, InitializeDTCommand);
			addCommand( ReportEvent.EVENT_GET_REFERENCE_REPORTS, InitializeDTCommand );
			addCommand( ReportEvent.EVENT_CREATE_REPORTS, InitializeDTCommand );
			addCommand( ReportEvent.EVENT_UPDATE_REPORTS, InitializeDTCommand );
			addCommand( ReportEvent.EVENT_DELETE_REPORTS, InitializeDTCommand );
			
			addCommand(ImpremiurEvent.EVENT_GET_ALL_IMPREMIUR,ImpremiurCommand);
			addCommand(ImpremiurEvent.EVENT_COPY_WF_IMPREMIUR,ImpremiurCommand);
			addCommand(ImpremiurEvent.EVENT_BULKUPDATE_IMPREMIUR,ImpremiurCommand);
			addCommand(ImpremiurEvent.EVENT_CREATE_IMPREMIUR,ImpremiurCommand);
			addCommand(PropPresetTemplateEvent.EVENT_GET_PROPPRESET_TEMPLATE,PropPresetTemplateCommand);
			addCommand(PresetTemplateEvent.EVENT_CREATE_PRESET_TEMPLATE,PresetTemplateCommand);
			addCommand(PresetTemplateEvent.EVENT_UPDATE_PRESET_TEMPLATE,PresetTemplateCommand);
			addCommand(PropPresetTemplateEvent.EVENT_DELETE_PROPPRESET_TEMPLATE,PropPresetTemplateCommand);
			addCommand(PropPresetTemplateEvent.EVENT_BULK_UPDATE_PROPPRESET_TEMPLATE,PropPresetTemplateCommand);
			addCommand(PropPresetTemplateEvent.EVENT_DELETE_PROPPRESET_TEMPLATE_BYID , PropPresetTemplateCommand );
			addCommand(PropPresetTemplateEvent.EVENT_CREATE_PROPPRESET_TEMPLATE , PropPresetTemplateCommand );
			addCommand(PropPresetTemplateEvent.EVENT_UPDATE_PROPPRESET_TEMPLATE , PropPresetTemplateCommand );
			addCommand(FileDetailsEvent.EVENT_CONVERT_FILE, InitializeDTCommand );
			addCommand(ProjectsEvent.EVENT_MOVE_DIRECTORY,ProjectsCommand);
			
			
			addCommand(DefaultTemplateEvent.EVENT_CREATE_DEFAULT_TEMPLATE , DefaultTemplateCommand);
			addCommand(DefaultTemplateEvent.BULK_UPDATE_DEFAULT_TEMPLATE , DefaultTemplateCommand);
			addCommand(DefaultTemplateEvent.EVENT_GET_ALL_DEFAULT_TEMPLATE , DefaultTemplateCommand);
			addCommand(DefaultTemplateEvent.UPDATE_DEFAULT_TEMPLATE , DefaultTemplateCommand);
			addCommand(DefaultTemplateEvent.GET_DEFAULT_TEMPLATE , DefaultTemplateCommand);
			addCommand(DefaultTemplateEvent.GET_COMMON_DEFAULT_TEMPLATE , DefaultTemplateCommand);
			
			addCommand(DefaultTemplateValueEvent.EVENT_CREATE_DEFAULT_TEMPLATE_VALUE , DefaultTemplateValueCommand);
			addCommand(DefaultTemplateValueEvent.BULK_UPDATE_DEFAULT_TEMPLATE_VALUE , DefaultTemplateValueCommand);
			addCommand(DefaultTemplateValueEvent.EVENT_GET_ALL_DEFAULT_TEMPLATE_VALUE , DefaultTemplateValueCommand);
			addCommand(DefaultTemplateValueEvent.UPDATE_DEFAULT_TEMPLATE_VALUE , DefaultTemplateValueCommand);
			addCommand(DefaultTemplateValueEvent.GET_DEFAULT_TEMPLATE_VALUE , DefaultTemplateValueCommand);
			addCommand(DefaultTemplateValueEvent.DELETE_DEFAULT_TEMPLATE_VALUE , DefaultTemplateValueCommand);
			
			addCommand(PersonsEvent.EVENT_LOGIN_RESULT, PersonsCommand);
			addCommand(PropertiespresetsEvent.EVENT_GET_CONTAINERLOGIN , PropertiesPresetsCommand);
			addCommand(ProjectsEvent.EVENT_ORACLE_NEWPROJECTCALL,ProjectsCommand);
			addCommand(ProjectsEvent.EVENT_UPDATE_PROJECT_PROPPJS , ProjectsCommand);
			addCommand(PropertiespjEvent.EVENT_ORACLE_BULKUPDATE_PROPERTIESPJ , PropertiesPjCommand);			
			addCommand(TasksEvent.EVENT_ORACLE_NAV_CREATETASKS , TasksCommand);
			addCommand(TeamlineEvent.EVENT_ORACLE_UPDATE_TEAMLINE , TeamlinesCommand);
			addCommand(DefaultTemplateEvent.EVENT_ORACLE_CREATE_DEFAULT_TEMPLATE , DefaultTemplateCommand);
			addCommand(DefaultTemplateValueEvent.QUERY_DELETE_DEFAULT_TEMPLATE_VALUE , DefaultTemplateValueCommand);
			addCommand(ProjectsEvent.EVENT_ORACLE_CLOSEPROJECT,ProjectsCommand);
			addCommand(TeamlineTemplatesEvent.EVENT_SELECT_TEAMLINETEMPLATES , TeamlineTemplatesCommand);
			addCommand(TeamlineEvent.EVENT_ORACLE_REFPROJECT_TEAMLINE , TeamlinesCommand);
			
		}
	}
}