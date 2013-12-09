package com.adams.scrum.models.vo
{
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.ReportsColumns')]
	public class ReportsColumns extends AbstractVO
	{
		private var _columnFk:int;
		private var _reportColumnsId:int;
		private var _reportFk:int;
		
		public function ReportsColumns()
		{
			super();
			destination='reportcolumn';
		}
		
		public function get reportFk():int
		{
			return _reportFk;
		}
		
		public function set reportFk(value:int):void
		{
			_reportFk = value;
		}
		
		public function get reportColumnsId():int
		{
			return _reportColumnsId;
		}
		
		public function set reportColumnsId(value:int):void
		{
			_reportColumnsId = value;
		}
		
		public function get columnFk():int
		{
			return _columnFk;
		}
		
		public function set columnFk(value:int):void
		{
			_columnFk = value;
		} 
	}
}