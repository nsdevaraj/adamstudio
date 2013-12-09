package com.adams.dt.model.vo 
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.Report')]
	public class Reports implements IValueObject
	{
		[ArrayElementType("com.adams.dt.model.vo.Columns")]
		public var columnSet:ArrayCollection = new ArrayCollection();
		public var headerArray:Array = [];
		public var fieldArray:Array = [];
		public var widthArray:Array = [];
		public var booleanArray:Array = [];
		public var pieChartCol:Columns;
		public var pieChartName:String;
		public var reportId:int;
		public var reportName:String;
		public var stackBarCol:Columns;
		public var stackBarName:String;
		public var profileFk:int;
		public var projectStatus:String; 
		
		[PostConstruct]
		public function Reports()
		{
			super()
		}
	}
}