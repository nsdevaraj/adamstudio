package com.adams.dt.event
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import com.adams.dt.model.vo.FileDetails;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class FileDetailsEvent extends UMEvent
	{
		public static const EVENT_SELECT_FILEDETAILS:String='selectFileDetails';
		public static const EVENT_GET_FILEDETAILS:String='getFileDetails';
		public static const EVENT_SAVEAS_FILE:String='saveAsfiles';
		public static const EVENT_UPLOAD_FILE:String='uploadfiles';
		public static const EVENT_MAILCREATE_FILEDETAILS:String='createMailFileDetails';
		public static const EVENT_SELECT_IMP_FILE:String='selectIMPFileDetails';
		public static const EVENT_GET_IMPFILEDETAILS:String='getIMPFileDetails';
		public static const EVENT_IMPSAVEAS_FILE:String='getIMPSaveDetails';
		

		/* public static const EVENT_GET_ALL_FILEDETAILS:String='getAllFileDetails';
		public static const EVENT_GET_FILEDETAILS:String='getFileDetails';
		public static const EVENT_CREATE_FILEDETAILS:String='createFileDetails';
		public static const EVENT_UPDATE_FILEDETAILS:String='updateFileDetails';
		public static const EVENT_DELETE_FILEDETAILS:String='deleteFileDetails';
		public static const EVENT_SELECT_FILEDETAILS:String='selectFileDetails';
		public static const EVENT_GET_BASICFILEDETAILS:String='getBasictFileDetails';
		public static const EVENT_GET_TASKFILEDETAILS:String='getTaskFileDetails';
		public static const EVENT_GET_SWFFILEDETAILS:String='getSwfFileDetails';
		public static const EVENT_BGUPLOAD_FILE:String='backgrounduploadfiles';
		public static const EVENT_BGDOWNLOAD_FILE:String='backgrounddownloadfiles';
		public static const EVENT_SAVEAS_FILE:String='saveAsfiles';
		public static const EVENT_UPDATE_DETAILS:String='update';
		public static const EVENT_GET_MESSAGEFILEDETAILS:String='getMessageFileDetails';
		public static const EVENT_GET_MESSAGE_BASICFILEDETAILS:String='getMessageBasicFileDetails';
		public static const EVENT_CREATE_MSG_DUPLI_FILE:String='getMsgDuplicateFileDetails'; */

		public var fileDeatils:ArrayCollection;
		public var fileDetailsObj:FileDetails;
		public var fileObj:Object;
		public var messageColl:ArrayCollection;
		
		public var filedetailsVo:FileDetails;
		public var storeByteArray:ByteArray = new ByteArray();
		public var fileName:String = "";
		public var filePath:String = "";
		public var impFileVo:FileDetails;
		
		public function FileDetailsEvent (pType:String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pFileDeatils:ArrayCollection=null ){
			
			fileDeatils = pFileDeatils;
			super(pType,handlers,true,false,fileDeatils);
			
		}
	}

}