package com.adams.scrum.models.vo
{
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Profiles')]
	public class Profiles extends AbstractVO
	{
		private var _profileCode:String;
		private var _profileId:int;
		private var _profileLabel:String;
		
		public function Profiles()
		{
			super();
		}
		
		public function get profileLabel():String
		{
			return _profileLabel;
		}
		
		public function set profileLabel(value:String):void
		{
			_profileLabel = value;
		}
		
		public function get profileId():int
		{
			return _profileId;
		}
		
		public function set profileId(value:int):void
		{
			_profileId = value;
		}
		
		public function get profileCode():String
		{
			return _profileCode;
		}
		
		public function set profileCode(value:String):void
		{
			_profileCode = value;
		}
		
	}
}