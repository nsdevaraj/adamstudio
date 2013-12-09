package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class FileDetailsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function FileDetailsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.FILE_DETAIL_SERVICE);
		}
 
		override public function findByTaskId(id:int):void
		{
			invoke("findByTaskId",id);
		}
		override public function findByIdName(id:int,str:String):void
		{
			invoke("findByIdName",id,str);
		}
		
		override public function findByMailFileId(id:int):void
		{
			invoke("findByMailFileId",id);
		}
		//Query change
		override public function findByBasicMessageId(id:int,str:String):void
		{
			invoke("findByBasicMessageId",id,str);
		}
		
	}
}
