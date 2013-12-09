package com.adams.dt.business.util
{
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Companies;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Phasestemplates;
	import com.adams.dt.model.vo.Presetstemplates;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.dt.model.vo.Status;
	import com.adams.dt.model.vo.Workflows;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class GetVOUtil
	{
		[Bindable]
		private static var model:ModelLocator = ModelLocator.getInstance(); 
		 
		private static var sort:Sort
		private static var dp:ArrayCollection;
		private static var cursor:IViewCursor;
		private static var found:Boolean;
		public static function getProjectObject( value:int):Projects{
            return getValueObject(value,'projectId',model.projectsCollection) as Projects;
		}  
		public static function getProfileObject( value:int):Profiles{
			return getValueObject(value,'profileId',model.teamProfileCollection) as Profiles;
		}
		public static function getPersonObject( value:int ):Persons {
			model.personsArrCollection.sort = null;
			return getValueObject( value, 'personId', model.personsArrCollection ) as Persons;
		}
		public static function getCategoryObject( value:int):Categories{
			model.categoriesCollection.sort = null;
			return getValueObject(value,'categoryId',model.categoriesCollection) as Categories;
		}
		public static function getWorkflowTemplate( value:int ):Workflowstemplates{
			return getValueObject( value,'workflowTemplateId',model.workflowstemplatesCollection ) as Workflowstemplates;
		}	
		public static function getPropertiesPresetObject( value:int):Propertiespresets{
			return getValueObject(value,'propertyPresetId',model.propertiespresetsCollection) as Propertiespresets;
		}
		public static function getPropertiesPresetFieldType( value:int):String{
			return Propertiespresets(getValueObject(value,'propertyPresetId',model.propertiespresetsCollection)).fieldType;
		}
		public static function getPresetTemplateObject( value:int):Presetstemplates{
			return getValueObject(value,'presetstemplateId',model.presetTempCollection) as Presetstemplates;
		}
		public static function getWorkflowObject( value:int):Workflows{
			return getValueObject(value,'workflowId',model.workflowsCollection) as Workflows;
		}
		public static function getPhaseTemplateObject( value:int):Phasestemplates{
			return getValueObject(value,'phaseTemplateId',model.allPhasestemplatesCollection) as Phasestemplates;
		}
		public static function getStatusObject( value:int):Status{ 
			return getValueObject(value,'statusId',model.getAllStatusColl) as Status;
		}
		public static function getCompanyObject( value:int):Companies{
			model.totalCompaniesColl.sort = null;
			return getValueObject(value,'companyid',model.totalCompaniesColl) as Companies;
		}
		public static function getCompanyObjectCode(companycode : String) : Companies
		{
			var item:IValueObject = new Companies();
			var arrc:ArrayCollection = model.totalCompaniesColl;
			arrc.sort = null;
			Companies(item).companycode = companycode;
			return GetVOUtil.getGenValueObject(item,'companycode',arrc) as Companies;
		}
		public static function getCategoryObjectCode(categorycode : String) : Categories
		{
			var item:IValueObject = new Categories();
			var arrc:ArrayCollection = model.categoriesCollection;
			arrc.sort = null;
			Categories(item).categoryCode = categorycode;
			return GetVOUtil.getGenValueObject(item,'categoryCode',arrc) as Categories;
		}
		public static function getPersonObjectLogin(username: String) : Persons
		{
			var item:IValueObject = new Persons();
			var arrc:ArrayCollection = model.personsArrCollection;
			arrc.sort = null;
			Persons(item).personLogin = username;
			return GetVOUtil.getGenValueObject(item,'personLogin',arrc) as Persons;
		}
		public static function getGenValueObject( item:IValueObject,sortField:String,arrc:ArrayCollection ):IValueObject{
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

		private static function getValueObject( value:int,sortField:String,arrc:ArrayCollection ):IValueObject{
			sort = new Sort(); 
            sort.fields = [ new SortField( sortField ) ];
            dp = arrc;
          	trace("getValueObject :"+value+" , sortField :"+sortField+" , arrc :"+arrc.length);

            if( dp.sort == null ) {
           	 	dp.sort = sort;
            	dp.refresh(); 
            }
			cursor =  dp.createCursor();
			var item:IValueObject;
			switch(sortField){
				case 'companyid':
					item = new Companies();
					Companies(item).companyid = value;
					break;
				case 'workflowId':
					item = new Workflows();
					Workflows(item).workflowId = value;
					break;
				case 'phaseTemplateId':
					item = new Phasestemplates();
					Phasestemplates(item).phaseTemplateId = value;
					break;
				case 'propertyPresetId':
					item = new Propertiespresets();
					Propertiespresets(item).propertyPresetId = value;
					break;
				case 'workflowTemplateId':
					item = new Workflowstemplates();
					Workflowstemplates(item).workflowTemplateId = value;
					break;
				case 'categoryId':
					item = new Categories();
					Categories(item).categoryId = value;
					break;
				case 'personId':
					item = new Persons();
					Persons(item).personId = value;
					break;
				case 'profileId':
					item = new Profiles();
					Profiles(item).profileId = value;
					break;
				case 'projectId':
					item = new Projects();
					Projects(item).projectId = value;
					break;
				case 'presetstemplateId':
					item = new Presetstemplates();
					Presetstemplates(item).presetstemplateId = value;
				break;
					
				default:
					break;
			}
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
	}
}