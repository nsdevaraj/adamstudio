package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class GroupsPersonsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function GroupsPersonsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.GROUPPERSON_SERVICE);
		}

	}
}