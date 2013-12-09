package com.adams.dt.model
{ 
	import com.adams.dt.model.vo.localize.*; 
	import com.adobe.cairngorm.model.IModelLocator 
	import mx.collections.ArrayCollection;
	import mx.messaging.ChannelSet;
	
	/**
     * The ModelLocator provides singleton access to all the 
     * model/business objects in the application.
     */

	[Bindable]
	public final class ModelLocator implements IModelLocator
	{		
		/**
     	 * ChannelSet variable.
     	 */
		public var langChannelSet : ChannelSet;  
		
		/**
     	 * ILocalizer instance.
     	 */
		public var loc : ILocalizer;
		
		/**
     	 * ILocalizer instance.
     	 */
		public var myLoc : Localizer = Localizer.getInstance();
		
		/**
     	 * ModelLocator instance.
     	 */
		private static var instance : ModelLocator;
		
		/**
     	 * language arraycollection instance variable.
     	 */
		[ArrayElementType("com.adams.dt.model.vo.LangEntries")]
		public var langEntriesCollection : ArrayCollection; 
	   	
	   	/**
     	 * ChannelSet variable.
     	 */
	    public var channelSet:ChannelSet;
	    
	    /**
     	 * String serverLocation variable.
     	 */
	    public var serverLocation : String;
	    
	     /**
     	 * String loginErrorMesg variable.
     	 */
	    public var loginErrorMesg : String;
	    
	    /**
     	 * Boolean loginStatus variable.
     	 */
	    public var loginStatus : Boolean;
			
		/**
         * Singleton access method to an instance of ModelLocator.
         * Ensures only one instance of the ModelLocator is created.
         * 
         * @returns The singleton ModelLocator.
         */
		public static function getInstance() : ModelLocator
		{
			if(instance == null)	instance = new ModelLocator();
			return instance;
		} 
		
		/**
         * ModelLocator Class Constructor.
         * As a singleton, only one instance of the ModelLocator can be created.
         */

		public function ModelLocator()
		{
			if(instance != null) throw new Error("Error: Singletons can only be instantiated via getInstance() method!");
			ModelLocator.instance = this;
		} 
		
	}
}
