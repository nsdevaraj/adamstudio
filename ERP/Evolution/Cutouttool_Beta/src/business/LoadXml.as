package business
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LoadXml extends EventDispatcher
	{
		public var xmlData:XML = new XML();
		public var objStr:String = ""
		public var finishBol:Boolean = false
		public function LoadXml()
		{
			super();
			
		}
		public function loadXmlData(path:String,storedStr:String,finished:Boolean = false):void{
			objStr = storedStr;
			finishBol = finished
			var url:URLRequest = new URLRequest(path);
			var loader:URLLoader = new URLLoader(url)
			loader.addEventListener(Event.COMPLETE,loaded);
		}
		private function loaded(ev:Event):void{
			xmlData = XML(ev.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}