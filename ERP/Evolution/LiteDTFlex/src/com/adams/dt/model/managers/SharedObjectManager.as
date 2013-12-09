package com.adams.dt.model.managers 
{
	import flash.net.SharedObject;
	
	import mx.utils.URLUtil;
	
	/**
	 * SharedObjectManager 
	 *  
	 */	
	public class SharedObjectManager
	{
		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  instance
		//----------------------------------
		
		/**
		 * @private 
		 */	
		private static var _instance:SharedObjectManager;
		
		/**
		 */		
		public static function get instance():SharedObjectManager
		{
			if (_instance == null)
				_instance = new SharedObjectManager();
			return _instance;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 */		
		public function SharedObjectManager()
		{
			if (_instance != null)
				throw new Error("Public construction not allowed.");
			initialize();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */		
		public var sharedObject:SharedObject;
		 
		//----------------------------------
		//  data
		//----------------------------------

		/**
		 * SharedObject 
		 */
		public function get data():Object
		{
			return sharedObject.data;
		}
		
		/**
		 * @private 
		 */	
		public function set data(value:Object):void
		{
			if (sharedObject.data != value)
			{	
				if (value == null)
				{
					for (var index:String in sharedObject.data)	
					{
						sharedObject.data[index] = null;
						sharedObject.clear();
						delete sharedObject.data[index];
					}
				}
				else
				{
					for (var index2:String in value)	
					{
						sharedObject.data[index2] = value[index2];
					}
				}
				sharedObject.flush();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */		
		private function initialize():void
		{
			sharedObject = SharedObject.getLocal('DTGENCREATOR'); 
		}
		 

	}
}