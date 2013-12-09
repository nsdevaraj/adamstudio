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
package com.universalmind.cairngorm.events.generator
{
   import com.adobe.cairngorm.control.CairngormEventDispatcher;
   import com.universalmind.cairngorm.events.UMEvent;
   
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   import mx.core.UIComponent;
   import mx.utils.StringUtil;
   import mx.rpc.IResponder;
   import com.universalmind.cairngorm.events.Callbacks;
   import com.adobe.cairngorm.control.CairngormEvent;
   import flash.events.IEventDispatcher;
   import flash.events.EventDispatcher;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.Fault;
   import mx.core.IMXMLObject;

	// *****************************************************
	// Events broadcast by the generator to outside listeners
	// *****************************************************
	
   [Event(name="fault", type="flash.events.Event")]
   [Event(name="result", type="flash.events.Event")]
   
   [DefaultProperty("events")]
   
   public class EventGenerator extends EventDispatcher implements IEventGenerator, IMXMLObject
   {      
       
      /*   
      		Actionscript and MXML example usages below:
      
      			// If any task/event fails, then abort the task processing entirely (e.g. trigger == "0")
	      	    var parallelEvents 		: Array 			= [LoadUserProfileEvent,LoadMetaDataEvent];
	      	    var parallelGen         : EventGenerator 	= new EventGenerator(parallelEvents,null,0,"parallel");
	      	    
	      	    // Now, manually add the parallel generator into the list for the consecutive generator...
	      	    var consecutiveTasks    : Array     		= [LoadBundleEvent, parallelGen, LoadUserPreferencesEvent];
	      	    
	      	    var handlers 			: CallBacks 		= new IResponder(whenAppIsReady, notifyUserOfError);	      	    
	      		var cmd      			: EventGenerator 	= new EventGenerator(consecutiveTasks,handlers,0);
	      			cmd.dispatch();

				[!! full classpaths are not specified above... should specify]
			
			or use tag notations:
			      	
			  <generator:EventGenerator id="startUpEvents" 										xmlns:generator="com.universalmind.cairngorm.events.generator.*">
				      <generator:EventGenerator trigger="sequence" result="onUserLoaded(event);" >
		         		  <events:LoadResourcesEvent 			            					xmlns:events="com.mercer.mercerOnline.control.events.*" />
						  <events:GetLoggedInUserEvent 											xmlns:events="com.mercer.mercerOnline.control.events.login.*" />
			  			  <!-- events:LoadClassesOfBusinessEvent                      			xmlns:events="com.mercer.mercerOnline.control.events.questionnaire.*"/ -->
				      </generator:EventGenerator>
			  		  <generator:EventGenerator trigger="parallel">
			      			<events:LoadRolesForFeaturesEvent               				xmlns:events="com.mercer.mercerOnline.control.events.login.*" />
					  		<events:LoadAssociatedUsersEvent 	                    		xmlns:events="com.mercer.common.control.events.*" /> 
			  		  </generator:EventGenerator>  			
			  </generator:EventGenerator>
      */
      
      public static const TRIGGER_SEQUENCE : String = "sequence";
      public static const TRIGGER_PARALLEL : String = "parallel";
      
      public var id             : String            = "";
  	  /**
  	   * Option to specify an alternate dispatcher mechanism  if using the default CairngormEventDispatcher is not desired.
  	   */
      public var dispatcher     : IEventDispatcher 	= null;

      public var trigger	 	: String 			= TRIGGER_SEQUENCE;
      public var failCount		: int				= -1;        
        	
      // ****************************************************************
      // Public Methods
      // ****************************************************************
      
      public function EventGenerator( 	eventsToFire 	: Array     = null, 
      									handlers 		: IResponder = null, 
      									failCount		: int       = -1,
      									triggerType		: String    = TRIGGER_SEQUENCE) {

         this.events        = eventsToFire;
         this.failCount 	= failCount;
         this.trigger   	= triggerType;         
         
         __announcer 	    = handlers;
      }
             
      public function start(handlers:IResponder = null)    : void { dispatch(handlers); }              
      public function dispatch(handlers:IResponder = null) : void {      	
      	 __announcer = handlers ? handlers : __announcer;
      	 resetCache();	
      	 
         dispatchNext();
      }            
      
      public function set events(eventsToFire : Array) : void {
      	buildCache(eventsToFire);
      }
	      
	 public function initialized(document:Object, id:String):void {
	 	this.id = id;
	 }	      
      // ****************************************************************
      // Private Methods
      // ****************************************************************
      
      private function dispatchNext():void {
      	
      	while(hasNext() == true){
      	
      		var item : * = getNext();
			
			if (item != null) {
				// To support synchronous events and IMMEDIATE callbacks, 
				// we must mark the pending item as dispatched before we actually dispatch
				markAsDispatched(item);

			  	if (item is EventGenerator) {
			  		// may be sequence or parallel event generator
			  		if (this.dispatcher != null) item.dispatcher = this.dispatcher;
			  		item.dispatch(new Callbacks(onEventDone,onEventFail));
			  	} else {
			  		// So we must have an instance or Class of an UMEvent subclass
	  				var inst : * = null;
				  	if (item is Class) inst = new item();
				  	else 	           inst = item;
				  	
				  	if (EventUtils.isValidEvent(inst,announceFail) == true) {				  	
					  	prepareResponder(inst);
					  	
					  	redirect::dispatchEvent( inst );
					}		  
			  	}
			}
		  	
		  	// Only break loop if firing a SINGLE event
		  	if (this.trigger == TRIGGER_SEQUENCE) break;
      	}
      }
      
      // *****************************************************
      // Event Handlers for responses to each dispatch action
      // *****************************************************
      
      private function onEventFail(response:*):void {
      	__doneCounter ++;

		notifyResponder(__sequence[__doneCounter - 1], response, true);
		var announced  : Boolean    = announceFail(response, false);

      	if (trigger == TRIGGER_SEQUENCE) {
	      	if (hasNext() && !announced)  {
	      			dispatchNext();
	      			return;
	      	}
      	} 
      	
      	if ((__doneCounter >= __sequence.length) && !announced)  announceFail(id,false);
      }

      private function onEventDone(response:*):void {
      	__doneCounter ++;

      	notifyResponder(__sequence[__doneCounter - 1],response);
  		
      	if (trigger == TRIGGER_SEQUENCE) {
      		if (hasNext()) {
	      		dispatchNext();
	      		return;      			
      		}
      	}

      	if (__doneCounter >= __sequence.length) {
      		announceDone(this.id);
      	}
	      		
      }
      
      private function announceDone(response:*=null):void {
  			// Announce event condition to any explicit or implicit (respectively) listeners
  			if (__announcer != null)__announcer.result(response);  				
  			else dispatchEvent(new UMEvent("result",null,false,false,response));
  			
	      //clearCache();		
      }
      
      private function announceFail(response:*=null, throwAnnouncement:Boolean= true): Boolean{
	    var failed : Boolean = false; 
	    
	    __numOfFails ++;
      	if ((failCount > -1) && (__numOfFails > failCount)) {
  				    // Announce event condition to any explicit or implicit (respectively) listeners
  	      		if (__announcer && (__announcer.fault != null)) __announcer.fault(response);					      		
  	      		else                     						dispatchEvent(new UMEvent(FaultEvent.FAULT,null,false,false,response));

  	      		//clearCache();
  	      		failed = true;
  	     }  
  	     
  	     if (throwAnnouncement == true) throw new Error(response);
  	     
  	     return failed;
      } 

	  // *****************************************
	  // Event Cache methods
	  // *****************************************

	  private function clearCache():void {
	  	for (var key:* in __events) {
	  		// clear value for each item...
	  		// since we constructed with weak references
	  		// this allows refactoring
	  		__events[key] = null;
	  		delete __events[key];
	  	}
	  }
      private function buildCache(eventsToFire:Array):void {
      	clearCache();
      	
      	__sequence = eventsToFire;
      	for each (var item:* in eventsToFire) {     		
      		
      		// Notice how we attach behaviours/flags to object instances
      		// WITHOUT modifying the object
      		__events[item] = { hasBeenDispatched : false,
      						   handlers          : null   };
      	}
      }
      
      private function resetCache():void {
      	buildCache(__sequence);
      }
	
	  // *****************************************
	  // Dispatch Tracking methods
	  // *****************************************

      private function getNext():* {
      	var results : * = null;
      	
      	switch(trigger) {
      	  case TRIGGER_SEQUENCE :  		if (__doneCounter <= __sequence.length) {
                                  		  	results = __sequence[__doneCounter];      	
                                  		};
                                  		break;
                                  		
          case TRIGGER_PARALLEL :     for each (var item : * in __sequence) {
                                        if (hasBeenDispatched(item) != true) {
                                          results = item;
                                          break;
                                        }                                        
                                      }
                                      break;
      	} 
		  	
      	return results;
      }
      
	  private function hasNext():Boolean {
	  	var result : Boolean = false;
	  	var key    : *       = getNext();

	  	if ((key != null) && !hasBeenDispatched(key)){ 
  				result = true;
	  	}
	  	
	  	return result;
	  }   
	     
      private function hasBeenDispatched(key:*):Boolean {
      	var results : Boolean = false;
        for (var it:* in __events) {
        	if (it == key) {
        		results = __events[it].hasBeenDispatched;
        		break;
        	}
        }
      	return results;
      }
      
      private function markAsDispatched(key:*):void {
        for (var it:* in __events) {
        	if (it == key) {
        		__events[it].hasBeenDispatched = true;
        		break;
        	}
        }
      }
      
      
	  private function prepareResponder(event:Event):void {  
	  	if (event != null) {
	  		var current : IResponder = EventUtils.getResponderFor(event);
	  		if (current != null) {
	  			// Cache the original event responder (if any)
	  			__events[event].handlers = current;
	  		}
  		
  			// Hook to allow the EventGenerator to get notifications.
  		    EventUtils.setResponderFor(event,new Callbacks(onEventDone,onEventFail));
	  	} 
	  }

	  public function notifyResponder(key:*, response:*, isFault:Boolean = false):void {
		// Did this event have a responder attached?
		var responder  : IResponder = key ? __events[key].handlers : null;
		if (responder != null) {
	  
	  		// Notify the original event responder (if any)
	  		if (isFault && (responder.fault != null)) { 
	  			responder.fault(response);
	  		} else if (!isFault && (responder.result != null)) {
	  			responder.result(response);
	  		}
		} else {
			//trace ("Event Done: " + response);
		}	
	  }
	  
	  // *****************************************
	  // Private Methods to manage responders
	  // *****************************************

      
      /**
      * Internal namespaced version of dispatchEvent to allow broadcasting generator events via the dispatcher or the CED
      */
   	  private namespace redirect;

	  /** 
	  * Internal method to allow broadcasting generator events via the dispatcher or the CED
	  * 
	  * @param event Event that will be dispatched in sequence or parallel by the EventGenerator
	  * 
	  * @private
	  */
      redirect function dispatchEvent(event:Event):void {
      	if (dispatcher != null) 			dispatcher.dispatchEvent(event);
      	else if (event is CairngormEvent)   __ced.dispatchEvent(event as CairngormEvent);
      	else {
		  	// We expect the Class to be an UMEvent or subclass only so responders back to the EventGenerator can be attached during construction
	  		var msg : String = "EventGenerators can only dispatch CairngormEvent instances to the CairngormEventDispatcher: {0} is an invalid class.";
	  			msg = StringUtil.substitute(msg,[event.type]);
	  		
	  		announceFail(msg);
      	}
      }

	  /**
	  * Reference to the Cairngorm EventDispatcher to allow dispatching of events via the "business" dispatcher
  	  * Use the CairngormEventDispatcher to dispatch the actual events... If using Cairngorm Extensions, 
  	  * this works great because registered commands will execute these events from the EventGenerator
	  * 
	  * @private
	  * 
	  */
   	  private var __ced : CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
      
	  // *****************************************
	  // Private Attributes
	  // *****************************************
      private var __numOfFails  : int = 0;
      private var __doneCounter : int = 0;

	  private var __sequence    : Array      = new Array();					      // maintains sequence of all events to fire
      private var __events 		: Dictionary = new Dictionary(false);  			  // tracks additional flags/conditions for each event
      private var __announcer   : IResponder  = null;						      // callbacks for broadcasting fail/success conditions
 
  }
}

