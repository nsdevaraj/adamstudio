package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class GroupsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function GroupsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.GROUP_SERVICE);
			
			
		} 
	}
}
