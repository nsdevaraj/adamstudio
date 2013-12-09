package com.adams.dt.model.vo 
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.ReportColumns')]
	public class ReportColumns extends AbstractVO
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