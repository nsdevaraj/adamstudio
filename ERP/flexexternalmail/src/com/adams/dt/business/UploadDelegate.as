package com.adams.dt.business
{ 
	import flash.utils.ByteArray;
	
	import mx.rpc.IResponder;
	public final class UploadDelegate extends AbstractDelegate implements IDAODelegate
	{
		public function UploadDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.UPLOAD_SERVICE);
		}
				
		override public function doUpload(bytearr:ByteArray, filename:String, filepath:String) : void
		{
			invoke("doUpload",bytearr, filename, filepath);
		} 
		
		override public function doDownload(filepath:String) : void
		{
			invoke("doDownload",filepath);
		} 
 
	}
}
