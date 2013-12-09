package data
{
	import data.Interface.IModel;
	
	public class UploadDeatils implements IModel
	{
		private var _pk_task:String='';
		private var _imagename:String='';
		private var _imageSize:String='';
		private var _status:String='';
		public function UploadDeatils()
		{
		}
		/**
		 * set the status based on the value from task table
		 * @param str:String
		 * 1 = waiting
		 * 2 = inprogress
		 * 3 = delivered
		 * 4 = archived 
		 */
		public function set status(str:String):void{
			switch(str){
				case "1":
					_status = "uploaded";
				break;
				case "2":
					_status = "delivered";
				break
			}
		}
		/**
		 * set the pk_task
		 */
		public function set pk_task(str:String):void{
			_pk_task = str;
		}
		/**
		 * get the status 
		 */
		public function get status():String{
			return _status
		}
		/**
		 * get the pk_task
		 */
		public function get pk_task():String{
			return _pk_task;
		}
		/**
		 * set the pk_task
		 */
		public function set imagename(str:String):void{
			_imagename = str;
		}
		/**
		 * get the pk_task
		 */
		public function get imagename():String{
			return _imagename;
		}
		/**
		 * set the pk_task
		 */
		public function set imagesize(str:String):void{
			_imageSize = str;
		}
		/**
		 * get the pk_task
		 */
		public function get imagesize():String{
			return _imageSize;
		}
		
	}
}