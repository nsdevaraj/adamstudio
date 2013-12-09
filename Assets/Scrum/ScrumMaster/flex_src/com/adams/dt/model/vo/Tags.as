package com.adams.dt.model.vo
{
	import mx.collections.ArrayCollection;
	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.Tags')]
	public final class Tags
	{
		private var _tagId : int;
		private var _fileFK : int;
		private var _tagLabel : String;
		public function Tags()
		{
		}
  		private var _filesetObject:ArrayCollection
  		public function set filesetObject (value : ArrayCollection) : void
		{
			_filesetObject = value;
		}

		public function get filesetObject () : ArrayCollection
		{
			return _filesetObject;
		}
		public function set tagLabel (value : String) : void
		{
			_tagLabel = value;
		}

		public function get tagLabel () : String
		{
			return _tagLabel;
		}

		public function set fileFK (value : int) : void
		{
			_fileFK = value;
		}

		public function get fileFK () : int
		{
			return _fileFK;
		}

		public function set tagId (value : int) : void
		{
			_tagId = value;
		}

		public function get tagId () : int
		{
			return _tagId;
		}
	}
}
