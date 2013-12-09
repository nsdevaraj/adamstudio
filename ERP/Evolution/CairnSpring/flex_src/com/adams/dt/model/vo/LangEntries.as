package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	/**
	* LangEntries Class value Object
	*/
	[RemoteClass(alias = "com.adams.dt.pojo.Languages")]	
	[Bindable]
	public final class LangEntries
	{
		/**
		* Sets the id of the language.
		* @param id
		* return type void
		*/
		private var _id : int;
		public function set id (value : int) : void
		{
			_id = value;
		}

		/**
		* Gets the id of the language.
		* @param id
		* return type int
		*/
		public function get id () : int
		{
			return _id;
		}

		/**
		* Sets the formid of the language.
		* @param formid
		* return type void
		*/
		private var _formid : String;
		public function set formid (value : String) : void
		{
			_formid = value;
		}

		/**
		* Gets the formid of the language.
		* @param formid
		* return type String
		*/
		public function get formid () : String
		{
			return _formid;
		}
		
		/**
		* Sets the englishlbl of the language.
		* @param englishlbl
		* return type void
		*/
		private var _englishlbl : String;
		public function set englishlbl (value : String) : void
		{
			_englishlbl = value;
		}
		
		/**
		* Gets the englishlbl of the language.
		* @param englishlbl
		* return type String
		*/
		public function get englishlbl () : String
		{
			return _englishlbl;
		}
	
		/**
		* Sets the frenchlbl of the language.
		* @param frenchlbl
		* return type void
		*/
		private var _frenchlbl : String;
		public function set frenchlbl (value : String) : void
		{
			_frenchlbl = value;
		}
		
		/**
		* Gets the frenchlbl of the language.
		* @param frenchlbl
		* return type String
		*/
		public function get frenchlbl () : String
		{
			return _frenchlbl;
		}
		
		/**
		* LangEntries Class Constuctor
		*/
		public function LangEntries()
		{
		}
	}
}
