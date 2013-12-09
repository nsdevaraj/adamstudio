package com.adams.dt.model.scheduler.taskClasses
{
	import com.adams.dt.model.scheduler.taskClasses.ITask;
	;
	public final class TaskLayoutItem
	{
		public var data : ITask;
		public var x : Number;
		public var y : Number;
		public var width : Number;
		public var height : Number;
		public var row : Number;
		public var zoom : Number;
		public function toString() : String
		{
			return "[object TaskLayoutItem" + " row:" + row + " x:" + x + " y:" + y + " width:" + width + " height:" + height + "]";
		}
	}
}
