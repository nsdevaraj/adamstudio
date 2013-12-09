package com.adams.dt.model.vo
{
	import com.adams.dt.utils.GetVOUtil;

	[RemoteClass(alias = "com.adams.dt.pojo.TeamTemplates")]	
	[Bindable]
	public final class TeamTemplates implements IValueObject
	{
		private var _teamTemplateId : int;
		public function set teamTemplateId (value : int) : void
		{
			_teamTemplateId = value;
		}

		public function get teamTemplateId () : int
		{
			return _teamTemplateId;
		}
 

		private var _teamTemplateLabel : String;
		public function set teamTemplateLabel (value : String) : void
		{
			_teamTemplateLabel = value;
		}

		public function get teamTemplateLabel () : String
		{
			return _teamTemplateLabel;
		}
		
		private var _workflowObject : Workflows;
		
		public function get workflowObject():Workflows
		{
			if(_workflowObject == null)
			_workflowObject =  GetVOUtil.getVOObject(_workflowFk,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
			return _workflowObject;
		}
		
		public function set workflowObject(value:Workflows):void
		{
			_workflowObject = value;
			_workflowFk = value.workflowId;
		}
		
		private var _workflowFk: int;
		public function set workflowFk(value : int) : void
		{
			_workflowFk= value;
			workflowObject =  GetVOUtil.getVOObject(value,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
		}

		public function get workflowFk() : int
		{
			return _workflowFk;
		}
		
		public function TeamTemplates()
		{
		}
	}
}