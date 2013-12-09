package com.adams.dt.model.scheduler.taskClasses
{
	public final class ColouredTask extends SimpleTask implements ITask
	{
		public var backgroundColor : uint = 0xcccccc;
		override public function toString() : String
		{
			return "[object ColouredTask startDate:" + startDate + " endDate:" + endDate + "final----" + taskLabel + "]";
		}
	}
}
