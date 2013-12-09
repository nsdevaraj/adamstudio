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
            return model.currentProjects;
		} 
		public static function getProfileObject( value:int):Profiles{
			return getValueObject(value,'profileId',model.teamProfileCollection) as Profiles;
		}
		public static function getPersonObject( value:int):Persons{
			return getValueObject(value,'personId',model.personsArrCollection) as Persons;
		}
		public static function getCategoryObject( value:int):Categories{
			return getValueObject(value,'categoryId',model.categoriesCollection) as Categories;
		}
		public static function getWorkflowTemplate( value:int):Workflowstemplates{
			return getValueObject(value,'workflowTemplateId',model.workflowstemplatesCollection) as Workflowstemplates;
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
		 public static function getCompanyObject( value:int):Companies{
			return getValueObject(value,'companyid',model.totalCompaniesColl) as Companies;
		} 
		private static function getValueObject( value:int,sortField:String,arrc:ArrayCollection ):IValueObject{
			sort = new Sort(); 
            sort.fields = [ new SortField( sortField ) ];
            dp = arrc;
            dp.sort = sort;
            dp.refresh(); 
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