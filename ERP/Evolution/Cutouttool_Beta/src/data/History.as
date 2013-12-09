/**
 * @author K.Sathish Balaji
 * 24-10-2008
 * */
package data
{
	import data.Interface.IModel;
	import flash.events.Event;
	/**
	 * use to store the history table data
	 * */
	[Bindable]
	public class History implements IModel
	{
		private var _date:String=''; 
		private var _type_of_event:String='';
		private var _task:String='';
		private var _author:String='';
		private var _error:String='';
		private var _details_error:String='';
		public function History()
		{
		}
		/**
		 * get the date 
		 */
		public function get date():String{
			return _date;
		}
		/**
		 * set the date
		 */
		public function set date(str:String):void{
			_date = str;
			dispatchEvent(new Event("historyDataChanged"));
		}
		/**
		 * get the type_of_event
		 */
		public function get type_of_event():String{
			return _type_of_event;
		}
		/**
		 * set the type_of_event
		 */
		public function set type_of_event(str:String):void{
			_type_of_event = str;
			dispatchEvent(new Event("historyDataChanged"));
		}
		/**
		 * get the task
		 */
		public function get task():String{
			return _task;
		}
		/**
		 * set the task 
		 */
		public function set task(str:String):void{
			_task = str;
		}
		/**
		 * get the author
		 */
		public function get author():String{
			return _author;
		}
		/**
		 * set the author
		 */
		public function set author(str:String):void{
			_author = str;
			dispatchEvent(new Event("historyDataChanged"));
		}
		/**
		 * get the error
		 */
		public function get error():String{
			return _error;
		}
		/**
		 * set the error
		 */
		public function set error(str:String):void{
			_error = str;
			dispatchEvent(new Event("historyDataChanged"));
		}
		/**
		 * get the details_error
		 */
		public function get details_error():String{
			return _type_of_event;
		}
		/**
		 * set the details_error
		 */
		public function set details_error(str:String):void{
			_details_error = str;
			dispatchEvent(new Event("historyDataChanged"));
		}
		
	}
}