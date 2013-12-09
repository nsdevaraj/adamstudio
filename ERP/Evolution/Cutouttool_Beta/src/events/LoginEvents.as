package events
{
	import flash.events.Event;

	public class LoginEvents extends Event
	{
		public static const LOGINSUCCESS:String = "loginSuccess";
		public static const LOGINFAILD:String = "loginFaild";
		public function LoginEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
} 