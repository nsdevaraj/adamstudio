package com.adams.dt.model.vo 
{
	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.Column')]
	public class Columns
	{ 
		public var columnField:String;
		public var columnFilter:int;
		public var columnId:int;
		public var columnName:String;
		public var columnWidth:int;
		
		public function Columns()
		{
			super()
		}
	}
}