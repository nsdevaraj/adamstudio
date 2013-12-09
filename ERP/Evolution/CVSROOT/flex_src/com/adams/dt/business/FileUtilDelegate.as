package com.adams.dt.business
{ 	
	import mx.rpc.IResponder;
	public final class FileUtilDelegate extends AbstractDelegate implements IDAODelegate
	{
		public function FileUtilDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.UPLOAD_SERVICE);
		}
		override public function doConvert( filePath:String, exe:String) : void
		{
			invoke("doConvert",filePath, exe);
		} 
		override public function copyDirectory(frompath : String,topath:String) : void
		{
			invoke("copyDirectory",frompath,topath );
		} 
	}
}
