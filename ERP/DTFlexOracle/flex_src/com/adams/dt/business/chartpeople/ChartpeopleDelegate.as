package com.adams.dt.business.chartpeople
{
	import com.adams.dt.business.AbstractDelegate;
	import com.adams.dt.business.IDAODelegate;
	import com.adams.dt.business.Services;
	
	import mx.rpc.IResponder;	
	public final class ChartpeopleDelegate extends AbstractDelegate implements IDAODelegate
	{
		public function ChartpeopleDelegate(handlers:IResponder = null, service:String='')
		{ 
			super(handlers, Services.PROJECT_SERVICE );
			
			
		} 
	}
}
