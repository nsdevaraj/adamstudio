package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;

	[RemoteClass(alias = "com.adams.dt.pojo.Projects")]	
	[Bindable]
	public final class Projects extends AbstractVO
	{ 
		public var phasesSet:Object;
		public var projectCommentBlob:Object;
		
		private var _projectId:int;
		public function get projectId():int {
			return _projectId;
		}
		public function set projectId( value:int ):void {
			_projectId = value;
		}
		
		private var _presetTemplateID:int;
		public function get presetTemplateID():int {
			return _presetTemplateID;
		}
		public function set presetTemplateID( value:int ):void {
			if( _presetTemplateFK ) {
				_presetTemplateFK = null;
			}
			_presetTemplateID = value;
		}
		
		private var _presetTemplateFK:Presetstemplates;
		public function get presetTemplateFK():Presetstemplates {
			return _presetTemplateFK;
		}
		public function set presetTemplateFK( value:Presetstemplates ):void {
			if( !_presetTemplateFK ) {
				_presetTemplateFK = value;
			}
		}
		
		private var _projectName:String = '';
		public function get projectName():String {
			return _projectName;
		}
		public function set projectName( value:String ):void {
			_projectName = value;
		}

		private var _workflowFk:Workflows;
		public function get workflowFk():Workflows {
			return _workflowFk;
		}
		public function set workflowFk( value:Workflows ):void {
			_workflowFk = value;
		}
		
		private var _projectStatusFK: int;
		public function get projectStatusFK():int {
			return _projectStatusFK;
		}
		public function set projectStatusFK( value:int ):void {
			_projectStatusFK= value;
		}

		private var _projectQuantity:int;
		public function get projectQuantity():int {
			return _projectQuantity;
		}
		public function set projectQuantity( value:int ):void {
			_projectQuantity = value;
		}

		private var _projectComment:ByteArray;
		public function get projectComment():ByteArray {
			return _projectComment;
		}
		public function set projectComment( value:ByteArray ):void {
			_projectComment = value;
		}
		
		private var _wftFK:int;
		public function  get wftFK():int {
			return _wftFK;
		}
		public function set wftFK( value:int ):void {
			if( _workflowTemplate ) {
				_workflowTemplate = null;
			}
			_wftFK = value;
		}
		
		private var _workflowTemplate:Workflowstemplates;
		public function  get workflowTemplate():Workflowstemplates {
			return _workflowTemplate;
		}
		public function set workflowTemplate( value:Workflowstemplates ):void {
			if( !_workflowTemplate ) {
				_workflowTemplate = value;
			}
		}
		
		private var _finalTask:Tasks;
		public function  get finalTask():Tasks {
			return _finalTask;
		}
		public function set finalTask( value:Tasks ):void {
			_finalTask = value;
		}
		
		private var _projectDateStart:Date;
		public function get projectDateStart():Date {
			return _projectDateStart;
		}
		public function set projectDateStart( value:Date ):void {
			_projectDateStart = value;
		}
		
		private var _currentTaskDateStart:Date;
		public function get currentTaskDateStart():Date {
			return _currentTaskDateStart;
		}
		public function set currentTaskDateStart( value:Date ):void {
			_currentTaskDateStart = value;
		}

		private var _projectDateEnd:Date;
		public function get projectDateEnd():Date {
			return _projectDateEnd;
		}
		public function set projectDateEnd( value:Date ):void {
			_projectDateEnd = value;
		}

		private var _taskDateStart:Date;
		public function get taskDateStart():Date {
			return _taskDateStart;
		}
		public function set taskDateStart( value:Date ):void {
			if( value ) { 
				_taskDateStart = value;
			}
		}

		private var _taskDateEnd:Date;
		public function get taskDateEnd():Date {
			return _taskDateEnd;
		}
		public function set taskDateEnd( value:Date ):void {
			if( value ) {
				_taskDateEnd = value;
			}
		}

		private var _phasesCollection:ArrayCollection; 
		public function get phasesCollection():ArrayCollection {
			return _phasesCollection;
		}
		public function set phasesCollection( value:ArrayCollection ):void {
			var sort:Sort = new Sort();
			sort.fields = [ new SortField( "phaseId" ) ]; 
			if( !value.sort ) {
           	 	value.sort = sort;
            	value.refresh(); 
            }
			_phasesCollection = value;
		}

		private var _workflowFK:int; 
		public function get workflowFK():int {
			return _workflowFK;
		} 
		public function set workflowFK( value:int ):void {
			_workflowFK= value;
		}
		
		
		private var _categoryFKey:int;
		public function get categoryFKey():int {
			return _categoryFKey;
		}
		public function set categoryFKey( value:int ):void 	{
			if( _categories ) {
				_categories = null;
			}
			_categoryFKey = value;
		}

		private var _categories:Categories;
		public function get categories():Categories {
			return _categories;
		}
		public function set categories( value:Categories ):void {
			if( !_categories ) {
				_categories = value;
			}
		}
 
		private var _propertiespjSet:ArrayCollection;
		public function get propertiespjSet():ArrayCollection {
			return _propertiespjSet;
		}
		public function set propertiespjSet( value:ArrayCollection ):void {
			_propertiespjSet = value;
		}
		
		private var _tasksCollection:ArrayCollection;
		public function get tasksCollection():ArrayCollection {
			return _tasksCollection;
		}
		public function set tasksCollection( value:ArrayCollection ):void {
			_tasksCollection = value;
		}

		public function Projects()
		{
		}
	}
}
