package com.adams.dt.business
{
	 
	import mx.rpc.IResponder;

	public final class ProjectMessageDelegate extends AbstractDelegate implements IDAODelegate
	{
	 	public function ProjectMessageDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.COMPANY_SERVICE );			
		}

	}
}
