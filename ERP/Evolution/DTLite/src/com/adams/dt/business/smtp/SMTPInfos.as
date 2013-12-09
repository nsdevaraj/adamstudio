package com.adams.dt.business.smtp
{
	public class SMTPInfos
	{
		public var code:int;
		public var message:String;
		
		public function SMTPInfos(code:int, message:String)
		{
			this.code = code;
			this.message = message;
		}
	}
}