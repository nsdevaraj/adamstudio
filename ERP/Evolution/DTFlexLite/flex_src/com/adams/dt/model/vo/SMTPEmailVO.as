package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	[Bindable]
	public final class SMTPEmailVO implements IValueObject
	{
		public var msgTo : String = "";
		public var msgSubject : String = "";
		public var msgBody : String = "";
		public function SMTPEmailVO()
		{
		}
	}
}
