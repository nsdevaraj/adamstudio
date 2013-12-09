package com.universalmind.cairngorm.events
{
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	/**
	  * This class is a superset of mx.rpc.Responder that
	  * allows developers to quickly create a responder with only a resultHandler
	  * or result, fault, and conflict handlers. 
	  */
	public class Callbacks implements IResponder
	{
		public static const PRIORITY_BEFORE   : int = 0;
		public static const PRIORITY_AFTER    : int = 1;
		public static const PRIORITY_OVERRIDE : int = 2;
	  
    /** Result handler function */
		public var resultHandler   : Function;
    /** Fault handler function */
		public var faultHandler    : Function;
    /** Conflict handler function */
		public var conflictHandler : Function;
		/** Priority of these callbacks over OTHER potential callbacks also registered */
		public var priority        : int;
		
	  /**
	    * Constructor that allows users to specify result, fault, and conflict handlers.
	    * 
	    * @resultFunc  The function that should be invoked as the resultHandler for a response
	    * @faultFunc   The function that should be invoked as the faultHandler for a response
	    * @conflicFunc The function that should be invoked as the conflictHandler for a response
	    */
		public function Callbacks(	resultFunc  : Function,
              									faultFunc   : Function = null,
              									conflictFunc: Function = null,
              									priority    : int      = PRIORITY_AFTER) {
			
			// This class uses "method closures" to allow dynamic callbacks
			// to methods of class instances.
			this.resultHandler   = resultFunc;
			this.faultHandler    = faultFunc;
			this.conflictHandler = conflictFunc;
		}
		
		/** Required method to support the IResponder interface */
		public function result(info:Object):void       {    if (resultHandler != null) resultHandler(info);			}
		/** Required method to support the IResponder interface */
		public function fault(info:Object):void        {	if (faultHandler != null) faultHandler(info);			}
	}
}