package com.adams.dt.event
{
	import com.adams.dt.model.vo.FileDetails;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class FileDetailsEvent extends UMEvent
	{
		
		public static const EVENT_GET_ALL_FILEDETAILS:String='getAllFileDetails';
		public static const EVENT_GET_FILEDETAILS:String='getFileDetails';
		public static const EVENT_GET_REFFILEDETAILS:String='getRefFileDetails';
		public static const EVENT_CREATE_FILEDETAILS:String='createFileDetails';
		public static const EVENT_UPDATE_FILEDETAILS:String='updateFileDetails';
		public static const EVENT_DELETE_FILEDETAILS:String='deleteFileDetails';
		public static const EVENT_SELECT_FILEDETAILS:String='selectFileDetails';
		public static const EVENT_GET_BASICFILEDETAILS:String='getBasictFileDetails';
		public static const EVENT_GET_TASKFILEDETAILS:String='getTaskFileDetails';
		public static const EVENT_GET_SWFFILEDETAILS:String='getSwfFileDetails';
		public static const EVENT_GET_INDFILEDETAILS:String='getINDSwfFileDetails';
		public static const EVENT_BGUPLOAD_FILE:String='backgrounduploadfiles';
		public static const EVENT_BGDOWNLOAD_FILE:String='backgrounddownloadfiles';
		public static const EVENT_UPDATE_DETAILS:String='update';
		public static const EVENT_GET_MESSAGEFILEDETAILS:String='getMessageFileDetails';
		public static const EVENT_GET_MESSAGE_BASICFILEDETAILS:String='getMessageBasicFileDetails';
		public static const EVENT_CREATE_MSG_DUPLI_FILE:String='getMsgDuplicateFileDetails';
		public static const EVENT_CONVERT_FILE:String='convertPDF2SWF';
		public static const EVENT_CREATE_SWFFILEDETAILS:String='createSwfFileDetails';
		public static const EVENT_DUPLICATE_FILEDETAILS:String='duplicateFileDetails';
		public static const EVENT_DELETEALL_FILEDETAILS:String='deleteALLDetails';
		public static const EVENT_REFRESH_FILEDETAILS:String='refreshDetails';
		public static const EVENT_GETPROJECT_FILEDETAILS:String='ProjectAllFileDetails';
		public static const EVENT_CREATE_REF_FILEDETAILS:String='createRefFileDetails';
		public static const EVENT_GET_FILEDETAILSBYID:String='getFileDetailsById';				

		public var fileDeatils:ArrayCollection;
		public var swfFiles:ArrayCollection;
		public var fileDetailsObj:FileDetails;
		public var fileObj:FileDetails;
		public var swffileDetailsObj:FileDetails;
		public var messageColl:ArrayCollection = new ArrayCollection;
		
		public var bytesPDFFile:ByteArray;
		public var PDFfilename:String;
		public var PDFfilepath:String;
		public var PDFconversionexe:String;
		
		public var projectId:int;
		
		public var bulkDownload:Boolean;
		
		public var thumbDownload:Boolean;
		
		public function FileDetailsEvent( pType:String, handlers:IResponder=null, bubbles:Boolean=true, cancelable:Boolean=false, pFileDeatils:ArrayCollection=null ) {
			fileDeatils = pFileDeatils;
			super( pType, handlers, true, false, fileDeatils );
		}
	}
}