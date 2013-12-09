package com.adams.dam.control
{
	import com.adams.dam.command.AuthenticationCommand;
	import com.adams.dam.command.CategoriesCommand;
	import com.adams.dam.command.CurrentDataSetCommand;
	import com.adams.dam.command.FileDetailsCommand;
	import com.adams.dam.command.PersonsCommand;
	import com.adams.dam.command.ProjectsCommand;
	import com.adams.dam.event.AuthenticationEvent;
	import com.adams.dam.event.CategoriesEvent;
	import com.adams.dam.event.CurrentDataSetEvent;
	import com.adams.dam.event.FileDetailsEvent;
	import com.adams.dam.event.PersonsEvent;
	import com.adams.dam.event.ProjectsEvent;
	import com.universalmind.cairngorm.control.FrontController;
	
	public final class DAMController extends FrontController
	{
		public function DAMController()
		{
			super();
			
			addCommand( AuthenticationEvent.EVENT_AUTHENTICATION, AuthenticationCommand );
			
			addCommand( PersonsEvent.EVENT_GET_ALL_PERSONS, PersonsCommand );
			
			addCommand( FileDetailsEvent.GET_ALL_FILES, FileDetailsCommand );
			addCommand( FileDetailsEvent.EVENT_CREATE_FILEDETAILS, FileDetailsCommand );
			addCommand( FileDetailsEvent.EVENT_SELECT_FILEDETAILS, FileDetailsCommand );
			addCommand( FileDetailsEvent.EVENT_UPDATE_FILEDETAILS, FileDetailsCommand );
			addCommand( FileDetailsEvent.EVENT_BGDOWNLOAD_FILE, FileDetailsCommand );
			addCommand( FileDetailsEvent.EVENT_BGUPLOAD_FILE, FileDetailsCommand );
			addCommand( FileDetailsEvent.EVENT_CONVERT_FILE, FileDetailsCommand );
			addCommand( FileDetailsEvent.EVENT_CREATE_SWFFILEDETAILS, FileDetailsCommand );
			
			
			addCommand( ProjectsEvent.EVENT_GET_ALL_PROJECTS, ProjectsCommand );
			
			addCommand( CategoriesEvent.EVENT_GET_ALL_CATEGORIES, CategoriesCommand );
			
			addCommand( CurrentDataSetEvent.EVENT_SET_PROJECTS, CurrentDataSetCommand );
		}
	}
}