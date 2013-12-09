package events
{
	import flash.events.Event;

	public class FileDropEvent extends Event
	{
		public static const FILEDROPED:String = "fileDroped";
		public static const FILEUPLOADED:String = "fileUploaded";
		public var filePath:String;
		public function FileDropEvent(str:String,type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			filePath = str;
			super(type, bubbles, cancelable);
		}
		
	}
}