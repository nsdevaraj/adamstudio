package com.adams.dt.business
{
	import com.adams.dt.model.vo.Categories;
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	public final class CategoriesDAODelegate extends AbstractDelegate implements IDAODelegate
	{ 
		public function CategoriesDAODelegate(handlers:IResponder = null, service:String='')
		{		
			super(handlers, Services.CATEGORY_SERVICE );	
		} 
		override public function findDomain(code : String) : void
		{
			invoke("findDomain",code);
		}
 
 		override public function findAll() : void
		{
			invoke("getList");//invoke("findAll");
		}
		override public function getList() : void
		{
			invoke("getList"); //invoke("findAll");
		}		
	}
}
