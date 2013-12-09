package business
{
	import controller.Controller;
	
	import data.History;
	
	import events.HistoryEvents;
	
	import flash.events.EventDispatcher;
	
	public class HistoryManager extends EventDispatcher
	{
		public var sqlQuery:String='';
		private var controllerObj:Controller = Controller.getInstance();
		public function HistoryManager()
		{
			Controller.getInstance().addEventListener(HistoryEvents.UPDATEHISTORY,historyData);
			
		}
		private function historyData(event:HistoryEvents):void{
			var history:History = new History();
			var author:String = controllerObj.currentTaskObj.userid;
			var type_of_event:String = event.typeOfEvent;
			var date:String = currentDate;
			var error:String = '0';
			var details_error:String = '';
			var task:String = controllerObj.currentTaskObj.pk_task;
			sqlQuery = "insert into history (author, type_of_event, date, error,details_error,task) values " + 
						"('"+author+"', '"+type_of_event+"', '"+date+"', '"+error+"', '"+
						details_error+"', '"+task+"')";		
			dispatchEvent(new HistoryEvents('',HistoryEvents.QUERYGENERATED));		
			
		}
		private function get currentDate():String{
			var date:Date = new Date();
			var month:String = String(date.month+1);
			month = (Number(month)>9)?month:"0"+month;
			var curDate:String = date.fullYear+"-"+month+"-"+date.date+" "+date.hours+":"+date.minutes+":"+date.seconds;
			return curDate;
		}
		

	}
}