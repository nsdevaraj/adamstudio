/**
 * @author K.Sathish Balaji
 * 24-10-2008
 * */
package data
{
	import data.Interface.IModel;
	
	import mx.collections.ArrayCollection;
	/**
	 * use to store the Tasks table data
	 * */
	public class Tasks implements IModel
	{
		public var _pk_task:String='';
		private var _label:String='';
		private var _userid:String='';
		private var _comments:String='';
		public var _status:String='';
		private var _creator:String='';
		private var _datetime_of_creation:String = "0000-00-00 00:00:00";
		private var _number_of_images:String='';
		private var _dedline:String = "0000-00-00 00:00:00";;
		private var _datetime_of_estimated:String = "0000-00-00 00:00:00";;
		private var _date_of_delivery:String = "0000-00-00 00:00:00";;
		private var _datetime_archive:String = "0000-00-00 00:00:00";;
		private var _time_spending:String='';
		private var _activated:String='';
		private var _uploadedImageData:ArrayCollection = new ArrayCollection();	
		private var _deliveredImageData:ArrayCollection = new ArrayCollection();		
		public function Tasks()
		{
			_pk_task = new String();
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
			_status = str
		}
		/**
		 * get the status 
		 */
		public function get statusVal():String{
			var statusVal:String=""
			switch(_status){
				case "1":
					statusVal = "waiting";
				break;
				case "2":
					statusVal = "inprogress";
				break
				case "3":
					statusVal = "delivered";
				break
				case "4":
					statusVal = "archived";
				break
			}
			return statusVal;
		}
		/**
		 * get the status 
		 */
		public function get status():String{			
			return _status;
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
		public function set pk_task(str:String):void{
			_pk_task = str;
		}
		/**
		 * get the userid
		 */
		public function get userid():String{
			return _userid;
		}
		/**
		 * set the userid
		 */
		public function set userid(str:String):void{
			_userid = str;
		}
		
		/**
		 * get the label
		 */
		public function get label():String{
			return _label;
		}
		/**
		 * set the label
		 */
		public function set label(str:String):void{
			_label = str;
		}
		
		/**
		 * get the comments
		 */
		public function get comments():String{
			return _comments;
		}
		/**
		 * set the comments
		 */
		public function set comments(str:String):void{
			_comments = str;
		}
		
		/**
		 * get the label
		 */
		public function get creator():String{
			return _creator;
		}
		/**
		 * set the label
		 */
		public function set creator(str:String):void{
			_creator = str;
		}
		
		/**
		 * get the label
		 */ 
		public function get datetime_of_creation():String{
			return _datetime_of_creation;
		}
		/**
		 * set the label
		 */
		public function set datetime_of_creation(str:String):void{
			_datetime_of_creation = str;
		}
		
		/**
		 * get the label
		 */
		public function get number_of_images():String{
			return _number_of_images;
		}
		/**
		 * set the label
		 */
		public function set number_of_images(str:String):void{
			_number_of_images = str;
		}
		/**
		 * get the label
		 */
		public function get dedline():String{
			return _dedline;
			
		}
		/**
		 * set the label
		 */
		public function set dedline(str:String):void{			
			_dedline =str;
		}
		
		/**
		 * get the label
		 */
		public function get datetime_of_estimated():String{
			return _datetime_of_estimated;
		}
		/**
		 * set the label
		 */
		public function set datetime_of_estimated(str:String):void{
			_datetime_of_estimated = str;
		}
		
		/**
		 * get the label
		 */
		public function get date_of_delivery():String{
			return _date_of_delivery;
		}
		/**
		 * set the label
		 */
		public function set date_of_delivery(str:String):void{
			
			_date_of_delivery = str;
		}
		
		/**
		 * get the label
		 */
		public function get datetime_archive():String{
			return _datetime_archive;
		}
		/**
		 * set the label
		 */
		public function set datetime_archive(str:String):void{
			
			_datetime_archive = str;
		}
		
		/**
		 * get the label
		 */
		public function get time_spending():String{
			return _time_spending;
		}
		/**
		 * set the label
		 */
		public function set time_spending(str:String):void{
			_time_spending = str;
		}
		
		/**
		 * get the label
		 */
		public function get activated():String{
			return _activated;
		}
		/**
		 * set the label
		 */
		public function set activated(str:String):void{
			_activated = str;
		}
		/**
		 * get the label
		 */
		public function get uploadedImageData():ArrayCollection{
			var imageDeatils:ArrayCollection = new ArrayCollection();
			for(var i:int=0;i<_uploadedImageData.length;i++){
				imageDeatils.addItem({No:(i+1),name:_uploadedImageData[i].imagename,size:_uploadedImageData[i].imagesize});
			}
			return imageDeatils;
		}
		/**
		 * set the label
		 */
		public function set uploadedImageData(obj:ArrayCollection):void{
			_uploadedImageData = obj;
		}
		/**
		 * get the label
		 */
		public function get uploadedImage():ArrayCollection{
			
			return _uploadedImageData;
		}
		/**
		 * get the label
		 */
		public function get deliveredImageData():ArrayCollection{
			var imageDeatils:ArrayCollection = new ArrayCollection();
			for(var i:int=0;i<_deliveredImageData.length;i++){
				imageDeatils.addItem({No:(i+1),name:_deliveredImageData[i].imagename,size:_deliveredImageData[i].imagesize});
			}
			return imageDeatils;
		}
		/**
		 * get the label
		 */
		public function get deliveredImage():ArrayCollection{
			
			return _deliveredImageData;
		}
		/**
		 * set the label
		 */
		public function set deliveredImageData(obj:ArrayCollection):void{
			_deliveredImageData = obj;
		}

	}
}