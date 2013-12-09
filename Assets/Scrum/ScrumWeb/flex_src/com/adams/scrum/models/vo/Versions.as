package com.adams.scrum.models.vo
{
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Versions')]
	public class Versions extends AbstractVO
	{
		
		private var _productFk:int;
		private var _versionId:int;
		private var _versionLbl:String;
		private var _versionStatusFk:int;
		
		public function Versions()
		{
			super()
		}
		private var _statusObject:Status;
		
		public function get statusObject():Status
		{
			return _statusObject;
		}
		
		public function set statusObject(value:Status):void
		{
			_statusObject = value;
		}
		public function get versionStatusFk():int
		{
			return _versionStatusFk;
		}
		
		public function set versionStatusFk(value:int):void
		{
			_versionStatusFk = value;
		}
		
		public function get versionLbl():String
		{
			return _versionLbl;
		}
		
		public function set versionLbl(value:String):void
		{
			_versionLbl = value;
		}
		
		public function get versionId():int
		{
			return _versionId;
		}
		
		public function set versionId(value:int):void
		{
			_versionId = value;
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