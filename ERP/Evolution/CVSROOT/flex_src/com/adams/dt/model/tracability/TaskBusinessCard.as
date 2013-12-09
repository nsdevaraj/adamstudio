package com.adams.dt.model.tracability
{
	import com.adams.dt.model.vo.Companies;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Profiles;
	import flash.utils.ByteArray;
	[Bindable]
	public final class TaskBusinessCard
	{
		public var personFirstName : String;
		public var personLastName : String;
		public var pesonPosition : String;
		public var personPict : String;
		public var company : Companies;
		public var taskProfile : Profiles;
		public var persons : Persons;
		public var perPicture : ByteArray;
		public function TaskBusinessCard()
		{
		}
	}
}
