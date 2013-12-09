package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class TeamlineTemplatesDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function TeamlineTemplatesDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.TEAMLINE_TEMPLATE_SERVICE);
			
			
		} 
	}
}
