/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.signal
{
	import com.adams.dt.model.vo.*;
	import com.adams.swizdao.views.mediators.IViewMediator;
	
	import mx.collections.ArrayCollection;
	
	import org.osflash.signals.Signal;
	
	public class ControlSignal
	{
		
		// add Signal 

		//SignalsCommand
		public var getTimeDiffSignal:Signal= new Signal(IViewMediator);
        public var modifyPDFContextSignal:Signal= new Signal();

		//ReportsCommand
		public var deleteReportSignal:Signal= new Signal(IViewMediator,Reports);
		public var updateReportSignal:Signal= new Signal(IViewMediator,Reports);
		public var createReportSignal:Signal= new Signal(IViewMediator,Reports);
		public var reOrderColumnsSignal:Signal= new Signal(IViewMediator,Reports);
		public var reportSignal:Signal= new Signal( IViewMediator, String, int );
		
		//PropertiesCommand
		public var updatePresetSignal:Signal= new Signal(IViewMediator,Propertiespresets);
		public var updatePropPresetTemplateSignal:Signal= new Signal(IViewMediator,Proppresetstemplates);
		public var bulkUpdatePrjPropertiesSignal:Signal= new Signal(IViewMediator,int,String,String,int,String);
		
		//PersonsCommand
		public var createPersonSignal:Signal= new Signal(IViewMediator,Persons);
		public var editPersonSignal:Signal= new Signal(IViewMediator,Persons);
		public var deletePersonSignal:Signal= new Signal(IViewMediator,Persons);
		
		//FilesCommand
        public var downloadFileSignal:Signal= new Signal(IViewMediator,String,int,int);
		public var convertFilesSignal:Signal= new Signal(IViewMediator,ArrayCollection);
		public var moveFilesSignal:Signal= new Signal(IViewMediator,ArrayCollection,String);
		public var bulkUpdateFilesSignal:Signal= new Signal(IViewMediator,ArrayCollection);
		public var getProjectFilesSignal:Signal= new Signal( IViewMediator, int );
		public var updateFileSignal:Signal= new Signal(IViewMediator,FileDetails);

		//NotesCommand
		public var createEventLogSignal:Signal= new Signal(IViewMediator,Events);
		public var createCommentSignal:Signal= new Signal(IViewMediator,CommentVO);
		public var updateCommentSignal:Signal= new Signal(IViewMediator,CommentVO);
		public var getProjectCommentsSignal:Signal= new Signal(IViewMediator,int);
		public var deleteCommentSignal:Signal= new Signal(IViewMediator,CommentVO);
		public var deleteAllProjectsSignal:Signal= new Signal(IViewMediator);
		public var getPDFCommentsSignal:Signal= new Signal(IViewMediator,int);
		
		//TaskCommand
		public var createTaskSignal:Signal= new Signal(IViewMediator,Tasks,String);
		public var updateTaskSignal:Signal= new Signal(IViewMediator,Tasks);
		public var createNavigationTaskSignal:Signal= new Signal(IViewMediator,int,int,int,int,int,String,String,String);
		public var getTodoTasksSignal:Signal= new Signal(IViewMediator,int);
		public var sendEmailSignal:Signal= new Signal(IViewMediator,String,String,String);
		
		//ProjectCommand
		public var getProjectEventsSignal:Signal= new Signal(IViewMediator,int);
		public var getModifiedProjectsSignal:Signal= new Signal(IViewMediator,String,int);
		public var modifyProjectStatusSignal:Signal= new Signal(IViewMediator,Array );
		public var closeProjectsSignal:Signal= new Signal(IViewMediator,Array);
		public var updateProjectSignal:Signal = new Signal( IViewMediator, Projects );
		public var getProjectListSignal:Signal = new Signal( IViewMediator, int, Boolean );
		public var getPagedProjectListSignal:Signal = new Signal( IViewMediator, int, int, int );
		public var createProjectSignal:Signal = new Signal( IViewMediator, String, String, String, int, int, String, Categories, Categories, Categories, int, String, String, String, int, String, String, String, String, String, String, int, int, String, String );
		public var getProjectTasksSignal:Signal = new Signal( IViewMediator, int );
		
		//GetAllCommand
		public var getPropPresetTemplateListSignal:Signal= new Signal(IViewMediator);
		public var getCategoryListSignal:Signal= new Signal(IViewMediator);
		public var getPropTemplatesSignal:Signal= new Signal(IViewMediator);
		public var getReportsListSignal:Signal= new Signal(IViewMediator);
		public var getColumnsListSignal:Signal= new Signal(IViewMediator);
		public var getPresetTemplateListSignal:Signal= new Signal(IViewMediator);
		public var getPropertiesPresetsListSignal:Signal= new Signal(IViewMediator);
		public var getAllTemplatesSignal:Signal= new Signal(IViewMediator,int,int);
		public var getPersonsSignal:Signal= new Signal(IViewMediator); 
		
		//StatesCommand
		public var logoutSignal:Signal = new Signal( IViewMediator );
		public var loginSignal:Signal = new Signal( IViewMediator, String, String );
		public var hideAlertSignal:Signal = new Signal( uint );
		public var showAlertSignal:Signal = new Signal( IViewMediator, String, String, int, Object );
		public var changeStateSignal:Signal = new Signal( String );
		
		//ReportViewMediator
		public var updateReportGridSignal:Signal = new Signal();
	}
} 