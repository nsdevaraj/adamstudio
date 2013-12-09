package com.adams.scrum.models.vo
{
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Sprintstories')]
	public class Sprintstories extends AbstractVO
	{
		private var _sprintFk:int;
		private var _sprintstoryId:int;
		private var _storyFk:int;
		
		public function Sprintstories()
		{
			super();
		}
		
		public function get storyFk():int
		{
			return _storyFk;
		}
		
		public function set storyFk(value:int):void
		{
			_storyFk = value;
		}
		
		public function get sprintstoryId():int
		{
			return _sprintstoryId;
		}
		
		public function set sprintstoryId(value:int):void
		{
			_sprintstoryId = value;
		}
		
		public function get sprintFk():int
		{
			return _sprintFk;
		}
		
		public function set sprintFk(value:int):void
		{
			_sprintFk = value;
		} 
		
	}
}