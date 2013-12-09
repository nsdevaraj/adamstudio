package com.adams.dt.event
{
	import com.adams.dt.model.vo.Categories;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class CategoriesEvent extends UMEvent
	{
		
		public static const EVENT_CREATE_DOMAIN:String='createDomain';
		public static const EVENT_GET_ALL_CATEGORIESS:String='getAllCategories';
		public static const EVENT_GET_CATEGORIES:String='getCategories';
		public static const EVENT_CREATE_CATEGORIES:String='createCategories';
		public static const EVENT_UPDATE_CATEGORIES:String='updateCategories';
		public static const EVENT_DELETE_CATEGORIES:String='deleteCategories';
		public static const EVENT_SELECT_CATEGORIES:String='selectCategories';
		public static const EVENT_GET_DOMAIN:String='getDomain';
		public static const EVENT_CHECK_CATEGORIES:String='check';
		public static const EVENT_CREATE_BULKCATEGORIES:String='bullkUpdate';
		public static const EVENT_CREATE_CATEGORIES1:String='createCategory1';
		public static const EVENT_CREATE_CATEGORIES2:String='createCategory2';
		public static const EVENT_CHECK_CATEGORIES2:String='check1';
		public static const EVENT_CREATE_CATEGORIES1FOLDER:String='createCategoryFolder1';
		public static const EVENT_CREATE_CATEGORIES2FOLDER:String='createCategoryFolder2';
		public static const EVENT_CREATE_PROJECTFOLDER:String='createProjectFolder';
		public static const EVENT_CREATE_CATEGORIESFOLDER:String='createCategoryFolder';
		public static const EVENT_CREATE_BASICFOLDER:String='createBasicFolder';
		public static const EVENT_CREATE_TASKSFOLDER:String='createTasksFolder';
		public static const EVENT_CREATENEW_DOMAIN:String='createNewDomain';
		
		public static const EVENT_ORACLE_NEWPROJECT:String='oracleNewCateogories';
		public static const EVENT_ORACLE_NEWPROJECTCALL:String='oracleNewCateogoriescall';
		
		public var categories:Categories; 
		public var categoriesCollection:ArrayCollection;
		public var categoryId:int;
		public function CategoriesEvent (pType:String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false,pCategories:Categories=null){			
			categories= pCategories;
			super(pType,handlers,true,false,categories);			
		}		 

		
	}

}