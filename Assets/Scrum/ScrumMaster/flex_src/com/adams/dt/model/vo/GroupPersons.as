package com.adams.dt.model.vo
{
	import com.adams.dt.utils.GetVOUtil;

	[RemoteClass(alias = "com.adams.dt.pojo.Grouppersons")]	
	[Bindable]
	public class GroupPersons implements IValueObject
	{
		private var _groupPersonId : int;
		private var _groupFk : int;
		private var _personFk : int;
		public function GroupPersons()
		{
		}
		
		public function get groupPersonId() : int
		{
			return _groupPersonId;
		}

		public function set groupPersonId(pData : int) : void
		{
			_groupPersonId = pData;
		}
		
		public function get groupFk() : int
		{
			return _groupFk;
		}

		public function set groupFk(pData : int) : void
		{
			_groupFk = pData;
		}
		public function get personFk() : int
		{
			return _personFk;
		}
		private var _personObject : Persons;
		public function  get personObject() : Persons
		{ 
			if(_personObject ==null)
			_personObject = GetVOUtil.getVOObject(_personFK,GetVOUtil.personList,'personId',Persons) as Persons;
			return _personObject;
		}
		
		public function set personObject(person : Persons) : void
		{
			this._personObject = person;
			_personFK = person.personId;
		}
		
		public function set personFk(pData : int) : void
		{
			_personFk = pData;
			personObject = GetVOUtil.getVOObject(pData,GetVOUtil.personList,'personId',Persons) as Persons;
		}
		

	}
}