package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class LangEntriesDelegate extends AbstractDelegate implements IDAODelegate
	{ 
		public function LangEntriesDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.LANG_SERVICE);
		}
 
	}
}
