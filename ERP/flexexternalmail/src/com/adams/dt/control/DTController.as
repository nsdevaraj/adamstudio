package com.adams.dt.control
{	
	import com.adams.dt.command.*;
	import com.adams.dt.command.authentication.AuthenticationCommand;
	import com.adams.dt.command.producerconsumer.ConsumerStatusOnlineCommand;
	import com.adams.dt.command.producerconsumer.ProducerCommand;
	import com.adams.dt.event.*;
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.universalmind.cairngorm.control.FrontController;
	
	public final class DTController extends FrontController
	{
		public function DTController()
		{
			super();
			addCommand(AuthenticationEvent.EVENT_AUTHENTICATION , AuthenticationCommand);
			addCommand(ChannelSetEvent.SET_CHANNEL , InitializeDTCommand);
			
			addCommand(TasksEvent.EVENT_GETMAILTASKID_TASKS,TasksCommand);
			addCommand(PersonsEvent.EVENT_GET_PERSONSID , PersonsCommand);
			addCommand(FileDetailsEvent.EVENT_SELECT_FILEDETAILS , FileDetailsCommand);			
			addCommand(FileDetailsEvent.EVENT_GET_FILEDETAILS , FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_SAVEAS_FILE , FileDetailsCommand);
			addCommand(TasksEvent.EVENT_MAILUPDATE_TASKS,TasksCommand);			
			addCommand(FileDetailsEvent.EVENT_UPLOAD_FILE , FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_MAILCREATE_FILEDETAILS , FileDetailsCommand);				
			addCommand(PersonsEvent.EVENT_GETMSG_SENDER , PersonsCommand);
			addCommand(ProfilesEvent.EVENT_MSGSENDER_PROFILES , ProfilesCommand);
			addCommand(TasksEvent.CREATE_MSG_TASKS,TasksCommand);
			
			addCommand(WorkflowstemplatesEvent.EVENT_GETMSG_WORKFLOWSTEMPLATES,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GETMSG_WORKFLOWSTEMPLATESID,WorkflowTemplatesCommand);
			addCommand(WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS,WorkflowTemplatesCommand);
			
			addCommand(LangEvent.EVENT_GET_ALL_LANGS , InitializeDTCommand);
			addCommand(TranslationEvent.GOOGLE_TRANSLATE , InitializeDTCommand);
			
			/* Impremier properties purpose */
			//today kumar  [Impremier project disply]
			addCommand(TasksEvent.EVENT_GET_TASKS,TasksCommand);
			addCommand(PropertiespresetsEvent.EVENT_GET_ALLPROPERTY,PropertiesPresetsCommand);
			addCommand(TasksEvent.EVENT_CREATE_TASKS,TasksCommand);
			addCommand(TasksEvent.EVENT_UPDATE_TASKS,TasksCommand);
			addCommand(ProfilesEvent.EVENT_GET_ALL_PROFILESS , ProfilesCommand);
			addCommand(FileDetailsEvent.EVENT_SELECT_IMP_FILE , FileDetailsCommand);
			addCommand(TeamlineEvent.EVENT_SELECT_TEAMLINE,TeamlinesCommand);
			addCommand(PersonsEvent.EVENT_GETIMP_PERSONS , PersonsCommand);	
			
			addCommand(PhasesEvent.EVENT_UPDATE_PHASES , PhasesCommand); 
			addCommand(ProjectsEvent.EVENT_UPDATE_PROJECTS , ProjectsCommand);
			addCommand(PropertiespjEvent.EVENT_UPDATE_PROPERTIESPJ , PropertiesPjCommand);
			
			addCommand(PersonsEvent.EVENT_CONSU_STATUSONLINE , ConsumerStatusOnlineCommand);
			
				
			addCommand(TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE , TeamlinesCommand);
			//addCommand(TasksEvent.EVENT_PUSH_CREATE_TASKS , ProducerTaskCreateCommand);
			addCommand(TasksEvent.EVENT_PUSH_CREATE_TASKS , ProducerCommand);
			addCommand(TasksEvent.EVENT_PUSH_CREATE_MESSAGE_TASKS , ProducerCommand);			
			addCommand(TasksEvent.EVENT_PUSH_STATUS_SEND , ProducerCommand);	
			
			addCommand(FileDetailsEvent.EVENT_GET_IMPFILEDETAILS , FileDetailsCommand); // now not use
			addCommand(FileDetailsEvent.EVENT_IMPSAVEAS_FILE , FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_GET_SWFFILEDETAILS, FileDetailsCommand);	
			addCommand(FileDetailsEvent.EVENT_GET_SINGLE_SWFFILE, FileDetailsCommand);				
			addCommand(FileDetailsEvent.EVENT_SELECT_IND_FILE, FileDetailsCommand);	
			
			addCommand(FileDetailsEvent.EVENT_CREATE_FILEDETAILS, FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_CREATE_DB_FILEDETAILS, FileDetailsCommand);
			
			addCommand(FileDetailsEvent.EVENT_SELECT_INDDOWNLOAD_FILE, FileDetailsCommand);
			addCommand(FileDetailsEvent.EVENT_SAVEAS_PDFDOWNLOADFILE, FileDetailsCommand);						
						
			addCommand(TeamlineEvent.EVENT_TASK_STATUS , TeamlinesCommand);
			addCommand(TeamlineEvent.EVENT_PROFILE_PROJECTMESSAGE_TEAMLINE , TeamlinesCommand);
			
			
			
			addCommand(ProjectsEvent.EVENT_GET_PROJECTSID , ProjectsCommand);
			
			/* Email purpose */
			addCommand(TasksEvent.EVENT_GET_EMAILSEARCH_TASKS,TasksCommand);
			
			addCommand(PersonsEvent.EVENT_GET_PERSONS , PersonsCommand);
			addCommand(PersonsEvent.EVENT_GET_ALL_PERSONSS , PersonsCommand);
			
			addCommand(ProjectsEvent.EVENT_GET_PROJECTS , ProjectsCommand);
			addCommand(ProfilesEvent.EVENT_GETPRJ_PROFILES , ProfilesCommand);
			
			//addCommand(CategoriesEvent.EVENT_GET_DOMAIN, CategoriesCommand);
			addCommand(CategoriesEvent.EVENT_GET_ALL_CATEGORIES, CategoriesCommand);
			
			addCommand(TasksEvent.EVENT_UPDATE_TODO_TASKS,TasksCommand);
			
			
			addCommand(PersonsEvent.EVENT_GET_AUTH_PERSONS , PersonsCommand);
			addCommand(TasksEvent.CREATE_PROPERTYMSG_TASKS , TasksCommand);
			addCommand(StatusEvents.EVENT_GET_ALL_STATUS , StatusCommand);
			
			addCommand(PresetTemplateEvent.EVENT_GETALL_PRESETTEMPLATE,PresetTemplateCommand);
			//PhaseTemplates Event 	
			addCommand(PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS , PhaseTemplatesCommand);
			
			addCommand(EventsEvent.EVENT_CREATE_EVENTS , EventsCommand);
			
			addCommand(TeamlineEvent.EVENT_MAILMESSAGE_TEAMLINE , TeamlinesCommand);	
			addCommand(TasksEvent.EVENT_PUSH_MAIL_REPLY_MSG , ProducerCommand);	
			
			addCommand(CompaniesEvent.EVENT_GET_ALL_COMPANIESS , CompaniesCommand);	
			
			/**
			* Pdf Events
			*/
			addCommand(CommentEvent.GET_COMMENT , NotesCommand); 
			addCommand(CommentEvent.ADD_COMMENT , NotesCommand);
			addCommand(CommentEvent.UPDATE_COMMENT , NotesCommand);
			addCommand(CommentEvent.REMOVE_COMMENT , NotesCommand);
			
			/* addCommand(PDFInitEvent.PDF_INIT, NotesCommand);
			addCommand(CommentEvent.ADD_COMMENT , NotesCommand);
			addCommand(CommentEvent.REMOVE_COMMENT , NotesCommand);
			addCommand(CommentEvent.UPDATE_COMMENT , NotesCommand);
			addCommand(CommentEvent.BULK_UPDATE_COMMENT , NotesCommand);
			addCommand(ImgEvent.LOADING_COMPLETED , NotesCommand);
			addCommand(updateSVGDataEvent.UPDATE_SVGDATA,NotesCommand); */			
		}
		
	}
}