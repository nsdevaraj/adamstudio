package com.adams.dam.business.delegates
{
	import com.adams.dam.business.Services;
	import com.adams.dam.business.interfaces.IDAODelegate;
	
	import mx.rpc.IResponder;
	
	public final class FileDetailsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function FileDetailsDAODelegate( handlers:IResponder = null, service:String = '' )
		{
			super( handlers, Services.FILE_DETAIL_SERVICE );
		}
		
		override public function findByMailFileId( id:int ):void {
			invoke( "findByMailFileId", id );
		}
	}
}
