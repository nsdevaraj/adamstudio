package events
{
	import flash.events.Event;
	
	public class HistoryEvents extends Event
	{
		public static const UPDATEHISTORY:String = "updateHistory";
		public static const QUERYGENERATED:String = "queryGenerated";
		public var typeOfEvent:String = ""
		public function HistoryEvents(eventType:String ,type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			typeOfEvent = eventType;
			super(type, bubbles, cancelable);
		}
		
	}
}