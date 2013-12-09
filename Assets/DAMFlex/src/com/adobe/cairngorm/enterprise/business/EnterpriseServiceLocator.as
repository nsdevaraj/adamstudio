package com.adobe.cairngorm.enterprise.business
{  
   import com.adobe.cairngorm.CairngormError;
   import com.adobe.cairngorm.CairngormMessageCodes;
   import com.adobe.cairngorm.business.ServiceLocator;
   
   import mx.messaging.Consumer;
   import mx.messaging.Producer;
   
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
   public class EnterpriseServiceLocator extends ServiceLocator implements IEnterpriseServiceLocator
   {   
      private static var instance : EnterpriseServiceLocator;
      
      private var _dataServices: DataServices;
      private var _consumers : Consumers;
      private var _producers : Producers;
      
      /**
       * Return the EnterpriseServiceLocator instance.
       * @return the instance.
       */
      public static function getInstance() : EnterpriseServiceLocator 
      {
         if ( instance == null )
         {
            instance = new EnterpriseServiceLocator();
         }
            
         return instance;
      }
         
      // Constructor should be private but current AS3.0 does not allow it
      public function EnterpriseServiceLocator() 
      {   
         if ( instance != null )
         {
            throw new CairngormError( CairngormMessageCodes.SINGLETON_EXCEPTION, "EnterpriseServiceLocator" );
         }
            
         instance = this;
      }
      
      /**
       * Return the DataService for the given name.
       * @param name the name of the DataService.
       * @return the DataService.
       */
      public function getDataService( name : String ) :Object
      {
         return dataServices.getService( name );
      }
         
      /**
       * Return the message Consumer for the given name.
       * @param name the name of the Consumer.
       * @return the Consumer.
       */
      public function getConsumer( name : String ) : Consumer
      {
         return Consumer( consumers.getService( name ) );
      }
      
      /**
       * Return the message Producer for the given name.
       * @param name the name of the Producer.
       * @return the Producer.
       */
      public function getProducer( name : String ) : Producer
      {
         return Producer( producers.getService( name ) );
      }
      
              
      /**
       * Set the credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public override function setCredentials( username : String, password : String ) : void
      {
         super.setCredentials( username, password );
         
         dataServices.setCredentials( username, password );
         consumers.setCredentials( username, password );
         producers.setCredentials( username, password );
      }
      
      /**
       * Set the remote credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public override function setRemoteCredentials( username : String, password : String ) : void 
      {
         super.setRemoteCredentials( username, password );
         
         dataServices.setRemoteCredentials( username, password );
         consumers.setRemoteCredentials( username, password );
         producers.setRemoteCredentials( username, password );
      }
      
      /**
       * Logs the user out of all registered services.
       */
      public override function logout() : void
      {
         super.logout();
         
         dataServices.logout();
         consumers.logout();
         producers.logout();
      }
      
      private function get dataServices() : DataServices
      {
         if ( _dataServices == null )
         {
            _dataServices = new DataServices();
            _dataServices.register( this );
         }
         
         return _dataServices;
      }

      private function get consumers() : Consumers
      {
         if ( _consumers == null )
         {
            _consumers = new Consumers();
            _consumers.register( this );
         }
         
         return _consumers;
      }
      
      private function get producers() : Producers
      {
         if ( _producers == null )
         {
            _producers = new Producers();
            _producers.register( this );
         }
         
         return _producers;
      }       
  }
}