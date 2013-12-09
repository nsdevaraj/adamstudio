package com.adams.dt.model.mainView
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import mx.core.ClassFactory;
	
	public class ViewFactory
	{
		public var fClasses:Dictionary = new Dictionary();
		public var objClasses:Dictionary = new Dictionary();
		public var buttonObjects:Dictionary = new Dictionary();
		public var DGColumnsRef:Dictionary = new Dictionary();
        private static var ref:ViewFactory;
  
        public static function getInstance():ViewFactory
        {
            if( null == ref)
            {
                 ref = new ViewFactory();   
            }
            return ref;     
        }

        public function ViewFactory()
        {
            if(null != ref)
            {
                throw new IllegalOperationError(" use getInstance()");
            }
        }
  
        public function addViewClass(id:String, viewClass:Class):void
        {
            if( fClasses.hasOwnProperty(id) )
            {
                throw new Error("View " + id + " is already registered.");
            }
            else
            { 
                fClasses[id] = viewClass;
            }
        }
  
        public function removeViewClass(id:String):void
        {
             if( !fClasses.hasOwnProperty(id) )
             {
                  throw new Error("View " + id + " is not registered." );
             }
             else
             {
                  delete fClasses[id];
             }
        }
  
        public function getClass(id:String):Class
        {
             if(fClasses.hasOwnProperty(id) )
             {
                  return fClasses[id];
             }
             else
             {
                  throw new ArgumentError("View " + id + 
                       " has not been registered");
             }
        }
  		
  		public function getObjectClass(id:String):*
        {
             if(objClasses.hasOwnProperty(id) )
             {
                  return objClasses[id];
             }
             else
             {
                  throw new ArgumentError("View " + id + 
                       " has not been registered");
             }
        }
  		
  		public function removeObjectClass(id:String):void
        {
             if( !objClasses.hasOwnProperty(id) )
             {
                  throw new Error("View " + id + " is not registered." );
             }
             else
             {
                  delete objClasses[id];
             }
        }
  		
        public function createInstance(id:String):*
        {
              var factory:ClassFactory;
              if( fClasses.hasOwnProperty(id) )
              {
                   factory = new ClassFactory( fClasses[id] );
              }
              return factory.newInstance();
        }
        
        public function addColumnRef( id:String, viewClass:Array ):void
        {
            if( DGColumnsRef.hasOwnProperty( id ) )
            {
                throw new Error("View " + id + " is already registered.");
            }
            else
            { 
                DGColumnsRef[ id ] = viewClass;
            }
        }
        
        public function getColumnRef(id:String):Array
        {
        	if( DGColumnsRef.hasOwnProperty( id ) )
            {
                 return DGColumnsRef[id];
            }
            else
            {
                 return null;
            }
        }

	}
} 