package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.Persons")]	
	[Bindable]
	public final class Persons implements IValueObject
	{ 
		private var _personPictBlob:Object;
		public function set personPictBlob (value : Object) : void
		{
			_personPictBlob = value;
		}
		private var _personId : int;
		public function set personId (value : int) : void
		{
			_personId = value;
		}

		public function get personId () : int
		{
			return _personId;
		}
		private var _defaultProfile : int;
		public function set defaultProfile (value : int) : void
		{
			_defaultProfile = value;
		}

		public function get defaultProfile () : int
		{
			return _defaultProfile;
		}
		private var _personFirstname : String;
		public function set personFirstname (value : String) : void
		{
			_personFirstname = value;
		}

		public function get personFirstname () : String
		{
			return _personFirstname;
		}

		private var _personLastname : String;
		public function set personLastname (value : String) : void
		{
			_personLastname = value;
		}

		public function get personLastname () : String
		{
			return _personLastname;
		}

		private var _personEmail : String;
		public function set personEmail (value : String) : void
		{
			_personEmail = value;
		}

		public function get personEmail () : String
		{
			return _personEmail;
		}

		private var _personLogin : String;
		public function set personLogin (value : String) : void
		{
			_personLogin = value;
		}

		public function get personLogin () : String
		{
			return _personLogin;
		}

		private var _personPassword : String;
		public function set personPassword (value : String) : void
		{
			_personPassword = value;
		}

		public function get personPassword () : String
		{
			return _personPassword;
		}

		private var _personPosition : String;
		public function set personPosition (value : String) : void
		{
			_personPosition = value;
		}

		public function get personPosition () : String
		{
			return _personPosition;
		}

		private var _personPhone : String;
		public function set personPhone (value : String) : void
		{
			_personPhone = value;
		}

		public function get personPhone () : String
		{
			return _personPhone;
		}

		private var _personMobile : String;
		public function set personMobile (value : String) : void
		{
			_personMobile = value;
		}

		public function get personMobile () : String
		{
			return _personMobile;
		}

		private var _personPict : ByteArray;
		public function set personPict (value : ByteArray) : void
		{
			_personPict = value;
		}

		public function get personPict () : ByteArray
		{
			return _personPict;
		}

		private var _personDateentry : Date;
		public function set personDateentry (value : Date) : void
		{
			_personDateentry = value;
		}

		public function get personDateentry () : Date
		{
			return _personDateentry;
		}

		private var _activated : int;
		public function set activated (value : int) : void
		{
			_activated = value;
		}

		public function get activated () : int
		{
			return _activated;
		}

		private var _activeChatid : String;
		public function set activeChatid (value : String) : void
		{
			_activeChatid = value;
		}

		public function get activeChatid () : String
		{
			return _activeChatid;
		}

		private var _loginStatus : String;
		public function set loginStatus (value : String) : void
		{
			_loginStatus = value;
		}

		public function get loginStatus () : String
		{
			return _loginStatus;
		}

		 
		private var _companyFk: int;
		public function set companyFk (value : int) : void
		{
			_companyFk= value;
		}

		public function get companyFk () : int
		{
			return _companyFk;
		}

		private var _profile : Profiles = new Profiles();
		public function set profile(value : Profiles) : void
		{
			_profile = value;
		}

		public function get profile() : Profiles
		{
			return _profile;
		}
		private var _personAddress : String;
		public function set personAddress (value : String) : void
		{
			_personAddress = value;
		}

		public function get personAddress () : String
		{
			return _personAddress;
		}
		private var _personCountry : String;
		public function set personCountry (value : String) : void
		{
			_personCountry = value;
		}

		public function get personCountry () : String
		{
			return _personCountry;
		}		
		private var _personCity : String;
		public function set personCity (value : String) : void
		{
			_personCity = value;
		}

		public function get personCity () : String
		{
			return _personCity;
		}		
		private var _personPostalCode : String;
		public function set personPostalCode (value : String) : void
		{
			_personPostalCode = value;
		}

		public function get personPostalCode () : String
		{
			return _personPostalCode;
		}		
		public var personRSSLink : String;
		public function Persons()
		{
		}
	}
}
