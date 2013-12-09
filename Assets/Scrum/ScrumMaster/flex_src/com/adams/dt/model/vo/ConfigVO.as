package com.adams.dt.model.vo
{ 
	[Bindable]
	public class ConfigVO implements IValueObject
	{
		public function ConfigVO()
		{ 
		}
		public var serverLocation:String
		public var FileServer:String
		public var pdfServerDir:String
		public var CF:int
		public var prjCount:int = 257
		public var evalMins:String
		public var Copyright:String
		public var SmtpHost:String
		public var SmtpPort:String
		public var SmtpUsername:String
		public var SmtpPassword:String
		public var SmtpfrmLbl:String
		public var SmtpTeamEmail:String
		public var allReports:Boolean
		public function set authenticated (value:int):void
		{
			_authenticated = value;
		}
		
		private var _authenticated:int = 0;
		public function get authenticated ():int
		{
			return _authenticated;
		}
		private var _login:String;
		public function set login (value:String):void
		{
			_login = value;
		}

		public function get login ():String
		{
			return _login;
		}
		
		 
		
		private var _password:String;
		public function set password (value:String):void
		{
			_password = value;
		}

		public function get password ():String
		{
			return _password;
		} 	
	}
}