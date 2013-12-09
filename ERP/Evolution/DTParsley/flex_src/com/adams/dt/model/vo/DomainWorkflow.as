package com.adams.dt.model.vo
{
	[RemoteClass(alias = "com.adams.dt.pojo.Domainworkflows")]	
	[Bindable]
	public final class DomainWorkflow implements IValueObject
	{
		private var _domain_workflow_ID : int;
		public function set domainWorkflowId (value : int) : void
		{
			_domain_workflow_ID = value;
		}

		public function get domainWorkflowId () : int
		{
			return _domain_workflow_ID;
		}
 
		private var _domain_FK : int;
		public function set domainFk (value : int) : void
		{
			_domain_FK = value;
		}

		public function get domainFk () : int
		{
			return _domain_FK;
		}
 
 		private var _workflow_FK : int;
		public function set workflowFk (value : int) : void
		{
			_workflow_FK = value;
		}

		public function get workflowFk () : int
		{
			return _workflow_FK;
		}
 
 		[PostConstruct]
  		public function DomainWorkflow()
		{
		}
	}
}