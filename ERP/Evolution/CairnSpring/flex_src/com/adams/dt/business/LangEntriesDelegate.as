package com.adams.dt.business
{
	import mx.rpc.IResponder;
	
	/**
	 * final LangEntriesDelegate class
	 * extends AbstractDelegate class
	 * implements IDAODelegate class
	 */
	public final class LangEntriesDelegate extends AbstractDelegate implements IDAODelegate
	{ 
		/**
		 * LangEntriesDelegate class constructor
		 * @param IResponder value pass
		 * @param Services name pass
		 */
		public function LangEntriesDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.LANG_SERVICE);
		}
	}
}
