package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import mx.collections.ArrayCollection;

	[RemoteClass(alias = "com.adams.dt.pojo.TeamTemplates")]	
	[Bindable]
	public final class TeamTemplates extends AbstractVO
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
 
		
		private var _workflowFk: int;
		public function set workflowFk(value : int) : void
		{
			_workflowFk= value;
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