package com.adams.dt.model.vo
{
	import com.adams.dt.utils.GetVOUtil;
	import com.adams.dt.utils.StringUtils;

	[RemoteClass(alias = "com.adams.dt.pojo.Workflowstemplates")]	
	[Bindable]
	public final class Workflowstemplates implements IValueObject
	{ 

		private var _phaseTemplateObject :Phasestemplates;
		private var _workflowTemplateId : int;

		public function get phaseTemplateObject():Phasestemplates
		{
			if(_phaseTemplateObject ==null)
			_phaseTemplateObject =  GetVOUtil.getVOObject(_phaseTemplateFK,GetVOUtil.phaseTemplateList,'phaseTemplateId',Phasestemplates) as Phasestemplates;
			return _phaseTemplateObject;
		}

		public function set phaseTemplateObject(value:Phasestemplates):void
		{
			_phaseTemplateObject = value;
			_phaseTemplateFK = value.phaseTemplateId;
		}

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
			var stoplabel:Array = _optionStopLabel.split(",");
			for(var i:int=0;i<stoplabel.length;i++){
				var permissionStr:Number = Number(stoplabel[i]);
				switch(int(permissionStr)){
					case WorkflowTemplatePermission.CLOSED:
						GetVOUtil.closeProjectTemplate.addItem(this );
						break;
					case WorkflowTemplatePermission.ANNULATION:
						GetVOUtil.modelAnnulationWorkflowTemplate.addItem(this ); 
						break;
					case WorkflowTemplatePermission.FIRSTRELEASE:
						GetVOUtil.firstRelease.addItem(this );
						break;
					case WorkflowTemplatePermission.OTHERRELEASE:
						GetVOUtil.otherRelease.addItem(this );
						break;
					case WorkflowTemplatePermission.FILEACCESS:
						GetVOUtil.fileAccessTemplates.addItem(this );
						break;
					case WorkflowTemplatePermission.MESSAGE:
						GetVOUtil.messageTemplatesCollection.addItem(this );
						break;
					case WorkflowTemplatePermission.VERSIONLOOP:
						GetVOUtil.versionLoop.addItem(this );
						break;
					case WorkflowTemplatePermission.ALARM:
						GetVOUtil.alarmTemplatesCollection.addItem(this );
						break;
					case WorkflowTemplatePermission.STANDBY:
						GetVOUtil.standByTemplatesCollection.addItem(this );
						break;
					case WorkflowTemplatePermission.SENDIMPMAIL:
						GetVOUtil.sendImpMailTemplatesCollection.addItem(this);
						break;
					case WorkflowTemplatePermission.PDFREADER:
						GetVOUtil.indReaderMailTemplatesCollection.addItem(this);
						break;
					case WorkflowTemplatePermission.CHECKIMPREMIUR:
						GetVOUtil.checkImpremiurCollection.addItem( this );	
						break;  
					case WorkflowTemplatePermission.IMPVALIDATOR:
						GetVOUtil.impValidCollection.addItem( this );	
						break;
					case WorkflowTemplatePermission.INDVALIDATOR:
						GetVOUtil.indValidCollection.addItem( this );	
						break;
					default:
						break;
				}
			}
		}

		public function get optionStopLabel () : String
		{
			return _optionStopLabel;
		}
		private var _profileFK : int;
		public function set profileFK (value : int) : void
		{
			_profileFK = value;
			profileObject =  GetVOUtil.getVOObject(value,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
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
			if(_profileObject ==null)
			_profileObject =  GetVOUtil.getVOObject(_profileFK,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
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
			phaseTemplateObject =  GetVOUtil.getVOObject(value,GetVOUtil.phaseTemplateList,'phaseTemplateId',Phasestemplates) as Phasestemplates;
		}

		public function get phaseTemplateFK ():int
		{
			return _phaseTemplateFK;
		}
 
		private var _workflowFK : int;
		public function set workflowFK (value : int) : void
		{
			_workflowFK = value;
			workflowObject =  GetVOUtil.getVOObject(value,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
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
		
		private var _workflowObject : Workflows;
		
		public function get workflowObject():Workflows
		{
			if(_workflowObject == null)
			_workflowObject =  GetVOUtil.getVOObject(_workflowFK,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
			return _workflowObject;
		}
		
		public function set workflowObject(value:Workflows):void
		{
			_workflowObject = value;
			_workflowFK = value.workflowId;
		}

		public function Workflowstemplates()
		{
		}
	}
}
