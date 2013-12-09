package com.adams.dt.business
{
	import com.adams.dt.model.vo.Categories;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	public final class ModuleDAODelegate extends AbstractDelegate implements IDAODelegate
	{ 
		public function ModuleDAODelegate(handlers:IResponder = null, service:String='')
		{		
			super(handlers, Services.MODULE_SERVICE );
		}

	}
}
