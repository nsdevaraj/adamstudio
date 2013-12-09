package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	import mx.collections.ArrayCollection;
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
		private var _domainFk : Categories;
		public function set domainFk (value : Categories) : void
		{
			_domainFk = value;
		}

		public function get domainFk () : Categories
		{
			return _domainFk;
		}

		public function Workflows()
		{
		}
	}
}
