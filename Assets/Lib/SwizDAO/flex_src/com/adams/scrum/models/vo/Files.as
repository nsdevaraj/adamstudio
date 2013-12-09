package com.adams.scrum.models.vo
{ 

	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Files')]
	public class Files extends AbstractVO
	{
		private var _fileId:int;
		private var _filedate:Date;
		private var _filename:String;
		private var _filepath:String;
		private var _productFk:int;
		private var _storedfilename:String;
		private var _storyFk:int;
		private var _taskFk:int;
		private var _taskObject:Tasks;
		private var _storyObject:Stories;
		private var _productObject:Products;
		private var _extension:String;
		
		private var _uploadStatus:String;
		private var _uploadPercentage:int;
		private var _img:Class; 
		
		public function Files()
		{
			super();
		}
		
		public function get productObject():Products
		{
			return _productObject;
		}

		public function set productObject(value:Products):void
		{
			_productObject = value;
		}

		public function get storyObject():Stories
		{
			return _storyObject;
		}

		public function set storyObject(value:Stories):void
		{
			_storyObject = value;
		}

		public function get taskObject():Tasks
		{
			return _taskObject;
		}

		public function set taskObject(value:Tasks):void
		{
			_taskObject = value;
		}

		public function get taskFk():int
		{
			return _taskFk;
		}
		
		public function set taskFk(value:int):void
		{
			_taskFk = value;
		}
		
		public function get storyFk():int
		{
			return _storyFk;
		}
		
		public function set storyFk(value:int):void
		{
			_storyFk = value;
		}
		
		public function get storedfilename():String
		{
			return _storedfilename;
		}
		
		public function set storedfilename(value:String):void
		{
			_storedfilename = value;
		}
		
		public function get productFk():int
		{
			return _productFk;
		}
		
		public function set productFk(value:int):void
		{
			_productFk = value;
		}
		
		public function get filepath():String
		{
			return _filepath;
		}
		
		public function set filepath(value:String):void
		{
			_filepath = value;
		}
		
		public function get filename():String
		{
			return _filename;
		}
		
		public function set filename(value:String):void
		{
			_filename = value;
		}
		
		public function get filedate():Date
		{
			return _filedate;
		}
		
		public function set filedate(value:Date):void
		{
			_filedate = value;
		}
		
		public function get fileId():int
		{
			return _fileId;
		}
		
		public function set fileId(value:int):void
		{
			_fileId = value;
		} 

		public function get uploadStatus():String
		{
			return _uploadStatus;
		}

		public function set uploadStatus(value:String):void
		{
			_uploadStatus = value;
		}

		public function get uploadPercentage():int
		{
			return _uploadPercentage;
		}

		public function set uploadPercentage(value:int):void
		{
			_uploadPercentage = value;
		}

		public function get img():Class
		{
			return _img;
		}

		public function set img(value:Class):void
		{
			_img = value;
		} 
		public function get extension():String
		{
			return _extension;
		}
		
		public function set extension(value:String):void
		{
			_extension = value;
		}
		
	}
}