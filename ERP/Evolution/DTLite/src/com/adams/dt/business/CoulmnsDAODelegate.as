package com.adams.dt.business
{
	 
	import mx.rpc.IResponder;

	public final class CoulmnsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
	 	public function CoulmnsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.COLUMN_SERVICE );
			
			
		}

	}
}
