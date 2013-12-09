/*
Copyright (c) 2008, Universal Mind
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the 
    * documentation and/or other materials provided with the distribution.
    * Neither the name of the Universal Mind nor the names of its contributors may be used to endorse or promote products derived from 
    * this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY UNIVERSAL MIND AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Thomas Burleson, Principal Architect
        ThomasB@UniversalMind.com
                
@ignore
*/
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