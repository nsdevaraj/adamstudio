package com.adams.dt.commands
{
	import com.adams.dt.model.vo.CurrentInstanceVO;
	import com.adams.dt.service.IDTService;
	

	public class LoginCommand
	{
		[Inject]
		public var service:IDTService; 
		[Inject]
		public var currentInstance:CurrentInstanceVO; 
		  
		public function execute():void
		{  
			 service.login(currentInstance.config.login,currentInstance.config.password );
			 trace('request login '+currentInstance.config.login+' , '+currentInstance.config.password );
		}
	}
}