package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class FileDetailsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function FileDetailsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.FILE_DETAIL_SERVICE);
		}
 		override public function findByIdName(id:int,type:String):void
		{
			invoke("findByIdName",id,type);			
		}
		override public function findByMailFileId(id:int):void
		{
			invoke("findByMailFileId",id);
		}
		override public function findByNameFileId(mis:String,projid:int,fileid:int):void
		{
			invoke("findByNameFileId",mis,projid,fileid);
		}
		override public function findByIndProjId(mis:String,projid:int):void
		{
			invoke("findByIndProjId",mis,projid);
		}		
		override public function findByTaskId(taskId:int):void
		{
			invoke("findByTaskId",taskId);
		}	
		
	}
}
