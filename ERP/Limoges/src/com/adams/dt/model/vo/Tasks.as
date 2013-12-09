package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;

	[RemoteClass(alias = "com.adams.dt.pojo.Tasks")]	
	[Bindable]
	public final class Tasks extends AbstractVO
	{
		public var swfConversion:Boolean;
		public var firstofPhase:Boolean;
		public var lastofPhase:Boolean;
		public var phase:Phases;
		public var taskCommentBlob:Object; 
		
		
		private var _taskId : int;
		public function get taskId():int {
			return _taskId;
		}
		public function set taskId( value:int ):void {
			_taskId = value;
		}

		private var _projectFk:int;
		public function get projectFk():int {
			return _projectFk;
		}
		public function set projectFk( value:int ):void {
			if( _projectObject ) {
				_projectObject = null;
			}
			_projectFk = value;
		}
		
		private var _projectObject:Projects;
		public function get projectObject():Projects {
			return _projectObject;
		}
		public function set projectObject( value:Projects ):void {
			if( !_projectObject ) {
				_projectObject = value;
			}
		}

		private var _taskComment:ByteArray;
		public function get taskComment():ByteArray {
			return _taskComment;
		}
		public function set taskComment( value:ByteArray ):void {
			_taskComment = value;
		}

		private var _taskFilesPath:String = '';
		public function get taskFilesPath():String {
			return _taskFilesPath;
		}
		public function set taskFilesPath( value:String ):void {
			_taskFilesPath = value;
		}

		private var _tDateCreation:Date;
		public function get tDateCreation():Date {
			return _tDateCreation;
		}
		public function set tDateCreation( value:Date ):void {
			_tDateCreation = value;
		}
		
		private var _tDateInprogress:Date;
		public function get tDateInprogress():Date {
			return _tDateInprogress;
		}
		public function set tDateInprogress( value:Date ):void {
			_tDateInprogress = value;
		}
		
		private var _tDateEnd : Date;
		public function get tDateEnd():Date {
			return _tDateEnd;
		}
		public function set tDateEnd( value:Date ):void {
			_tDateEnd = value;
		}
		
		private var _tDateEndEstimated:Date;
		public function get tDateEndEstimated():Date {
			return _tDateEndEstimated;
		}
		public function set tDateEndEstimated( value:Date ):void {
			_tDateEndEstimated = value;
		}

		private var _tDateDeadline:Date;
		public function get tDateDeadline():Date {
			return _tDateDeadline;
		}
		public function set tDateDeadline( value:Date ):void {
			_tDateDeadline = value;
		}

		private var _waitingTime:int;
		public function get waitingTime():int {
			return _waitingTime;
		}
		public function set waitingTime( value:int ):void {
			_waitingTime = value;
		}
		
		private var _onairTime:int;
		public function get onairTime():int {
			return _onairTime;
		}
		public function set onairTime( value:int ):void {
			_onairTime = value;
		}

		private var _estimatedTime:int;
		public function get estimatedTime():int {
			return _estimatedTime;
		}
		public function set estimatedTime( value:int ):void {
			_estimatedTime = value;
		}
		
		private var _deadlineTime : int;
		public function get deadlineTime():int {
			return _deadlineTime;
		}
		public function set deadlineTime( value:int ):void {
			_deadlineTime = value;
		}
		
		private var _taskFormCode:String;
		public function get taskFormCode():String {
			return _taskFormCode;
		} 
		public function set taskFormCode( value:String ):void {
			_taskFormCode = value;
		}

		/**
		* Previous Task Values
		* */
		private var _previousTask:Tasks;
		public function get previousTask():Tasks {
			return _previousTask;
		}
		public function set previousTask( value:Tasks ):void {
			_previousTask = value;
		}
		
		/**
		* Next Task Values
		* */
		private var _nextTask:Tasks;
		public function get nextTask():Tasks {
			return _nextTask;
		}
		public function set nextTask( value:Tasks ):void {
			_nextTask = value;
		}
		
		private var _taskStatusFK:int;
		public function get taskStatusFK():int {
			return _taskStatusFK;
		}
		public function set taskStatusFK( value:int ):void {
			_taskStatusFK= value;
		}
		
		private var _wftFK:int;
		public function  get wftFK():int {
			return _wftFK;
		}
		public function set wftFK( value:int ):void {
			if( _workflowtemplateFK ) {
				_workflowtemplateFK = null;
			}
			_wftFK = value;
		}
		
		private var _workflowtemplateFK:Workflowstemplates;
		public function  get workflowtemplateFK():Workflowstemplates 	{
			return _workflowtemplateFK;
		}
		public function set workflowtemplateFK( value:Workflowstemplates ):void {
			if( !_workflowtemplateFK ) {
				_workflowtemplateFK = value;
			}
		}

		private var _domainDetails:Categories;
		public function  get domainDetails():Categories {
			return _domainDetails;
		}
		public function set domainDetails( value:Categories ):void {
			_domainDetails = value;
		}
		
		private var _personFK:int;
		public function  get personFK():int {
			return _personFK;
		}
		public function set personFK( value:int ):void {
			if( personDetails ) {
				personDetails = null;
			} 
			_personFK = value;
		}
		
		private var _personDetails:Persons;
		public function  get personDetails():Persons {
			return _personDetails;
		}
		public function set personDetails( value:Persons ):void 	{
			if( !_personDetails ) {
				_personDetails = value;
			}
		}
		
		private var _fileObj:FileDetails;
		public function get fileObj():FileDetails {
			return _fileObj;
		}
		public function set fileObj( value:FileDetails ):void {
			_fileObj = value;
		}
		
		public function Tasks()
		{
			
		}
	}
}