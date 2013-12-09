package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Projects;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public final class ProjectsCommand extends AbstractCommand 
	{ 
		private var tempObj : Object = {};
		private var projectsEvent : ProjectsEvent;		
		private var cursor:IViewCursor;
		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			projectsEvent =event as ProjectsEvent;
			this.delegate = DelegateLocator.getInstance().projectDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			
		  	switch(event.type){  
		  	 	case ProjectsEvent.EVENT_UPDATE_PROJECTS:
		       		delegate.responder = new Callbacks(updateProjectResult,fault);
		       		delegate.update(model.currentProjects);
		       	break;
		       	case ProjectsEvent.EVENT_GET_PROJECTS:
		        	delegate.responder = new Callbacks(getProjectResult,fault);
					delegate.findPersonsList(model.person);
		       	break; 		         
		      	default:
		       		break; 
		      }
		}

		public function updateProjectResult( rpcEvent : Object ) : void
		{
			model.currentProjects = Projects(rpcEvent.message.body);
			var arrc:ArrayCollection = new ArrayCollection();
			arrc.list = model.propertiespresetsCollection.list;
			arrc.refresh();
			model.propertiespresetsCollection.list = arrc.list;
			model.propertiespresetsCollection.refresh();
			if(model.currentProjects.projectStatusFK == ProjectStatus.ARCHIVED){
				var phases:ArrayCollection = model.currentProjects.phasesSet;
				for each(var ph:Phases in phases){
					if(ph.phaseTemplateFK == model.currentTasks.workflowtemplateFK.phaseTemplateFK){
						ph.phaseEnd = model.currentTime;
					}
				}
				/* var updateCloseTask:TasksEvent = new TasksEvent(TasksEvent.EVENT_UPDATE_CLOSETASKS);
				var updatePhase:PhasesEvent = new PhasesEvent(PhasesEvent.EVENT_UPDATE_LASTPHASE);
				updatePhase.phasesCollection = phases;
				var updateBulkCloseTask:TasksEvent = new TasksEvent(TasksEvent.EVENT_BULKUPDATE_CLOSETASKS);
				var eventsArr:Array = [updateCloseTask,updatePhase,updateBulkCloseTask]  
	 			var handler:IResponder = new Callbacks(result,fault)
	 			var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  			newProjectSeq.dispatch();
	  			
	  			//Added By Deepan
	  			
	  			for( var i:int = 0;i < model.catagory2.length;i++ ) {
	  				var projectSet:ArrayCollection = Categories( model.catagory2.getItemAt( i ) ).projectSet;
	  				for( var j:int = 0;j < projectSet.length;j++ ) {
	  					if( Projects( projectSet.getItemAt( j ) ).projectId == model.currentProjects.projectId ) {
	  						Projects( projectSet.getItemAt( j ) ).projectDateEnd = model.currentProjects.projectDateEnd;
	  						break;
	  					}
	  				}
	  			} */
	  			model.domainCollection1.refresh();
	  			
			}		
			super.result(rpcEvent);
		}
		
		public function getProjectResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			model.projectsCollection = rpcEvent.result as ArrayCollection;
			model.projectSelectionCollection = new ArrayCollection();
			// cat 2 creation
			var projectsCollection_Len:int=model.projectsCollection.length;
			for(var i : int = 0; i < projectsCollection_Len;i++) {
				var proj : Projects = model.projectsCollection.getItemAt(i) as Projects;
				proj.categories.domain = proj.categories.categoryFK.categoryFK;
				if( !proj.categories.projectSet )	proj.categories.projectSet = new ArrayCollection();
				Utils.checkDuplicateItem( proj, proj.categories.projectSet, "projectId" );
				proj.categories.projectSet.addItem( proj );
				/* if( !Utils.checkDuplicateItem( proj.categories, model.catagory2, "categoryId" ) ) {
					model.catagory2.addItem( proj.categories );
				} */
			}
			// cat 1 creation
			/* var catagory2_Len:int=model.catagory2.length;
			for(var j : int = 0; j < catagory2_Len;j++) 	{
				var cat2 : Categories = model.catagory2.getItemAt(j) as Categories;
				if( !Utils.checkDuplicateItem( cat2, cat2.categoryFK.childCategorySet, "categoryId" ) )
					cat2.categoryFK.childCategorySet.addItem(cat2);
				if( !Utils.checkDuplicateItem( cat2.categoryFK, model.catagory1, "categoryId" ) )
					model.catagory1.addItem( cat2.categoryFK );
			}
			// dom creation
			var catagory1_Len:int=model.catagory1.length;
			for(var k : int = 0; k < catagory1_Len;k++) {
				var cat1 : Categories = model.catagory1.getItemAt(k) as Categories;
				if( !Utils.checkDuplicateItem( cat1, cat1.categoryFK.childCategorySet, "categoryId" ) )
					cat1.categoryFK.childCategorySet.addItem(cat1);
				if( !Utils.checkDuplicateItem( cat1.categoryFK, model.domainCollection1, "categoryId" ) )
					model.domainCollection1.addItem( cat1.categoryFK );
			}
			model.domainCollection1.refresh();
			model.catagoriesState = true; */
			
		}		
		
	}
}
