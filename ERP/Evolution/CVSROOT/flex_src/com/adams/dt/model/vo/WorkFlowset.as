package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	[Bindable]
	public final class WorkFlowset implements IValueObject
	{
		private var _frontWFTask : Workflowstemplates;
		public function set frontWFTask (value : Workflowstemplates) : void
		{
			_frontWFTask = value;
		}

		public function get frontWFTask () : Workflowstemplates
		{
			return _frontWFTask;
		}

		private var _backWFTask : Workflowstemplates;
		public function set backWFTask (value : Workflowstemplates) : void
		{
			_backWFTask = value;
		}

		public function get backWFTask () : Workflowstemplates
		{
			return _backWFTask;
		}
		
		private var _frontWorkFlowId : int;
		public function set frontWorkFlowId (value : int) : void
		{
			_frontWorkFlowId = value;
		}

		public function get frontWorkFlowId () : int
		{
			return _frontWorkFlowId;
		}
		
		private var _backWorkFlowId : int;
		public function set backWorkFlowId (value : int) : void
		{
			_backWorkFlowId = value;
		}

		public function get backWorkFlowId () : int
		{
			return _backWorkFlowId;
		}
		
		private var _phasesId : int;
		public function set phasesId (value : int) : void
		{
			_phasesId = value;
		}

		public function get phasesId () : int
		{
			return _phasesId;
		}
	}
}