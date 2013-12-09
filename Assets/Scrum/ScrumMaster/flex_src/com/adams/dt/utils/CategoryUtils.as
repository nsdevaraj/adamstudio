package com.adams.dt.utils
{
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.IValueObject;
	
	import mx.collections.ArrayCollection;

	public class CategoryUtils
	{ 
		
		private static var monthYearName:String; 
		//check current month year available for Domain
		public static function checkCategory(categories : Categories, monthYear:String, arrc:ArrayCollection):Categories{
			var returnVal:Categories 
			monthYearName = monthYear;
			arrc.filterFunction = checkMonthYear;
			arrc.refresh();
			for each(var cat:Categories in arrc){ 
				if(getDomains(cat).categoryId == categories.categoryId){
					returnVal = cat;
				}
			}
			arrc.filterFunction = null;
			arrc.refresh();
			return returnVal;
		}
		// filter Function to get the Current Month category
		private static function checkMonthYear(item:Categories):Boolean{
			var returnVal:Boolean
			if(item.categoryName == monthYearName) returnVal=true;
			return returnVal;	
		}
		//get Domain of any Category
		public static function getDomains(categories : Categories) : Categories
		{
			var tempCategories : Categories = new Categories(); 
			if(categories.categoryFK != null)
			{
				tempCategories = getDomains(categories.categoryFK);
			}else
			{
				return categories;
			}
			return tempCategories;
		}
		
		public static function getCategory(categoryCode : String) : Categories
		{
			var item:IValueObject = new Categories();
			var arrc:ArrayCollection = GetVOUtil.categoryList.items as ArrayCollection;
			arrc.sort = null;
			Categories(item).categoryCode = categoryCode;
			return GetVOUtil.getValueObject(item,'categoryCode',arrc) as Categories;
		}  
	}
}