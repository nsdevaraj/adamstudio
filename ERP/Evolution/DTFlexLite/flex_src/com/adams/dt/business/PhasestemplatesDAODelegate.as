package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class PhasestemplatesDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function PhasestemplatesDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.PHASE_TEMPLATE_SERVICE);
			
			
		}
	}
}
