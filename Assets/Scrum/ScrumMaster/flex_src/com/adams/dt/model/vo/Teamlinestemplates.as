package com.adams.dt.model.vo
{
 	import com.adams.dt.utils.GetVOUtil;

	[RemoteClass(alias = "com.adams.dt.pojo.Teamlinestemplates")]	
	[Bindable]
	public final class Teamlinestemplates  implements IValueObject
	{
		public function Teamlinestemplates()
		{
		}

		private var _teamlineTemplateId : int;
		public function set teamlineTemplateId (value : int) : void
		{
			_teamlineTemplateId = value;
		}

		public function get teamlineTemplateId () : int
		{
			return _teamlineTemplateId;
		}

		private var _teamTemplateFk : int;
		public function set teamTemplateFk (value : int) : void
		{
			_teamTemplateFk = value;
		}

		public function get teamTemplateFk () : int
		{
			return _teamTemplateFk;
		}

		private var _profileFk : int;
		public function set profileFk (value : int) : void
		{
			_profileFk = value;
			profileObject =  GetVOUtil.getVOObject(value,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
		}

		public function get profileFk () : int
		{
			return _profileFk;
		}
		private var _profileObject : Profiles
		public function set profileObject (value : Profiles) : void
		{
			_profileObject = value;
			_profileFk = value.profileId;
		}
		
		public function get profileObject () : Profiles
		{
			if(_profileObject ==null)
			_profileObject =  GetVOUtil.getVOObject(_profileFk,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
			return _profileObject;
		}
		private var _personFk : int;
		public function set personFk (value : int) : void
		{
			_personFk = value;
			personObject = GetVOUtil.getVOObject(value,GetVOUtil.personList,'personId',Persons) as Persons;
		}

		public function get personFk () : int
		{
			return _personFk;
		}
		private var _personObject : Persons;
		public function  get personObject() : Persons
		{ 
			if(_personObject ==null)
			_personObject = GetVOUtil.getVOObject(_personFk,GetVOUtil.personList,'personId',Persons) as Persons;
			return _personObject;
		}
		
		public function set personObject(person : Persons) : void
		{
			this._personObject = person;
			_personFk = person.personId;
		} 
	}
}
