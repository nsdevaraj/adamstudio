package com.adams.dt.business
{
	 
	import mx.rpc.IResponder;

	public final class CompaniesDAODelegate extends AbstractDelegate implements IDAODelegate
	{
	 	public function CompaniesDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.COMPANY_SERVICE );
			
			
		}

	}
}
