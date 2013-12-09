/*
* Copyright 2010 @nsdevaraj
* 
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License. You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*/
package com.adams.scrum.utils
{  
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.Columns;
	import com.adams.scrum.models.vo.Companies;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Files;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.ProfileAccessVO;
	import com.adams.scrum.models.vo.Profiles;
	import com.adams.scrum.models.vo.Reports;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Teammembers;
	import com.adams.scrum.models.vo.Teams;
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.models.vo.Tickets;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.views.components.ImageRenderer;
	import com.adams.scrum.views.components.RatingComponent;
	import com.adams.scrum.views.renderers.ADStoryRenderer;
	import com.adams.scrum.views.renderers.ADTaskRenderer;
	import com.adams.scrum.views.renderers.ProductBLogRenderer;
	import com.adams.scrum.views.renderers.ProductRenderer;
	import com.adams.scrum.views.renderers.SprintStoryRenderer;
	import com.adams.scrum.views.renderers.TeamMemberRenderer;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.core.ClassFactory;
	
	public class Utils
	{  	
		public static const SCRUM_CATEGORY:String = "ADAMS";
		
		public static var productStatusWaiting:int;
		public static var productStatusInProgress:int;
		public static var productStatusStandBy:int;
		public static var productStatusFinished:int;
		
		public static var taskStatusWaiting:int;
		public static var taskStatusInProgress:int;
		public static var taskStatusStandBy:int;
		public static var taskStatusFinished:int;
		
		public static var sprintStatusWaiting:int;
		public static var sprintStatusInProgress:int;
		public static var sprintStatusStandBy:int;
		public static var sprintStatusFinished:int;
		
		public static var storyStatusWaiting:int;
		public static var storyStatusInProgress:int;
		public static var storyStatusStandBy:int;
		public static var storyStatusFinished:int;
		
		public static var versionStatusWaiting:int;
		public static var versionStatusInProgress:int;
		public static var versionStatusStandBy:int;
		public static var versionStatusFinished:int;
		
		public static var eventStatusDomainCreate:int;
		public static var eventStatusDomainUpdate:int;
		public static var eventStatusDomainDelete:int;
		
		public static var eventStatusProductCreate:int;
		public static var eventStatusProductUpdate:int;
		public static var eventStatusProductDelete:int;
		
		public static var eventStatusSprintCreate:int;
		public static var eventStatusSprintUpdate:int;
		public static var eventStatusSprintDelete:int;
		
		public static var eventStatusVersionCreate:int;
		public static var eventStatusVersionUpdate:int;
		public static var eventStatusVersionDelete:int;
		
		public static var eventStatusThemeCreate:int;
		public static var eventStatusThemeUpdate:int;
		public static var eventStatusThemeDelete:int;
		
		public static var eventStatusStoryCreate:int;
		public static var eventStatusStoryUpdate:int;
		public static var eventStatusStoryDelete:int;
		
		public static var eventStatusTaskCreate:int;
		public static var eventStatusTaskUpdate:int;
		public static var eventStatusTaskDelete:int;
		
		public static var eventStatusTicketCreate:int;
		public static var eventStatusTicketUpdate:int;
		public static var eventStatusTicketDelete:int;
		
		public static var eventStatusTeamCreate:int;
		public static var eventStatusTeamUpdate:int;
		public static var eventStatusTeamDelete:int;
		
		public static var eventStatusTeamMemberCreate:int;
		public static var eventStatusTeamMemberUpdate:int;
		public static var eventStatusTeamMemberDelete:int;
		
		public static var eventStatusFileCreate:int;
		public static var eventStatusFileUpdate:int;
		public static var eventStatusFileDelete:int;
		
		public static const LOGIN_INDEX:int=0; 
		public static const HOME_INDEX:int=1; 
		public static const PRODUCT_OPEN_INDEX:int=3; 
		public static const PRODUCT_EDIT_INDEX:int=2;
		public static const SPRINT_OPEN_INDEX:int=5; 
		public static const SPRINT_EDIT_INDEX:int=4; 
		public static const HISTORY_INDEX:int=6; 
		public static var FileSeparator:String='//';
		public static var version:String='';
		public static const VIEW_INDEX_ARR:Array = ['com'+FileSeparator+'adams'+FileSeparator+'scrum'+FileSeparator+'views'+FileSeparator+'modules'+FileSeparator+'LoginModule',
													'com'+FileSeparator+'adams'+FileSeparator+'scrum'+FileSeparator+'views'+FileSeparator+'modules'+FileSeparator+'HomeViewModule',
													'com'+FileSeparator+'adams'+FileSeparator+'scrum'+FileSeparator+'views'+FileSeparator+'modules'+FileSeparator+'ProductEditModule',
													'com'+FileSeparator+'adams'+FileSeparator+'scrum'+FileSeparator+'views'+FileSeparator+'modules'+FileSeparator+'ProductViewModule',
													'com'+FileSeparator+'adams'+FileSeparator+'scrum'+FileSeparator+'views'+FileSeparator+'modules'+FileSeparator+'SprintEditModule',
													'com'+FileSeparator+'adams'+FileSeparator+'scrum'+FileSeparator+'views'+FileSeparator+'modules'+FileSeparator+'SprintViewModule',
													'com'+FileSeparator+'adams'+FileSeparator+'scrum'+FileSeparator+'views'+FileSeparator+'modules'+FileSeparator+'HistoryModule'];
		
		public static const PRODUCT:String="product";
		public static const TASK:String="task";
		public static const SPRINT:String="sprint";
		public static const STORY:String="story";
				
		public static const SQL_TYPE:String="type";
		public static const PRODUCT_STATUS:String="productStatus";
		public static const SPRINT_STATUS:String="sprintStatus";
		public static const VERSION_STATUS:String="versionStatus";
		public static const EVENT_STATUS:String="eventStatus";
		
		public static const BASICSTATE:String="BasicState"; 
		public static const DOMAINSTATE:String="NewDomain"; 
		public static const SPRINTSTATE:String="NewSprint";
		public static const PRODUCTSTATE:String="NewProduct"; 
		public static const THEMESTATE:String="NewTheme";
		public static const VERSIONSTATE:String="NewVersion"; 
		public static const NEWTEAMSTATE:String="NewTeam";
		public static const PERSONVIEW:String="personview";
		public static const PROFILEVIEW:String="profileview";
		public static const COMPANYVIEW:String="companyview";
		
		public static const TEAMMEMBERSTATE:String="NewTeamMember"; 
		public static const STORYSTATE:String="NewStory"; 
		public static const EDITSTORYSTATE:String="EditStory"; 
		public static const TICKETSTATE:String="NewTicket";
		public static const TICKETDETAIL:String="TicketDetail";
		public static const BURNDOWNSTATE:String="BurnDown";
		
		public static const TEAMSTATE:String = "TeamState";
		public static const PERSONSTATE:String = "PersonState";
		public static const PROFILESTATE:String = "ProfileState";
		public static const COMPANYSTATE:String = "CompanyState";
		
		public static const SPRINTRENDER:String="SprintRender";
		public static const PRODUCTRENDER:String="ProductRender";  
		public static const VERSIONRENDER:String="VersionRender";
		public static const THEMERENDER:String="ThemeRender";
		public static const SPRINTSTORYRENDER:String="SprintStoryRender";
		public static const SPRINTLOGSTORYRENDER:String="SprintLogStoryRender";
		public static const SPRINTLOGTASKRENDER:String="SprintLogTaskRender";
		public static const PRODUCTSTORYRENDER:String="ProductBLogRenderer";
		public static const TEAMMEMBERRENDER:String="TeamMemberRender";
		public static const THEMESELECTIONRENDERER:String="ThemeSelectionRenderer";
		public static const TICKETDETAILRENDERER:String="ticketdetailrenderer";
		public static const HISTORYRENDERER:String="historyrenderer";	
		
		public static const IMAGERENDER:String="ImageRender"; 
		
		public static const ALERTHEADER:String='Scrum Tool';
		public static const GOTOPRODUCT:String='Goto Product '
		public static const DELETEITEMALERT:String="Are you sure you want to delete this item?";
		
		public static const TASKKEY	:String="taskId";
		public static const PERSONKEY 	:String="personId"; 
		public static const EVENTKEY 	:String="eventId"; 
		public static const COLUMNKEY 	:String="columnId"; 
		public static const DOMAINKEY 	:String="domainId"; 
		public static const FILEKEY 	:String="fileId"; 
		public static const PRODUCTKEY 	:String="productId"; 
		public static const PROFILEKEY 	:String="profileId"; 
		public static const REPORTKEY 	:String="reportId"; 
		public static const SPRINTKEY 	:String="sprintId"; 
		public static const STATUSKEY 	:String="statusId"; 
		public static const STORYKEY 	:String="storyId"; 
		public static const TEAMKEY		:String="teamId"; 
		public static const TEAMMEMBERKEY :String="teammemberId";
		public static const THEMEKEY 	:String="themeId"; 
		public static const TICKETKEY 	:String="ticketId"; 
		public static const VERSIONKEY 	:String="versionId"; 
		public static const COMPANYKEY 	:String="companyId"; 
		
		public static const TASKDAO	:String="taskDAO";
		public static const PERSONDAO 	:String="personDAO"; 
		public static const EVENTDAO 	:String="eventDAO"; 
		public static const COLUMNDAO 	:String="columnDAO"; 
		public static const DOMAINDAO 	:String="domainDAO"; 
		public static const FILEDAO 	:String="fileDAO"; 
		public static const PRODUCTDAO 	:String="productDAO"; 
		public static const PROFILEDAO 	:String="profileDAO"; 
		public static const REPORTDAO 	:String="reportDAO"; 
		public static const SPRINTDAO 	:String="sprintDAO"; 
		public static const STATUSDAO 	:String="statusDAO"; 
		public static const STORYDAO 	:String="storyDAO"; 
		public static const TEAMDAO		:String="teamDAO"; 
		public static const TEAMMEMBERDAO :String="teammemberDAO";
		public static const THEMEDAO 	:String="themeDAO"; 
		public static const TICKETDAO 	:String="ticketDAO"; 
		public static const VERSIONDAO 	:String="versionDAO";
		public static const COMPANYDAO	:String="companyDAO";
		
		public static const DOMAIN_CREATE:String="Domain Created";
		public static const DOMAIN_DELETE:String="Domain Deleted";
		public static const DOMAIN_UPDATE:String="Domain Updated";
		public static const PRODUCT_CREATE:String="Product Created";
		public static const PRODUCT_DELETE:String="Product Deleted";
		public static const PRODUCT_UPDATE:String="Product Updated";
		public static const VERSION_CREATE:String="Version Created";
		public static const VERSION_DELETE:String="Version Deleted";
		public static const VERSION_UPDATE:String="Version Updated";
		public static const THEME_CREATE:String="Theme Created";
		public static const THEME_DELETE:String="Theme Deleted";
		public static const THEME_UPDATE:String="Theme Updated";
		public static const STORY_CREATE:String="Story Created";
		public static const STORY_DELETE:String="Story Deleted";
		public static const STORY_UPDATE:String="Story Updated";
		public static const SPRINT_CREATE:String="Sprint Created";
		public static const SPRINT_DELETE:String="Sprint Deleted";
		public static const SPRINT_UPDATE:String="Sprint Updated";
		public static const TEAMMEMBER_CREATE:String="TeamMember Created";
		public static const TEAMMEMBER_DELETE:String="TeamMember Deleted";
		public static const TEAMMEMBER_UPDATE:String="TeamMember Updated";
		public static const TASK_CREATE:String="Task Created";
		public static const TASK_DELETE:String="Task Deleted";
		public static const TASK_UPDATE:String="Task Updated";
		public static const TEAM_CREATE:String="Team Created";
		public static const TEAM_DELETE:String="Team Deleted";
		public static const TEAM_UPDATE:String="Team Updated";
		public static const TICKET_CREATE:String="Ticket Created";
		public static const TICKET_DELETE:String="Ticket Deleted";
		public static const TICKET_UPDATE:String="Ticket Updated";
		public static const COMPANY_CREATE:String="Company Created";
		public static const COMPANY_UPDATE:String="Company Updated";
		public static const COMPANY_DELETE:String="Company Deleted";		
		public static const FILE_CREATE:String="File Created";
		public static const FILE_UPDATE:String="File Updated";
		public static const FILE_DELETE:String="File Deleted";
		
		public static const DOMAIN_EVENT:String="Domain";
		public static const PRODUCT_EVENT:String="Product";
		public static const SPRINT_EVENT:String="Sprint";
		public static const VERSION_EVENT:String="Version";
		public static const THEME_EVENT:String="Theme";
		public static const STORY_EVENT:String="Story";
		public static const TASK_EVENT:String="Task";
		public static const TICKET_EVENT:String="Ticket";
		public static const TEAM_EVENT:String="Team";
		public static const TEAMMEMBER_EVENT:String="TeamMember";
		public static const COMPANY_EVENT:String="Company";
		public static const FILE_EVENT:String="File";
		public static const DIFFERENT_LOCATION:String="Place the Task in Correct Position"
			
		public static const GRID_TICKET_TITLE_ARR:Array = ['Ticket_of_Task','Person','Hours_Spent','Comments'];
		public static const GRID_TITLE_ARR:Array = ['TaskId','Comment','Status','EstimationTime','Done','Balance'];
		
		public static const REPORT_HTML:String ="HTML"
		public static const REPORT_PDF:String ="pdf"
		public static const REPORT_EXCEL:String ="EXCEL"
		
		public static function getCustomRenderer( type:String):ClassFactory{
			switch(type){
				case PRODUCTRENDER:					
					return new ClassFactory(com.adams.scrum.views.renderers.ProductRenderer);
					break;
				case SPRINTRENDER:
					return new ClassFactory(com.adams.scrum.views.renderers.SprintRenderer);
					break;
				case VERSIONRENDER:
					return new ClassFactory(com.adams.scrum.views.renderers.VersionsRenderer);
					break;
				case THEMERENDER:
					return new ClassFactory(com.adams.scrum.views.renderers.ThemesRenderer);
					break;
				case SPRINTSTORYRENDER:
					return new ClassFactory(com.adams.scrum.views.renderers.SprintStoryRenderer);
					break;
				case PRODUCTSTORYRENDER:
					return new ClassFactory(com.adams.scrum.views.renderers.ProductBLogRenderer);
					break; 
				case TEAMMEMBERRENDER:
					return new ClassFactory(com.adams.scrum.views.renderers.TeamMemberRenderer);
					break;
				case SPRINTLOGSTORYRENDER:
					return new ClassFactory(com.adams.scrum.views.renderers.ADStoryRenderer);
					break;
				case SPRINTLOGTASKRENDER:
					return new ClassFactory(com.adams.scrum.views.renderers.ADTaskRenderer);
					break;
				case THEMESELECTIONRENDERER:
					return new ClassFactory(com.adams.scrum.views.renderers.ThemeSelectionRenderer);
					break;
				case TICKETDETAILRENDERER:
					return new ClassFactory(com.adams.scrum.views.renderers.TicketsDetailRenderer);
					break;
				
				case HISTORYRENDERER:
					return new ClassFactory(com.adams.scrum.views.renderers.HistoryRenderer);
					break;
				
			}			
			return null; 
		} 
		public static function getFileRenderer( type:String):ClassFactory{
			switch(type){
				case IMAGERENDER:					
					return new ClassFactory(com.adams.scrum.views.components.ImageRenderer);
					break;
			}
			return null; 
		}
		//@TODO
		public static function StrToByteArray(str:String):ByteArray{
			var by:ByteArray = new ByteArray();
			by.writeUTFBytes(str);
			return by;
		}
		public static function removeArrcItem(item:Object,arrc:ArrayCollection, sortString:String):void{
			var returnValue:int = -1;
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue != -1 ) {
				arrc.removeItemAt(returnValue);
			}
		} 
		public static function findObject( item:Object, arrc:ArrayCollection, sortString:String ):Object{
			var returnValue:int = -1;
			var returnObject:Object = new Object();
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue != -1 ) { 
				returnObject = arrc.getItemAt(returnValue);
			}
			return returnObject;
		}
		public static function addArrcStrictItem( item:Object, arrc:ArrayCollection, sortString:String, modified:Boolean =false ):void{
			var returnValue:int = -1;
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue == -1 ) {
				arrc.addItem(item);
			}else{
				if(modified){
					arrc.removeItemAt(returnValue);
					arrc.addItemAt(item, returnValue);
				}
			}
		}
		public static function findPriority(story:Stories):int{
			var priority:int;
			var sp:int = RatingComponent.fibArr.indexOf(story.storypoints);
			var eff:int = Math.ceil(story.effort/3);
			if(eff>10) eff =10;
			eff = (eff-11);
			if(eff<0) eff = -eff;
			if(story.effort==0) eff=0;
			priority = (eff+sp) /2;
			story.priority = priority;
			return priority;
		}
		public static function expandStory(story:Stories):String{
			var storyStr:String ='';
			if(int(story.storyId)){
				var asLbl:String 
				if(story.productObject.productRolesArr)asLbl= story.productObject.productRolesArr[story.asLabel]
				storyStr = 'As a '+asLbl
					+' I want to '+story.IWantToLabel;
				if(story.soThatICanLabel.length>0)
					storyStr+=' so that I can '+story.soThatICanLabel;
			}			
			return storyStr;
		}
		public static function totalStoriesEffortTime(effortTime:int,currntTime:int):int{
			var totalEffort:int = 0;
			totalEffort = effortTime + currntTime;
			return totalEffort;
		}	
		public static function totalStoriesEstimatedTime( story:Stories ):String{
			var storiesEstimatedTime:int = 0;
			var arrc:ArrayCollection = story.taskSet;			
			if( arrc ){
				for each(var items:Tasks in arrc){
					if(items.visible == 1){
						if(storiesEstimatedTime == 0)					
							storiesEstimatedTime = items.estimatedTime;					
						else					
							storiesEstimatedTime += items.estimatedTime;
					}
				}
			}
			story.effort = storiesEstimatedTime;
			return storiesEstimatedTime.toString();
		}
		public static function totalStoriesDoneTime( story:Stories ):String{
			var storiesDoneTime:int = 0;
			var arrc:ArrayCollection = story.taskSet;			
			if( arrc ){
				for each(var items:Tasks in arrc){
					if(items.visible == 1){
						if(storiesDoneTime == 0)					
							storiesDoneTime = items.doneTime;					
						else					
							storiesDoneTime += items.doneTime;	
					}
				}
			}
			return storiesDoneTime.toString();
		}		
		public static function headingTotalStoryEstimated( storyArrayCol:IList ):int{
			var totalStoriesEstimated:int = 0;
			var arrcStroy:ArrayCollection = storyArrayCol as ArrayCollection;			
			if( arrcStroy ){
				for each(var itemStories:Stories in arrcStroy){					
					if( totalStoriesEstimated == 0 ){
						totalStoriesEstimated = int(totalStoriesEstimatedTime(itemStories));
					}else{
						totalStoriesEstimated += int(totalStoriesEstimatedTime(itemStories));
					}
				}
			}			
			return totalStoriesEstimated;
		}
		public static function headingTotalStoryDone( storyArrayCol:IList ):int{
			var totalStoriesDone:int = 0;
			var arrcStroy:ArrayCollection = storyArrayCol as ArrayCollection;			
			if( arrcStroy ){
				for each(var itemStories:Stories in arrcStroy){					
					if( totalStoriesDone == 0 ){
						totalStoriesDone = int(totalStoriesDoneTime(itemStories));
					}else{
						totalStoriesDone += int(totalStoriesDoneTime(itemStories));
					}
				}
			}			
			return totalStoriesDone;
		}		
		public static function totalStoryRemainingTime(estmateTime:int,doneTime:int):int{
			var totalremaining:int = 0;
			totalremaining = estmateTime - doneTime;
			return totalremaining;
		}
		
		public static function headingTotalStoryStatus( storyArrayCol:IList ):Array{
			var totalArray:Array = [];
			var arrcStroy:ArrayCollection = storyArrayCol as ArrayCollection;			
			if( arrcStroy ){
				for each(var itemStories:Stories in arrcStroy){	
					if(totalArray.length == 0){
						totalArray = totalStoriesStatus(itemStories);	
					}else{
						var tempArray:Array = totalStoriesStatus( itemStories );
						for(var i:int = 0;i < 4; i++){
							totalArray[i] = Number( totalArray[i] )+ Number( tempArray[i] );
						}
					}
				}
			}			
			return totalArray;
		}
		public static function totalStoriesStatus( story:Stories ):Array {
			var taskStatusWaiting:int = 0;
			var taskStatusInProgress:int = 0;
			var taskStatusStandBy:int = 0;			
			var taskStatusFinished:int = 0;
			var totalTempArray:Array = [];
			var arrc:ArrayCollection = story.taskSet;			
			if( arrc ){
				for each(var items:Tasks in arrc){
					if( items.taskStatusFk == Utils.taskStatusWaiting ){ 
						taskStatusWaiting++;
					}
					else if( items.taskStatusFk == Utils.taskStatusInProgress ){ 
						taskStatusInProgress++;
					}
					else if( items.taskStatusFk == Utils.taskStatusStandBy ){ 
						taskStatusStandBy++;
					}
					else if( items.taskStatusFk == Utils.taskStatusFinished ){ 
						taskStatusFinished++;
					}
				}
			}
			totalTempArray.push(taskStatusWaiting);
			totalTempArray.push(taskStatusInProgress);
			totalTempArray.push(taskStatusStandBy);
			totalTempArray.push(taskStatusFinished);
			return totalTempArray;
		}
		
		public static function headingValidateStoryFinish( storyArrayCol:IList ):Array{
			var totalArray:Array = [];
			var arrcStroy:ArrayCollection = storyArrayCol as ArrayCollection;			
			if( arrcStroy ){
				for each(var itemStories:Stories in arrcStroy){	
					if(totalArray.length == 0){
						totalArray = validateTotalTaskFinish(itemStories);	
					}else{
						var tempArray:Array = validateTotalTaskFinish( itemStories );
						for(var i:int = 0;i < 4; i++){
							totalArray[i] = Number( totalArray[i] )+ Number( tempArray[i] );
						}
					}
				}
			}			
			return totalArray;
		}
		public static function validateTotalTaskFinish( story:Stories ):Array {
			var taskWaiting:int = 0;
			var taskInProgress:int = 0;
			var taskStandBy:int = 0;			
			var taskFinished:int = 0;
			var totalArray:Array = [];
			var arrc:ArrayCollection = story.taskSet;			
			if( arrc ){
				for each(var items:Tasks in arrc){
					if(items.visible == 1){
						if( items.taskStatusFk == Utils.taskStatusWaiting ){ 
							taskWaiting++;
						}
						else if( items.taskStatusFk == Utils.taskStatusInProgress ){ 
							taskInProgress++;
						}
						else if( items.taskStatusFk == Utils.taskStatusStandBy ){ 
							taskStandBy++;
						}
						else if( items.taskStatusFk == Utils.taskStatusFinished ){ 
							taskFinished++;
						}
					}
				}
			}
			totalArray.push(taskWaiting);
			totalArray.push(taskInProgress);
			totalArray.push(taskStandBy);
			totalArray.push(taskFinished);
			return totalArray;
		}
		
		public static function getStatusName( task:Tasks ): String
		{
			var statusName:String
			switch( task.taskStatusFk )
			{
				case taskStatusFinished :
					statusName = "Finished"
					break;
				case taskStatusInProgress:
					statusName = "InProgress"
					break;
				case taskStatusStandBy:
					statusName = "StandBy"
					break;
				case taskStatusWaiting:
					statusName = "Waiting"
					break;
			}
			return statusName;
		}
		public static function createEvent( obj:Object, eventDAO:AbstractDAO,eventType:int,evtLbl:String, personId:int,
											taskId:int=0,productId:int=0,sprintId:int=0,storyId:int =0,ticketId:int =0 ): SignalVO
		{
			var eventsStorySignal:SignalVO = new SignalVO(obj,eventDAO,Action.CREATE);
			var eventsVoStory:Events = new Events();
			eventsVoStory.eventDate = new Date();
			eventsVoStory.eventStatusFk = eventType;
			eventsVoStory.personFk = personId;
			eventsVoStory.taskFk = taskId;
			eventsVoStory.productFk = productId;
			eventsVoStory.eventLabel = evtLbl;
			eventsVoStory.storyFk = storyId;
			eventsVoStory.sprintFk = sprintId;
			eventsVoStory.ticketFk = ticketId; 				
			eventsStorySignal.valueObject = eventsVoStory; 
			return eventsStorySignal;
		}
		
		public static function getStatusSkinName(statusFK:int,category:String):String{
			var skinName:String;
			var currentCategory:String = category+"Status";
			switch(statusFK){
				case Utils[currentCategory+'Waiting']:
					skinName = "waitingSkin";
					break;
				case Utils[currentCategory+'InProgress']:
					skinName  = "inProgressSkin";
					break;
				case Utils[currentCategory+'StandBy']:
					skinName  = "standBySkin";
					break;
				case Utils[currentCategory+'Finished']:
					skinName  = "finishedSkin";
					break;
			}
			return skinName;
		}
		
		/**
		 * @item //The New Item to be added
		 * @source //The  Array in which the new item is to be added
		 * @sortString //The property of the item by which the comparison takes place
		 * Checks wheather the item to be added already exists in the array, if so replaces it
		 * otherwise just pushes the new object and returns the source array
		 */
		public static function pushNewItem( item:Object, source:Array, sortString:String ):Array {
			var findIndex:int = -1;
			
			for( var i:int = 0; i < source.length; i++ ) {
				if( source[ i ][ sortString ] == item[ sortString ] ) {
					findIndex = i;
					break;
				}
			}
			
			if( findIndex != -1 ) {
				source[ findIndex ] = item;
			}
			else {
				source.push( item );
			}
			
			return source;
		}
		public static function profileAccess( currentProfileAccessvo:ProfileAccessVO,tempIList:ArrayCollection ):ProfileAccessVO{
			if( tempIList.length!=0 ){
				var tempBool:Boolean = false;
				for each(var itemsProfile:Profiles in tempIList){		
					switch(itemsProfile.profileCode)
					{ 	
						case "ROLE_ADM":
							currentProfileAccessvo.isADM = true;
							currentProfileAccessvo.domainAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.domainAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.domainAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.domainAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.domainAccessArr[ProfileAccessVO.ADMIN]=true;
							currentProfileAccessvo.productAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.productAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.productAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.productAccessArr[ProfileAccessVO.ADMIN] = true;
							currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.EDIT]=currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.ADMIN] = true;
							currentProfileAccessvo.eventAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.eventAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.eventAccessArr[ProfileAccessVO.DELETE]=currentProfileAccessvo.eventAccessArr[ProfileAccessVO.ADMIN] = true;
							currentProfileAccessvo.reportAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.reportAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.ADMIN]=true;
							break;
						case "ROLE_SPO":
							currentProfileAccessvo.isSPO = true;
							currentProfileAccessvo.productAccessArr[ProfileAccessVO.READ] = true;
							currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.READ] = true;
							currentProfileAccessvo.eventAccessArr[ProfileAccessVO.READ] = true;
							currentProfileAccessvo.reportAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.EDIT] = true;
							currentProfileAccessvo.storyAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.storyAccessArr[ProfileAccessVO.READ] = true;
							break;
						case "ROLE_SSM":
							currentProfileAccessvo.isSSM = true;
							currentProfileAccessvo.domainAccessArr[ProfileAccessVO.READ] = true;
							currentProfileAccessvo.productAccessArr[ProfileAccessVO.CREATE]= currentProfileAccessvo.productAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.productAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.productAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.productAccessArr[ProfileAccessVO.ADMIN]=true;
							currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.ADMIN]=true;
							currentProfileAccessvo.eventAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.eventAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.eventAccessArr[ProfileAccessVO.DELETE]=currentProfileAccessvo.eventAccessArr[ProfileAccessVO.ADMIN] = true;
							currentProfileAccessvo.reportAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.reportAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.ADMIN]=true;
							currentProfileAccessvo.storyAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.storyAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.storyAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.storyAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.storyAccessArr[ProfileAccessVO.ADMIN]=true;
							break;
						case "ROLE_STM":
							currentProfileAccessvo.isSTM = true;
							currentProfileAccessvo.domainAccessArr[ProfileAccessVO.READ] = true;
							currentProfileAccessvo.productAccessArr[ProfileAccessVO.READ] = true;
							currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.EDIT]=true;
							currentProfileAccessvo.reportAccessArr[ProfileAccessVO.READ] = true;
							break;
						case "ROLE_OPE":
							currentProfileAccessvo.isOPE = true;
							currentProfileAccessvo.domainAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.domainAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.domainAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.domainAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.domainAccessArr[ProfileAccessVO.ADMIN]=false;
							currentProfileAccessvo.productAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.productAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.productAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.productAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.productAccessArr[ProfileAccessVO.ADMIN]=false;
							currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.sprintAccessArr[ProfileAccessVO.ADMIN]=false;
							currentProfileAccessvo.eventAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.eventAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.eventAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.eventAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.eventAccessArr[ProfileAccessVO.ADMIN]=false;
							currentProfileAccessvo.reportAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.reportAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.reportAccessArr[ProfileAccessVO.ADMIN]=false;							
							currentProfileAccessvo.storyAccessArr[ProfileAccessVO.CREATE] = currentProfileAccessvo.storyAccessArr[ProfileAccessVO.READ] = currentProfileAccessvo.storyAccessArr[ProfileAccessVO.EDIT]= currentProfileAccessvo.storyAccessArr[ProfileAccessVO.DELETE] = currentProfileAccessvo.storyAccessArr[ProfileAccessVO.ADMIN]=false;
							break;
					}  
				}
			}			
			return currentProfileAccessvo;
		} 
	}	
}