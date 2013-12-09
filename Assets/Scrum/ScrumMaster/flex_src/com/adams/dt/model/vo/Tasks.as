package com.adams.dt.model.vo
{
	import com.adams.dt.model.collections.ProjectCollection;
	import com.adams.dt.utils.GetVOUtil;
	
	import flash.utils.ByteArray;
	
	[RemoteClass(alias = "com.adams.dt.pojo.Tasks")]	
	[Bindable]
	public final class Tasks implements IValueObject
	{
		
		private var _projectList:ProjectCollection;   
 		private var _taskId : int;

		public function get projectList():ProjectCollection
		{
			return _projectList;
		}
		[Inject]
		public function set projectList(value:ProjectCollection):void
		{
			_projectList = value;
		}

		public function set taskId (value : int) : void
		{
			_taskId = value;
		}

		public function get taskId () : int
		{
			return _taskId;
		}
		public var taskCommentBlob:Object;
		public var firstofPhase : Boolean;
		public var lastofPhase : Boolean;
		public var phase : Phases;
		private var _projectFK:int
		public function set projectFK(value : int) : void
		{
			_projectFK = value;
			projectObject =  GetVOUtil.getVOObject(value,GetVOUtil.projectList,'projectId',Projects) as Projects;
 		}

		public function get projectFK() : int
		{
			return _projectFK;
		}
		
		private var _projectObject:Projects;
		public function set projectObject(value : Projects) : void
		{
			_projectObject = value;
			_projectFK = value.projectId;
		}
		
		public function get projectObject() : Projects
		{
			if(_projectObject==null)
			_projectObject =  GetVOUtil.getVOObject(_projectFK,GetVOUtil.projectList,'projectId',Projects) as Projects;
			return _projectObject;
		}
		
 
		private var _taskComment : ByteArray;
		public function set taskComment (value : ByteArray) : void
		{
			_taskComment = value;
		}

		public function get taskComment () : ByteArray
		{
			return _taskComment;
		}

		private var _taskFilesPath : String = '';
		public function set taskFilesPath (value : String) : void
		{
			_taskFilesPath = value;
		}

		public function get taskFilesPath () : String
		{
			return _taskFilesPath;
		}

		private var _tDateCreation : Date;
		public function set tDateCreation (value : Date) : void
		{
			_tDateCreation = value;
		}

		public function get tDateCreation () : Date
		{
			return _tDateCreation;
		}

		private var _tDateInprogress : Date;
		public function set tDateInprogress (value : Date) : void
		{
			_tDateInprogress = value;
		}

		public function get tDateInprogress () : Date
		{
			return _tDateInprogress;
		}

		private var _tDateEnd : Date;
		public function set tDateEnd (value : Date) : void
		{
			_tDateEnd = value;
		}

		public function get tDateEnd () : Date
		{
			return _tDateEnd;
		}

		private var _tDateEndEstimated : Date;
		public function set tDateEndEstimated (value : Date) : void
		{
			_tDateEndEstimated = value;
		}

		public function get tDateEndEstimated () : Date
		{
			return _tDateEndEstimated;
		}

		private var _tDateDeadline : Date;
		public function set tDateDeadline (value : Date) : void
		{
			_tDateDeadline = value;
		}

		public function get tDateDeadline () : Date
		{
			return _tDateDeadline;
		}

		private var _waitingTime : int;
		public function set waitingTime (value : int) : void
		{
			_waitingTime = value;
		}

		public function get waitingTime () : int
		{
			return _waitingTime;
		}

		private var _onairTime : int;
		public function set onairTime (value : int) : void
		{
			_onairTime = value;
		}

		public function get onairTime () : int
		{
			return _onairTime;
		}

		private var _estimatedTime : int;
		public function set estimatedTime (value : int) : void
		{
			_estimatedTime = value;
		}

		public function get estimatedTime () : int
		{
			return _estimatedTime;
		}

		private var _deadlineTime : int;
		public function set deadlineTime (value : int) : void
		{
			_deadlineTime = value;
		}

		public function get deadlineTime () : int
		{
			return _deadlineTime;
		}

		private var _taskFormCode : String;
		public function set taskFormCode (value : String) : void
		{
			_taskFormCode = value;
		}

		public function get taskFormCode () : String
		{
			return _taskFormCode;
		} 
		/**
		* Previous Task Values
		* */
		private var _previousTask : Tasks;
		public function set previousTask (value : Tasks) : void
		{
			_previousTask = value;
		}

		public function get previousTask () : Tasks
		{
			return _previousTask;
		}

		/**
		* Next Task Values
		* */
		private var _nextTask : Tasks;
		public function set nextTask (value : Tasks) : void
		{
			_nextTask = value;
		}

		public function get nextTask () : Tasks
		{
			return _nextTask;
		}

		/**
		* Next Task Values
		* */
		
		private var _taskStatusFK : int;
		public function set taskStatusFK(value : int) : void 
		{
			_taskStatusFK= value;
			statusObject = GetVOUtil.getVOObject(value,GetVOUtil.statusList,'statusId',Status) as Status;
		}

		public function get taskStatusFK () : int
		{
			return _taskStatusFK;
		}

		private var _wftFK : int;
		public function  get wftFK() : int
		{
			return _wftFK;
		}

		public function set wftFK(value:int) : void
		{
			this._wftFK = value;
			workFlowTemplateObject =GetVOUtil.getVOObject(value,GetVOUtil.workflowTemplateList,'workflowTemplateId',Workflowstemplates) as Workflowstemplates;
		}
  
		private var _personFK : int;
		public function  get personFK() : int
		{
			return _personFK;
		}

		public function set personFK(value : int) : void
		{
			this._personFK = value;
			personObject = GetVOUtil.getVOObject(value,GetVOUtil.personList,'personId',Persons) as Persons;
		}
		
		private var _personObject : Persons;
		public function  get personObject() : Persons
		{
			if(_personObject==null)
				_personObject = GetVOUtil.getVOObject(_personFK,GetVOUtil.personList,'personId',Persons) as Persons;
			return _personObject;
		}

		public function set personObject(person : Persons) : void
		{
			this._personObject = person;
			_personFK = person.personId;
		}
		
		private var _fileObj:FileDetails;
		public function set fileObj (value:FileDetails):void
		{
			_fileObj = value;
			if(_fileObj!=null)
			taskFilesPath = _fileObj.filePath;
		}

		public function get fileObj ():FileDetails
		{
			return _fileObj;
		}
		
		
		private var _workFlowTemplateObject:Workflowstemplates
		public function get workFlowTemplateObject():Workflowstemplates
		{
			if(_workFlowTemplateObject == null)
				_workFlowTemplateObject =GetVOUtil.getVOObject(_wftFK,GetVOUtil.workflowTemplateList,'workflowTemplateId',Workflowstemplates) as Workflowstemplates;
			return _workFlowTemplateObject;
		}
		
		public function set workFlowTemplateObject(value:Workflowstemplates):void
		{
			_workFlowTemplateObject = value;
			_wftFK = value.workflowTemplateId;
		}
		
		private var _statusObject:Status
		public function get statusObject():Status
		{
			if(_statusObject == null)
			_statusObject = GetVOUtil.getVOObject(_taskStatusFK,GetVOUtil.statusList,'statusId',Status) as Status;
			return _statusObject;
		}
		
		public function set statusObject(value:Status):void
		{
			_statusObject = value;
			_taskStatusFK = value.statusId;
		}
		public var swfConversion:Boolean = false;
		
		[PostConstruct] 
		public function Tasks()
		{
		}
	}
}