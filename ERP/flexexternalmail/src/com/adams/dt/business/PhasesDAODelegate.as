package com.adams.dt.business
{
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class PhasesDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function PhasesDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.PHASE_SERVICE );	
		}  
		override public function findAll() : void
		{
			invoke("getList");//invoke("findAll");
		}
		override public function getList() : void
		{
			invoke("getList"); //invoke("findAll");
		}
		override public function bulkUpdate(collection : ArrayCollection) : void
		{
			invoke("bulkUpdate",collection);
		}	
	}
}
