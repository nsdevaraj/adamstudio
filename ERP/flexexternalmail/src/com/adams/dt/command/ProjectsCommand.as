package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	
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
		        	delegate.responder = new Callbacks(getProjectResultMail,fault);
					delegate.findPersonsList(model.person);
		       	break; 
		       	case ProjectsEvent.EVENT_GET_PROJECTSID:
		        	delegate.responder = new Callbacks(getProjectResults,fault);
					delegate.findProjectId(model.modelProjectLocalId);
		       	break;		         
		      	default:
		       		break; 
		      }
		}
		public function getProjectResults(rpcEvent : Object) : void { 
			super.result(rpcEvent);
			model.delayUpdateTxt = "Current Project Details";			
			var arr:Array= rpcEvent.result.getItemAt( 0 );
			model.currentProjects = arr[0] as Projects;
			model.currentPropertiespjSingle = model.currentProjects.propertiespjSet;
			trace("ProjectsCommand getProjectResults :"+model.currentProjects.propertiespjSet.length);
			model.currentTempProjects = model.currentProjects;		
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
	  			model.domainCollection1.refresh();	  			
			}		
			super.result(rpcEvent);
		}
		
		public function getProjectResultMail( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			model.projectsCollection = rpcEvent.result as ArrayCollection;
			/* var resultAC:ArrayCollection= rpcEvent.result as ArrayCollection;
			for each(var arr:Array in resultAC){
				var prj:Projects = arr[0] as Projects;
				prj.wftFK = arr[1]
				model.projectsCollection.addItem(prj) 
			}  */
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
		}			
	}
}
