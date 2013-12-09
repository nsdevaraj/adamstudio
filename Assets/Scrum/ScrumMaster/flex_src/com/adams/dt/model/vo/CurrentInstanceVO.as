package com.adams.dt.model.vo
{
	import mx.collections.ArrayCollection;
	

	[Bindable]
	public class CurrentInstanceVO implements IValueObject
	{
		public function CurrentInstanceVO()
		{ 
		} 
		private var _config:ConfigVO = new ConfigVO();
		public function set config (value:ConfigVO):void
		{
			_config = value;
		}

		public function get config ():ConfigVO
		{
			return _config;
		}
		private var _currentProject:Projects;
		public function set currentProject (value:Projects):void
		{
			_currentProject = value;
		}

		public function get currentProject ():Projects
		{
			return _currentProject;
		}  
		private var _currentWorkflow:Workflows;
		public function set currentWorkflow (value:Workflows):void
		{
			_currentWorkflow = value;
		}
		
		public function get currentWorkflow ():Workflows
		{
			return _currentWorkflow;
		}  
		
		private var _currentTask:Tasks;
		public function set currentTask (value:Tasks):void
		{
			_currentTask = value;
		}

		public function get currentTask ():Tasks
		{
			return _currentTask;
		}
		
		private var _currentPerson:Persons;
		public function set currentPerson (value:Persons):void
		{
			_currentPerson = value;
		}

		public function get currentPerson ():Persons
		{
			return _currentPerson;
		}
		private var _currentDomain:Categories;
		public function set currentDomain (value:Categories):void
		{
			_currentDomain = value;
		}
		
		public function get currentDomain ():Categories
		{
			return _currentDomain;
		}
		private var _currentCategory:Categories;
		public function set currentCategory (value:Categories):void
		{
			_currentCategory = value;
		}
		
		public function get currentCategory ():Categories
		{
			return _currentCategory;
		} 
		private var _currentWorkFlowCollection:ArrayCollection = new ArrayCollection();
		public function set currentWorkFlowCollection (value:ArrayCollection):void
		{
			_currentWorkFlowCollection = value;
		}
		
		public function get currentWorkFlowCollection ():ArrayCollection
		{
			return _currentWorkFlowCollection;
		}
		
		private var _currentDomainCollection:ArrayCollection = new ArrayCollection();
		public function set currentDomainCollection (value:ArrayCollection):void
		{
			_currentDomainCollection = value;
		}
		
		public function get currentDomainCollection ():ArrayCollection
		{
			return _currentDomainCollection;
		}
	}
}