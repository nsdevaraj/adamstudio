/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.model.processor
{
	import com.adams.dt.model.vo.Categories;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;

	public class CategoriesProcessor extends AbstractProcessor
	{   
		
		public function CategoriesProcessor()
		{
			super();
		}
		
		//@TODO
		override public function processVO( vo:IValueObject ):void {
			if( !vo.processed ) {
				var categoriesvo:Categories = vo as Categories;
				categoriesvo.domain = getCategories(categoriesvo)
				super.processVO( vo );
			}
		}
		
		private function getCategories(categories : Categories) : Categories
		{
			var tempCategories : Categories = new Categories(); 
			if(categories.categoryFK != null)
			{
				tempCategories = getCategories(categories.categoryFK);
			}else
			{
				return categories;
			}
			return tempCategories;
		}
	}
}