package com.adams.dt.business
{
	import com.adams.dt.business.chat.ChatDAODelegate;
	import com.adams.dt.business.login.LogoutDAODelegate;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
    /**
     * A Singleton responsible for storing references to all Business Delegates. 
     * This allows for these delegates to be injected into the application using an IoC framework.
     *  
     * <a href="http://www.allenmanning.com/?p=25">See Allan Manning's post on the DelegateLocator</a>
     */
    public class DelegateLocator
    {
    	/**
		 * Reference to self used for singleton access.
		 */
		private static var instance:DelegateLocator;
		
		/**
		 * Constructor.
		 * 
		 * <p>As a singleton, only one instance of the DelegateLocator can be created.</p>
		 */
		public function DelegateLocator()
		{
			if(instance != null)
			{
				throw new CairngormError(CairngormMessageCodes.SINGLETON_EXCEPTION, "DelegateLocator");
			}
			else
			{
				instance = this;
			}
		}
		
		/**
		 * Singleton access method to an instance of DelegateLocator.
		 * Ensures only one instance of the ModelLocator is created.
		 * 
		 * @returns The singleton DelegateLocator.
		 */
		public static function getInstance():DelegateLocator
		{
			if(instance == null)
			{
				instance = new DelegateLocator();
			}
			
			return instance;
		}
		
		/**
		 * Reference to the delegate. Provides an interface 
		 * to get the injected delegate at run-time.
		 */
		public var authenticationDelegate:IDAODelegate = new AuthenticationDelegate();
		public var categoryDelegate:IDAODelegate = new CategoriesDAODelegate();
		public var domainWorkflowDelegate:IDAODelegate = new DomainWorkflowsDAODelegate();
		public var personDelegate:IDAODelegate = new PersonsDAODelegate();
		public var projectDelegate:IDAODelegate = new ProjectsDAODelegate();
		public var chatDelegate:IDAODelegate = new ChatDAODelegate();
		public var companyDelegate:IDAODelegate = new CompaniesDAODelegate();
		public var columnDelegate:IDAODelegate = new CoulmnsDAODelegate();
		public var eventDelegate:IDAODelegate = new EventsDAODelegate();
		public var fileUploadDelegate:IDAODelegate = new UploadDelegate();
		public var fileDetailsDelegate:IDAODelegate = new FileDetailsDAODelegate();
		public var groupDelegate:IDAODelegate = new GroupsDAODelegate();
		public var groupPersonsDelegate:IDAODelegate = new GroupsPersonsDAODelegate();
		public var languageDelegate:IDAODelegate = new LangEntriesDelegate();
		public var commentDelegate:IDAODelegate = new CommentsDAODelegate();
		public var phaseDelegate:IDAODelegate = new PhasesDAODelegate();
		public var phasetemplateDelegate:IDAODelegate = new PhasestemplatesDAODelegate();
		public var profileDelegate:IDAODelegate = new ProfilesDAODelegate();
		public var propertiespjDelegate:IDAODelegate = new PropertiespjDAODelegate();
		public var propertiespresetsDelegate:IDAODelegate = new PropertiespresetsDAODelegate();
		public var statusDelegate:IDAODelegate = new StatusDAODelegate();
		public var taskDelegate:IDAODelegate = new TasksDAODelegate();
		public var teamlineDelegate:IDAODelegate = new TeamlineDAODelegate();
		public var teamlinetemplateDelegate:IDAODelegate = new TeamlineTemplatesDAODelegate();
		public var teamtemplateDelegate:IDAODelegate = new TeamTemplatesDAODelegate();
		public var translateDelegate:IDAODelegate = new TranslateDAODelegate();
		public var workflowDelegate:IDAODelegate = new WorkflowsDAODelegate();
		public var workflowtemplateDelegate:IDAODelegate = new WorkflowstemplatesDAODelegate();
		public var directoryDelegate:IDAODelegate = new DirectoryDAODelegate();
		public var logoutDelegate:IDAODelegate = new LogoutDAODelegate();
		public var pagingDelegate:PageDAODelegate = new PageDAODelegate();
		public var moduleDelegate:ModuleDAODelegate = new ModuleDAODelegate();
		public var impremiurDelegate:IDAODelegate = new ImpremiurDAODelegate();
		public var propPresetTemplateDelegate:IDAODelegate = new PropPresetTemplateDAODelegate();
		public var presetTeamplateDelegate:IDAODelegate = new PresetTemplateDAODelegate();
		public var fileutilDelegate:IDAODelegate = new FileUtilDelegate();
		public var projectMessageDelegate:IDAODelegate = new ProjectMessageDelegate();
		public var reportsDelegate:IDAODelegate = new ReportDelegate();
		public var reportsColumnDelegate:IDAODelegate = new ReportColumnsDelegate();
		public var sprintsDelegate:IDAODelegate = new SprintsDelegate();
		public var defaultTemplateDelegate:IDAODelegate = new DefaultTemplateDelegate();
		public var defaultTemplateValueDelegate:IDAODelegate = new DefaultTemplateValueDelegate();		
		public var smtpEmailUtilDelegate:IDAODelegate = new SmtpEmailUtilDelegate();
    }
}