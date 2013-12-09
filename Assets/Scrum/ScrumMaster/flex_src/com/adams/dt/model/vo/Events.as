package com.adams.dt.model.vo
{
	import com.adams.dt.utils.GetVOUtil;
	
	import flash.utils.ByteArray;

	[RemoteClass(alias = "com.adams.dt.pojo.Events")]	
	[Bindable]
	public final class Events implements IValueObject
	{
		private var _eventId : int;
		public function set eventId (value : int) : void
		{
			_eventId = value;
		}

		public function get eventId () : int
		{
			return _eventId;
		}

		private var _eventDateStart : Date;
		public function set eventDateStart (value : Date) : void
		{
			_eventDateStart = value;
		}

		public function get eventDateStart () : Date
		{
			return _eventDateStart;
		}

		private var _eventType : int;
		public function set eventType (value : int) : void
		{
			_eventType = value;
		}

		public function get eventType () : int
		{
			return _eventType;
		}

		private var _personFk : int;
		public function set personFk (value : int) : void
		{
			_personFk = value;
			personObject = GetVOUtil.getVOObject(value,GetVOUtil.personList,'personId',Persons) as Persons;
		}

		public function get personFk () : int
		{
			return _personFk;
		}
		private var _personObject : Persons;
		public function  get personObject() : Persons
		{ 
			if(_personObject ==null)
			_personObject = GetVOUtil.getVOObject(_personFk,GetVOUtil.personList,'personId',Persons) as Persons; 
			return _personObject;
		}
		
		public function set personObject(person : Persons) : void
		{
			this._personObject = person;
			_personFk = person.personId;
		}
		
		
		private var _taskFk : int;
		public function set taskFk (value : int) : void
		{
			_taskFk = value;
		}

		public function get taskFk () : int
		{
			return _taskFk;
		}

		private var _details : ByteArray;
		public function set details (value : ByteArray) : void
		{
			_details = value;
		}

		public function get details () : ByteArray
		{
			return _details;
		}		
		
		private var _projectFk : int;
		public function set projectFk (value : int) : void
		{
			_projectFk = value;
			projectObject =  GetVOUtil.getVOObject(value,GetVOUtil.projectList,'projectId',Projects) as Projects;
		}

		public function get projectFk () : int
		{
			return _projectFk;
		}
		private var _projectObject:Projects;
		public function set projectObject(value : Projects) : void
		{
			_projectObject = value;
			_projectFk = value.projectId;
		}
		
		public function get projectObject() : Projects
		{
			if(_projectObject ==null)
			_projectObject =  GetVOUtil.getVOObject(_projectFk,GetVOUtil.projectList,'projectId',Projects) as Projects;
			return _projectObject;
		}

		private var _eventname : String;
		public function set eventName (value : String) : void
		{
			_eventname = value;
		}
		
		public function get eventName () : String
		{
			return _eventname;
		}		
		
		private var _workflowtemplatesFk : int;
		public function set workflowtemplatesFk (value : int) : void
		{
			_workflowtemplatesFk = value;
			workFlowTemplateObject =GetVOUtil.getVOObject(value,GetVOUtil.workflowTemplateList,'workflowTemplateId',Workflowstemplates) as Workflowstemplates;
		}

		public function get workflowtemplatesFk () : int
		{
			return _workflowtemplatesFk;
		}
		
		private var _workFlowTemplateObject:Workflowstemplates
		public function get workFlowTemplateObject():Workflowstemplates
		{
			if(_workFlowTemplateObject ==null)
			_workFlowTemplateObject =GetVOUtil.getVOObject(_workflowtemplatesFk,GetVOUtil.workflowTemplateList,'workflowTemplateId',Workflowstemplates) as Workflowstemplates;
			return _workFlowTemplateObject;
		}
		
		public function set workFlowTemplateObject(value:Workflowstemplates):void
		{
			_workFlowTemplateObject = value;
			_workflowtemplatesFk =value.workflowTemplateId;
		}
		

		public function Events()
		{
		}
	}
}
