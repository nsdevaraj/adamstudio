package com.adams.dt.model.vo
{ 
	
	import com.adams.dt.utils.GetVOUtil;

	[RemoteClass(alias = "com.adams.dt.pojo.Propertiespj")]	
	[Bindable]
	public final class Propertiespj implements IValueObject
	{
		private var _propertyPresetFk : int = new int();
		public function set propertyPresetFk (value : int) : void
		{
			_propertyPresetFk = value;
		}

		public function get propertyPresetFk () : int
		{
			return _propertyPresetFk;
		}

		private var _propertyPjId : int;
		public function set propertyPjId (value : int) : void
		{
			_propertyPjId = value;
		}

		public function get propertyPjId () : int
		{
			return _propertyPjId;
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
		private var _fieldValue : String;
		public function set fieldValue (value : String) : void
		{
			_fieldValue = value;
		}

		public function get fieldValue () : String
		{
			return _fieldValue;
		}
 
		private var _accordeon : String;
		public function set accordeon (value : String) : void
		{
			_accordeon = value;
		}

		public function get accordeon () : String
		{
			return _accordeon;
		}
 

		public function Propertiespj()
		{
		}
	}
}
