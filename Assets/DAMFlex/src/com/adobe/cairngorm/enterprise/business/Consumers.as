package com.adobe.cairngorm.enterprise.business
{
   import com.adobe.cairngorm.CairngormError;
   import com.adobe.cairngorm.CairngormMessageCodes;
   import com.adobe.cairngorm.business.AbstractServices;
   import com.adobe.cairngorm.business.IServiceLocator;
   
   import flash.utils.Dictionary;
   
   import mx.messaging.Consumer;
   
   /**
    * Used to manage all Consumer's defined on the IServiceLocator instance.
    */
   internal class Consumers extends AbstractServices
   {
      private var services : Dictionary = new Dictionary();
      
      /**
       * Register the services.
       * @param serviceLocator the IServiceLocator instance.
       */
      public override function register( serviceLocator : IServiceLocator ) : void
      {
         var accessors : XMLList = getAccessors( serviceLocator );
         
         for ( var i : uint = 0; i < accessors.length(); i++ )
         {
            var name : String = accessors[ i ];
            var obj : Object = serviceLocator[ name ];
            
            if ( obj is Consumer )
            {
               services[ name ] = obj;
            }
         }
      }
      
      /**
       * Return the service with the given name.
       * @param name the name of the service.
       * @return the service.
       */
      public override function getService( name : String ) : Object
      {
         var service : Consumer = services[ name ];
         
         if ( service == null )
         {
            throw new CairngormError( CairngormMessageCodes.CONSUMER_NOT_FOUND, name );
         }
         
         return service;
      }
      
      /**
       * Set the credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public override function setCredentials( username : String, password : String ) : void
      {
         for ( var name : String in services )
         {
            var service : Consumer = services[ name ];
            
            service.logout();
            service.setCredentials( username, password );
         }
      }
      
      /**
       * Set the remote credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public override function setRemoteCredentials( username : String, password : String ) : void
      {
         for ( var name : String in services )
         {
            var service : Consumer = services[ name ];
            
            service.setRemoteCredentials( username, password );
         }
      }
      
      /**
       * Log the user out of all registered services.
       */
      public override function logout() : void
      {
         for ( var name : String in services )
         {
            var service : Consumer = services[ name ];
            
            service.logout();
         }
      }
   }
}