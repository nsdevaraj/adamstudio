package com.adams.dt.model.vo
{
	[RemoteClass(alias = "com.adams.dt.pojo.Grouppersons")]	
	[Bindable]
	public class GroupPersons implements IValueObject
	{
		private var _groupPersonId : int;
		private var _groupFk : int;
		private var _personFk : int;
		
		[PostConstruct]
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

		public function set personFk(pData : int) : void
		{
			_personFk = pData;
		}
		

	}
}