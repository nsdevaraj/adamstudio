package com.adobe.cairngorm.business
{
   import mx.rpc.http.HTTPService;
   import mx.rpc.remoting.RemoteObject;
   import mx.rpc.soap.WebService;
   
   /**
	 * IServiceLocator defines an interface for service locator. Its intention is
	 * to support unit testing.
	 */
   public interface IServiceLocator
   {
	 

      /**
		 * Return the HTTPService for the given service id.
       * @param name the name of the HTTPService.
		 * @return the RemoteObject.
		 */
      function getHTTPService( name : String ) : HTTPService;
      
		/**
		 * Return the RemoteObject for the given service id.
       * @param name the name of the RemoteObject.
		 * @return the RemoteObject.
		 */
      function getRemoteObject( name : String ) : RemoteObject;
            
		/**
		 * Return the WebService for the given service id.
       * @param name the name of the WebService.
		 * @return the RemoteObject.
		 */
      function getWebService( name : String ) : WebService;
      
		/**
		 * Set the credentials for all registered services. Note that services
		 * that use a proxy or a third-party adapter to a remote endpoint will
		 * need to setRemoteCredentials instead.
		 * @param username the username to set.
		 * @param password the password to set.
		 */
      function setCredentials( username : String, password : String ) : void;
      
      /**
       * Set the remote credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      function setRemoteCredentials( username : String, password : String ) : void
      
		/**
		 * Logs the user out of all registered services.
		 */
      function logout() : void;
   }
}