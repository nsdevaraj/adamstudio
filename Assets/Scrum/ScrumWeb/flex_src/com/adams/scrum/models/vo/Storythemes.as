package com.adams.scrum.models.vo
{
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Storythemes')]
	public class Storythemes extends AbstractVO
	{
		private var _storyFk:int;
		private var _storyThemeId:int;
		private var _themeFk:int;
		
		public function Storythemes()
		{
			super();
			destination="storytheme"
		}
		
		public function get themeFk():int
		{
			return _themeFk;
		}
		
		public function set themeFk(value:int):void
		{
			_themeFk = value;
		}
		
		public function get storyThemeId():int
		{
			return _storyThemeId;
		}
		
		public function set storyThemeId(value:int):void
		{
			_storyThemeId = value;
		}
		
		public function get storyFk():int
		{
			return _storyFk;
		}
		
		public function set storyFk(value:int):void
		{
			_storyFk = value;
		}  
	}
}