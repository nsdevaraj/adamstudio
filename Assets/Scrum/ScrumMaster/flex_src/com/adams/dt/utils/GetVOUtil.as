package com.adams.dt.utils
{  
	
	import com.adams.dt.*;
	import com.adams.dt.model.collections.*;
	import com.adams.dt.model.vo.*;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class GetVOUtil
	{  
		private static var sort:Sort
		private static var dp:ArrayCollection;
		private static var cursor:IViewCursor;
		private static var found:Boolean; 
		
		public static function getPersonObject( username:String, password:String,arrc:ArrayCollection):Persons{
			var item:IValueObject = new Persons();
			Persons(item).personLogin = username;
			Persons(item).personPassword = password;
			var returnPerson:Persons = getValueObject(item,'personLogin',arrc) as Persons;
			arrc.sort = null;
			return returnPerson; 
		}  
		public static function getVOObject( pkId:int, List:ICollection, primaryKey:String, clz:Class):IValueObject{
			var item:IValueObject = new clz();
			clz(item)[primaryKey] = pkId;
			var returnClz :IValueObject;
			if(List)
				returnClz = getValueObject(item,primaryKey, List.items as ArrayCollection) as IValueObject;
			return returnClz;
		} 
		public static function getValueObject( item:IValueObject,sortField:String,arrc:ArrayCollection ):IValueObject{
			sort = new Sort(); 
            sort.fields = [ new SortField( sortField ) ];
            dp = arrc;
            if( dp.sort == null ) {
           	 	dp.sort = sort;
            	dp.refresh(); 
            }
			cursor =  dp.createCursor(); 
			try{
				found = cursor.findAny( item );
			}
			catch(err:Error){
				
			}finally{
				if ( found )  {
					item = IValueObject( cursor.current ); 
				}
				return item;
			} 
		}
		[Bindable]
		public static var selectedWFTemplateID:int;
		
		public static var closeProjectTemplate:ArrayCollection = new ArrayCollection();
		public static var modelAnnulationWorkflowTemplate:ArrayCollection = new ArrayCollection();
		public static var firstRelease:ArrayCollection = new ArrayCollection();
		public static var otherRelease:ArrayCollection = new ArrayCollection();
		public static var fileAccessTemplates:ArrayCollection = new ArrayCollection();
		public static var messageTemplatesCollection:ArrayCollection = new ArrayCollection();
		public static var versionLoop:ArrayCollection = new ArrayCollection();
		public static var standByTemplatesCollection:ArrayCollection = new ArrayCollection();
		public static var alarmTemplatesCollection:ArrayCollection = new ArrayCollection();
		public static var sendImpMailTemplatesCollection:ArrayCollection = new ArrayCollection();
		public static var indReaderMailTemplatesCollection:ArrayCollection = new ArrayCollection(); 
		public static var checkImpremiurCollection:ArrayCollection = new ArrayCollection();
		public static var impValidCollection :ArrayCollection= new ArrayCollection();
		public static var indValidCollection :ArrayCollection= new ArrayCollection();
		
		public static var moduleList:ModuleCollection; 
		public static var categoryList:CategoryCollection; 
		public static var projectList:ProjectCollection;
		[Bindable]
		public static var profileList:ProfileCollection;
		[Bindable]
		public static var workflowList:WorkflowCollection;
		public static var personList:PersonCollection;
		public static var workflowTemplateList:WorkflowTemplateCollection;
		public static var companyList:CompanyCollection;
		[Bindable]
		public static var phaseTemplateList:PhasesTemplateCollection;
		public static var statusList:StatusCollection;
		public static var presetTemplateList:PresetsTemplatesCollection;
		public static var propertyPresetList:PropertiesPresetCollection;
	}
}