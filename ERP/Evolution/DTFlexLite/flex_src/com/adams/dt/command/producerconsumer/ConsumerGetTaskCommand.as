package com.adams.dt.command.producerconsumer
{
	import com.adams.dt.business.*;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.*;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adams.dt.view.components.chatscreen.asfile.MessageWindow;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.data.SQLResult;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.rpc.IResponder;
	public final class ConsumerGetTaskCommand extends AbstractCommand implements ICommand , IResponder
	{ 
		private var AlertWindow:MessageWindow; 
		private var cursor:IViewCursor;
		private var tasksEvent : TasksEvent;	
		public function ConsumerGetTaskCommand()
		{
			
		}
		override public function execute( event : CairngormEvent ) : void
		{
			tasksEvent = TasksEvent(event);
			this.delegate = DelegateLocator.getInstance().taskDelegate;
			this.delegate.responder = this; 
			
			if(tasksEvent.taskeventtaskId!=0){
				delegate.findByTaskId(tasksEvent.taskeventtaskId);
			}
		}
		private function update(event:Event):void{
			pusedTaskUpdation();
		}
		
		override public function result( rpcEvent : Object ) : void
		{
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			var found:Boolean
			tasks = arrc.getItemAt(0) as Tasks;
			/* loadPrjIds = [];
			checkPrjItem( tasks.projectFk, model.projectsCollection );
			if (loadPrjIds.length>0){ */
				var handler:IResponder = new Callbacks( loadPushTask, fault )
				var eventupdateprojects:ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_PUSH_GET_PROJECTSID,handler);
				//eventupdateprojects.eventPushProjectsId = loadPrjIds[0];	
				eventupdateprojects.eventPushProjectsId = tasks.projectFk;		
				eventupdateprojects.dispatch();
			/* }
			for each(var tsk:Tasks in model.tasks){
				if(tsk.taskId == tasks.taskId){
					found=true;
					break;
				}
			}
			if(!found && loadPrjIds.length==0) loadPushTask(); */
		}
		private function loadPushTask(ev:Object = null):void{
			if(tasks.previousTask!=null)
				{
					if(tasks.previousTask.fileObj!=null)
					{
						var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate(); 		
						var result:SQLResult = delegate.getSwfFileDetails(tasks.previousTask.fileObj);
						var array:Array = [];
						array = result.data as Array;
						if(array!=null)
						{
							pusedTaskUpdation();
						}
						else
						{			
							model.bgDownloadFile.addEventListener("downloadComplete",update,false,0,true);		
							var fileEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_SWFFILEDETAILS);
							fileEvents.fileDetailsObj = tasks.previousTask.fileObj;
							fileEvents.dispatch();
							model.loadPushedSwfFiles = true;
						}
					}
					else
					{
						if(Utils.checkTemplateExist(model.indReaderMailTemplatesCollection,tasks.workflowtemplateFK.workflowTemplateId))
						{
							model.bgDownloadFile.addEventListener("downloadComplete",update,false,0,true);
							
							var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();	
							var result:SQLResult; 
							if(tasks.fileObj){
								result = delegate.getIndFileDetails(tasks.fileObj);
								 
								var array:Array = [];
								array = result.data as Array;
								if(array!=null){
									if(model.bgDownloadFile.fileToDownload.length == 0 ) pusedTaskUpdation()
								}else{			
									var fileEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_INDFILEDETAILS);
									fileEvents.fileDetailsObj = tasks.fileObj;
									fileEvents.dispatch()
									
									pusedTaskUpdation();
								}
							}
							model.loadPushedSwfFiles = true;
						}
						else
						{
							pusedTaskUpdation();
						}
					}
				}
				
				else if(Utils.checkTemplateExist(model.indReaderMailTemplatesCollection,tasks.workflowtemplateFK.workflowTemplateId))
				{
					model.bgDownloadFile.addEventListener("downloadComplete",update,false,0,true);
					var fileEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_INDFILEDETAILS);
					fileEvents.fileDetailsObj = tasks.fileObj;
					fileEvents.dispatch()
					model.loadPushedSwfFiles = true;
				}
				else
				{
					pusedTaskUpdation();
				}
		}
		private var tasks:Tasks;
		public function pusedTaskUpdation():void
		{
			model.bgDownloadFile.removeEventListener("downloadComplete",update);
			AlertWindow = new MessageWindow();
			tasks.projectObject.wftFK = tasks.wftFK;
			tasks.projectObject.finalTask = tasks; 
			tasks.projectObject.currentTaskDateStart = tasks.tDateCreation;
			if( Utils.getDashboardProject( tasks.projectObject ) ) {
				if( Utils.getDashboardProject( tasks.projectObject ).taskDateStart ) {
					tasks.projectObject.taskDateStart =	Utils.getDashboardProject( tasks.projectObject ).taskDateStart;
					}
				if( Utils.getDashboardProject( tasks.projectObject ).taskDateEnd ) {
					tasks.projectObject.taskDateEnd =	Utils.getDashboardProject( tasks.projectObject ).taskDateEnd;
				}	 
			}
			
			if(tasksEvent.alertMessage != "NewTasks") //ProjectClose or  "NewTasks"
			{
				if(tasksEvent.alertMessage == 'ProjectClose')
				{
					if( model.preloaderVisibility )	model.preloaderVisibility = false;
					if(model.currentUserProfileCode!='CLT')
					{						
						AlertWindow.createWindow(model.mainClass,"DT",model.loc.getString('projectClose'),"corner");	
					}							
					else
					{
						AlertWindow.createWindow(model.mainClass,"DT",model.loc.getString('clientProjectClose'),"corner");
					}
				}
				else if(tasksEvent.alertMessage == 'ProjectAboretd') {
					AlertWindow.createWindow( model.mainClass,"DT", "ProjectCancelled","corner");	
					removeTasks(tasks.projectObject)
					
				}
				else if(tasksEvent.alertMessage =='NewMessage') {
					AlertWindow.createWindow( model.mainClass,"DT", "Mail Message","corner");	
				}
				for( var i:int = 0;i < model.catagory2.length;i++ ) {
	  				var projectSet:ArrayCollection = Categories( model.catagory2.getItemAt( i ) ).projectSet;
	  				for( var j:int = 0;j < projectSet.length;j++ ) {
	  					if( Projects( projectSet.getItemAt( j ) ).projectId == tasks.projectObject.projectId ) {
	  						Projects( projectSet.getItemAt( j ) ).projectDateEnd = tasks.projectObject.projectDateEnd;
	  						break;
	  					}
	  				}
	  			}
	  			model.domainCollection1.refresh();
			}
			else if(tasksEvent.alertMessage =='ProjectDelay') {						
				AlertWindow.createWindow( model.mainClass,"DT", tasksEvent.prjName,"corner");	
			}
			else if(tasksEvent.alertMessage =='ProjectAboretd') {
				AlertWindow.createWindow( model.mainClass,"DT", "ProjectCancelled","corner");	
			}			
			else {  //NewTasks
				AlertWindow.createWindow(model.mainClass,"DT",model.loc.getString('newTaskAwaiting'),"corner");
			} 
			
			var anulationTemp:Workflowstemplates =  Utils.getWorkflowTemplates(model.modelAnnulationWorkflowTemplate,tasks.workflowtemplateFK.workflowFK);	
			if( tasks.workflowtemplateFK.workflowTemplateId == anulationTemp.workflowTemplateId ){
				var projectObject:Projects = tasks.projectObject;
				projectObject.wftFK = tasks.wftFK;
				projectObject.finalTask = tasks;
				projectObject.currentTaskDateStart = tasks.tDateCreation;
				checkRepeatedItem( projectObject, model.projectsCollection );
				 
				model.projectsCollection.addItem( projectObject );
				model.projectsCollection.refresh();
			}
			if( tasks.projectObject.categories.categoryFK ) {
				 Utils.todoListUpdate( tasks );
			}
			Utils.refreshPendingCollection( tasks.projectObject );			
			var historyTasksEvent:TasksEvent = new TasksEvent( TasksEvent.EVENT_FETCH_TASKS );
			historyTasksEvent.dispatch(); 			
		}
		private var loadPrjIds:Array=[];
		private function checkPrjItem( item:int, dp:ArrayCollection ): void {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'projectId' ) ];
            if( !dp.sort ) {
            	dp.sort = sort;
            	dp.refresh();
            }	 
			var cursor:IViewCursor =  dp.createCursor();
			var prj:Projects = new Projects();
			prj.projectId = item
			var found:Boolean = cursor.findAny( prj );	
			if( !found ) {
				loadPrjIds.push(item);
			} 
		}
		private function checkItem( item:Object, dp:ArrayCollection ): Projects {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'projectId' ) ];
           if(dp.sort == null){
           	 	dp.sort = sort;
            	dp.refresh(); 
            }
			var cursor:IViewCursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				return Projects( cursor.current );
			}
			return Projects( item );
		}
		
		public function removeTasks(project:Projects):void{
			var tasksCollection:ArrayCollection = new ArrayCollection();
			var domain:Categories = Utils.getDomains(project.categories);
			for each( var item:Object in model.taskCollection ) {
				if( item.domain.categoryId != null ) {
					if( item.domain.categoryId == domain.categoryId ){
						for each( var taskItem:Tasks in item.tasks){
							if(taskItem.projectObject.projectId == project.projectId){								
								ArrayCollection(item.tasks).removeItemAt(ArrayCollection(item.tasks).getItemIndex(taskItem))
							}
						}
						break;
					}
				}
			}
			model.taskCollection.refresh()
		} 
		private function checkRepeatedItem( item:Object, dp:ArrayCollection ):void {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField("projectId") ];
            dp.sort = sort;
            dp.refresh(); 
            cursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if(	found ){
				dp.removeItemAt( dp.getItemIndex( cursor.current ) );
			}
		}
	}
}
