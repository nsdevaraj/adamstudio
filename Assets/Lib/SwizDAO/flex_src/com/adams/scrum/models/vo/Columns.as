package com.adams.scrum.models.vo
{
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Columns')]
	public class Columns extends AbstractVO
	{
		private var _columnField:String;
		private var _columnFilter:Boolean;
		private var _columnId:int;
		private var _columnName:String;
		private var _columnWidth:int;
		
		public function Columns()
		{
			super();
		}
		
		public function get columnField():String
		{
			return _columnField;
		}
		
		public function set columnField(value:String):void
		{
			_columnField = value;
		}
		
		public function get columnFilter():Boolean
		{
			return _columnFilter;
		}
		
		public function set columnFilter(value:Boolean):void
		{
			_columnFilter = value;
		}
		
		public function get columnId():int
		{
			return _columnId;
		}
		
		public function set columnId(value:int):void
		{
			_columnId = value;
		}
		
		public function get columnName():String
		{
			return _columnName;
		}
		
		public function set columnName(value:String):void
		{
			_columnName = value;
		}
		
		public function get columnWidth():int
		{
			return _columnWidth;
		}
		
		public function set columnWidth(value:int):void
		{
			_columnWidth = value;
		}
		
	}
}