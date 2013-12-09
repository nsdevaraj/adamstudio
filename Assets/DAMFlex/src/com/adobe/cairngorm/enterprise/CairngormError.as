package com.adobe.cairngorm.enterprise
{
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;
	import mx.utils.StringUtil;
	
	public class CairngormError extends Error
	{
		[ResourceBundle("CairngormMessages")] 
	 	private static var rb : ResourceBundle;
		
		public function CairngormError( errorCode : String, ... rest )
		{
			super( formatMessage( errorCode, rest.toString() ) );
		}
		
		private function formatMessage( errorCode : String, ... rest ) : String
		{
			var message : String =
				StringUtil.substitute(
				ResourceManager.getInstance().getString(
				"CairngormMessages", errorCode), rest );
			
			return StringUtil.substitute(
				"{0}: {1}",
				errorCode,
				message);
		}
		
		protected function get resourceBundle() : ResourceBundle
		{
			return rb;
		}
	}
}