package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.PagingEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class PagingCommand extends AbstractCommand 
	{ 
		private var pagingEvent :PagingEvent 
		private var perPageMaximum :int = 200;
		private var count:int
		private var startIndex:int = 0
		private var numberofPages:int
		private var colIndex:int = 0;
		override public function execute( event : CairngormEvent ) : void
		{	
			super.execute(event);
			pagingEvent = PagingEvent(event);
			this.delegate = DelegateLocator.getInstance().pagingDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){                  
				case PagingEvent.EVENT_GET_PROJECT_COUNT:
					delegate = DelegateLocator.getInstance().projectDelegate;
					delegate.responder = new Callbacks(projCountResult,fault);
					delegate.findPersonsListCount(model.person.personId); 	
					break;   
				case PagingEvent.EVENT_GET_PROJECT_PAGED:				
					delegate.responder = new Callbacks(pageResult,fault);
					if(model.dbserver=="oracle") {
						delegate.namedQueryId("Projects.findPersonsListOracle", model.person.personId,pagingEvent.startIndex,pagingEvent.endIndex);
					} else {
						delegate.namedQueryId("Projects.findPersonsList", model.person.personId,pagingEvent.startIndex,pagingEvent.endIndex);
					}
					break; 
				case PagingEvent.EVENT_GET_SQL_QUERY:
					delegate.responder = new Callbacks(sqlResult,fault);
					colIndex = pagingEvent.colIndex;
					if(pagingEvent.queryString) delegate.getQueryResult(pagingEvent.queryString);
					break; 
				default:
					break; 
				}
		}
		public function sqlResult( rpcEvent : Object ) : void {
			model.currentReport.resultArray[colIndex] = rpcEvent.result as ArrayCollection;
			super.result(rpcEvent);
		}
		public function pageResult( rpcEvent : Object ) : void {
			model.prjCollection = new ArrayCollection( model.prjCollection.source.concat( (rpcEvent.result as ArrayCollection).source ) );
			super.result(rpcEvent);	
		}
		private var curTsk:Tasks
		public function getProjectResult( resultAC:ArrayCollection ) : void { 
			model.projectsCollection.removeAll();
			for each(var arr:Array in resultAC){
				var prj:Projects = arr[0] as Projects;
				curTsk = arr[1] as Tasks;
				prj.currentTaskDateStart = curTsk.tDateCreation;
				trace("curTsk.wftFK :"+curTsk.wftFK);
				prj.wftFK = curTsk.wftFK;
				prj.finalTask = curTsk; 
				model.projectsCollection.addItem(prj) 
			}
			model.projectSelectionCollection = new ArrayCollection();
			var projectsCollection_Len:int=model.projectsCollection.length;
			trace("\n\n PAGGINGCOMMAND projectsCollection_Len :"+projectsCollection_Len);
			for(var i : int = 0; i < projectsCollection_Len;i++) {
				var proj : Projects = model.projectsCollection.getItemAt(i) as Projects;
				if(proj.categories.categoryFK){					
					proj.categories.domain = proj.categories.categoryFK.categoryFK;
					trace("1st domain :"+proj.categories.domain.categoryId+"=="+proj.categories.domain.categoryName);
				}
				if( !proj.categories.projectSet )	proj.categories.projectSet = new ArrayCollection();
				Utils.checkDuplicateItem( proj, proj.categories.projectSet, "projectId" );
				proj.categories.projectSet.addItem( proj );
				trace("1st projectSet :"+proj.categories.projectSet.length);
				if( !Utils.checkDuplicateItem( proj.categories, model.catagory2, "categoryId" ) ) {
					model.catagory2.addItem( proj.categories );
					trace("1st catagory2 length:"+model.catagory2.length);
				}
			}
			// cat 1 creation
			var catagory2_Len:int=model.catagory2.length;
			trace("\n\n PAGGINGCOMMAND  ------------------------------ 2nd ------------------------------");
			trace("2nd catagory2_Len:"+catagory2_Len);
			for(var j : int = 0; j < catagory2_Len;j++) 	{
				var cat2 : Categories = model.catagory2.getItemAt(j) as Categories;
				//trace("2nd cat2:"+cat2.categoryId+"-categoryName- :"+cat2.categoryName+"-categoryFK- :"+cat2.categoryFK.categoryId+"-categoryFK categoryName- :"+cat2.categoryFK.categoryName);
				if( !Utils.checkDuplicateItem( cat2, cat2.categoryFK.childCategorySet, "categoryId" ) )
					cat2.categoryFK.childCategorySet.addItem(cat2);
				trace("2nd cat2.categoryFK:"+cat2.categoryFK.categoryId+"-categoryName- :"+cat2.categoryFK.categoryName+"-categoryFK- :"+cat2.categoryFK.categoryFK.categoryId+"-categoryFK categoryName- :"+cat2.categoryFK.categoryFK.categoryName);
				if( !Utils.checkDuplicateItem( cat2.categoryFK, model.catagory1, "categoryId" ) )
					model.catagory1.addItem( cat2.categoryFK );
			}
			trace(" ------------------------------ End ------------------------------");
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
			model.catagoriesState = true;
		} 
		public function getAllProjectResult( rpcEvent : Object ) : void {
				getProjectResult(model.prjCollection);
				super.result(rpcEvent);	
		}
		public function projCountResult( rpcEvent : Object ) : void { 
			count = (rpcEvent.result.source as Array)[0];
			numberofPages =  Math.ceil(count/perPageMaximum);
			var eventsArr:Array = []
			for(var curPage:int=1; curPage<=numberofPages; curPage++){
				var projectpageEvent : PagingEvent = new PagingEvent(PagingEvent.EVENT_GET_PROJECT_PAGED);
				projectpageEvent.startIndex = startIndex;
				projectpageEvent.endIndex = perPageMaximum;
				startIndex = perPageMaximum*curPage;
				eventsArr.push(projectpageEvent);
			}
 			var handler:IResponder = new Callbacks(getAllProjectResult,fault);
 			var loginSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
  			if(count>0) { loginSeq.dispatch()} 
  			else{ getAllProjectResult(null);}
	  	}    
 	}
}
										