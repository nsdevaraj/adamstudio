package com.adams.dt.model.vo 
{
	
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.Report')]
	public class Reports extends AbstractVO
	{
		[ArrayElementType("com.adams.dt.model.vo.Columns")]
		public var columnSet:ArrayCollection = new ArrayCollection();
		public var headerArray:Array = [];
		public var fieldArray:Array = [];
		public var widthArray:Array = [];
		public var booleanArray:Array = [];
		public var resultArray:Array = [];
		public var pieChartCol:Columns = new Columns();
		public var pieChartName:String;
		public var reportId:int;
		public var reportName:String;
		public var stackBarCol:Columns = new Columns();
		public var stackBarName:String;
		public var profileFk:int;
		public var projectStatus:String; 
		public function Reports()
		{
			super()
		}
	}
}