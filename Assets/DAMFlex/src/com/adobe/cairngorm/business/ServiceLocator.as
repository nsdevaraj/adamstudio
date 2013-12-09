package com.adobe.cairngorm.business
{
   import com.adobe.cairngorm.CairngormError;
   import com.adobe.cairngorm.CairngormMessageCodes;
   
   import mx.rpc.AbstractInvoker;
   import mx.rpc.AbstractService;
   import mx.rpc.http.HTTPService;
   import mx.rpc.remoting.RemoteObject;
   import mx.rpc.soap.WebService;
   
   /**
    * The ServiceLocator allows service to be located and security
    * credentials to be managed.
    * 
    * Although credentials are set against a service they apply to the channel
    * i.e. the set of services belonging to the channel share the same
    * credentials.
    * 
    * You must always make sure you call logout at the end of the user's
    * session.
    */
   public class ServiceLocator implements IServiceLocator
   {   
      protected static var __instance : ServiceLocator;
      
      private var _httpServices : HTTPServices;
      private var _remoteObjects : RemoteObjects;
      private var _webServices : WebServices;
      
      /**
       * Return the ServiceLocator __instance.
       * @return the __instance.
       */
      public static function getInstance() : ServiceLocator 
      {
         if ( __instance == null )
         {
            __instance = new ServiceLocator();
         }
            
         return __instance;
      }
         
      // Constructor should be private but current AS3.0 does not allow it
      public function ServiceLocator() 
      {   
         if ( __instance != null )
         {
            throw new CairngormError( CairngormMessageCodes.SINGLETON_EXCEPTION, "ServiceLocator" );
         }
            
         __instance = this;
      }
      
      /**
       * <p><strong>Deprecated as of Cairngorm 2.1</strong></p>
       * 
       * Returns the service defined for the id, to allow services to be looked up
       * using the ServiceLocator by a canonical name.
       *
       * <p>If no service exists for the service name, an Error will be thrown.</p>
       * @param The id of the service to be returned. This is the id defined in the
       * concrete service locator implementation.
       */
      [Deprecated("You should now use one of the strongly typed methods for returning a service.")]
      public function getService( serviceId : String ) : AbstractService
      {
         return AbstractService( getServiceForId( serviceId ) );
      }      

      /**
       * <p><strong>Deprecated as of Cairngorm 2.1</strong></p>
       * 
       * Returns an AbstractInvoker defined for the id, to allow services to be looked up
       * using the ServiceLocator by a canonical name.
       *
       * <p>If no service exists for the service name, an Error will be thrown.</p>
       * @param The id of the service to be returned. This is the id defined in the
       * concrete service locator implementation.
       */
      [Deprecated("You should now use one of the strongly typed methods for returning a service.")]
      public function getInvokerService( serviceId : String ) : AbstractInvoker
      {
         return AbstractInvoker( getServiceForId( serviceId ) );
      }
      
      /**
       * Return the HTTPService for the given name.
       * @param name the name of the HTTPService
       * @return the HTTPService.
       */
      public function getHTTPService( name : String ) : HTTPService
      {
         return HTTPService( httpServices.getService( name ) );
      }
      
      /**
       * Return the RemoteObject for the given name.
       * @param name the name of the RemoteObject.
       * @return the RemoteObject.
       */
      public function getRemoteObject( name : String ) : RemoteObject
      {
         return RemoteObject( remoteObjects.getService( name ) );
      }
      
      /**
       * Return the WebService for the given name.
       * @param name the name of the WebService.
       * @return the WebService.
       */
      public function getWebService( name : String ) : WebService
      {
         return WebService( webServices.getService( name ) );
      }
              
      /**
       * Set the credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public function setCredentials( username : String, password : String ) : void
      {
         httpServices.setCredentials( username, password );
         remoteObjects.setCredentials( username, password );
         webServices.setCredentials( username, password );
      }
      
      /**
       * Set the remote credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public function setRemoteCredentials( username : String, password : String ) : void 
      {
         httpServices.setRemoteCredentials( username, password );
         remoteObjects.setRemoteCredentials( username, password );
         webServices.setRemoteCredentials( username, password );
      }
      
      /**
       * Logs the user out of all registered services.
       */
      public function logout() : void
      {
         httpServices.logout();
         remoteObjects.logout();
         webServices.logout();
      }
      
      private function get httpServices() : HTTPServices
      {
         if ( _httpServices == null )
         {
            _httpServices = new HTTPServices();
            _httpServices.register( this );
         }
         
         return _httpServices;
      }
      
      private function get remoteObjects() : RemoteObjects
      {
         if ( _remoteObjects == null )
         {
            _remoteObjects = new RemoteObjects();
            _remoteObjects.register( this );
         }
         
         return _remoteObjects;
      }
      
      private function get webServices() : WebServices
      {
         if ( _webServices == null )
         {
            _webServices = new WebServices();
            _webServices.register( this );
         }
         
         return _webServices;
      }
      
      /**
       * Return the service with the given id.
       * @param serviceId the id of the service to return.
       * @return the service.
       */
      private function getServiceForId( serviceId : String ) : Object
      {
         if ( this[ serviceId ] == null )
         {
            throw new CairngormError( CairngormMessageCodes.SERVICE_NOT_FOUND, serviceId );
         }
         
         return this[ serviceId ];
      }
   }
}