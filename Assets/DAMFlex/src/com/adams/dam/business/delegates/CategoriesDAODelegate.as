package com.adams.dam.business.delegates
{
	import com.adams.dam.business.Services;
	import com.adams.dam.business.interfaces.IDAODelegate;
	
	import mx.rpc.IResponder;
	
	public final class CategoriesDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function CategoriesDAODelegate( handlers:IResponder = null, service:String = '' )
		{
			super( handlers, Services.CATEGORY_SERVICE );
		}
	}
}
