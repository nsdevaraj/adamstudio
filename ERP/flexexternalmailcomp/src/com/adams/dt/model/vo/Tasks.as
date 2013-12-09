package com.adams.dt.model.vo
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.Tasks")]	
	[Bindable]
	public final class Tasks implements IValueObject
	{
		private var _taskId : int;
		public function set taskId (value : int) : void
		{
			_taskId = value;
		}

		public function get taskId () : int
		{
			return _taskId;
		}
		private var _projectObject : Projects = new Projects();
		public var firstofPhase : Boolean;
		public var lastofPhase : Boolean;
		public var phase : Phases;
		public var _projectFk:int
		public function set projectFk(value : int) : void
		{
			_projectFk = value;
			//projectObject = Utils.getProjectObject(value);
		}

		public function get projectFk() : int
		{
			return _projectFk;
		}

		public function set projectObject(value : Projects) : void
		{
			_projectObject = value;
			//projectFk = value.projectId
		}

		public function get projectObject() : Projects
		{
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
			workflowtemplateFK = GetVOUtil.getWorkflowTemplate(value);
		}
		private var _workflowtemplateFK : Workflowstemplates;
		public function  get workflowtemplateFK() : Workflowstemplates
		{
			if(_workflowtemplateFK==null)
				_workflowtemplateFK = GetVOUtil.getWorkflowTemplate(_wftFK);
			return _workflowtemplateFK;
		}

		public function set workflowtemplateFK(workflowtemplateFK : Workflowstemplates) : void
		{
			this._workflowtemplateFK = workflowtemplateFK;
			_wftFK = workflowtemplateFK.workflowTemplateId;
		}

		private var _domainDetails : Categories;
		public function  get domainDetails() : Categories
		{
			return _domainDetails;
		}

		public function set domainDetails(domainDetails : Categories) : void
		{
			this._domainDetails = domainDetails;
		}
		private var _personFK : int;
		public function  get personFK() : int
		{
			return _personFK;
		}

		public function set personFK(value : int) : void
		{
			this._personFK = value;
			personDetails = GetVOUtil.getPersonObject(value);
		}
		
		private var _personDetails : Persons;
		public function  get personDetails() : Persons
		{
			if(_personDetails==null)
				_personDetails = GetVOUtil.getPersonObject(_personFK);
			return _personDetails;
		}

		public function set personDetails(person : Persons) : void
		{
			this._personDetails = person;
			_personFK = person.personId;
		}
		
		private var _fileObj:FileDetails;
		public function set fileObj (value:FileDetails):void
		{
			_fileObj = value;
			//if(_fileObj!=null)
			//taskFilesPath = _fileObj.filePath;
		}

		public function get fileObj ():FileDetails
		{
			return _fileObj;
		}
		public var swfConversion:Boolean = false;

		public function Tasks()
		{
		}
	}
}