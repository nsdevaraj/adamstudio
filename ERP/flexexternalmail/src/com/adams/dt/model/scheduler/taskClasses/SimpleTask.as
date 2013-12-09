package com.adams.dt.model.scheduler.taskClasses
{
	import com.adams.dt.model.tracability.TaskBusinessCard;
	
	import flash.utils.ByteArray;
	public class SimpleTask implements ITask
	{
		public var label : String;
		private var _startDate : Date;
		private var _endDate : Date;
		private var _finalTask : Boolean;
		private var _phaseBelonging : int;
		private var _projectName : String;
		private var _taskComment : String;
		private var _taskFilePath : String;
		private var _taskLabel : String;
		private var _perPicture : ByteArray;
		private var _taskBusinessCard : TaskBusinessCard;
		private var _profileTask : String;
		private var _selectionId:int;
		
		public function get perPicture() : ByteArray
		{
			return _perPicture;
		}

		public function set perPicture( value : ByteArray) : void
		{
			_perPicture = value;
		}

		public function get startDate() : Date
		{
			return _startDate;
		}

		public function set startDate( value : Date) : void
		{
			_startDate = value;
		}

		public function get endDate() : Date
		{
			return _endDate;
		}

		public function set endDate( value : Date ) : void
		{
			_endDate = value;
		}

		public function get finalTask() : Boolean
		{
			return _finalTask;
		}

		public function set finalTask( value : Boolean) : void
		{
			_finalTask = value;
		}

		public function get phaseBelonging() : int
		{
			return _phaseBelonging;
		}

		public function set phaseBelonging( value : int ) : void
		{
			_phaseBelonging = value;
		}

		public function get projectName() : String
		{
			return _projectName;
		}

		public function set projectName( value : String ) : void
		{
			_projectName = value;
		}

		public function get taskComment() : String
		{
			return _taskComment;
		}

		public function set taskComment( value : String ) : void
		{
			_taskComment = value;
		}

		public function get taskFilePath() : String
		{
			return _taskFilePath;
		}

		public function set taskFilePath( value : String ) : void
		{
			_taskFilePath = value;
		}

		public function get taskLabel() : String
		{
			return _taskLabel;
		}

		public function set taskLabel( value : String ) : void
		{
			_taskLabel = value;
		}

		public function get taskBusinessCard() : TaskBusinessCard
		{
			return _taskBusinessCard;
		}

		public function set taskBusinessCard( value : TaskBusinessCard ) : void
		{
			_taskBusinessCard = value;
		}
		
		public function get profileTask() : String
		{
			return _profileTask;
		}

		public function set profileTask( value : String ) : void
		{
			_profileTask = value;
		}
		
		public function get selectionId() : int
		{
			return _selectionId;
		}

		public function set selectionId( value : int ) : void
		{
			_selectionId = value;
		}
		
		public function toString() : String
		{
			return "[object SimpleTask startDate:" + startDate + " endDate:" + endDate + "]";
		}
	}
}
