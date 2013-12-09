package com.adams.scrum.models.vo
{
	import flash.utils.ByteArray;
	
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Tickets')]
	public class Tickets extends AbstractVO
	{
		
		public function get personObject():Persons
		{
			return _personObject;
		}

		public function set personObject(value:Persons):void
		{
			_personObject = value;
		}

		public function get taskObject():Tasks
		{
			return _taskObject;
		}

		public function set taskObject(value:Tasks):void
		{
			_taskObject = value;
		}

		public function get personFk():int
		{
			return _personFk;
		}
		
		public function set personFk(value:int):void
		{
			_personFk = value;
		}
		
		public function get taskFk():int
		{
			return _taskFk;
		}
		
		public function set taskFk(value:int):void
		{
			_taskFk = value;
		}
		
		public function get ticketComments():String
		{
			return _ticketComments;
		}
		
		public function set ticketComments(value:String):void
		{
			_ticketComments = value;
		}
		
		public function get ticketDate():Date
		{
			return _ticketDate;
		}
		
		public function set ticketDate(value:Date):void
		{
			_ticketDate = value;
		}
		
		public function get ticketId():int
		{
			return _ticketId;
		}
		
		public function set ticketId(value:int):void
		{
			_ticketId = value;
		}
		
		public function get ticketTechnical():ByteArray
		{
			return _ticketTechnical;
		}
		
		public function set ticketTechnical(value:ByteArray):void
		{
			_ticketTechnical = value;
		}
		
		public function get ticketTimespent():int
		{
			return _ticketTimespent;
		}
		
		public function set ticketTimespent(value:int):void
		{
			_ticketTimespent = value;
		} 
		private var _personObject:Persons;
		private var _taskObject:Tasks;
		private var _personFk:int;
		private var _taskFk:int;
		private var _ticketComments:String;
		private var _ticketDate:Date;
		private var _ticketId:int;
		private var _ticketTechnical:ByteArray;
		private var _ticketTimespent:int;
		
		public function Tickets()
		{
			super();
		}
	}
}