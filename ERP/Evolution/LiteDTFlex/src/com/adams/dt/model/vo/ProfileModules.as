package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.ProfileModules")]	
	[Bindable]
	public final class ProfileModules implements IValueObject
	{ 
		private var _profileModuleId : int;
		public function set profileModuleId (value : int) : void
		{
			_profileModuleId = value;
		}

		public function get profileModuleId () : int
		{
			return _profileModuleId;
		} 
		
		private var _profileFk : int;
		public function set profileFk (value : int) : void
		{
			_profileFk = value;
		}

		public function get profileFk () : int
		{
			return _profileFk;
		}
		
		private var _moduleFk : int;
		public function set moduleFk (value : int) : void
		{
			_moduleFk = value;
		}

		public function get moduleFk () : int
		{
			return _moduleFk;
		}  
		public function ProfileModules()
		{
		}
	}
}
