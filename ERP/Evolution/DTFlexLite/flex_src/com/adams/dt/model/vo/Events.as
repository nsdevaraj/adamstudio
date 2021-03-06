package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	import mx.collections.ArrayCollection;
	import flash.utils.ByteArray;
	[RemoteClass(alias = "com.adams.dt.pojo.Events")]	
	[Bindable]
	public final class Events implements IValueObject
	{
		private var _details_blob:Object;
		public function set details_blob (value : Object) : void
		{
			_details_blob = value;
		} 
		private var _eventId : int;
		public function set eventId (value : int) : void
		{
			_eventId = value;
		}

		public function get eventId () : int
		{
			return _eventId;
		}

		private var _eventDateStart : Date;
		public function set eventDateStart (value : Date) : void
		{
			_eventDateStart = value;
		}

		public function get eventDateStart () : Date
		{
			return _eventDateStart;
		}

		private var _eventType : int;
		public function set eventType (value : int) : void
		{
			_eventType = value;
		}

		public function get eventType () : int
		{
			return _eventType;
		}

		private var _personFk : int;
		public function set personFk (value : int) : void
		{
			_personFk = value;
		}

		public function get personFk () : int
		{
			return _personFk;
		}

		private var _taskFk : int;
		public function set taskFk (value : int) : void
		{
			_taskFk = value;
		}

		public function get taskFk () : int
		{
			return _taskFk;
		}

		private var _details : ByteArray;
		public function set details (value : ByteArray) : void
		{
			_details = value;
		}

		public function get details () : ByteArray
		{
			return _details;
		}		
		
		private var _projectFk : int;
		public function set projectFk (value : int) : void
		{
			_projectFk = value;
		}

		public function get projectFk () : int
		{
			return _projectFk;
		}
		
		private var _eventname : String;
		public function set eventName (value : String) : void
		{
			_eventname = value;
		}
		
		public function get eventName () : String
		{
			return _eventname;
		}		
		
		private var _workflowtemplatesFk : int;
		public function set workflowtemplatesFk (value : int) : void
		{
			_workflowtemplatesFk = value;
		}

		public function get workflowtemplatesFk () : int
		{
			return _workflowtemplatesFk;
		}

		public function Events()
		{
		}
	}
}
