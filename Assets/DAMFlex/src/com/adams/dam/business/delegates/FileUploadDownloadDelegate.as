package com.adams.dam.business.delegates
{ 
	import com.adams.dam.business.Services;
	import com.adams.dam.business.interfaces.IDAODelegate;
	
	import flash.utils.ByteArray;
	
	import mx.rpc.IResponder;
	
	public final class FileUploadDownloadDelegate extends AbstractDelegate implements IDAODelegate
	{
		public function FileUploadDownloadDelegate( handlers:IResponder = null, service:String = '' )
		{
			super( handlers, Services.UPLOAD_DOWNLOAD_SERVICE );
		}
		
		override public function doUpload( bytearr:ByteArray, filename:String, filepath:String ):void {
			invoke( "doUpload", bytearr, filename, filepath );
		} 
		
		override public function doDownload( filepath:String ):void {
			invoke( "doDownload", filepath );
		} 
		
		override public function doConvert( filePath:String, exe:String ):void {
			invoke( "doConvert", filePath, exe );
		} 
		
		override public function copyDirectory( frompath:String, topath:String ):void {
			invoke( "copyDirectory", frompath, topath );
		} 
	}
}
