package com.adams.dt.model.vo
{ 
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	[RemoteClass(alias = "com.adams.dt.pojo.Workflows")]	
	[Bindable]
	public final class Workflows implements IValueObject
	{
		private var _workflowId : int;
		public function set workflowId (value : int) : void
		{
			_workflowId = value;
		}

		public function get workflowId () : int
		{
			return _workflowId;
		}

		private var _workflowLabel : String;
		public function set workflowLabel (value : String) : void
		{
			_workflowLabel = value;
		}

		public function get workflowLabel () : String
		{
			return _workflowLabel;
		}

		private var _workflowCode : String;
		public function set workflowCode (value : String) : void
		{
			_workflowCode = value;
		}

		public function get workflowCode () : String
		{
			return _workflowCode;
		}  
		protected var _teamlineTemplateCollection:IList = new ArrayCollection();
		
		public function get teamlineTemplateCollection():IList {
			return _teamlineTemplateCollection;
		}
		
		public function set teamlineTemplateCollection(v:IList):void {
			_teamlineTemplateCollection=v;
		}
		
		
		protected var _phaseTemplateCollection:IList = new ArrayCollection();
		
		public function get phaseTemplateCollection():IList {
			return _phaseTemplateCollection;
		}
		
		public function set phaseTemplateCollection(v:IList):void {
			_phaseTemplateCollection=v;
		}
		
		public function Workflows()
		{
		}
	}
}
