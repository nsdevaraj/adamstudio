package com.adams.dt.business
{
	import com.adams.dt.model.vo.Categories;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;

	public final class DomainWorkflowsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function DomainWorkflowsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.DOMAIN_SERVICE);
		}
		override public function findByDomainWorkFlow(vo:IValueObject):void{
			invoke("findByDomainWorkFlow", Categories(vo).categoryId);
		}  
	}
}
