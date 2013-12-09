package com.adams.dt.business
{
	 
	import mx.rpc.IResponder;

	public final class SprintsDelegate extends AbstractDelegate implements IDAODelegate
	{
	 	public function SprintsDelegate( handlers:IResponder = null, service:String='' )
		{
			super( handlers, Services.SPRINTS_SERVICE );			
		}

	}
}
