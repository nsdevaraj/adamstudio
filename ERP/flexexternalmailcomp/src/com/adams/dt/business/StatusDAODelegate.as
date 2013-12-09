package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class StatusDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function StatusDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.STATUS_SERVICE);		
			
		}
 		override public function findAll() : void 
		{
			invoke("findAll");
		}
	}
}
