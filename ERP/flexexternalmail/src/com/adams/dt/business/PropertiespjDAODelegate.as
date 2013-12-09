package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class PropertiespjDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function PropertiespjDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.PROPERTIES_PJ_SERVICE);			
		}  
	}
}
