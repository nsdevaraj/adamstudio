package events
{
	import flash.events.Event;

	public class TaskEvent extends Event
	{
		public static const NEWTASK:String = "newTask";
		public function TaskEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}