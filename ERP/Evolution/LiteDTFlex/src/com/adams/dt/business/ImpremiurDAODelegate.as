package com.adams.dt.business
{
	import mx.rpc.IResponder;
	
	public class ImpremiurDAODelegate  extends AbstractDelegate implements IDAODelegate
	{
		public function ImpremiurDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.IMPREMIUR_SERVICE);
		}  
	}
}