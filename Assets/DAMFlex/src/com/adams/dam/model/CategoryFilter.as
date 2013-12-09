package com.adams.dam.model
{
	import com.adams.dam.model.vo.Categories;

	[Bindable]
	public class CategoryFilter
	{
		
		private var _categoryFilterName:String;
		public function get categoryFilterName():String {
			return _categoryFilterName;
		} 
		public function set categoryFilterName( value:String ):void {
			_categoryFilterName = value;
		}
		
		private var _categoryOne:Categories;
		public function get categoryOne():Categories {
			return _categoryOne;
		} 
		public function set categoryOne( value:Categories ):void {
			_categoryOne = value;
		}
		
		private var _categoryTwo:Categories;
		public function get categoryTwo():Categories {
			return _categoryTwo;
		} 
		public function set categoryTwo( value:Categories ):void {
			_categoryTwo = value;
		}
		
		public function CategoryFilter()
		{
		}
	}
}