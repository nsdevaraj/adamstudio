package com.adams.dt.business
{
 	import mx.rpc.IResponder;
    
	public class DirectoryDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		 
		public function DirectoryDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.DIRECTORY_SERVICE);
			
			
		}   
		
		
		override public function createSubDir(parentFilePath:String,dirName:String):void{
			invoke("createSubDir",parentFilePath,dirName);
		}
		
		/* override public function moveDirectory(parentFilePath:String,dirName:String):void{
			invoke("createSubDir",parentFilePath,dirName);
		} */
		
			

	}

}	