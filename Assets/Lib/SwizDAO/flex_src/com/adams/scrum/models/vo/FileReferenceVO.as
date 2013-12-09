package com.adams.scrum.models.vo
{
	import flash.net.FileReference;

	public class FileReferenceVO
	{
		public function FileReferenceVO()
		{
		}
		
		private var _name:String = "";

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}
		
		private var _extension:String = "";

		public function get extension():String
		{
			return _extension;
		}

		public function set extension(value:String):void
		{
			_extension = (value!=null)?value.substr(1):"";
		}
		
		public var fileRefVO:FileReference = new FileReference();

	}
}