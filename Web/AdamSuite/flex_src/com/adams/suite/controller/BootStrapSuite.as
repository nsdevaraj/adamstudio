package com.adams.suite.controller
{
	import com.adams.suite.models.vo.CurrentInstance;
	import com.adams.suite.utils.Utils;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class BootStrapSuite
	{
		[Inject]
		public var currentInstance:CurrentInstance; 
		public function BootStrapSuite()
		{
		}
		
		[PostConstruct]
		public function execute():void
		{
			currentInstance.config.serverLocation =Utils.XMLPATH; 
			for(var i:int =0; i<Utils.chapQsArr.length; i++){
				currentInstance[Utils.CHAPTER+int(i+1)] = new XMLList();
				currentInstance[Utils.CHAPTER+int(i+1)+Utils.ARRSTR] = new Array();
				currentInstance[Utils.CHAPTER+int(i+1)+Utils.ARRSTR].length= Utils.chapQsArr[i];
			} 	
			sendHTTPRequest();
		} 
		
		private function sendHTTPRequest():void{
			var http:HTTPService = new HTTPService();
			http.url=currentInstance.config.serverLocation;
			http.resultFormat =Utils.E4X;
			http.addEventListener(ResultEvent.RESULT,loadXML);
			http.send();
		}
		
		private function loadXML(event:ResultEvent):void{ 
			currentInstance.xml=  XML(event.result);
		}
	}
}