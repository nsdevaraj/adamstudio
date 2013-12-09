package com.adams.dt.model.vo
{ 
	import com.adams.dt.utils.GetVOUtil;
	
	[RemoteClass(alias = "com.adams.dt.pojo.Phasestemplates")]	
	[Bindable]
	public final class Phasestemplates implements IValueObject
	{
		private var _workflowObject : Workflows;
		private var _phaseTemplateId : int;

		public function get workflowObject():Workflows
		{
			if(_workflowObject == null)
				_workflowObject =  GetVOUtil.getVOObject(_workflowId,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
			return _workflowObject;
		}

		public function set workflowObject(value:Workflows):void
		{
			_workflowObject = value;
			_workflowId = value.workflowId;
		}

		public function set phaseTemplateId (value : int) : void
		{
			_phaseTemplateId = value;
		}

		public function get phaseTemplateId () : int
		{
			return _phaseTemplateId;
		}
		 
		private var _phaseName : String;
		public function set phaseName (value : String) : void
		{
			_phaseName = value;
		}

		public function get phaseName () : String
		{
			return _phaseName;
		}

		private var _phaseDurationDays : int;
		public function set phaseDurationDays (value : int) : void
		{
			_phaseDurationDays = value;
		}

		public function get phaseDurationDays () : int
		{
			return _phaseDurationDays;
		}
		
		private var _workflowId : int;
		public function set workflowId (value : int) : void
		{
			_workflowId = value;
 			workflowObject =  GetVOUtil.getVOObject(value,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
			workflowObject.phaseTemplateCollection.addItem(this);
		}

		public function get workflowId () : int
		{
			return _workflowId;
		}


		public function Phasestemplates()
		{
		}
	}
}