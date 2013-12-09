package com.adobe.cairngorm.enterprise.business
{
   import com.adobe.cairngorm.business.IServiceLocator;
   
   import mx.messaging.Consumer;
   import mx.messaging.Producer;
    
   /** 
	 * <code>IEnterpriseServiceLocator</code> extends <code>IServiceLocator</code> to add support
	 * for eneterprise services. Its intention is to support unit testing.
	 */
   public interface IEnterpriseServiceLocator extends IServiceLocator
   {     
      /**
		 * Return the DataService for the given service id.
       * @param name the name of the DataService.
		 * @return the DataService.
		 */
      function getDataService( name : String ):Object;

      /**
		 * Return the message Consumer for the given service id.
       * @param name the name of the Consumer.
		 * @return the Consumer.
		 */
      function getConsumer( name : String ) : Consumer;

		/**
		 * Return the message Produce for the given service id.
       * @param name the name of the Producer.
		 * @return the Producer.
		 */
      function getProducer( name : String ) : Producer;
   }
}