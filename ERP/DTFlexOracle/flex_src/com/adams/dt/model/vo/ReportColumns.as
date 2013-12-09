package com.adams.dt.model.vo 
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.ReportColumns')]
	public class ReportColumns implements IValueObject
	{ 
		public var reportColumnId:int;
		public var reportfk:int;     
		public var columnfk:int; 
		public function ReportColumns()
		{
			super()
		}
	}
}