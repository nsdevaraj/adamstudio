package com.universalmind.cairngorm.business
{    
   import com.adobe.cairngorm.business.ServiceLocator;
   import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
   import com.universalmind.cairngorm.vo.ConnectionVO;
   
   import mx.rpc.events.FaultEvent;
   import mx.rpc.http.HTTPService;
   import mx.rpc.soap.LoadEvent;
   import mx.rpc.soap.WebService;
   
  /**
    * This ServiceLocator provides two methods in addition to the standard adobe.cairngorm...ServiceLocator:
    * updateServiceURLs() and findServiceByName(). 
    * 
    * <p>
    * 
    * A ServiceLocator is still intended to be subclassed by a Services.mxml class... and it is that class
    * that is mxml tag instantiated in the <mx:Application /> class. The ServiceLocator is intended to provide
    * easy access to HTTPService, WebService, and RemoteObject instances using IDs. The Universal Mind ServiceLocator
    * also provides an easy way to update 1 or more service instances with URLs strings that are loaded at runtime.
    * <br/><br/>
    * 
    * </p>
    * 
    * @example Consider the code (Services.mxml) below that demonstrates the intended manner in which the ServiceLocator is subclassed:  
    * <pre> 
    *   
    *   &lt;?xml version="1.0" encoding="utf-8"?&gt;
    *   &lt;service:ServiceLocator xmlns:mx="http://www.adobe.com/2006/mxml" 
    *                         xmlns:service="com.universalmind.cairngorm.business.*" &gt;
    * 
    *        &lt;mx:HTTPService id="loginService"  url="https://trail.clientX.com/login.do" 
    *                                              resultFormat="e4x" useProxy="false" /&gt;
    * 
    *         &lt;mx:RemoteObject id="ratingService" destination="clientXRatingServices"&gt;
    *               &lt;mx:method name="getRatingsByDate" makeObjectsBindable="true" /&gt;
    *         &lt;/mx:RemoteObject&gt;
    * 
    *   &lt;/service:ServiceLocator&gt;
    * </pre>
    * 
    * @see com.adobe.cairngorm.business.ServiceLocator
    */

    public class ServiceLocator extends com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator{
   	    /**
   	      * Variable to all switch between remote data services and local files
   	      */
     		public var local        : Boolean = false;

   	    /**
   	      * Cross-reference table of serviceName, local URL, and remote URL
   	      */
    		public var urlDetails 	: Array   = [];
  
  
       /**
         * Return the ServiceLocator __instance.
         * 
         * @return the instance of com.universalmind.cairngorm.business.ServiceLocator. 
         * Note: this should be an instantiation of com.universalmind.cairngorm.business.ServiceLocator
         */
        public static function get instance(): com.adobe.cairngorm.business.ServiceLocator
        {
        	return getInstance();
        }
        
        public static function getInstance() : com.adobe.cairngorm.business.ServiceLocator 
        {
           if ( __instance == null )
           {
              __instance = new com.universalmind.cairngorm.business.ServiceLocator();
           }
              
           return __instance;
        }
  									  
   	    /**
   	      * Method to initialize services with cross-reference URL table.
   	      * This allows services to be initialized based on a runtime loaded configuration file.
   	      *  
   	      * <pre>
   	      *      urlDetails = [
   	      *                     {serviceName, localURL, remoteURL},
   	      *                     {serviceName, localURL, remoteURL}
   	      *                   ];
   	      * <pre> 
   	      *
   	      * @urlDetails This the array of init objects
   	      */
    		public function updateServiceURLs(urlDetails:Array):void {
    			this.urlDetails = urlDetails != null ? urlDetails : [];
    			
    			// Scan thru the services and attempt to set the proper URL or WSDL references...
    			for each (var item:* in urlDetails) {
    				/* !! expected data format: 
    					
    					[ 
    					 {serviceName, localURL, remoteURL},
    					 {serviceName, localURL, remoteURL} 
    					]
    				*/								
    				var serviceID   : String = item.serviceName;
    				var serviceURL  : String = lookupServiceURL(serviceID);
    				var service     : *      = findServiceByName(serviceID,true);
    				
    				if (service != null) {
    					if  (service is WebService)		{
    						var ws : WebService = (service as WebService);	
    						
    						ws.requestTimeout 	= getValueByKey(item,ConnectionVO.TIMEOUT_WSDL,2);
							ws.wsdl             = lookupServiceWSDL(serviceID);								
							if (ws.canLoadWSDL() == true) {
		    					attachWDLListeners(ws);	    				
								ws.loadWSDL();
							}
    					}
    					else if (service is HTTPService)	{
    				    var hs : HTTPService = service as HTTPService;
    				            hs.requestTimeout = getValueByKey(item,ConnectionVO.TIMEOUT_URL,30);
    						    hs.url = serviceURL;
    					}
    				}					
    			}
    						
    		}
  
       
     	  // ************************************************* 
     	  // Public Service Lookup functions 
     	  // ************************************************* 
        
        /**
          * Utility method to get reference to any service instance based on the service name/id.
          * 
          * @serviceName The service name/id specified when the service was instantiated. Note the service type is
          * irrelevant. Using the service name/id a RemoteObject, WebService, or HTTPService instance can be returned.
          *
          * @throws If the service was not found, an error may be thrown.
          */ 	  
    	  public function findServiceByName(serviceName:String, throwError : Boolean = true ) : * {
    	  	var results 	: Object = null;
      		
      		if (serviceName != "") { 
      			// Scan for the service...
      			try { results = (results == null) ? getWebService(serviceName)   : results;  } catch(e:Error) { /* ignore */ }
      			try { results = (results == null) ? getHTTPService(serviceName)  : results;  } catch(e:Error) { /* ignore */ }  
      			try { results = (results == null) ? getRemoteObject(serviceName) : results;  } catch(e:Error) { /* ignore */ }  
      		}
      		
      		if ((results == null) && throwError) {
      			throw new Error( "Service "+serviceName+" was not found in the Cairngorm Services registry." );
      		}
      		
      		return results;
    	  }
  	  
  
  	  // ***************************************************
  	  // Utility methods...
  	  // ***************************************************
  		
    	  private function lookupServiceURL(serviceID:String):String {
    	  	var serviceURL : String = "";
    	  	
      		for each (var item:* in urlDetails) {
      			// !! expected data format: [ {serviceName, localURL, remoteURL} ]
      			if (item.serviceName == serviceID) {
      				serviceURL = (local && (String(item.localURL) != "")) ? item.localURL      : getValueByKey(item,ConnectionVO.REMOTE_URL,"");
      				break;
      			}
      		}	  		
      		
      		return serviceURL;
    		
    	  }

        private function lookupServiceWSDL(serviceID:String):String {
    	  	var wsdl : String = "";
    	  	
      		for each (var item:* in urlDetails) {
      			// !! expected data format: [ {serviceName, localURL, remoteURL} ]
      			if (item.serviceName == serviceID) {
      				wsdl = getValueByKey(item,ConnectionVO.WSDL,"");
      				break;
      			}
      		}	  		
      		
      		return ((wsdl == "") ? lookupServiceURL(serviceID) : wsdl);
        }		
        
        
        private function lookupServiceDetails(serviceID:String):Object {
        	var results : Object = null;
        	
        	for each (var connection:* in urlDetails) {
        		if (connection.serviceName == serviceID) {
        			results = connection;
        			break;
        		}
        	}
        	
        	return results;
        }        
  	 //******************************************************
  	 // Safe error handlers
  	 //******************************************************
  	 	  /**
  	 	    * When a WebService URL is set, the WSDL is reloaded, this method provides an fault handler
  	 	    * if the WSDL could not be loaded or the call issued a timeout.
  	 	    * 
  	 	    * @event The FaultEvent that provides details why the WebService could not be initialized.
  	 	    * 
  	 	    * @private
  	 	    */
    		private function onWSDL_LoadError(event:FaultEvent):void {
				attachWDLListeners(event.target as WebService,false);	    				
    			if (local != true) 	throw new Error(event.fault.faultDetail);
    		}

  	 	  /**
  	 	    * When a WebService URL is set, the WSDL is reloaded, this method provides an result handler
  	 	    * used to reset future timeouts to 300 ms.
  	 	    * 
  	 	    * @event The ResultEvent that provides details about the WSDL load request
  	 	    * 
  	 	    * @private
  	 	    */
    		private function onWSDL_Loaded(event:LoadEvent):void {
    			var ws : WebService = event.target as WebService;
    			if (ws != null) {
    				// So the WSDL loaded... reset any future calls to 
    				// timeout the call after 5 minutes
    				ws.requestTimeout = getValueByKey(lookupServiceDetails(ws.service),ConnectionVO.TIMEOUT_URL,300);
					
					attachWDLListeners(ws,false);	    				
    			}
    		}
    		
    		private function attachWDLListeners(ws:WebService,attach:Boolean = true):void {
    			if (ws == null) return;
    			
    			if (attach == true) {
    				ws.addEventListener(FaultEvent.FAULT,	onWSDL_LoadError,false,0,true);
    				ws.addEventListener(LoadEvent.LOAD,	    onWSDL_Loaded,false,0,true);
    			} else {
    				ws.removeEventListener(FaultEvent.FAULT,	onWSDL_LoadError);
    				ws.removeEventListener(LoadEvent.LOAD,	    onWSDL_Loaded);
    			}
	    					    
    		}
    		
    		private function getValueByKey(cache:Object,key:String,defaultValue:*):* {
    			var results : * = defaultValue;

    			if (cache && cache.hasOwnProperty(key)){
    					results = cache[key];
    			}
    			
    			return results;
    		}
  
     }   
}
