package com.adams.dt.model.vo 
{
	import com.adams.swizdao.model.vo.AbstractVO;

	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.Column')]
	public class Columns extends AbstractVO
	{ 
		public var columnField:String;
		public var columnFilter:String;
		public var columnId:int; 
		
		private var _columnName:String;
		public function set columnName ( value : String ) : void
		{
			_columnName = value;
			label = value;
		}

		public function get columnName () : String
		{
			return _columnName;
		}
		public var columnWidth:int;
		public var label:String
		
		public function Columns()
		{
			super()
		}
	}
}