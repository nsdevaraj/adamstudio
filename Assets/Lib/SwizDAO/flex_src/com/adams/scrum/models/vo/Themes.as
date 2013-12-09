package com.adams.scrum.models.vo
{
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Themes')]
	public class Themes extends AbstractVO
	{
		
		private var _productFk:int;
		private var _themeId:int;
		private var _themeLbl:String;
		
		public function Themes()
		{
			super();
		}
		
		public function get themeLbl():String
		{
			return _themeLbl;
		}
		
		public function set themeLbl(value:String):void
		{
			_themeLbl = value;
		}
		
		public function get themeId():int
		{
			return _themeId;
		}
		
		public function set themeId(value:int):void
		{
			_themeId = value;
		}
		
		public function get productFk():int
		{
			return _productFk;
		}
		
		public function set productFk(value:int):void
		{
			_productFk = value;
		} 
		
	}
}