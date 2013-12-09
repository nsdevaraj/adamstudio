package com.adams.scrum.models.vo
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.utils.GetVOUtil;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Teams')]
	public class Teams extends AbstractVO
	{
		private var _teamId:int;
		private var _teamLabel:String;
		
		[ArrayElementType("com.adams.scrum.models.vo.Teammembers")]
		private var _teamMemberSet:ArrayCollection=new ArrayCollection(); 
		
		[ArrayElementType("com.adams.scrum.models.vo.Profiles")]
		private var _profileList:ArrayCollection = new ArrayCollection(); 
		
		[ArrayElementType("com.adams.scrum.models.vo.Persons")]
		private var _personList:ArrayCollection = new ArrayCollection();
		 
		public function Teams()
		{
			super();
		}
		
		public function get personList():ArrayCollection
		{
			return _personList;
		}
		
		public function set personList(value:ArrayCollection):void
		{
			_personList = value;
		}
		
		public function get profileList():ArrayCollection
		{
			return _profileList;
		}
		
		public function set profileList(value:ArrayCollection):void
		{
			_profileList = value;
		}
		
		public function get teamMemberSet():ArrayCollection
		{
			return _teamMemberSet;
		}
		
		public function set teamMemberSet(value:ArrayCollection):void
		{ 
			_teamMemberSet = value;
		}
		
		public function get teamLabel():String
		{
			return _teamLabel;
		}
		
		public function set teamLabel(value:String):void
		{
			_teamLabel = value;
		}
		
		public function get teamId():int
		{
			return _teamId;
		}
		
		public function set teamId(value:int):void
		{
			_teamId = value;
		} 
		
	}
}