package com.adams.dt.business
{   
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
    /**
     * A Singleton responsible for storing references to all Business Delegates. 
     * This allows for these delegates to be injected into the application using an IoC framework.
     *  
     * <a href="http://www.allenmanning.com/?p=25">See Allan Manning's post on the DelegateLocator</a>
     */
    public class DelegateLocator
    {
    	/**
		 * Reference to self used for singleton access.
		 */
		private static var instance:DelegateLocator;
		
		/**
		 * Constructor.
		 * 
		 * <p>As a singleton, only one instance of the DelegateLocator can be created.</p>
		 */
		public function DelegateLocator()
		{
			if(instance != null)
			{
				throw new CairngormError(CairngormMessageCodes.SINGLETON_EXCEPTION, "DelegateLocator");
			} 
			else
			{
				instance = this;
			}
		}
		
		/**
		 * Singleton access method to an instance of DelegateLocator.
		 * Ensures only one instance of the ModelLocator is created.
		 * 
		 * @returns The singleton DelegateLocator.
		 */
		public static function getInstance():DelegateLocator
		{
			if(instance == null)
			{
				instance = new DelegateLocator();
			}
			
			return instance;
		}
		
		/**
		 * Reference to the delegate. Provides an interface 
		 * to get the injected delegate at run-time.
		 */ 
		public var languageDelegate:IDAODelegate = new LangEntriesDelegate();
		public var pagingDelegate:IDAODelegate = new PageDAODelegate(); 
    }

}