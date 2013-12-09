package com.adams.dt.model.vo
{
	[RemoteClass(alias = "com.adams.dt.pojo.Languages")]	
	[Bindable]
	public final class LangEntries
	{
		private var _id : int;
		public function set id (value : int) : void
		{
			_id = value;
		}

		public function get id () : int
		{
			return _id;
		}

		private var _formid : String;
		public function set formid (value : String) : void
		{
			_formid = value;
		}

		public function get formid () : String
		{
			return _formid;
		}

		private var _englishlbl : String;
		public function set englishlbl (value : String) : void
		{
			_englishlbl = value;
		}

		public function get englishlbl () : String
		{
			return _englishlbl;
		}

		private var _frenchlbl : String;
		public function set frenchlbl (value : String) : void
		{
			_frenchlbl = value;
		}

		public function get frenchlbl () : String
		{
			return _frenchlbl;
		}
		
		[PostConstruct]
		public function LangEntries()
		{
		}
	}
}
