package com.adams.dt.model.vo
{
	
	import com.adams.dt.utils.GetVOUtil;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;

	[RemoteClass(alias = "com.adams.dt.pojo.Projects")]	
	[Bindable]
	public final class Projects implements IValueObject
	{
		private var _projectId : int;

		public function get workFlowTemplateObject():Workflowstemplates
		{
			if(_workFlowTemplateObject ==null)
			_workFlowTemplateObject =GetVOUtil.getVOObject(_wftFK,GetVOUtil.workflowTemplateList,'workflowTemplateId',Workflowstemplates) as Workflowstemplates;
			return _workFlowTemplateObject;
		}

		public function set workFlowTemplateObject(value:Workflowstemplates):void
		{
			_workFlowTemplateObject = value;
			_wftFK = value.workflowTemplateId;
		}

		public function get statusObject():Status
		{
			if(_statusObject==null)
			_statusObject = GetVOUtil.getVOObject(_projectStatusFK,GetVOUtil.statusList,'statusId',Status) as Status;
			return _statusObject;
		}

		public function set statusObject(value:Status):void
		{
			_statusObject = value;
			_projectStatusFK = value.statusId;
		}

		public function set projectId (value : int) : void
		{
			_projectId = value;
		}

		public function get projectId () : int
		{
			return _projectId;
		}
		
		public var projectCommentBlob:Object;
		private var _presetTemplateObject:Presetstemplates;
		public function set presetTemplateObject (value:Presetstemplates):void
		{
			_presetTemplateObject = value;
			_presetTemplateID = value.presetstemplateId;
		}

		public function get presetTemplateObject ():Presetstemplates
		{
			if(_presetTemplateObject==null)
				_presetTemplateObject = GetVOUtil.getVOObject(_presetTemplateID,GetVOUtil.presetTemplateList,'presetstemplateId',Presetstemplates) as Presetstemplates;
			return _presetTemplateObject;
		}
		
		private var _presetTemplateID:int;
		public function set presetTemplateID (value:int):void
		{
			_presetTemplateID = value;
			presetTemplateObject = GetVOUtil.getVOObject(value,GetVOUtil.presetTemplateList,'presetstemplateId',Presetstemplates) as Presetstemplates;
		}

		public function get presetTemplateID ():int
		{
			return _presetTemplateID;
		}
 
		private var _projectName : String='';
		public function set projectName (value : String) : void
		{
			_projectName = value;
		}

		public function get projectName () : String
		{
			return _projectName;
		}
 
		private var _workflowObject : Workflows = new Workflows();
		public function set workflowObject (value : Workflows) : void
		{
			_workflowObject = value;
			_workflowFK = value.workflowId;
		}

		public function get workflowObject () : Workflows
		{
			if(_workflowObject == null)
			_workflowObject = GetVOUtil.getVOObject(_workflowFK,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
			return _workflowObject;
		}
		private var _statusObject:Status
		private var _projectStatusFK: int;
		public function set projectStatusFK (value : int) : void
		{
			_projectStatusFK= value;
			statusObject = GetVOUtil.getVOObject(value,GetVOUtil.statusList,'statusId',Status) as Status;
		}

		public function get projectStatusFK () : int
		{
			return _projectStatusFK;
		}

		private var _projectQuantity : int;
		public function set projectQuantity (value : int) : void
		{
			_projectQuantity = value;
		}

		public function get projectQuantity () : int
		{
			return _projectQuantity;
		}

		private var _projectComment : ByteArray;
		public function set projectComment (value : ByteArray) : void
		{
			_projectComment = value;
		}

		public function get projectComment () : ByteArray
		{
			return _projectComment;
		}
		private var _workFlowTemplateObject:Workflowstemplates
		private var _wftFK : int;
		public function  get wftFK() : int
		{
			return _wftFK;
		}

		public function set wftFK(value:int) : void
		{
			if(value!=0){
				this._wftFK = value;
				workFlowTemplateObject =GetVOUtil.getVOObject(value,GetVOUtil.workflowTemplateList,'workflowTemplateId',Workflowstemplates) as Workflowstemplates;
			} 
		}
		private var _projectDateStart : Date;
		public function set projectDateStart (value : Date) : void
		{
			_projectDateStart = value;
		}

		public function get projectDateStart () : Date
		{
			return _projectDateStart;
		}
		private var _currentTaskDateStart : Date;
		public function set currentTaskDateStart (value : Date) : void
		{
			_currentTaskDateStart = value;
		}

		public function get currentTaskDateStart () : Date
		{
			return _currentTaskDateStart;
		}

		private var _projectDateEnd : Date;
		public function set projectDateEnd (value : Date) : void
		{
			_projectDateEnd = value;
		}

		public function get projectDateEnd () : Date
		{
			return _projectDateEnd;
		}
		
		private var _taskDateStart:Date;
		public function set taskDateStart( value:Date ):void {
			if( value ) { 
				_taskDateStart = value;
			}
		}

		public function get taskDateStart():Date {
			return _taskDateStart;
		}

		private var _taskDateEnd:Date;
		public function set taskDateEnd( value:Date ):void {
			if( value ) {
				_taskDateEnd = value;
			}
		}

		public function get taskDateEnd():Date {
			return _taskDateEnd;
		}
		
		private var _phasesSet : ArrayCollection = new ArrayCollection();
		public function set phasesSet (value : ArrayCollection) : void
		{
			var sort : Sort = new Sort();
			sort.fields = [new SortField("phaseId")]; 
			if(value.sort == null){
           	 	value.sort = sort;
            	value.refresh(); 
            }
			_phasesSet = value;
		}

		public function get phasesSet () : ArrayCollection
		{
			return _phasesSet;
		}

		private var _workflowFK: int;
		public function set workflowFK(value : int) : void
		{
			_workflowFK= value;
			workflowObject = GetVOUtil.getVOObject(value,GetVOUtil.workflowList,'workflowId',Workflows) as Workflows;
		}

		public function get workflowFK() : int
		{
			return _workflowFK;
		} 
		private var _categoryFKey : int;
		public function set categoryFKey (value : int) : void
		{
			_categoryFKey = value;
			categoryObject = GetVOUtil.getVOObject(value,GetVOUtil.categoryList,'categoryId',Categories) as Categories;
		}

		public function get categoryFKey () : int
		{
			return _categoryFKey;
		}
		private var _categoryObject : Categories;
		public function set categoryObject (value : Categories) : void
		{
			_categoryObject = value;
			_categoryFKey = value.categoryId;
			_categoryObject.projectSet.addItem(this);
		}

		public function get categoryObject () : Categories
		{
			if(_categoryObject== null)
			_categoryObject = GetVOUtil.getVOObject(_categoryFKey,GetVOUtil.categoryList,'categoryId',Categories) as Categories;
			return _categoryObject;
		}

		private var _propertiespjSet : ArrayCollection = new ArrayCollection();
		public function set propertiespjSet (value : ArrayCollection) : void
		{
			_propertiespjSet = value;
		}

		public function get propertiespjSet () : ArrayCollection
		{
			return _propertiespjSet;
		}
 		
		private var _teamSet : ArrayCollection = new ArrayCollection();
		public function set teamSet (value : ArrayCollection) : void
		{
			_teamSet = value;
		}

		public function get teamSet () : ArrayCollection
		{
			return _teamSet;
		}
		public var procedeImpression:Number=0;
		public function Projects()
		{
		}
	}
}