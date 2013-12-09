package com.adams.dt.model.vo
{
	import flash.net.FileReference;

	public class FileReferenceVO
	{
		public function FileReferenceVO()
		{
		}		
		private var _fileDate:Date;
		public function set fileDate (value:Date):void
		{
			_fileDate = value;
		}
		
		public function get fileDate ():Date
		{
			return _fileDate;
		}
		private var _fileName:String;
		public function set fileName (value:String):void
		{
			_fileName = value;
		}
		
		public function get fileName ():String
		{
			return _fileName;
		}
		
		private var _filePath:String='';
		public function set filePath (value:String):void
		{
			_filePath = value;
		}
		
		public function get filePath ():String
		{
			return _filePath;
		}
		
		private var _taskId:int; 
		public function set taskId (value:int):void
		{
			_taskId = value;
		}
		
		public function get taskId ():int
		{
			return _taskId;
		}
		
		private var _categoryFK:int;
		public function set categoryFK (value:int):void
		{
			_categoryFK = value;
		}
		
		public function get categoryFK ():int
		{
			return _categoryFK;
		}
		
		private var _type:String;
		public function set type (value:String):void
		{
			_type = value;
		}
		
		public function get type ():String
		{
			return _type;
		}
		
		private var _storedFileName:String;
		public function set storedFileName (value:String):void
		{
			_storedFileName = value;
		}
		
		public function get storedFileName ():String
		{
			return _storedFileName;
		}
		
		private var _projectFK:int;
		public function set projectFK (value:int):void
		{
			_projectFK = value;
		}
		
		public function get projectFK ():int
		{
			return _projectFK;
		}
				
		private var _destinationpath:String;
		public function set destinationpath (value:String):void
		{
			_destinationpath = value;
		}
		
		public function get destinationpath ():String
		{
			return _destinationpath;
		}
		
		private var _downloadPath:String;
		public function set downloadPath( value:String ):void
		{
			_downloadPath = value;
		}
		
		public function get downloadPath():String
		{
			return _downloadPath;
		}
		
		private var _releaseStatus:int;
		public function set releaseStatus (value:int):void
		{
			_releaseStatus = value;
		}
		
		public function get releaseStatus ():int
		{
			return _releaseStatus;
		}
		
		private var _visible:Boolean;
		public function set visible (value:Boolean):void
		{
			_visible = value;
		}
		
		public function get visible ():Boolean
		{
			return _visible;
		}
		
		private var _miscelleneous:String;
		public function set miscelleneous (value:String):void
		{
			_miscelleneous = value;
		}
		
		public function get miscelleneous ():String
		{
			return _miscelleneous;
		}
		
		private var _fileCategory:String;
		public function set fileCategory (value:String):void
		{
			_fileCategory = value;
		}
		
		public function get fileCategory ():String
		{
			return _fileCategory;
		}
		
		
		private var _page:int;
		public function set page (value:int):void
		{
			_page = value;
		}
		
		public function get page ():int
		{
			return _page;
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