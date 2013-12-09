package com.adams.scrum.models.vo
{
	import com.adams.scrum.dao.AbstractDAO;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Products')]
	public class Products extends AbstractVO
	{
		private var _domainObject:Domains 
		private var _statusObject:Status;

		public function get productTaskTypeArr():Array
		{
			return _productTaskTypeArr;
		}

		public function set productTaskTypeArr(value:Array):void
		{
			_productTaskTypeArr = value;
		}

		public function get productRolesArr():Array
		{
			return _productRolesArr;
		}

		public function set productRolesArr(value:Array):void
		{
			_productRolesArr = value;
		}

		public function get statusObject():Status
		{
			return _statusObject;
		}

		public function set statusObject(value:Status):void
		{
			_statusObject = value;
		}

		public function get domainObject():Domains
		{
			return _domainObject;
		}

		public function set domainObject(value:Domains):void
		{
			_domainObject = value;
		}

		public function get storyCollection():ArrayCollection
		{
			return _storyCollection;
		}
		
		public function set storyCollection(value:ArrayCollection):void
		{
			_storyCollection = value;
		}
		
		public function get sprintCollection():ArrayCollection
		{
			return _sprintCollection;
		}
		
		public function set sprintCollection(value:ArrayCollection):void
		{
			_sprintCollection = value;
		}
		
		public function get versionSet():ArrayCollection
		{
			return _versionSet;
		}
		
		public function set versionSet(value:ArrayCollection):void
		{
			_versionSet = value;
		}
		
		public function get themeSet():ArrayCollection
		{
			return _themeSet;
		}
		
		public function set themeSet(value:ArrayCollection):void
		{
			_themeSet = value;
		}
		
		public function get productTasktypes():ByteArray
		{
			return _productTasktypes;
		}
		
		public function set productTasktypes(value:ByteArray):void
		{
			_productTasktypes = value;
		}
		
		public function get productStatusFk():int
		{
			return _productStatusFk;
		}
		
		public function set productStatusFk(value:int):void
		{
			_productStatusFk = value;
		}
		
		public function get productRoles():ByteArray
		{
			return _productRoles;
		}
		
		public function set productRoles(value:ByteArray):void
		{
			_productRoles = value;
		}
		
		public function get productName():String
		{
			return _productName;
		}
		
		public function set productName(value:String):void
		{
			_productName = value;
		}
		
		public function get productId():int
		{
			return _productId;
		}
		
		public function set productId(value:int):void
		{
			_productId = value;
		}
		
		public function get productDateStart():Date
		{
			return _productDateStart;
		}
		
		public function set productDateStart(value:Date):void
		{
			_productDateStart = value;
		}
		
		public function get productDateEnd():Date
		{
			return _productDateEnd;
		}
		
		public function set productDateEnd(value:Date):void
		{
			_productDateEnd = value;
		}
		
		public function get productComment():ByteArray
		{
			return _productComment;
		}
		
		public function set productComment(value:ByteArray):void
		{
			_productComment = value;
		}
		
		public function get productCode():String
		{
			return _productCode;
		}
		
		public function set productCode(value:String):void
		{
			_productCode = value;
		}
		
		public function get domainFk():int
		{
			return _domainFk;
		}
		
		public function set domainFk(value:int):void
		{
			_domainFk = value;
		}
		
		private var _domainFk:int;
		private var _productCode:String;
		private var _productComment:ByteArray;
		private var _productDateEnd:Date;
		private var _productDateStart:Date;
		private var _productId:int;
		private var _productName:String;
		private var _productRoles:ByteArray;
		private var _productStatusFk:int;
		private var _productTasktypes:ByteArray;
		
		[ArrayElementType("com.adams.scrum.models.vo.Themes")]
		private var _themeSet:ArrayCollection = new ArrayCollection();
		
		[ArrayElementType("com.adams.scrum.models.vo.Versions")]
		private var _versionSet:ArrayCollection = new ArrayCollection();
		
		[ArrayElementType("com.adams.scrum.models.vo.Sprints")]
		private var _sprintCollection:ArrayCollection = new ArrayCollection();
		
		[ArrayElementType("com.adams.scrum.models.vo.Stories")]
		private var _storyCollection:ArrayCollection = new ArrayCollection();
		private var _productTaskTypeArr:Array =[];
		private var _productRolesArr:Array =[];
		public function Products()
		{
			super();
		}
	}
}