package com.adams.dam.business.utils
{
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.Categories;
	import com.adams.dam.model.vo.Persons;
	import com.adams.dam.model.vo.Projects;
	
	import mx.collections.ArrayCollection;

	public class VOUtils
	{
		
		private static var model:ModelLocator = ModelLocator.getInstance();
		
		public static function getPersonObjectLogin( username:String, totalCollection:ArrayCollection ):Persons {
			for each( var item:Persons in totalCollection ) {
				if( item.personLogin == username ) {
					return item;
				}
			}
			return null;
		}
		
		public static function getProjectObject( id:int ):Projects {
			for each( var prj:Projects in model.totalProjectsCollection ) {
				if( prj.projectId == id ) {
					return prj;
				}
			}
			return null;
		}
		
		public static function getCategoryObject( categoryTwoId:int ):Categories {
			for each( var item:Categories in model.categoryTwoCollection ) {
				if( item.categoryId == categoryTwoId ) {
					return item;
				}
			}
			return null;
		}
		
		public static function filterFunction( obj:Object, property:String ):String {
			var value:String;
			switch( property ) {
				case 'Project Name':
					value = getProjectObject( obj.projectFK ).projectName;
					break;
				default:
					break;
			}
			return value;
		} 
	}
}