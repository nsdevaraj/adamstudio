package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.LoginUtils;
	import com.adams.dt.business.util.StringUtils;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.CategoriesEvent;
	import com.adams.dt.event.DomainWorkFlowEvent;
	import com.adams.dt.event.ProjectsEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.DomainWorkflow;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class CategoriesCommand extends AbstractCommand 
	{
		private var dirStr:String='';
		private var categories2:Categories;
		private var categories1:Categories;
		private var projects:Projects;
		private var categories:Categories;
		private var categoriesEvent : CategoriesEvent 
		override public function execute( event : CairngormEvent ) : void
		{	
			super.execute(event);
			categoriesEvent = CategoriesEvent(event);
			this.delegate = DelegateLocator.getInstance().categoryDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){
				case CategoriesEvent.EVENT_CREATE_CATEGORIES:
					delegate.responder = new Callbacks(createCategoriesResult,fault);
					delegate.create(categoriesEvent.categories);
					break;     
				case CategoriesEvent.EVENT_CREATE_DOMAIN:
					delegate.responder = new Callbacks(createDomainResult,fault);
					delegate.create(categoriesEvent.categories);
					break;  
				case CategoriesEvent.EVENT_CREATENEW_DOMAIN:
					delegate.responder = new Callbacks(createNewDomainResult,fault);
					delegate.create(categoriesEvent.categories);
					break;                 
				case CategoriesEvent.EVENT_DELETE_CATEGORIES:
					delegate.deleteVO(categoriesEvent.categories);
					break;                   
				case CategoriesEvent.EVENT_GET_ALL_CATEGORIESS:
					delegate.responder = new Callbacks(collectDomainResult,fault);
					delegate.findAll();
					break;                   
				case CategoriesEvent.EVENT_GET_CATEGORIES:
					delegate.responder = new Callbacks( getCategoryResult, fault );
					delegate.findById( categoriesEvent.categoryId );
					break;                   
				case CategoriesEvent.EVENT_SELECT_CATEGORIES:
					delegate.select(categoriesEvent.categories);
					break;                   
				case CategoriesEvent.EVENT_UPDATE_CATEGORIES:
					delegate.update(categoriesEvent.categories);
					break;                   
				case CategoriesEvent.EVENT_GET_DOMAIN:
					delegate.responder = new Callbacks(getDomainResult,fault);
					delegate.findDomain(GetVOUtil.getCompanyObject(model.person.companyFk).companycode);
					break;
				//check categories1 using name       
				case CategoriesEvent.EVENT_CHECK_CATEGORIES:
					categories2 =  model.categories2;
					categories1 = model.categories1;	
					delegate.responder = new Callbacks(checkCategoriesResult,fault);	
					trace("EVENT_CHECK_CATEGORIES :"+categories1.categoryId+"***"+categories1.categoryName+" --- "+categories2.categoryId+"***"+categories2.categoryName);
					delegate.findByName(categories1.categoryName);
					break;  
				//check categories2 using name  and category 1 id                   
				case CategoriesEvent.EVENT_CHECK_CATEGORIES2:
					categories2 =  model.categories2;
					model.categories2.categoryFK = model.categories1;
					categories1 = model.categories1;	
					delegate.responder = new Callbacks(checkCategoriesTwoResult,fault);	
					trace("EVENT_CHECK_CATEGORIES2 :"+model.categories2.categoryName+"***"+model.categories2.categoryFK.categoryId);
					delegate.findByNameId(model.categories2.categoryName,model.categories2.categoryFK.categoryId);
					break;                   
				case CategoriesEvent.EVENT_CREATE_CATEGORIES1:
					categories2 = model.categories2;
					delegate.responder = new Callbacks(createCategoryOneResult,fault);
					trace("EVENT_CREATE_CATEGORIES1 :"+model.categories1.categoryName);
					delegate.create(model.categories1);  
					break;                   
				case CategoriesEvent.EVENT_CREATE_CATEGORIES2:
					delegate.responder = new Callbacks(createCategoryTwoResult,fault);
					model.categories2.categoryFK  = model.categories1;
					trace("EVENT_CREATE_CATEGORIES2 :"+model.categories2.categoryName);
					delegate.create(model.categories2);
					break;                   
				case CategoriesEvent.EVENT_CREATE_CATEGORIES1FOLDER:
					delegate = DelegateLocator.getInstance().directoryDelegate;
					categories2 = model.categories2;
					delegate.responder = new Callbacks(createCategoryOneDirectoryResult,fault);
					trace("EVENT_CREATE_CATEGORIES1FOLDER :"+model.parentFolderName+model.domain.categoryName+"***"+categories2.categoryFK.categoryName);
					delegate.createSubDir(model.parentFolderName+model.domain.categoryName,categories2.categoryFK.categoryName);      
					break;                   
				case CategoriesEvent.EVENT_CREATE_CATEGORIES2FOLDER:
					delegate = DelegateLocator.getInstance().directoryDelegate;
					categories2 =  model.categories2;
					delegate.responder = new Callbacks(createCategoryTwoDirectoryResult,fault);
					trace("EVENT_CREATE_CATEGORIES2FOLDER :"+model.parentFolderName+model.domain.categoryName+"/"+categories2.categoryFK.categoryName+"***"+categories2.categoryName);
					delegate.createSubDir(model.parentFolderName+model.domain.categoryName+"/"+categories2.categoryFK.categoryName,categories2.categoryName);     
					break;                   
				case CategoriesEvent.EVENT_CREATE_PROJECTFOLDER:
					delegate = DelegateLocator.getInstance().directoryDelegate;
					delegate.responder = new Callbacks(createProjectsFolderResult,fault);
					model.categories2.categoryFK = model.categories1;
					categories2 = model.categories2;		
					dirStr = model.parentFolderName+model.domain.categoryName+"/"+categories2.categoryFK.categoryName+"/"+categories2.categoryName+"/"+StringUtils.compatibleTrim(model.newProject.projectName)
					model.currentDir = dirStr;
					delegate.createSubDir(model.parentFolderName+model.domain.categoryName+"/"+categories2.categoryFK.categoryName+"/"+categories2.categoryName,StringUtils.compatibleTrim(model.newProject.projectName));
					break;                   
				case CategoriesEvent.EVENT_CREATE_CATEGORIESFOLDER:
					var dirName:String = categoriesEvent.categories.categoryName;
					var parentFolderName:String = model.parentFolderName;
					var domainName:String = Utils.getDomains(categoriesEvent.categories).categoryName;
					var folder:String = getOtherFolder(categoriesEvent.categories);
					break;                   
				case CategoriesEvent.EVENT_CREATE_BASICFOLDER:
					delegate = DelegateLocator.getInstance().directoryDelegate;
					categories2 = model.categories2;
					delegate.responder = new Callbacks(createBasicFolderResult,fault);					
					delegate.createSubDir(model.currentDir,"Basic");
					break;                   
				case CategoriesEvent.EVENT_CREATE_TASKSFOLDER:
					delegate = DelegateLocator.getInstance().directoryDelegate;
					delegate.responder = new Callbacks(createTasksFolderResult,fault);
					categories2 = model.categories2;		
					delegate.createSubDir(model.currentDir,"Tasks");
					break;        
				default:
					break; 
				}
		}
		
		private function getCategoryResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			var categories:Categories = arrc.getItemAt( 0 ) as Categories;
	  		model.categoriesCollection.addItem( categories );
	  		Utils.tempPrj.categories = categories;
			Utils.refreshProject( Utils.tempPrj );
			Utils.todoListUpdate();
		}
		/**
	  	 * check the categories2 is exist or not
	  	 * IF EXIST create the folders and create the project
	  	 * ELSE create the create the categor2,folders,projects
	  	 */
		public function checkCategoriesTwoResult( rpcEvent : Object ) : void {
					
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			var eventsArr:Array = [];
			var categroies:Categories;
			var createprojectfolderevent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_PROJECTFOLDER);
			var createbasicfolderevent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_BASICFOLDER);
			var createtaskfolderevent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_TASKSFOLDER);
			var newProjectevent:ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_CREATE_PROJECTS);
			
			var createcategory2event:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_CATEGORIES2);
			var createcate2folderevent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_CATEGORIES2FOLDER);

			if(arrc.length>0){
				model.categories2 = arrc.getItemAt(0) as Categories;
				model.newProject.categories = model.categories2;
				eventsArr.push(createprojectfolderevent,createbasicfolderevent,createtaskfolderevent,newProjectevent);
			}else{
				eventsArr.push(createcategory2event,createcate2folderevent,createprojectfolderevent,createbasicfolderevent,createtaskfolderevent,newProjectevent);
			}
			var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch();
	  		super.result(rpcEvent);	
	  	}  
	  	 
	  	public function collectDomainResult( rpcEvent : Object ) : void {
	  		super.result(rpcEvent);
  		
	  		model.categoriesCollection.source = ArrayCollection(rpcEvent.result).source
	  		model.collectAllDomains = rpcEvent.result as ArrayCollection;
	  		model.collectAllDomains.filterFunction = getDomainsOnly;
	  		model.collectAllDomains.refresh();
			model.domain = GetVOUtil.getCategoryObjectCode(GetVOUtil.getCompanyObject(model.person.companyFk).companycode);
			if(model.domain.categoryId!=0){
				var profile : Profiles = new Profiles();
				profile.profileId = 2;
				profile.profileCode = 'CLT'
				model.profilesCollection.addItem(profile);
				model.domainCollection.addItem(model.domain);
			}
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
	  	/**
	  	 * check the categories1 is exist or not
	  	 * IF EXIST check the categories2 is exist or not
	  	 * ELSE create the category1,category1 folder, category2, category2 folder, project folder,basic folder, task folder
	  	 * and finally create the projects
	  	 */
		public function checkCategoriesResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			var eventsArr:Array = [];			
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			var categroies:Categories;
	
			var createprojectfolderevent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_PROJECTFOLDER);
			var createbasicfolderevent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_BASICFOLDER);
			var createtaskfolderevent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_TASKSFOLDER);
			var newProjectevent:ProjectsEvent = new ProjectsEvent(ProjectsEvent.EVENT_CREATE_PROJECTS);
			var checkcategories2event:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CHECK_CATEGORIES2);
			var createcategory1event:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_CATEGORIES1);
			var createcat1folderevent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_CATEGORIES1FOLDER);
			var createcategory2event:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_CATEGORIES2);
			var createcate2folderevent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_CATEGORIES2FOLDER);
			if(arrc!=null&&arrc.length>0){ 
				trace("1st If checkCategoriesResult getCategroies calling");
				categroies = getCategroies(arrc);
			}
			if(categroies!=null){
				model.categories1 = categroies;
				trace("2nd If checkCategoriesResult getCategroies calling"+model.categories1.categoryId+"--"+model.categories1.categoryName);
				if(categories2==null){
					trace("2nd inner If checkCategoriesResult getCategroies calling");
					eventsArr.push(createprojectfolderevent,createbasicfolderevent,createtaskfolderevent,newProjectevent);
				}else{
					categories2.categoryFK = categroies;
					model.categories2 = categories2;
					eventsArr.push(checkcategories2event);
					trace("2nd inner else checkCategoriesResult getCategroies calling"+categories2.categoryFK);					
				}
			}else{ 
				trace("2nd outer else checkCategoriesResult getCategroies calling");					
				eventsArr.push(createcategory1event,createcat1folderevent,createcategory2event,createcate2folderevent,createprojectfolderevent,createbasicfolderevent,createtaskfolderevent,newProjectevent);
			}
			var handler:IResponder = new Callbacks(result,fault)
	 		var newProjectSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	  		newProjectSeq.dispatch();
		} 
		public function getCategroies(arrc:ArrayCollection):Categories{
			for each(var item:Categories in arrc){
				if(item.categoryFK.categoryId == model.domain.categoryId){
					return item;
				}
			}
			return null;
		}
		/**
		 * create category 1 folder
		 */
		public function createCategoryTwoDirectoryResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
		}
		/**
		 * create category 2 folder
		 */
		public function createCategoryOneDirectoryResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);	
	 	} 
	 	/**
		 * create category 2 
		 */
		public function createCategoryTwoResult( rpcEvent : Object ) : void {
			var categories:Categories = rpcEvent.result as Categories;
			model.categoriesCollection.addItem(categories);
			categories.categoryFK = model.categories1;
			model.categories2= 	categories;
			model.newProject.categories = model.categories2;
			super.result(rpcEvent);
		}
		/**
		 * create category 1 
		 */
		public function createCategoryOneResult( rpcEvent : Object ) : void {	
			var category:Categories = Categories(rpcEvent.result);
			model.categoriesCollection.addItem(category);
			categories2.categoryFK = category;
			model.categories1 = category;
			model.categories2 = categories2;
			super.result(rpcEvent);	
		} 
		/**
		 * create the Basic folder
		 */  
		public function createBasicFolderResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
		}
		/**
		 * create the project folder
		 */  
		public function createProjectsFolderResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
		}
		/**
		 * create the teask folder
		 */  
		public function createTasksFolderResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
		}
		/**
		 * the result will be used for only client to create the project. 
		 */  
		public function getDomainResult( rpcEvent : Object ) : void
		{
			model.domainCollection = ArrayCollection(rpcEvent.result);
			if(model.domainCollection.length > 0)
			{
				var profile : Profiles = new Profiles()
				profile.profileId = 2;
				profile.profileCode = 'CLT'
				model.profilesCollection.addItem(profile);
				model.domain = Categories(ArrayCollection(rpcEvent.result).getItemAt(0));
			}
			super.result(rpcEvent);
		}
		/**
		 * get the folder path. 
		 */  
		public function getOtherFolder(categories:Categories):String{
 			var tempCategories:Categories = new Categories(); 			
 			if(categories.categoryFK != null){
 				dirStr = categories.categoryFK.categoryName+"/"+dirStr; 				
 				getOtherFolder(categories.categoryFK);
 			}else{
 				dirStr = categories.categoryName+"/"+dirStr; 
 			}
 			return dirStr;
 		}
 		
 		public function createDomainResult( rpcEvent : Object ) : void {
	  		super.result(rpcEvent);
	  		var categories : Categories = rpcEvent.result as Categories;
	  		var catArr:ArrayCollection = rpcEvent.result as ArrayCollection;
	  		model.categoriesCollection.addItem(categories);
	  		var domainEvent:DomainWorkFlowEvent  = new DomainWorkFlowEvent(DomainWorkFlowEvent.BULK_UPDATE_DOMAIN_WORKLFLOW);
			domainEvent.domainWorkFLowArr = model.selectedDomainWorkflows;
			for each(var dw:DomainWorkflow in model.selectedDomainWorkflows){
				dw.domainFk = categories.categoryId;
			}
			var handler:IResponder = new Callbacks(result,fault);
	  		var domainworkflowCreateSeq:SequenceGenerator = new SequenceGenerator([domainEvent],handler)
	  		domainworkflowCreateSeq.dispatch();
	  	}
	  	public function createNewDomainResult( rpcEvent : Object ) : void {
	  		super.result(rpcEvent);
	  		var categories : Categories = rpcEvent.result as Categories;
	  		var catArr:ArrayCollection = rpcEvent.result as ArrayCollection;
	  		model.collectAllDomains.addItem(categories);
			var domainEvent:DomainWorkFlowEvent  = new DomainWorkFlowEvent(DomainWorkFlowEvent.BULK_UPDATE_DOMAIN_WORKLFLOW);
			domainEvent.domainWorkFLowArr = model.selectedDomainWorkflows;
			for each(var dw:DomainWorkflow in model.selectedDomainWorkflows){
				dw.domainWorkflowId = NaN;
				dw.domainFk = categories.categoryId;
			}
			var handler:IResponder = new Callbacks(result,fault);
	  		var domainworkflowCreateSeq:SequenceGenerator = new SequenceGenerator([domainEvent],handler)
	  		domainworkflowCreateSeq.dispatch();
	  	}
	  	/**
		 * Create new categories. 
		 */
		public function createCategoriesResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var categories : Categories = rpcEvent.result as Categories;
			model.categoriesCollection.addItem(categories);
			if(model.selectedCategory1 == null)
			{
				model.selectedCategory1 = categories;
				model.selectedCategory1.childCategorySet = new ArrayCollection();
				var domain : Categories = Utils.getDomains(model.selectedCategory1)
				var updated : Boolean = updateDomain(domain);
				model.catagory1.addItem(model.selectedCategory1);
			}else if(model.selectedCategory2 == null)
			{
				var arrC : ArrayCollection = new ArrayCollection();
				model.selectedCategory2 = categories;
				model.catagory2.addItem(model.selectedCategory2);
			}
			var event:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_CREATE_CATEGORIESFOLDER);
			event.categories = categories;
	      	var handler:IResponder = new Callbacks(result,fault)
	 		var categorySelectionSeq:SequenceGenerator = new SequenceGenerator([event],handler)
	  		categorySelectionSeq.dispatch(); 
		}
		private function updateDomain(domain : Categories) : Boolean
		{
			var domainCollection1_Len:int=model.domainCollection1.length;
			for(var i : int = 0;i < domainCollection1_Len;i++)
			{
				var cat : Categories = model.domainCollection1.getItemAt(i) as Categories
				if(domain.categoryId == cat.categoryId)
				{
					Categories(model.domainCollection1.getItemAt(i)).childCategorySet.addItem(model.selectedCategory1);
					return true;
				}
			}
			return false;
		}	 
 	}
}
