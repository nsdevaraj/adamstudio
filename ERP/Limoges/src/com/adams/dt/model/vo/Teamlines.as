package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import mx.collections.ArrayCollection;

	[RemoteClass(alias = "com.adams.dt.pojo.Teamlines")]	
	[Bindable]
	public final class Teamlines extends AbstractVO
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
		}

		public function get projectID () : int
		{
			return _projectID;
		}

		private var _profileID : int;
		public function set profileID (value : int) : void
		{
			_profileID = value;
		}

		public function get profileID () : int
		{
			return _profileID;
		}

		private var _personID : int;
		public function set personID (value : int) : void
		{
			_personID = value;
		}

		public function get personID () : int
		{
			return _personID;
		}
		
		private var _profileData:ArrayCollection = new ArrayCollection();
		public function set profileData (value : ArrayCollection) : void
		{
			_profileData = value;
		}

		public function get profileData () : ArrayCollection
		{
			return _profileData;
		}
	}
}
