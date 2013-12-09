package com.adams.dt.model.vo
{
	
	import flash.utils.getDefinitionByName;
	[RemoteClass(alias = "com.adams.dt.pojo.Modules")]	
	[Bindable]
	public final class Modules implements IValueObject
	{
		private var _moduleId : int;
		public function set moduleId (value : int) : void
		{
			_moduleId = value;
		}

		public function get moduleId () : int
		{
			return _moduleId;
		}

		private var _moduleY : int;
		public function set moduleY (value : int) : void
		{
			_moduleY = value;
		}

		public function get moduleY () : int
		{
			return _moduleY;
		}

		private var _moduleWidth : int;
		public function set moduleWidth (value : int) : void
		{
			_moduleWidth = value;
		}

		public function get moduleWidth () : int
		{
			return _moduleWidth;
		}

		private var _moduleName : String;
		public function set moduleName (value : String) : void
		{
			_moduleName = value;
			moduleClass = getDefinitionByName('com.adams.dt.view.mainView.'+value) as Class;
		}

		public function get moduleName () : String
		{
			return _moduleName;
		}
		
		private var _moduleClass : Class;
		public function set moduleClass (value : Class) : void
		{
			_moduleClass = value;
		}

		public function get moduleClass () : Class
		{
			return _moduleClass;
		}
		
		[PostConstruct]
		public function Modules()
		{
		}
	}
}