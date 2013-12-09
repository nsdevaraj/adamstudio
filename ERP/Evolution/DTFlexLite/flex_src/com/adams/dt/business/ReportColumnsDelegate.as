package com.adams.dt.business
{
	 
	import mx.rpc.IResponder;

	public final class ReportColumnsDelegate extends AbstractDelegate implements IDAODelegate
	{
	 	public function ReportColumnsDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.REPORT_COL_SERVICE );			
		}

	}
}
