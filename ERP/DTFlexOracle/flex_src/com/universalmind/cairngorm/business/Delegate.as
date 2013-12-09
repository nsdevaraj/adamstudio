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
        Darron Schall, Principal Architect
                
@ignore
*/

package com.universalmind.cairngorm.business
{
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

  /**
    * A base class used to access remote data services or local storage mechanisms.
    * A Delegate subclass is usually used for 1-to-1 mappings to services and API calls on the remote server
    *
    * <p>
    * While some MVC approaches deprecate the use of Delegates as an un-necessary layer 
    * and use the Command classes to directly access the Services[.mxml]-based services,
    * that bypass is not recommended. 
    * 
    * This base class provides several functional features that reduce complexities
    * for subclasses:
    *   a) Implicit getter "service" that will return an internal lookup of the service with the name specified in the 
    *      Delegate constructor
    *   b) getServiceByName() that will look up the service by name from the ServiceLocator singleton
    *   c) prepareHandlers() that will connect any IResponder handlers to the AsyncToken produced by calls to remote dataservices
    * 
    * </p>
    *
    * <p>
    * The Delegate class is ideal class to:
    *   a) to queue multiple server calls for 1 command request
    *   b) to transform the data before delivery to the command.
    *      e.g. 
    *        Transform incoming structures to value objects 
    *        Transform outgoing value objects to XML  
    * </p>
    *
    * <p>
    * Delegates use a responder constructor argument that will be used to announce
    * responses (result or fault) for asynchronous events. The responders is typically an
    * instance of the Command class. However, it may also be ANY class that supports the IResponder
    * interface. 
    * 
    * Below is sample code 
    * </p>
    *
    * @example The following is an example Delegate subclass that (a) uses intermediate responders, 
    * (b) transformation utils, and (c) notifyCallers() [usually a Command instance]. 
    * <listing version="3.0">
    *    public class LoginDelegate extends Delegate {
    *   
    *        public function LoginDelegate(handlers:IResponder,serviceID:String = "") {
    * 		   if (serviceID == "") serviceID = "serviceLogin";
    *          super(handlers,serviceID);
    *        }
    * 
    *        public function loginUser(user:UserVO) : void {
    *            var token    : AsyncToken = service.loginUser(user);
    *            var handlers : Callbacks  = new Callbacks(onResults_loginUser);
    *
    *            // Here we want to use an intermediate handler BEFORE we use the original
    *            // responder.
    *            prepareHandlers(token,handlers);
    *        }
    * 
    *		public function findMovieTemplate( ownerID:String, templateID:int ):void {
    *		    // Note how we set the webService.request param in order to recieve 
    *           // a proper request token!
    * 
    * 			var ws : WebService         = service as WebService;
    *			    ws.FindTemplate.request = { guid: ownerID, id: templateID };
    *			
    * 			var token : AsyncToken = ws.FindTemplate.send(); 
    *			prepareHandlers(token);
    *		}
    *		
    *        public function onResults_doLogin(event:ResultEvent):void {
    *            var response : LoginResponseVO = (event.result as LoginResponseVO);
    *            var login    : LoginUtils      = new LoginUtils(response);
    *            if (login.status == LoginUtils.ERROR_USER_ALREADY_CONNECTED) {
    *                 response.errorCode = LoginUtils.LOGIN_GOOD;
    *            }
    *  
    *            // This uses [internally] the original delegate responder...
    *            notifyCallers(new ResultEvent(response));
    *        }
    *     }
    * </listing>
    *  
    * @see com.universalmind.cairngorm.events.Callbacks
    */
	public class Delegate {
		
		/**
		  * public read-only access to current Responder
		  * 
		  * @return The current responder registered to handle reponses. Note: this should not be confused with
		  * intermediate responders that are used in the example code. This is the responder used internally when
		  * notifyCallers() is invoked.
		  */  
		public function get responder():IResponder {
			return __responder;
		}
		
		/**
		  * Utility method to get a service by name; useful if a delegate call needs a service
		  * that is different originally registered in the Delegate constructor
		  * 
		  * @return An instance of either a WebService, HTTPService, RemoteObject, or null.
		  */  
    public function getServiceByName(serviceName:String = ""):Object {
        return ((serviceName != "") ? serviceRegistry.findServiceByName(serviceName, false) : null);
    }	
    
    /**
      * Getter that performs an internal lookup of the service using the ServiceLocator. Note the serviceName
      * used is the one originally registered in the Delegate constructor. The Delegate subclass NEVER have to use
      * or import a ServiceLocator; such details are encapsulated and handled by this Delegate parent class. 
	  * 
	  * @return An instance of either a WebService, HTTPService, RemoteObject, or null.
      */
		public function get service():Object {
			// Set up response handlers DIRECTLY to the command unless overriden later 
			// with another call to prepareHandlers
			if (__service == null) {
				if (__serviceName != "") __service = serviceRegistry.findServiceByName(__serviceName, false);
		
				if (__service is WebService) {
					var ws : WebService = __service as WebService;
					
	    		    use namespace mx_internal;
	      		 	if (ws.wsdlFault == true) {
	      		 		    var message : String = StringUtil.substitute("The Webservice {0} :: WSDL '{1}' was not loaded properly.",[ws.service,ws.wsdl]);
							throw new Error(message);	      		 	
	      		 	}
				}
			}
			
			return __service;
		}

    /**
      * Constructor that allows easy registration of responder and the ID/name of the service
      * instance that should be used for remote calls
      * 
      * @param commandHandlers This responder that will be used as the synchronous or asynchronous response
      * to a delegate call
      * 
      * @param serviceName This is the ID or name of the service [HTTPService, RemoteObject, WebService] that
      * should be used to perform the remote dataservice call. This service instance is retrieved via an internal
      * call to the ServiceLocator.
      */
		public function Delegate(commandHandlers:IResponder = null,serviceName:String="") {	
			// Usually the responder is the calling command instance... but not always
			__responder   = commandHandlers;
			__serviceName = serviceName;	
							  
		}
		
		
		// *******************************************************************************************************************
		// PrepareHandler variations
		// *******************************************************************************************************************
		/**
		 * Static utility method used to quickly add responder handlers to an AsyncToken
		 * 
		 * @param token           AsyncToken that is returned from a AbstractMethod call
		 * @param resultHandler   Function that should be invoked asynchronously to handle the ResultEvent
		 * @param faultHandler    Function that should be invoked asynchronously to handle the FaultEvent
		 * 
		 */
		public static function prepareResponder(token:AsyncToken,resultHandler:Function,faultHandler:Function):void {
			if (token != null) {
				token.addResponder(new mx.rpc.Responder(resultHandler,faultHandler));
			}
		}				
		
		/**
		 * Utility method used to add responder handlers (and options) to an AsyncToken
		 * 
		 * @param token           AsyncToken that is returned from a AbstractMethod call
		 * @param options         Generic object that contains one or more properties/objects that should be cached while waiting for a response from the aysnchronous call
		 * 
		 * @param faultHandler    Callbacks instance to specific overrides to the current responder. This allows
		 * inidividual methods to have custom handlers internal to the Delegate subclass. Such solutions would be used to transform data
		 * before a Command responder is then called. 
		 * 
		 */
		public function prepareHandlersWithOptions( token:AsyncToken=null ,options:*=null, handlers:Callbacks = null):void { 
			if (token != null) token.options = options;
			prepareHandlers(token, handlers);
		}
		
		/**
		 * Utility method used to add responder handlers (and options) to an AsyncToken. If the service token has not been configured
		 * properly, this method will throw an error announcing an initialization issue with the service.
		 * 
		 * @param token           AsyncToken that is returned from a AbstractMethod call
		 * @param faultHandler    Callbacks instance to specific overrides to the current responder. This allows
		 * inidividual methods to have custom handlers internal to the Delegate subclass. Such solutions would be used to transform data
		 * before a Command responder is then called. 
		 *
		 * @throws Error Announces that the service instance has not been initialized properly. 
		 */
		public function prepareHandlers(token:AsyncToken=null,handlers:IResponder =null):void {
			
			
			// Normally we have 1 call per service so the default handler implementation works
			// but if we have multiple call options, how do we assign different handlers to
			// different calls? .... alternateHandlers...
			if (token == null || token.message == null) {
				var ws        : WebService = (this.service as WebService);
				if ((ws && !ws.canLoadWSDL()) || (ws == null)) {
					var msg       : String = "The Service for Delegate '{0}' has not been initialized properly.";
					var classInfo : Object = ObjectUtil.getClassInfo(this); 
					throw new Error(StringUtil.substitute(msg,[String(classInfo['name'])]));
				}
			}
			
			Delegate.prepareResponder(token, getResultHandler(handlers), getFaultHandler(handlers));
		}
	
	  /**
	    * This method allows a delegate method to manually announce a response to the the original responder.
	    * This method is normally not used since the prepareHandlers() call connects the asynchronous handlers for the 
	    * responder DIRECTLY to the remote call. In such cases the delegate is bypassed completely.
	    * 
	    * <p>
	    * However, if the delegate call wishes to "massage" the incoming response before notifying the original responder
	    * then prepareHandlers() is given an "intermediate" responder... and the developer is then responsible for manually invoking
	    * the original responder. Below is an example for a LoginDelegate subclass:
	    * 
      * <pre>
      * public function loginUser(user:UserVO) : void {
      *    var token    : AsyncToken = service.loginUser(user);
      *    var handlers : Callbacks  = new Callbacks(onResults_loginUser);
      *
      *    // Here we want to use an intermediate handler BEFORE we use the original
      *    // responder.
      *    prepareHandlers(token,handlers);
      * }
      * 
      * public function onResults_doLogin(event:ResultEvent):void {
      *    var response : LoginResponseVO = (event.result as LoginResponseVO); 
      *    if (response.errorCode == ERROR_USER_ALREADY_CONNECTED) {
      *         response.errorCode = LOGIN_GOOD;
      *    }
      *  
      *    // This uses [internally] the original delegate responder...
      *    notifyCaller(response,event);
      * }
      * </pre>
      * 
      * @results    This is the data or event to return to the "original" IResponder
      * @srcEvent   This is the original event generated as response to the Delegates asynchronous call
	    */ 
		public function notifyCaller(results:* = null, srcEvent:* = null):void {
  			// Default result handler simply forwards 
  			// the event to the view handler... if available
  			var isData : Boolean = (results != ResultEvent) && (results != FaultEvent); 
  			
  			if (isData && (srcEvent != null)) {
  			    // Let's package the new data inside a clone of the original event
  			    // Since this is coming from a Delegate, the call is most likely a Command
  			    // we usually expects results directly back from the FlashPlayer; which delivers
  			    // an event NOT data!
  			    
  			    var rEv : ResultEvent = srcEvent as ResultEvent;
  			    var fEv : FaultEvent  = srcEvent as FaultEvent;
  			    
  			    if (rEv != null)      results = new ResultEvent(rEv.type,false,false,results,rEv.token,rEv.message);
  			    else if (fEv != null) results = new FaultEvent(fEv.type,false,false,fEv.fault,fEv.token,fEv.message);
  			}			

				if (results is FaultEvent) this.onFault(results);
				else 					   this.onResult(results);
				
		}
		

		// *********************** **********************************
		// Stub Handlers for IResponder
		// *********************** ********************************

    /**
      * @private - This method is ONLY necessary to allow Delegates to "implement" the IResponder interface;
      */
		public function onResult(event:*):void {
			if (responder != null) responder.result(event);
			else 				   throwError("onResult");
		}
	
    /**
      * @private - This method is ONLY necessary to allow Delegates to "implement" the IResponder interface;
      */
		public function onFault(event:*=null):void {
			if (responder != null) responder.fault(event);
			else 				   throwError("onFault");
		}
		

		// *********************** **********************************
		// Private utility methods
		// *********************** ********************************

		private function getResultHandler(delegateHandlers:IResponder =null):Function {
				// Did the Delegate subclass have specific methods that should handler the results 1st?
				// This 1st handler is where the factories could convert the incoming data...
			return makeMethodClosure("onResult", delegateHandlers );
		}
		
		private function getFaultHandler(delegateHandlers:IResponder =null):Function {
				// Did the Delegate subclass have specific methods that should handler the results 1st?
				// This 1st handler is where the factories could convert the incoming data...
			return makeMethodClosure("onFault",delegateHandlers );
		}
		
		private function makeMethodClosure(method:String,scope:IResponder=null):Function {
	
			var results : Function = null;
			
			if (scope == null) scope = this.responder;
			switch(method) {
				case "onResult":	results = scope.result;
									break;
				case "onFault":		results = scope.fault;
									break;
			}
			
			return results;
		}
		
		// *********************** **********************************
		// Private Attributes
		// *********************** ********************************

		private function throwError(eventType:String):void {
			var msg : String = StringUtil.substitute("Delegate for {0} does not have any eventHandlers for the {1} event.",
													  [__serviceName,eventType]);
			throw (new Error(msg));													  
		}		
		
		private function get serviceRegistry(): ServiceLocator {
		  // Note this means that developers must take care that the proper instance is created...
		  var locator : com.universalmind.cairngorm.business.ServiceLocator = com.universalmind.cairngorm.business.ServiceLocator(com.universalmind.cairngorm.business.ServiceLocator.getInstance());
		  if (locator == null) {
		    throw new Error("com.universalmind.cairngorm.business.ServiceLocator instance is not available!");
		  }
		  
			return locator;
		}
		
	
		// *********************** **********************************
		// Private Attributes
		// *********************** ********************************

		protected var __service  		: *;
		protected var __serviceName 	: String; 
		protected var __responder		: IResponder;
	}
}