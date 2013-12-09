package com.adams.dt.business
{
	 
	import mx.rpc.IResponder;

	public final class ReportDelegate extends AbstractDelegate implements IDAODelegate
	{
	 	public function ReportDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.REPORT_SERVICE );			
		}

	}
}
