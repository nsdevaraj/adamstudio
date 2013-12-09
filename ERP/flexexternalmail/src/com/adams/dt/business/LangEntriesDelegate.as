package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class LangEntriesDelegate extends AbstractDelegate implements IDAODelegate
	{ 
		public function LangEntriesDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.LANG_SERVICE);
		}
 		override public function findAll() : void
		{
			invoke("getList");
		}
		override public function getList() : void
		{
			invoke("getList"); //invoke("findAll");
		}
	}
}
