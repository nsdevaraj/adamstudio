package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import mx.collections.ArrayCollection;

	[RemoteClass(alias = "com.adams.dt.pojo.Phasestemplates")]	
	[Bindable]
	public final class Phasestemplates extends AbstractVO
	{
		private var _phaseTemplateId : int;
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