package com.adams.dt.business
{
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	
	import mx.rpc.IResponder;
	public final class EventsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function EventsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers,Services.EVENT_SERVICE);
		} 
	}
}
