package com.adams.dt.business.util
{
	import com.adams.dt.event.DefaultTemplateEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Columns;
	import com.adams.dt.model.vo.Companies;
	import com.adams.dt.model.vo.DomainWorkflow;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.PhaseStatus;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.dt.model.vo.Reports;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.StatusTypes;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.WorkflowTemplatePermission;
	import com.adams.dt.model.vo.Workflows;
	import com.adams.dt.model.vo.Workflowstemplates;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	
	public class LoginUtils
	{	
		private var tempObj : Object ={};
		[Bindable]
		private static var model:ModelLocator = ModelLocator.getInstance(); 
		public function LoginUtils():void
		{
		}
		public function getAllStatuses( arrc:ArrayCollection ) : void
		{			
			model.getAllStatusColl = arrc;
			model.taskStatusColl = getTaskStatusColl(model.getAllStatusColl);
		}	
		
		private function getTaskStatusColl(arrc:ArrayCollection):ArrayCollection{
			var temp:ArrayCollection  = new ArrayCollection();
			
			var taskColl:ArrayCollection = new ArrayCollection();
			var projectColl:ArrayCollection = new ArrayCollection();
			var workFLowTempColl:ArrayCollection = new ArrayCollection();
			var eventTypeColl:ArrayCollection = new ArrayCollection();
			var phaseColl:ArrayCollection = new ArrayCollection();
			
			var status:Status = new Status();
			status.statusLabel = 'All';
			temp.addItem(status);
			for each(var item:Status in arrc){				
				switch(item.type){
					case StatusTypes.TASKSTATUS:
						temp.addItem(item);
						taskColl.addItem(item);
					break;
					case StatusTypes.PROJECTSTATUS:
						projectColl.addItem(item);
					break;
					case StatusTypes.WORKFLOWTEMPLATETYPE:
						workFLowTempColl.addItem(item);
					break;
					case StatusTypes.EVENTTYPE:
						eventTypeColl.addItem(item);
					break;
					case StatusTypes.PHASESTATUS:
						phaseColl.addItem(item);
					break;
				}
			}
			TaskStatus.taskStatusColl = taskColl;
			ProjectStatus.projectStatusColl = projectColl;
			WorkflowTemplatePermission.workFlowTempStatusColl = workFLowTempColl;
			EventStatus.eventStatusColl = eventTypeColl;
			PhaseStatus.phaseStatusColl = phaseColl;
			
			return temp;
		}
		
		public function getAllCompanies( arrc:ArrayCollection) : void { 
			model.totalCompaniesColl = arrc;
			
			//defaultTemplateCollections();
		}
		public function getAllPhaseTemplates( arrc:ArrayCollection ) : void{
			model.allPhasestemplatesCollection = arrc;
		}
		private function defaultTemplateCollections():void{			 		
			model.totalCompaniesColl.filterFunction = commercialFilter;
			model.totalCompaniesColl.refresh();
			model.clientCompanyId = ( model.totalCompaniesColl.getItemAt( 0 ) as Companies ).companyid;
			trace("defaultTemplateCollections clientCompanyId :"+model.clientCompanyId);
			var tempCompanies:Companies = ( model.totalCompaniesColl.getItemAt( 0 ) as Companies );
			model.commonDefaultTemplateCollect.addItem( tempCompanies );
			trace("defaultTemplateCollections :"+model.commonDefaultTemplateCollect.length);
		}
		private function commercialFilter( obj:Companies ):Boolean {
	    	var retVal:Boolean = false;
			if ( obj.companyCategory == 'PHOTOGRAVURE' ) { 
				retVal = true;
			}
			return retVal;
	    }
	    public function commonDefaultTemplate():void{
			var getDefaultTemplateEvt:DefaultTemplateEvent = new DefaultTemplateEvent( DefaultTemplateEvent.GET_COMMON_DEFAULT_TEMPLATE ); 
		    getDefaultTemplateEvt.dispatch();
		}
	    
		
		public function collectDomainResult( arrc: ArrayCollection ) : void {
	  		model.categoriesCollection.source = arrc.source
	  		model.collectAllDomains = arrc;
	  		trace("collectDomainResult :"+model.collectAllDomains.length);
	  		model.collectAllDomains.filterFunction = getDomainsOnly;
	  		model.collectAllDomains.refresh();
			model.domain = GetVOUtil.getCategoryObjectCode(GetVOUtil.getCompanyObject(model.person.companyFk).companycode);
			if(model.domain.categoryId!=0){
				trace("collectDomainResult inner if loop");
				var profile : Profiles = new Profiles();
				profile.profileId = 2;
				profile.profileCode = 'CLT'
				model.profilesCollection.addItem(profile);
				model.domainCollection.addItem(model.domain);
			}
			trace("collectDomainResult");
	  	}
	  	
	  	private function getDomainsOnly(item:Categories):Boolean
	  	{
	  		var retVal : Boolean = false;
			// check the items in the itemObj Ojbect to see if it contains the value being tested
			if ( item.categoryFK == null)
			{ 
				retVal = true;
			}
			return retVal;
	  	}
	  	
	  	public function getPrjProfilesResult( profilecollection:ArrayCollection ):void {	
			if(profilecollection.length > 0)
			{
				model.profilesCollection = profilecollection;
			}
		}
		
		
		public function getAllProfiles( arrc: ArrayCollection):void {
			model.teamProfileCollection = arrc;
			updateImpId(); 			
		}
		
		public function updateImpId():void {
			for each(var pro:Profiles in model.teamProfileCollection){
				if(pro.profileCode == 'EPR') {
					model.impProfileId = pro.profileId;
				}
				//DECEMBER 31 2009  INDIA
				if(pro.profileCode == 'IND') {
					model.indProfileId = pro.profileId;
				}
			}			
		}
		
		public function getAllGroups( arrc:ArrayCollection ):void {
			model.CollectAllGroupsColl = arrc;

			var profilesColl:ArrayCollection = model.profilesCollection;
			if(profilesColl.length == 0){
			 profilesColl.addItem(GetVOUtil.getProfileObject(model.person.defaultProfile));
			}
			filterCollection(profilesColl);			 
		}
		
		public function getAllTemplate(arrc : ArrayCollection):void{
			model.closeProjectTemplate = new ArrayCollection();
			model.modelAnnulationWorkflowTemplate = new ArrayCollection();
			model.firstRelease = new ArrayCollection();
			model.otherRelease = new ArrayCollection();
			model.fileAccessTemplates = new ArrayCollection();
			model.messageTemplatesCollection = new ArrayCollection();
			model.versionLoop = new ArrayCollection();
			model.backTask = new ArrayCollection();
			model.standByTemplatesCollection = new ArrayCollection();
			model.alarmTemplatesCollection = new ArrayCollection();
			model.sendImpMailTemplatesCollection = new ArrayCollection();
			model.indReaderMailTemplatesCollection = new ArrayCollection(); 
			model.checkImpremiurCollection = new ArrayCollection();
			model.impValidCollection = new ArrayCollection();
			model.indValidCollection = new ArrayCollection();
			model.CPValidCollection = new ArrayCollection();
			model.CPPValidCollection = new ArrayCollection();
			model.COMValidCollection = new ArrayCollection();
			model.AGEValidCollection = new ArrayCollection();
 			model.workflowstemplatesCollection = arrc;
			for each(var wTemp:Workflowstemplates in arrc){
				if(wTemp.optionStopLabel!=null){
					var stoplabel:Array = wTemp.optionStopLabel.split(",");
					for(var i:int=0;i<stoplabel.length;i++){
						var permissionStr:Number = Number(stoplabel[i]);
						switch(int(permissionStr)){
							case WorkflowTemplatePermission.CLOSED:
								model.closeProjectTemplate.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.ANNULATION:
								 model.modelAnnulationWorkflowTemplate.addItem(wTemp); 
							break;
							case WorkflowTemplatePermission.FIRSTRELEASE:
								model.firstRelease.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.OTHERRELEASE:
								model.otherRelease.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.FILEACCESS:
								model.fileAccessTemplates.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.MESSAGE:
								model.messageTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.VERSIONLOOP:
								model.versionLoop.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.BACKTASK:
								model.backTask.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.ALARM:
								model.alarmTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.STANDBY:
								model.standByTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.SENDIMPMAIL:
								model.sendImpMailTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.PDFREADER:
								model.indReaderMailTemplatesCollection.addItem(wTemp);
							break;
							case WorkflowTemplatePermission.CHECKIMPREMIUR:
								model.checkImpremiurCollection.addItem( wTemp );	
							break;  
							case WorkflowTemplatePermission.IMPVALIDATOR:
								model.impValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.INDVALIDATOR:
								model.indValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.CPVALIDATOR:
								model.CPValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.CPPVALIDATOR:
								model.CPPValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.COMVALIDATOR:
								model.COMValidCollection.addItem( wTemp );	
							break;
							case WorkflowTemplatePermission.AGENCEVALIDATOR:
								model.AGEValidCollection.addItem( wTemp );	
							break;
							default:
							break;
						}
					} 
				}
			}
		} 
		
		private var domainId:int;
		public function getAllDomainWorkFlowResult( arrc : ArrayCollection ):void{
			model.getAllDomainWorkflows = arrc;
			trace("getAllDomainWorkFlowResult :"+model.collectAllDomains.length);
			for each(var domain:Categories in model.collectAllDomains){ 
				domainId = domain.categoryId;
				model.getAllDomainWorkflows.filterFunction = getSpecialWorkFlowsOnly;
	  			model.getAllDomainWorkflows.refresh();
	  			for each(var domainWf:DomainWorkflow in model.getAllDomainWorkflows){
					domain.domainworkflowSet.addItem(domainWf);
				}
				model.getAllDomainWorkflows.filterFunction = null;
				model.getAllDomainWorkflows.refresh();
			}
		}
		
		private function filterCollection(ac:ArrayCollection):void{
			// assign the filter function
			ac.filterFunction = deDupe;
			//refresh the collection
			ac.refresh();
		}
		private function deDupe(item : Object) : Boolean
		{
			// the return value
			var retVal : Boolean = false;
			// check the items in the itemObj Ojbect to see if it contains the value being tested
			if ( !tempObj.hasOwnProperty(item.profileId))
			{
				// if not found add the item to the object
				tempObj[item.profileId] = item;
				retVal = true;
			}

			return retVal;
			//	 or if you want to feel like a total bad ass and use only one line of code, use a tertiary statement ;)
			// return (tempObj.hasOwnProperty(item.label) ? false : tempObj[item.label] = item && true);
		} 
		
		private function getSpecialWorkFlowsOnly(item:DomainWorkflow):Boolean
	  	{
	  		var retVal : Boolean = false;
			if ( item.domainFk == domainId)
			{ 
				retVal = true;
			}
			return retVal;
	  	}
		
		public function getAllModuleResult( arrc:ArrayCollection ):void{
			model.getAllModules = new ArrayCollection( model.getAllModules.source.concat(arrc.source));
			successResult();
		}
		
		public function successResult():void{
			model.dtState = model.CF;
		}
		//****************************************************************
		public function findAllPropertyResult( arrc:ArrayCollection ) : void { 
			model.propertiespresetsCollection = arrc;
			for each( var techPropPrest:Propertiespresets in arrc ) {
				if(techPropPrest.editablePropertyPreset == 1) {
					if(techPropPrest.fieldType =="popup"){
						techPropPrest.fieldDefaultValue = String( 0 );
					}
					model.techPropPresetCollection.addItem(techPropPrest);
				}
			}
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'propertyPresetId' ) ];
			model.propertiespresetsCollection.sort = sort;
			model.propertiespresetsCollection.refresh();
		}
		public function findAllPresettemplate( arrc:ArrayCollection ) : void { 
			model.presetTempCollection =  arrc; 			
		}
		public function findAllWorkflows( arrc:ArrayCollection ) : void { 
			var domainworkflowCollection:ArrayCollection = arrc;
			model.workflowsCollection = domainworkflowCollection;	
			if(model.profilesCollection.length>0){				 			
			    if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode =='CLT'){
					model.currentWorkflows = domainworkflowCollection.getItemAt(0) as Workflows;
			    }
			}
		}
		public function projCountResult( arrc:ArrayCollection ) : void { 
			/* count = (rpcEvent.result.source as Array)[0];
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
  			else{ getAllProjectResult(null);} */
	  	}
	  	private var curTsk:Tasks;
	  	public function getAllProjectResult( arrcoll:ArrayCollection ) : void { 
			var resultAC:ArrayCollection = arrcoll;
			model.projectsCollection.removeAll();
			for each(var arr:Array in resultAC){
				var prj:Projects = arr[0] as Projects;
				curTsk = arr[1] as Tasks;
				prj.currentTaskDateStart = curTsk.tDateCreation;
				prj.wftFK = curTsk.wftFK;
				prj.finalTask = curTsk;
				model.projectsCollection.addItem(prj);
			}
			model.projectSelectionCollection = new ArrayCollection();
			// cat 2 creation
			var projectsCollection_Len:int = model.projectsCollection.length;
			for(var i : int = 0; i < projectsCollection_Len;i++) {
				var proj : Projects = model.projectsCollection.getItemAt(i) as Projects;
				proj.categories.domain = proj.categories.categoryFK.categoryFK;
				if( !proj.categories.projectSet )	proj.categories.projectSet = new ArrayCollection();
				Utils.checkDuplicateItem( proj, proj.categories.projectSet, "projectId" );
				proj.categories.projectSet.addItem( proj );
				if( !Utils.checkDuplicateItem( proj.categories, model.catagory2, "categoryId" ) ) {
					model.catagory2.addItem( proj.categories );
				}
			}
			// cat 1 creation
			var catagory2_Len:int = model.catagory2.length;
			for(var j : int = 0; j < catagory2_Len;j++) 	{
				var cat2 : Categories = model.catagory2.getItemAt(j) as Categories;
				if( !Utils.checkDuplicateItem( cat2, cat2.categoryFK.childCategorySet, "categoryId" ) )
					cat2.categoryFK.childCategorySet.addItem(cat2);
				if( !Utils.checkDuplicateItem( cat2.categoryFK, model.catagory1, "categoryId" ) )
					model.catagory1.addItem( cat2.categoryFK );
			}
			// dom creation
			var catagory1_Len:int = model.catagory1.length;
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
		public function getTasksResult( arrcoll:ArrayCollection ) : void {  
			//model.tasks = ArrayCollection( rpcEvent.message.body );
			model.tasks = arrcoll; 
			var domainDeatils:Array = [];
			var taskCollection:ArrayCollection = new ArrayCollection();
			var tasks:ArrayCollection;
			var object:Object;
			var domains:Categories;
			var isCLT : Boolean
			model.taskCollection = new ArrayCollection();
			model.taskCollection.refresh();
			if( model.profilesCollection.length > 0 ) {
				if( GetVOUtil.getProfileObject( model.person.defaultProfile ).profileCode == 'CLT' ) { 
					isCLT = true;
				}	
			}   
			for each( var item:Tasks in model.tasks ) {
				item.projectObject = checkItem( item.projectObject, model.projectsCollection );
				if( isCLT && ( model.appDomain != 'Brennus' ) ) {
					domains = item.projectObject.categories;
					model.domainCollection.addItem( Utils.getDomains( item.projectObject.categories ) );
				}
				else {
					domains = Utils.getDomains( item.projectObject.categories );
					model.domainCollection.addItem( domains );
				}
				if( domainDeatils.indexOf( domains ) > - 1 ) {				
					for each( var item2:Object in taskCollection ) {
						if( item2.domain.categoryId == domains.categoryId ) {
							tasks = item2.tasks;
							break;
 						}
					}
					if( ( item.personDetails ) && ( Utils.checkTemplateExist( model.messageTemplatesCollection, item.workflowtemplateFK.workflowTemplateId ) ) ) {
						if( item.personDetails.personId == model.person.personId ) {
							tasks.addItem( item );
						}	
					}
					else {	
						tasks.addItem( item );
					}
				}
				else {
					object = new Object();
					tasks = new ArrayCollection();
					object[ 'domain' ] = domains;
					object[ 'tasks' ] = tasks;
					if( ( item.personDetails ) && ( Utils.checkTemplateExist( model.messageTemplatesCollection, item.workflowtemplateFK.workflowTemplateId ) ) ) {
						if( item.personDetails.personId == model.person.personId ) {
							tasks.addItem( item );
						}
					}
					else {
						tasks.addItem( item );
					}
					taskCollection.addItem( object );
					domainDeatils.push( domains );
				}
				
				if( item.tDateEndEstimated ) {
					var previousDate:Date = model.currentTime;
					var nextDate:Date = new Date( model.currentTime.getTime() + DateUtil.DAY_IN_MILLISECONDS );
					var previousCompare:Number = new Date( previousDate.getFullYear(),  previousDate.getMonth(), previousDate.getDate() ).getTime();
					var nextCompare:Number = new Date( nextDate.getFullYear(), nextDate.getMonth(), nextDate.getDate() ).getTime();
					if( ( item.tDateEndEstimated.getTime() >= previousCompare ) && ( item.tDateEndEstimated.getTime() < nextCompare ) ) {
						if( Utils.checkTemplateExist( model.alarmTemplatesCollection, item.workflowtemplateFK.workflowTemplateId ) ) {
							if( !Utils.checkDuplicateItem( item, model.delayedTasks, 'taskId' ) ) {
								model.delayedTasks.addItem( item );
							}
						}
					}
				}
			}
			model.taskCollection = taskCollection;
			model.domainCollection = new ArrayCollection( domainDeatils );
			model.workflowState = 0;
		}   
		private function checkItem( item:Object, dp:ArrayCollection ): Projects {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'projectId' ) ];
            if( !dp.sort ) {
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
		public function getMaxTaskResult( arrcoll:ArrayCollection ) : void {  
			var maxtaskarray:ArrayCollection = arrcoll;
			for each( var obj:Array in maxtaskarray.source ) {
				var projId:int = obj[ 1 ];
				var proj:Projects = GetVOUtil.getProjectObject( projId );
				proj.taskDateStart = obj[ 2 ];
				proj.taskDateEnd = obj[ 3 ];
			}
		}
		public function findAllReportResult( arrcoll:ArrayCollection ) : void {  
			if( model.preloaderVisibility )	model.preloaderVisibility = false;
			model.tabsCollection = new ArrayCollection();
			var returnCollection:ArrayCollection = arrcoll;
			for each (var reportObj:Reports in returnCollection){
				for each (var col:Columns in reportObj.columnSet){
					reportObj.headerArray.push(col.columnName);
					reportObj.fieldArray.push(col.columnField);
					reportObj.widthArray.push(col.columnWidth);
					reportObj.booleanArray.push(col.columnFilter);
					reportObj.resultArray.push('');
				}
				model.tabsCollection.addItem(reportObj);
			} 
		}
		public function findAllColumnResult( arrcoll:ArrayCollection ) : void { 
			model.totalColumnsColl = arrcoll;
		}
		
		public function createOracleNewProjectResult( arrcoll:ArrayCollection ) : void {
			var localprojcoll:ArrayCollection = arrcoll;
			
			model.project = arrcoll.getItemAt( 0 ) as Projects;
			model.currentProjects = model.project;	
			model.newProjectCreated = true;	
			trace("createOracleNewProjectResult model.currentProjects:"+model.currentProjects.projectId+", projectName :"+model.currentProjects.projectName);
			
			model.project.categories = tempCategories;
			model.currentProjects.categories = tempCategories;
			
			if( model.catagory1.length == 0 )
			{
				var cat1 : Categories = model.project.categories.categoryFK;
				var category2 : Categories = model.project.categories;
				cat1.childCategorySet.addItem( category2 );
				category2.projectSet = new ArrayCollection();
				category2.projectSet.addItem( model.project );
				model.catagory1.addItem( cat1 );
			}else
			{
				var cat2 : Categories = model.project.categories;
				var catagory1_Len:int=model.catagory1.length;
				for( var i : int = 0;i < catagory1_Len;i++)
				{
					var subCat : ArrayCollection = Categories( model.catagory1.getItemAt( i ) ).childCategorySet;
					var subCat_Len:int=subCat.length;
					
					for( var j : int = 0;j < subCat_Len;j++)
					{
						if( Categories( subCat.getItemAt( j ) ).categoryId == cat2.categoryId )
						{
							Categories( subCat.getItemAt( j ) ).projectSet.addItem( model.project );
						}
					}
				}
			} 
		} 
		public function getTeamLineOracleProjectResult( arrcoll:ArrayCollection ):void {
			model.teamlLineCollection = arrcoll;
			model.impPerson = Utils.getProfilePerson( 'EPR' );
			model.impPersonId = model.impPerson.personId;
			model.indPerson = Utils.getProfilePerson( 'IND' );
			model.indPersonId = model.indPerson.personId;
			model.cltPerson = Utils.getProfilePerson( 'CLT' );
			model.cltPersonId = model.cltPerson.personId; 
			model.CP_Person = Utils.getProfilePerson( 'CHP' );
			model.CPP_Person = Utils.getProfilePerson( "CPP" );
			model.comPerson = Utils.getProfilePerson( 'COM' );
			model.agencyPerson = Utils.getProfilePerson( 'AGN' );
			model.techPerson = Utils.getProfilePerson( 'BAT' );
			trace("getTeamLineOracleProjectResult calling");
		}
		
		public function createBulkUpdatePhasesResult( arrcoll:ArrayCollection ) : void
		{
			model.project.phasesSet = arrcoll;
			/* var intialTask : Tasks = new Tasks();
			var tasks : Tasks = new Tasks();
			intialTask.workflowtemplateFK = model.workflowstemplates;
			intialTask.projectObject = model.project;
			intialTask.taskComment = model.project.projectComment;
			var status : Status = new Status();
			status.statusId = TaskStatus.FINISHED;
			intialTask.taskStatusFK = status.statusId;
			intialTask.tDateCreation = model.currentTime;
			intialTask.tDateDeadline = model.currentTime;
			intialTask.tDateInprogress = model.currentTime;
			intialTask.tDateEnd = model.currentTime;
			intialTask.deadlineTime = 0;
			intialTask.onairTime = 0;
			intialTask.personDetails = model.person;
			model.currentTasks = intialTask; */
			trace("createBulkUpdatePhasesResult calling");
		} 
		public function createOracleBulkTasksResult( arrcoll:ArrayCollection ) : void {
			var localarrc:ArrayCollection = arrcoll;
				 
			model.createdTask = localarrc.getItemAt(0) as Tasks;
			model.currentTasks = model.createdTask 
			model.project = Tasks(localarrc.getItemAt(0)).projectObject;
			var arrc : ArrayCollection = model.project.propertiespjSet;
			for each(var item : Propertiespj in arrc) {
				item.projectFk = model.project.projectId;
			}
			model.propertiespjCollection =  arrc; 
			trace("createOracleBulkTasksResult calling");		

		}
		public function createOracleupdateResult( arrcoll:ArrayCollection ):void {
			//if( model.currentProjects.propertiespjSet.length == ArrayCollection( arrcoll ).length )
				model.currentProjects.propertiespjSet = ArrayCollection( arrcoll );
			//else
			//	model.currentProjects.propertiespjSet = Utils.modifyItems( model.currentProjects.propertiespjSet, ArrayCollection( arrcoll ), 'propertyPjId' );
			
			Utils.refreshPendingCollection( model.currentProjects );
			
			//Utils.refreshProject( model.currentProjects );
			//Utils.todoListUpdate();
		}
		public static var tempCategories:Categories;
		public function getOracleCategoryResult( arrcoll:ArrayCollection ):void {
			var arrc:ArrayCollection = arrcoll;
			var categories:Categories = arrc.getItemAt( 0 ) as Categories;
	  		model.categoriesCollection.addItem( categories );
	  		
	  		tempCategories = categories;
	  		
	  		/* Utils.tempPrj.categories = categories;
			Utils.refreshProject( Utils.tempPrj );
			Utils.todoListUpdate(); */
		}
		public function getOracleCategoryDomainResult( arrcoll:ArrayCollection ):void {
			var arrc:ArrayCollection = arrcoll;
			var categories:Categories = arrc.getItemAt( 0 ) as Categories;
	  		
	  		model.domain = categories;	
	  		tempCategories = categories;  		
		}
		public function getOracleCategory1Result( arrcoll:ArrayCollection ):void {
			var arrc:ArrayCollection = arrcoll;
			var categories:Categories = arrc.getItemAt( 0 ) as Categories;
	  		
	  		model.catagory1 = arrc;	  		
		}
		public function getOracleCategory2Result( arrcoll:ArrayCollection ):void {
			var arrc:ArrayCollection = arrcoll;
			var categories:Categories = arrc.getItemAt( 0 ) as Categories;
	  		
	  		model.catagory2 = arrc;	  		
		}
		
		
	}
}