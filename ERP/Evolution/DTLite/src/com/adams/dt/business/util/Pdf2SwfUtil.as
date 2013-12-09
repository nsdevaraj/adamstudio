package com.adams.dt.business.util
{
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.FileDetails;
	
	public class Pdf2SwfUtil
	{ 
		[Bindable]
		private static var model:ModelLocator = ModelLocator.getInstance();
		 	
		private static var convertSWFArr:Array = [];
		
		public static var firstConversion:Boolean;
		
		public static function doConvert( uppath:String, fileobj:FileDetails = null ):void {
			convertSWFArr.push( { "uppath":uppath, "fileobj":fileobj } );
			if( !firstConversion ) {
				loopConvertSWF();
			}
		}
		
		public static function loopConvertSWF():void {
			firstConversion = true;
			
			if( convertSWFArr.length > 0 ) {
				
				var uppath:String = convertSWFArr[ 0 ].uppath;
				var fileobj:FileDetails = convertSWFArr[ 0 ].fileobj;
				
				convertSWFArr.shift();
				
				var path:String = uppath.slice( 0, ( uppath.length - 4 ) );
				
				var convert:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CONVERT_FILE );
			 	convert.PDFconversionexe = model.pdfServerDir; 
				( convert.PDFconversionexe.indexOf( '.sh' ) != -1 ) ? uppath : uppath = path;
				convert.PDFfilepath = uppath;
				convert.fileObj = fileobj;
				convert.dispatch(); 
			}
			else {
				firstConversion = false;
				model.bgDownloadFile.idle = true;
				model.bgDownloadFile.isThumbDownload = true;
				model.bgDownloadFile.fileToDownload.list = model.thumbFiles.list; 
				
				var filedetailsTaskEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_SWFFILEDETAILS );
				filedetailsTaskEvent.dispatch();
			}
		}   
	}
}