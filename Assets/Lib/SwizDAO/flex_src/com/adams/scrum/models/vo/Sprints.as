package com.adams.scrum.models.vo
{
	import com.adams.scrum.dao.AbstractDAO;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Sprints')]
	public class Sprints extends AbstractVO
	{
		private var _statusObject:Status;
		
		public function get statusObject():Status
		{
			return _statusObject;
		}
		
		public function set statusObject(value:Status):void
		{
			_statusObject = value;
		}
		public function get productObject():Products
		{
			return _productObject;
		}

		public function set productObject(value:Products):void
		{
			_productObject = value;
		}

		public function get versionObject():Versions
		{
			return _versionObject;
		}

		public function set versionObject(value:Versions):void
		{
			_versionObject = value;
		}

		public function get teamObject():Teams
		{
			return _teamObject;
		}

		public function set teamObject(value:Teams):void
		{
			_teamObject = value;
		}

		public function get storySet():ArrayCollection
		{
			return _storySet;
		}
		
		public function set storySet(value:ArrayCollection):void
		{
			_storySet = value;
		}
		
		public function get versionFk():int
		{
			return _versionFk;
		}
		
		public function set versionFk(value:int):void
		{
			_versionFk = value;
		}
		
		public function get teamFk():int
		{
			return _teamFk;
		}
		
		public function set teamFk(value:int):void
		{
			_teamFk = value;
		}
		
		public function get sprintStatusFk():int
		{
			return _sprintStatusFk;
		}
		
		public function set sprintStatusFk(value:int):void
		{
			_sprintStatusFk = value;
		}
		
		public function get sprintLabel():String
		{
			return _sprintLabel;
		}
		
		public function set sprintLabel(value:String):void
		{
			_sprintLabel = value;
		}
		
		public function get sprintId():int
		{
			return _sprintId;
		}
		
		public function set sprintId(value:int):void
		{
			_sprintId = value;
		}
		
		public function get productFk():int
		{
			return _productFk;
		}
		
		public function set productFk(value:int):void
		{
			_productFk = value;
		}
		
		public function get preparationComments():ByteArray
		{
			return _preparationComments;
		}
		
		public function set preparationComments(value:ByteArray):void
		{
			_preparationComments = value;
		}
		
		public function get demoComments():ByteArray
		{
			return _demoComments;
		}
		
		public function set demoComments(value:ByteArray):void
		{
			_demoComments = value;
		}
		
		public function get SDatePreparation():Date
		{
			return _SDatePreparation;
		}
		
		public function set SDatePreparation(value:Date):void
		{
			_SDatePreparation = value;
		}
		
		public function get SDateEnd():Date
		{
			return _SDateEnd;
		}
		
		public function set SDateEnd(value:Date):void
		{
			_SDateEnd = value;
		}
		
		public function get SDateDemo():Date
		{
			return _SDateDemo;
		}
		
		public function set SDateDemo(value:Date):void
		{
			_SDateDemo = value;
		}
		
		public function get SDateCreation():Date
		{
			return _SDateCreation;
		}
		
		public function set SDateCreation(value:Date):void
		{
			_SDateCreation = value;
		}
		 
		private var _SDateCreation:Date;
		private var _SDateDemo:Date;
		private var _SDateEnd:Date;
		private var _SDatePreparation:Date;
		private var _demoComments:ByteArray;
		private var _preparationComments:ByteArray;
		private var _productFk:int;
		private var _sprintId:int;
		private var _sprintLabel:String;
		private var _sprintStatusFk:int;
		private var _teamFk:int;
		private var _versionFk:int;
		
		public var totalEstimatedTime:int;
		public var totalDoneTime:int;
		public var totalRemainingTime:int;
		private var _teamObject:Teams;
		private var _versionObject:Versions;
		private var _productObject:Products;
		[ArrayElementType("com.adams.scrum.models.vo.Stories")]
		private var _storySet:ArrayCollection = new ArrayCollection();
		public function Sprints()
		{
			super();
		}
	}
}