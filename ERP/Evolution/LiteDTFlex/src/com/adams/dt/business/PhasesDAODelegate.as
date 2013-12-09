package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class PhasesDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function PhasesDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.PHASE_SERVICE );
			
			
		}  
	}
}
