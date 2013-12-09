package business
{
	import events.DemoEvents;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class LoadDemoXml extends EventDispatcher
	{
		private const PATH:String = "assets/demoxml/";
		private const TASKS:String = "tasks.xml";
		private const USERS:String = "users.xml";
		private const IMAGE_1:String = "uploadDeatils_4.xml";
		private const IMAGE_2:String = "uploadDeatils_5.xml";
		private const IMAGE_3:String = "uploadDeatils_6.xml";
		private const BACKOFFICE_HISTORY:String = "backOffice_history.xml";
		private const BACKOFFICE_LOGIN:String = "backOffice_log.xml";
		private const BACKOFFICE_TASK:String = "backOffice_task.xml";
		private const REPORT:String = "monthlyReport.xml";
		private var loadXml:LoadXml = new LoadXml();
		public var taskXml:XML;
		public var users:XML;
		public var uploadDeatils_4:XML;
		public var uploadDeatils_5:XML;
		public var uploadDeatils_208:XML;
		public var backOfficeHistory:XML;
		public var backOfficeLogin:XML;
		public var backOfficeTask:XML;
		public var report:XML;
		public function LoadDemoXml()
		{
			loadXml.addEventListener(Event.COMPLETE,XmlLoaded);
			loadTaskXml();
		}
		public function loadTaskXml():void{
			loadXml.loadXmlData(PATH+TASKS,'taskXml');			
		}
		public function loadUserXml():void{
			loadXml.loadXmlData(PATH+USERS,'users');
		}
		public function loadReportXml():void{
			loadXml.loadXmlData(PATH+REPORT,'report');			
		}
		public function loadBackOfficeHistoryXml():void{
			loadXml.loadXmlData(PATH+BACKOFFICE_HISTORY,'backOfficeHistory');
		}
		public function loadBackOfficeLoginXml():void{
			loadXml.loadXmlData(PATH+BACKOFFICE_LOGIN,'backOfficeLogin');
		}
		public function loadBackOfficetaskXml():void{
			loadXml.loadXmlData(PATH+BACKOFFICE_TASK,'backOfficeTask',true);			
		}
		public function loadUploadedImageXml_4():void{
			loadXml.loadXmlData(PATH+IMAGE_1,'uploadDeatils_4');		
		}
		public function loadUploadedImageXml_5():void{
			loadXml.loadXmlData(PATH+IMAGE_2,'uploadDeatils_5')
		}
		public function loadUploadedImageXml_6():void{
			loadXml.loadXmlData(PATH+IMAGE_3,'uploadDeatils_208');		
		}
		public function XmlLoaded(event:Event):void{
			this[event.currentTarget.objStr] = event.currentTarget.xmlData;			
			switch(event.currentTarget.objStr){
				case "taskXml":
					loadUploadedImageXml_4()
				break;
				case "uploadDeatils_4":
					loadUploadedImageXml_5()
				break;
				case "uploadDeatils_5":
					loadUploadedImageXml_6()
				break;
				case "uploadDeatils_208":
					loadUserXml()
				break;
				case "users":
					dispatchEvent(new DemoEvents(DemoEvents.FINISHED));
					loadReportXml();
				break;
				case "report":
					loadBackOfficetaskXml();
				break;
				case "backOfficeTask":
					loadBackOfficeHistoryXml()
				break;
				case "backOfficeLogin":
					
				break;
				case "backOfficeHistory":
					loadBackOfficeLoginXml();
				break;
			}
		}
	}
}