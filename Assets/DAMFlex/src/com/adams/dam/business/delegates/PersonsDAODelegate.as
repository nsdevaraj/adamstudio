package com.adams.dam.business.delegates
{
	import com.adams.dam.business.Services;
	import com.adams.dam.business.interfaces.IDAODelegate;
	
	import mx.rpc.IResponder;
	
	public final class PersonsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function PersonsDAODelegate( handlers:IResponder = null, service:String = '' )
		{
			super( handlers, Services.PERSON_SERVICE );
		}
	}
}
