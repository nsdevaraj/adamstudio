package com.adams.dam.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias = "com.adams.dt.pojo.Categories")]	
	[Bindable]
	public final class Categories implements IValueObject
	{
		private var _categoryId:int;
		public function get categoryId():int {
			return _categoryId;
		}
		public function set categoryId( value:int ):void {
			_categoryId = value;
		}
		
		private var _itemIsProject:Boolean;
		public function get itemIsProject():Boolean {
			return _itemIsProject;
		}
		public function set itemIsProject( value:Boolean ):void 	{
			_itemIsProject = value;
		}
		
		private var _domain:Categories;
		public function get domain():Categories {
			return _domain;
		}
		public function set domain( value:Categories ):void {
			_domain = value;
		}
		
		private var _categoryFK:Categories;
		public function get categoryFK():Categories {
			return _categoryFK;
		}
		public function set categoryFK( value:Categories ):void {
			_categoryFK = value;
		}
		
		private var _categoryName:String;
		public function get categoryName():String {
			return _categoryName;
		}
		public function set categoryName( value:String ):void {
			_categoryName = value;
		}

		private var _categoryCode:String;
		public function get categoryCode():String {
			return _categoryCode;
		}
		public function set categoryCode( value:String ):void {
			_categoryCode = value;
		}
 		
		private var _domainworkflowSet:ArrayCollection = new ArrayCollection();
		public function get domainworkflowSet():ArrayCollection {
			return _domainworkflowSet;
		}
		public function set domainworkflowSet( value:ArrayCollection ):void {
			_domainworkflowSet = value;
		}
		
		private var _projectSet:ArrayCollection = new ArrayCollection(); 
		public function get projectSet():ArrayCollection {
			return _projectSet;
		}
		public function set projectSet( value:ArrayCollection ):void {
			_projectSet = value;
		}
		
		private var _childCategorySet:ArrayCollection = new ArrayCollection();
		public function get childCategorySet():ArrayCollection {
			return _childCategorySet;
		}
		public function set childCategorySet( value:ArrayCollection ):void {
			_childCategorySet = value;
		}
		
		private var _categoryStartDate:Date;
		public function get categoryStartDate():Date {
			return _categoryStartDate;
		}
		public function set categoryStartDate( value:Date ):void {
			_categoryStartDate = value;
		}
		
		private var _categoryEndDate:Date;
		public function get categoryEndDate():Date {
			return _categoryEndDate;
		}
		public function set categoryEndDate( value:Date ):void 	{
			_categoryEndDate = value;
		}
		
		public function Categories()
		{
			
		}
 	}
}
