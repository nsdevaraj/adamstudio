package com.adams.dam.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	
	[Bindable]
	public final class LoginVO implements IValueObject
	{
		private var _userName:String;
		public function get userName():String {
			return _userName;
		}
		public function set userName( value:String ):void {
			_userName = value;
		}
		
		private var _password:String;
		public function get password():String {
			return _password;
		}
		public function set password( value:String ):void {
			_password = value;
		}
		
		public function LoginVO()
		{
			
		}
	}
}
