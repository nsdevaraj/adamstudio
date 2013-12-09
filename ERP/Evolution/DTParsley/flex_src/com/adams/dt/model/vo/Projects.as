package com.adams.dt.model.vo
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection; 
	[RemoteClass(alias = "com.adams.dt.pojo.Projects")]	
	[Bindable]
	public final class Projects implements IValueObject
	{
		private var _projectId : int;
		public function set projectId (value : int) : void
		{
			_projectId = value;
		}

		public function get projectId () : int
		{
			return _projectId;
		}
		
		
		private var _presetTemplateFK:Presetstemplates;
		public function set presetTemplateFK (value:Presetstemplates):void
		{
			_presetTemplateFK = value;
			_presetTemplateID = value.presetstemplateId;
		}

		public function get presetTemplateFK ():Presetstemplates
		{
			return _presetTemplateFK;
		}
		
		private var _presetTemplateID:int;
		public function set presetTemplateID (value:int):void
		{
			_presetTemplateID = value;
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
 
		private var _workflowFk : Workflows;
		public function set workflowFk (value : Workflows) : void
		{
			_workflowFk = value;
		}

		public function get workflowFk () : Workflows
		{
			return _workflowFk;
		}

		private var _projectStatusFK: int;
		public function set projectStatusFK (value : int) : void
		{
			_projectStatusFK= value;
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

		private var _wftFK : int;
		public function  get wftFK() : int
		{
			return _wftFK;
		}

		public function set wftFK(value:int) : void
		{
			if(value!=0) this._wftFK = value;
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

		private var _projectDateEnd : Date;
		public function set projectDateEnd (value : Date) : void
		{
			_projectDateEnd = value;
		}

		public function get projectDateEnd () : Date
		{
			return _projectDateEnd;
		}

		private var _phasesSet : ArrayCollection;
		public function set phasesSet (value : ArrayCollection) : void
		{
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
		}

		public function get workflowFK() : int
		{
			return _workflowFK;
		} 
		private var _categoryFKey : int;
		public function set categoryFKey (value : int) : void
		{
			_categoryFKey = value;
		}

		public function get categoryFKey () : int
		{
			return _categoryFKey;
		}
		private var _categories : Categories;
		public function set categories (value : Categories) : void
		{
			_categories = value;
		}

		public function get categories () : Categories
		{
			return _categories;
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
 		
		[PostConstruct]		
		public function Projects()
		{
		}
	}
}
