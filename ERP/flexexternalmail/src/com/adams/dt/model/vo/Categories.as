package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.Categories")]	
	[Bindable]
	public final class Categories implements IValueObject
	{
		private var _categoryId : int;
		private var _categoryName : String;
		private var _categoryCode : String;
		private var _categoryFK : Categories;
		private var _domain : Categories;
		private var _projectSet : ArrayCollection = new ArrayCollection(); 
		private var _domainworkflowSet : ArrayCollection = new ArrayCollection();
		private var _childCategorySet : ArrayCollection = new ArrayCollection();
		private var _itemIsProject : Boolean;
		public function get itemIsProject() : Boolean
		{
			return _itemIsProject;
		}

		public function set itemIsProject(o : Boolean) : void
		{
			_itemIsProject = o;
		}

		public function Categories()
		{
		}

		public function get domain() : Categories
		{
			return _domain;
		}

		public function set domain(pData : Categories) : void
		{
			_domain = pData;
		}

		public function get categoryFK() : Categories
		{
			return _categoryFK;
		}

		public function set categoryFK(pData : Categories) : void
		{
			_categoryFK = pData;
		}

		public function get categoryId() : int
		{
			return _categoryId;
		}

		public function set categoryId(pData : int) : void
		{
			_categoryId = pData;
		}

		public function get categoryName() : String
		{
			return _categoryName;
		}

		public function set categoryName(pData : String) : void
		{
			_categoryName = pData;
		}

		public function get categoryCode() : String
		{
			return _categoryCode;
		}

		public function set categoryCode(pData : String) : void
		{
			_categoryCode = pData;
		}
 
		public function get domainworkflowSet() : ArrayCollection
		{
			return _domainworkflowSet;
		}

		public function set domainworkflowSet(pData : ArrayCollection) : void
		{
			_domainworkflowSet = pData;
		}

		public function get projectSet() : ArrayCollection
		{
			return _projectSet;
		}

		public function set projectSet(pData : ArrayCollection) : void
		{
			_projectSet = pData;
		}
		public function get childCategorySet() : ArrayCollection
		{
			return _childCategorySet;
		}

		public function set childCategorySet(pData : ArrayCollection) : void
		{
			_childCategorySet = pData;
		}
		

		private var _categoryStartDate : Date;
		public function set categoryStartDate (value : Date) : void
		{
			_categoryStartDate = value;
		}

		public function get categoryStartDate () : Date
		{
			return _categoryStartDate;
		}
		

		private var _categoryEndDate : Date;
		public function set categoryEndDate (value : Date) : void
		{
			_categoryEndDate = value;
		}

		public function get categoryEndDate () : Date
		{
			return _categoryEndDate;
		}
 	}
}
