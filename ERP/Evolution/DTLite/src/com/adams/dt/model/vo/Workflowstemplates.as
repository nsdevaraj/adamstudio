package com.adams.dt.model.vo
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.StringUtils;
	import com.adobe.cairngorm.vo.IValueObject;
	[RemoteClass(alias = "com.adams.dt.pojo.Workflowstemplates")]	
	[Bindable]
	public final class Workflowstemplates implements IValueObject
	{ 

		private var _workflowTemplateId : int;
		public function set workflowTemplateId (value : int) : void
		{
			_workflowTemplateId = value;
		}

		public function get workflowTemplateId () : int
		{
			return _workflowTemplateId;
		}

		private var _taskCode : String;
		public function set taskCode (value : String) : void
		{
			_taskCode = StringUtils.trimSpace(value);
		}

		public function get taskCode () : String
		{
			return _taskCode;
		}

		private var _taskLabel : String;
		public function set taskLabel (value : String) : void
		{
			_taskLabel = value;
		}

		public function get taskLabel () : String
		{
			return _taskLabel;
		}

		private var _taskLabelTodo : String;
		public function set taskLabelTodo (value : String) : void
		{
			_taskLabelTodo = value;
		}

		public function get taskLabelTodo () : String
		{
			return _taskLabelTodo;
		}

		private var _optionPrevLabel : String;
		public function set optionPrevLabel (value : String) : void
		{
			_optionPrevLabel = value;
		}

		public function get optionPrevLabel () : String
		{
			return _optionPrevLabel;
		}

		private var _optionNextLabel : String;
		public function set optionNextLabel (value : String) : void
		{
			_optionNextLabel = value;
		}

		public function get optionNextLabel () : String
		{
			return _optionNextLabel;
		}

		private var _optionJumpLabel : String;
		public function set optionJumpLabel (value : String) : void
		{
			_optionJumpLabel = value;
		}

		public function get optionJumpLabel () : String
		{
			return _optionJumpLabel;
		}

		private var _optionLoopLabel : String;
		public function set optionLoopLabel (value : String) : void
		{
			_optionLoopLabel = value;
		}

		public function get optionLoopLabel () : String
		{
			return _optionLoopLabel;
		}
 

		private var _optionStopLabel : String;
		public function set optionStopLabel (value : String) : void
		{
			_optionStopLabel = value;
		}

		public function get optionStopLabel () : String
		{
			return _optionStopLabel;
		}
		private var _profileFK : int;
		public function set profileFK (value : int) : void
		{
			_profileFK = value;
			profileObject = GetVOUtil.getProfileObject(value);
		}

		public function get profileFK () : int
		{
			return _profileFK;
		}
		private var _profileObject : Profiles
		public function set profileObject (value : Profiles) : void
		{
			_profileObject = value;
			_profileFK = value.profileId;
		}

		public function get profileObject () : Profiles
		{
			if(_profileObject==null)
				_profileObject = GetVOUtil.getProfileObject(profileFK);
			return _profileObject;
		}

		private var _nextTaskFk : Workflowstemplates;
		public function set nextTaskFk (value : Workflowstemplates) : void
		{
			_nextTaskFk = value;
		}

		public function get nextTaskFk () : Workflowstemplates
		{
			return _nextTaskFk;
		}

		private var _prevTaskFk : Workflowstemplates;
		public function set prevTaskFk (value : Workflowstemplates) : void
		{
			_prevTaskFk = value;
		}

		public function get prevTaskFk () : Workflowstemplates
		{
			return _prevTaskFk;
		}

		private var _jumpToTaskFk : Workflowstemplates;
		public function set jumpToTaskFk (value : Workflowstemplates) : void
		{
			_jumpToTaskFk = value;
		}

		public function get jumpToTaskFk () : Workflowstemplates
		{
			return _jumpToTaskFk;
		}

		private var _loopFk : Workflowstemplates;
		public function set loopFk (value : Workflowstemplates) : void
		{
			_loopFk = value;
		}

		public function get loopFk () : Workflowstemplates
		{
			return _loopFk;
		}
		
		private var _phaseTemplateFK:int;
		public function set phaseTemplateFK (value:int):void
		{
			_phaseTemplateFK = value;
		}

		public function get phaseTemplateFK ():int
		{
			return _phaseTemplateFK;
		}
 
		private var _workflowFK : int;
		public function set workflowFK (value : int) : void
		{
			_workflowFK = value;
		}

		public function get workflowFK () : int
		{
			return _workflowFK;
		}

		
		private var _defaultEstimatedTime:int;
		public function set defaultEstimatedTime (value:int):void
		{
			_defaultEstimatedTime = value;
		}

		public function get defaultEstimatedTime ():int
		{
			return _defaultEstimatedTime;
		}


		public function Workflowstemplates()
		{
		}
	}
}
