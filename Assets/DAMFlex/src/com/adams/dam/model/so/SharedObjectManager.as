package com.adams.dam.model.so
{
	import flash.net.SharedObject;
	
	import mx.utils.URLUtil;
	
	public class SharedObjectManager
	{
		
		public var sharedObject:SharedObject;
		
		private static var _instance:SharedObjectManager;
		public static function get instance():SharedObjectManager
		{
			if( !_instance ) {
				_instance = new SharedObjectManager();
			}	
			return _instance;
		}
		
		public function SharedObjectManager()
		{
			if( _instance ) {
				throw new Error( "Public construction not allowed." );
			}	
			initialize();
		}
		
		public function get data():Object {
			return sharedObject.data;
		}
		
		public function set data( value:Object ):void {
			if ( sharedObject.data != value ) {	
				if ( !value ) {
					for( var index:String in sharedObject.data ) {
						sharedObject.data[ index ] = null;
						sharedObject.clear();
						delete sharedObject.data[ index ];
					}
				}
				else {
					for( var index2:String in value ) {
						sharedObject.data[ index2 ] = value[ index2 ];
					}
				}
				sharedObject.flush();
			}
		}
		
		private function initialize():void {
			sharedObject = SharedObject.getLocal( 'DTGENCREATOR' ); 
		}
	}
}