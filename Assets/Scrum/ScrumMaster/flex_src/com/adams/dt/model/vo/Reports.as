package com.adams.dt.model.vo 
{
	import com.adams.dt.utils.GetVOUtil;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.Report')]
	public class Reports
	{
		[ArrayElementType("com.adams.dt.model.vo.Columns")]
		private var _columnSet:ArrayCollection = new ArrayCollection();
		public var headerArray:Array = [];
		public var fieldArray:Array = [];
		public var widthArray:Array = [];
		public var booleanArray:Array = [];
		private var _pieChartCol:Columns = new Columns();
		private var _pieChartName:String;
		private var _reportId:int;
		private var _reportName:String;
		private var _stackBarCol:Columns;
		private var _stackBarName:String;
		private var _profileFk:int;
		private var _projectStatus:String;
		private var _profileObject:Profiles;
		public function Reports()
		{
			super()
		}

		public function get profileObject():Profiles
		{
			if(_profileObject ==null)
			_profileObject =  GetVOUtil.getVOObject(_profileFk,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
			return _profileObject;
		}

		public function set profileObject(value:Profiles):void
		{
			_profileObject = value;
			_profileFk = value.profileId;
		}

		public function get columnSet():ArrayCollection
		{
			return _columnSet;
		}

		public function set columnSet(value:ArrayCollection):void
		{
			_columnSet = value;
		}

		public function get pieChartCol():Columns
		{
			return _pieChartCol;
		}

		public function set pieChartCol(value:Columns):void
		{
			_pieChartCol = value;
		}

		public function get pieChartName():String
		{
			return _pieChartName;
		}

		public function set pieChartName(value:String):void
		{
			_pieChartName = value;
		}

		public function get reportId():int
		{
			return _reportId;
		}

		public function set reportId(value:int):void
		{
			_reportId = value;
		}

		public function get reportName():String
		{
			return _reportName;
		}

		public function set reportName(value:String):void
		{
			_reportName = value;
		}

		public function get stackBarCol():Columns
		{
			return _stackBarCol;
		}

		public function set stackBarCol(value:Columns):void
		{
			_stackBarCol = value;
		}

		public function get stackBarName():String
		{
			return _stackBarName;
		}

		public function set stackBarName(value:String):void
		{
			_stackBarName = value;
		}

		public function get profileFk():int
		{
			return _profileFk;
		}

		public function set profileFk(value:int):void
		{
			_profileFk = value;
			profileObject =  GetVOUtil.getVOObject(value,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
		}

		public function get projectStatus():String
		{
			return _projectStatus;
		}

		public function set projectStatus(value:String):void
		{
			_projectStatus = value;
		}

	}
}