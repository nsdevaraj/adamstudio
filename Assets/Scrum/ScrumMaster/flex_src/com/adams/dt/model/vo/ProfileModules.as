package com.adams.dt.model.vo
{
	import com.adams.dt.utils.GetVOUtil;
	
	[RemoteClass(alias = "com.adams.dt.pojo.ProfileModules")]	
	[Bindable]
	public final class ProfileModules implements IValueObject
	{ 
		private var _profileModuleId : int;

		public function get moduleObject():Modules
		{
			if(_moduleObject ==null)
			_moduleObject =  GetVOUtil.getVOObject(_moduleFk,GetVOUtil.moduleList,'moduleId',Modules) as Modules;
			return _moduleObject;
		}

		public function set moduleObject(value:Modules):void
		{
			_moduleObject = value;
			_moduleFk =value.moduleId;
		}

		public function get profileObject():Profiles
		{
			if(_profileObject ==null)
				_profileObject =  GetVOUtil.getVOObject(_profileFk,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
			return _profileObject;
		}

		public function set profileObject(value:Profiles):void
		{
			_profileObject = value;
			_profileFk = value.profileId;
		}
		private var _profileObject:Profiles 
		
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
			profileObject =  GetVOUtil.getVOObject(value,GetVOUtil.profileList,'profileId',Profiles) as Profiles;
		}
		
		public function get profileFk () : int
		{
			return _profileFk;
		}
		private var _moduleObject:Modules 
		
		private var _moduleFk : int;
		public function set moduleFk (value : int) : void
		{
			_moduleFk = value;
			moduleObject =  GetVOUtil.getVOObject(value,GetVOUtil.moduleList,'moduleId',Modules) as Modules;
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