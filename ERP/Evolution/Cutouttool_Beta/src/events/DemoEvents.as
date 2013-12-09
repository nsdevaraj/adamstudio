package events
{
	import flash.events.Event;

	public class DemoEvents extends Event
	{
		public static const PROCESSING:String = "processsing";
		public static const FINISHED:String = "finished";
		public static const DEMO:String = "demo";
		public function DemoEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}