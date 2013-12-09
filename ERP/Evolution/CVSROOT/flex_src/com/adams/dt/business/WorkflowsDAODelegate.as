package com.adams.dt.business
{
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Workflows;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;

	public final class WorkflowsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function WorkflowsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.WORKFLOW_SERVICE);
			
			
		}
		override public function findByDomainWorkFlow(vo:IValueObject):void{
			invoke("findByDomainWorkFlow", Workflows(vo).workflowId);
		}
		override public function findWorkflow(vo:int):void{
			invoke("findWorkflow", vo);
		}
		
 
	}
}
