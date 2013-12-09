package com.adams.dam.event
{
	import com.adams.dam.model.vo.FileDetails;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class FileDetailsEvent extends UMEvent
	{
		
		public static const GET_ALL_FILES:String = "getAllFiles";
		public static const EVENT_CREATE_FILEDETAILS:String = 'createFileDetails';
		public static const EVENT_UPDATE_FILEDETAILS:String = "updateFileDetails";
		public static const EVENT_SELECT_FILEDETAILS:String = 'selectFileDetails';
		public static const EVENT_BGUPLOAD_FILE:String = 'backgrounduploadfiles';
		public static const EVENT_BGDOWNLOAD_FILE:String = 'backgrounddownloadfiles';
		public static const EVENT_CONVERT_FILE:String = 'convertPDF2SWF';
		public static const EVENT_CREATE_SWFFILEDETAILS:String = 'createSwfFileDetails';
		
		public var fileDetails:FileDetails;
		public var bulkDownload:Boolean;
		public var thumbDownload:Boolean;
		public var fdToCreate:ArrayCollection;
		public var PDFfilepath:String;
		public var PDFconversionexe:String;
		
		public function FileDetailsEvent( eventType:String, handlers:IResponder = null, bubbles:Boolean = true, cancelable:Boolean=false, data:* = null ) {
			super( eventType, handlers, true, false, data );
		}
	}
}