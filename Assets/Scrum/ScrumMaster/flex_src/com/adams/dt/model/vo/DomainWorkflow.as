package com.adams.dt.model.vo
{
	import com.adams.dt.utils.GetVOUtil;
	
	[RemoteClass(alias = "com.adams.dt.pojo.Domainworkflows")]	
	[Bindable]
	public final class DomainWorkflow implements IValueObject
	{
		private var _domain_workflow_ID : int;

		public function get workflowObject():Workflows
		{
			if(_workflowObject ==null)
			_workflowObject =  GetVOUtil.getVOObject(_workflow_FK,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
			return _workflowObject;
		}

		public function set workflowObject(value:Workflows):void
		{
			_workflowObject = value;
			_workflow_FK = value.workflowId;
		}

		public function get categoryObject():Categories
		{
			if(_categoryObject == null)
			_categoryObject =  GetVOUtil.getVOObject(_domain_FK,GetVOUtil.categoryList,'categoryId',Categories) as Categories;
			return _categoryObject;
		}

		public function set categoryObject(value:Categories):void
		{
			_categoryObject = value;
			_domain_FK = value.categoryId;
		}

		public function set domainWorkflowId (value : int) : void
		{
			_domain_workflow_ID = value;
		}

		public function get domainWorkflowId () : int
		{
			return _domain_workflow_ID;
		}
		private var _categoryObject:Categories;
		private var _workflowObject:Workflows;
		
		private var _domain_FK : int;
		public function set domainFk (value : int) : void
		{
			_domain_FK = value;
			categoryObject =  GetVOUtil.getVOObject(value,GetVOUtil.categoryList,'categoryId',Categories) as Categories;
		}
		public function get domainFk () : int
		{
			return _domain_FK;
		}
 
 		private var _workflow_FK : int;
		public function set workflowFk (value : int) : void
		{
			_workflow_FK = value;
			workflowObject =  GetVOUtil.getVOObject(value,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
		}

		public function get workflowFk () : int
		{
			return _workflow_FK;
		}
 
  		public function DomainWorkflow()
		{
		}
	}
}
