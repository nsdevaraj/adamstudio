package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.Groups")]	
	[Bindable]
	public final class Groups implements IValueObject
	{
		private var _groupId : int;
		private var _groupLabel : String;
		private var _authLevel : String;
		private var _personsSet : ArrayCollection;
		public function Groups()
		{
		}

		public function get groupId() : int
		{
			return _groupId;
		}

		public function set groupId(pData : int) : void
		{
			_groupId = pData;
		}
		public function get authLevel() : String
		{
			return _authLevel;
		}

		public function set authLevel(pData : String) : void
		{
			_authLevel = pData;
		}
		public function get groupLabel() : String
		{
			return _groupLabel;
		}

		public function set groupLabel(pData : String) : void
		{
			_groupLabel = pData;
		}

		public function get personsSet() : ArrayCollection
		{
			return _personsSet;
		}

		public function set personsSet(pData : ArrayCollection) : void
		{
			_personsSet = pData;
		}
	}
}
