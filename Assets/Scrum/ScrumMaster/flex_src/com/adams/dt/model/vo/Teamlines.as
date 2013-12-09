package com.adams.dt.model.vo
{
	import com.adams.dt.utils.GetVOUtil;

	[RemoteClass(alias = "com.adams.dt.pojo.Teamlines")]	
	[Bindable]
	public final class Teamlines implements IValueObject
	{
		public function Teamlines()
		{
		}

		private var _teamlineId : int;
		public function set teamlineId (value : int) : void
		{
			_teamlineId = value;
		}

		public function get teamlineId () : int
		{
			return _teamlineId;
		}
 
		private var _projectID : int;
		public function set projectID (value : int) : void
		{
			_projectID = value;
			projectObject =  GetVOUtil.getVOObject(value,GetVOUtil.projectList,'projectId',Projects) as Projects;
		}

		public function get projectID () : int
		{
			return _projectID;
		}
		private var _projectObject:Projects;
		public function set projectObject(value : Projects) : void
		{
			_projectObject = value;
			_projectID = value.projectId;
		}
		
		public function get projectObject() : Projects
		{
			if(_projectObject == null)
			_projectObject =  GetVOUtil.getVOObject(_projectID,GetVOUtil.projectList,'projectId',Projects) as Projects;
			return _projectObject;
		}
		private var _profileID : int;
		public function set profileID (value : int) : void
		{
			_profileID = value;
			profileObject =  GetVOUtil.getVOObject(value,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
		}

		public function get profileID () : int
		{
			return _profileID;
		}
		
		private var _profileObject : Profiles
		public function set profileObject (value : Profiles) : void
		{
			_profileObject = value;
			_profileID = value.profileId;
		}
		
		public function get profileObject () : Profiles
		{
			if(_profileObject == null)
				_profileObject =  GetVOUtil.getVOObject(_profileID,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
			return _profileObject;
		}
		private var _personID : int;
		public function set personID (value : int) : void
		{
			_personID = value;
			personObject = GetVOUtil.getVOObject(value,GetVOUtil.personList,'personId',Persons) as Persons;
		}

		public function get personID () : int
		{
			return _personID;
		}
		
		private var _personObject : Persons;
		public function  get personObject() : Persons
		{ 
			if(_personObject==null)
				_personObject = GetVOUtil.getVOObject(_personID,GetVOUtil.personList,'personId',Persons) as Persons;
			return _personObject;
		}
		
		public function set personObject(person : Persons) : void
		{
			this._personObject = person;
			_personID = person.personId;
		}
		
	}
}
