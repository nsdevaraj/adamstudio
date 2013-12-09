package com.universalmind.cairngorm.vo
{
	
	public dynamic class ConnectionVO implements IValueObject
	{
		static public const REMOTE_URL   : String = "remoteURL";
		static public const SERVICE_NAME : String = "serviceName";
		static public const WSDL         : String = "wsdl";
		static public const TIMEOUT_URL  : String = "urlTimeout";
		static public const TIMEOUT_WSDL : String = "wsdlTimeout";
		
		public var serviceName : String = "";
		
		public var remoteURL   : String = "";
		public var urlTimeout  : int    = 0;
		
		public var wsdl        : String = "";
		public var wsdlTimeout : int    = 0;
		
		public function ConnectionVO( serviceName : String = "",
		                              remoteURL   : String = "",
		                              wsdl        : String = "",
		                              urlTimeout  : int    = 300,
		                              wsdlTimeout : int    = 5) {
		
			this.serviceName = serviceName;
			this.remoteURL   = remoteURL;
			this.wsdl        = wsdl;
			
			this.urlTimeout  = urlTimeout;
			this.wsdlTimeout = wsdlTimeout;                              	
		}
		
		public function clone():* {
			return new ConnectionVO().copyFrom(this);
		}
		
		public function copyFrom(src:*):* {
			var results : ConnectionVO = null;
			
			if (src is ConnectionVO) {
				this.serviceName = (src as ConnectionVO).serviceName;
				this.remoteURL   = (src as ConnectionVO).remoteURL;
				this.wsdl        = (src as ConnectionVO).wsdl;
				
				this.urlTimeout  = (src as ConnectionVO).urlTimeout;
				this.wsdlTimeout = (src as ConnectionVO).wsdlTimeout;
				
				results = this;                              	
			}
			
			return results;
		}
		
		public function equals(src:*):Boolean {
			var results : Boolean = false;
			
			if (src is ConnectionVO) {
				var vo : ConnectionVO = src as ConnectionVO;
				
				results  = this.serviceName == vo.serviceName  &&
						  (this.remoteURL   == vo.remoteURL)   &&
						  (this.wsdl        == vo.wsdl)        &&
						  (this.urlTimeout  == vo.urlTimeout) &&
						  (this.wsdlTimeout == vo.wsdlTimeout);
			}
			
			return results;			
		}
	}
}