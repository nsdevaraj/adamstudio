package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	[Bindable]
	public final class LoginVO implements IValueObject
	{
		public var userName : String = "";
		public var password : String = "";
		//public var personId:int;
		public var loginId : int;
		public var userFirstName : String;
		public function LoginVO()
		{
		}
	}
}
