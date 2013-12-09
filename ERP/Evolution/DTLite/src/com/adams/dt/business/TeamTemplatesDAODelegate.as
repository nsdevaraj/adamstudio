package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class TeamTemplatesDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function TeamTemplatesDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.TEAM_TEMPLATE_SERVICE);
			
			
		}

	 
	}
}
