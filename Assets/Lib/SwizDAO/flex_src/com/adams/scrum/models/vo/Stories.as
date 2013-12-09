package com.adams.scrum.models.vo
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.utils.GetVOUtil;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Stories')]
	public class Stories extends AbstractVO
	{
		[ArrayElementType("com.adams.scrum.models.vo.Themes")]
		private var _themeList:ArrayCollection = new ArrayCollection();
		
		private var _statusObject:Status;
		
		public function get statusObject():Status
		{
			return _statusObject;
		}
		
		public function set statusObject(value:Status):void
		{
			_statusObject = value;
		}
		public function get versionObject():Versions
		{
			return _versionObject;
		}

		public function set versionObject(value:Versions):void
		{
			_versionObject = value;
		}

		public function get productObject():Products
		{
			return _productObject;
		}

		public function set productObject(value:Products):void
		{
			_productObject = value;
		}
		
		public function get themeSet():ArrayCollection
		{
			return _themeSet;
		}
		
		public function set themeSet(value:ArrayCollection):void
		{
			_themeSet = value;
		}
		
		public function get fileCollection():ArrayCollection
		{
			return _fileCollection;
		}
		
		public function set fileCollection(value:ArrayCollection):void
		{
			_fileCollection = value;
		}
		
		public function get taskSet():ArrayCollection
		{
			return _taskSet;
		}
		
		public function set taskSet(value:ArrayCollection):void
		{
			_taskSet = value;
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		
		public function get versionFk():int
		{
			return _versionFk;
		}
		
		public function set versionFk(value:int):void
		{
			_versionFk = value;
		}
		
		public function get storypoints():int
		{
			return _storypoints;
		}
		
		public function set storypoints(value:int):void
		{
			_storypoints = value;
		}
		
		public function get storyStatusFk():int
		{
			return _storyStatusFk;
		}
		
		public function set storyStatusFk(value:int):void
		{
			_storyStatusFk = value;
		}
		
		public function get storyId():int
		{
			return _storyId;
		}
		
		public function set storyId(value:int):void
		{
			_storyId = value;
		}
		
		public function get storyComments():ByteArray
		{
			return _storyComments;
		}
		
		public function set storyComments(value:ByteArray):void
		{
			_storyComments = value;
		}
		
		public function get soThatICanLabel():String
		{
			return _soThatICanLabel;
		}
		
		public function set soThatICanLabel(value:String):void
		{
			_soThatICanLabel = value;
		}
		
		public function get productFk():int
		{
			return _productFk;
		}
		
		public function set productFk(value:int):void
		{
			_productFk = value;
		}
		
		public function get priority():int
		{
			return _priority;
		}
		
		public function set priority(value:int):void
		{
			_priority = value;
		}
		
		public function get effort():int
		{
			return _effort;
		}
		
		public function set effort(value:int):void
		{
			_effort = value;
		}
		
		public function get asLabel():int
		{
			return _asLabel;
		}
		
		public function set asLabel(value:int):void
		{
			_asLabel = value;
		}
		
		public function get IWantToLabel():String
		{
			return _IWantToLabel;
		}
		
		public function set IWantToLabel(value:String):void
		{
			_IWantToLabel = value;
		} 
		private var _IWantToLabel:String;
		private var _asLabel:int;
		private var _effort:int;
		private var _priority:int;
		private var _productFk:int;
		private var _soThatICanLabel:String;
		private var _storyComments:ByteArray;
		private var _storyId:int;
		private var _storyStatusFk:int;
		private var _storypoints:int;
		private var _versionFk:int;
		private var _visible:Boolean;
		private var _productObject:Products;
		private var _versionObject:Versions;
		[ArrayElementType("com.adams.scrum.models.vo.Tasks")]
		private var _taskSet:ArrayCollection = new ArrayCollection();
		
		[ArrayElementType("com.adams.scrum.models.vo.Files")]
		private var _fileCollection:ArrayCollection = new ArrayCollection();
		
		[ArrayElementType("com.adams.scrum.models.vo.Themes")]
		private var _themeSet:ArrayCollection = new ArrayCollection();
		
		public function Stories()
		{
			super();
		}
	}
}