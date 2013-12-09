package com.adobe.cairngorm.business
{
   import com.adobe.cairngorm.CairngormError;
   import com.adobe.cairngorm.CairngormMessageCodes;
   
   import flash.utils.describeType;
   
   /**
    * Used to manage all services defined on the IServiceLocator instance.
    */
   public class AbstractServices implements IServices
   {
      /**
       * Register the services.
       * @param serviceLocator the IServiceLocator isntance.
       */
      public function register( serviceLocator : IServiceLocator ) : void
      {
         throw new CairngormError( CairngormMessageCodes.ABSTRACT_METHOD_CALLED, "register" );
      }
      
      /**
       * Return the service with the given name.
       * @param name the name of the service.
       * @return the service.
       */
      public function getService( name : String ) : Object
      {
         throw new CairngormError( CairngormMessageCodes.ABSTRACT_METHOD_CALLED, "getService" );
      }
      
      /**
       * Set the credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public function setCredentials( username : String, password : String ) : void
      {
         throw new CairngormError( CairngormMessageCodes.ABSTRACT_METHOD_CALLED, "setCredentials" );
      }
      
      /**
       * Set the remote credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public function setRemoteCredentials( username : String, password : String ) : void
      {
         throw new CairngormError( CairngormMessageCodes.ABSTRACT_METHOD_CALLED, "setRemoteCredentials" );
      }
      
      /**
       * Log the user out of all registered services.
       */
      public function logout() : void
      {
         throw new CairngormError( CairngormMessageCodes.ABSTRACT_METHOD_CALLED, "logout" );
      }
         
      /**
       * Return all the accessors on this object.
       * @param serviceLocator the IServiceLocator instance.
       * @return this object's accessors.
       */
      protected function getAccessors( serviceLocator : IServiceLocator ) : XMLList
      {
         var description : XML = describeType( serviceLocator );
         var accessors : XMLList = description.accessor.( @access == "readwrite" ).@name;
            
         return accessors;
      }
   }
}