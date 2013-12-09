/*
Copyright (c) 2008, Universal Mind
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the 
    * documentation and/or other materials provided with the distribution.
    * Neither the name of the Universal Mind nor the names of its contributors may be used to endorse or promote products derived from 
    * this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY UNIVERSAL MIND AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Thomas Burleson, Principal Architect
        ThomasB@UniversalMind.com
                
@ignore
*/

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