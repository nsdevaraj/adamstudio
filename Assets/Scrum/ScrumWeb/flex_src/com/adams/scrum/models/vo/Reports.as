package com.adams.scrum.models.vo
{
	import com.adams.scrum.dao.AbstractDAO;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Reports')]
	public class Reports extends AbstractVO
	{
		private var _barchartName:String;
		private var _barcolFk:int;
		private var _piechartName:String;
		private var _profileFk:int;
		private var _reportId:int;
		private var _reportName:String;
		private var _seriescolFk:int;
		private var _seriesCol:Columns;
		private var _barCol:Columns;
		
		[ArrayElementType("com.adams.scrum.models.vo.Columns")]
		private var _columnSet:ArrayCollection;
		
		public function Reports()
		{
			super();
		}
		
		public function get barCol():Columns
		{
			return _barCol;
		}

		public function set barCol(value:Columns):void
		{
			_barCol = value;
		}

		public function get seriesCol():Columns
		{
			return _seriesCol;
		}

		public function set seriesCol(value:Columns):void
		{
			_seriesCol = value;
		}

		public function get columnSet():ArrayCollection
		{
			return _columnSet;
		}

		public function set columnSet(value:ArrayCollection):void
		{
			_columnSet = value;
		}

		public function get seriescolFk():int
		{
			return _seriescolFk;
		}
		
		public function set seriescolFk(value:int):void
		{
			_seriescolFk = value;
		}
		
		public function get reportName():String
		{
			return _reportName;
		}
		
		public function set reportName(value:String):void
		{
			_reportName = value;
		}
		
		public function get reportId():int
		{
			return _reportId;
		}
		
		public function set reportId(value:int):void
		{
			_reportId = value;
		}
		 
		public function get profileFk():int
		{
			return _profileFk;
		}
		
		public function set profileFk(value:int):void
		{
			_profileFk = value;
		}
		
		public function get piechartName():String
		{
			return _piechartName;
		}
		
		public function set piechartName(value:String):void
		{
			_piechartName = value;
		}
		
		public function get barcolFk():int
		{
			return _barcolFk;
		}
		
		public function set barcolFk(value:int):void
		{
			_barcolFk = value;
		}
		
		public function get barchartName():String
		{
			return _barchartName;
		}
		
		public function set barchartName(value:String):void
		{
			_barchartName = value;
		}
		
	}
}