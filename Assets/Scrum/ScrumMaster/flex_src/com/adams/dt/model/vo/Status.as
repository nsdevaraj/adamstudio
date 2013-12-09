package com.adams.dt.model.vo
{
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.Status")]	
	[Bindable]
	public final class Status implements IValueObject
	{
		private var _statusId : int;
		public function set statusId (value : int) : void
		{
			_statusId = value;
		}

		public function get statusId () : int
		{
			return _statusId;
		}

		private var _type : String;
		public function set type (value : String) : void
		{
			_type = value;
		}

		public function get type () : String
		{
			return _type;
		}

		private var _statusLabel : String;
		public function set statusLabel (value : String) : void
		{
			_statusLabel = value;
		}

		public function get statusLabel () : String
		{
			return _statusLabel;
		}

		private var _statusNumCode : int;
		public function set statusNumCode (value : int) : void
		{
			_statusNumCode = value;
		}

		public function get statusNumCode () : int
		{
			return _statusNumCode;
		} 
		public function Status()
		{
		}
	}
}
