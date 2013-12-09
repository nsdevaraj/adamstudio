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

Author: Darron Schall, Principal Architect
		Thomas Burleson, Principal Architect
        ThomasB@UniversalMind.com
                
@ignore
*/

package com.universalmind.cairngorm.control
{
   import com.adobe.cairngorm.commands.ICommand;
   import com.adobe.cairngorm.control.CairngormEvent;
   import com.adobe.cairngorm.control.CairngormEventDispatcher;
   
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.utils.StringUtil;

   /**
     *
     * The traditional cairngorm FrontController requires events to be dispatched
     * to the CairngormEventDispatcher in order for the "event->command" mappings to 
     * trigger. This Class continues to support that mechanism [for direct triggering] but now
     * supports an improved mechanism for dispatching CairngormEvents from the UI layers.
     * 
     * <p> 
     * Alternate extensions have modified the FrontController to not only register
     * events with the CairngormEventDispatcher but also with the <mx:Application>.
     * This solution would allow events - via event bubbling - to reach the Cairngorm framework
     * and not require the use of CairngormEventDispatcher in view class. Opponents 
     * of this solution did not want their Cairngorm events to bubble thru the entire 
     * view hierarchy.
     * </p>
     * 
     * <p>
     * Recent changes have now leveraged a UIComponent event hook to not only dispatch
     * the event "up" the view hierarchy but to also directly trigger the Cairngorm 
     * event->command mapping (if any exists).
     * </p>
     */
   public class BaseController extends com.adobe.cairngorm.control.FrontController
   {

	      /**
	        * This function provides extra runtime type checking of Command class argument: commandRef 
	        * This argument must not be null and must support the ICommand interface.
	        * After these checks, the request is forwarded to the Adobe FrontController 
	        */
		  override public function addCommand( commandName : String, commandRef : Class, useWeakReference : Boolean = true ) : void {

			// Provide runtime checking to confirm the commandRef is non-null and implements ICommand 
			if (null == commandRef) throw new Error("The commandRef argument cannot be null");
			else {
				var classDescription:XML = describeType(commandRef) as XML;
				
				var clazzName         : String = getQualifiedClassName(ICommand);
				var implementsICommand:Boolean = (classDescription.factory.implementsInterface.(@type == clazzName).length() != 0);
				if (!implementsICommand) throw new Error("The commandRef argument '" + commandRef + "' must implement the ICommand interface");
			  }

			super.addCommand(commandName, commandRef, useWeakReference);
		  }

	      /**
	        * This function allows FrontController subclasses to easily register new 
	        * event-command mappings.
	        * 
	        * @eventType This is the event.type or ID of events that we will listen for.
	        * @handler   This is the event handler; usually this is the FrontController::execute()
	        */
	      protected function listenForEvent(eventType:String, handler:Function):void {
	      	 
	      	 if ((commands[eventType] != null) || (__handlers[eventType] != null)) {
	      	 	var msg : String = "Warning: Event '{0}' has already been registered with the FrontController";
	      	 	trace(StringUtil.substitute(msg,[eventType]));
	      	 }
	      	 
	         __dispatcher.addEventListener(eventType, handler,false,0,true);
	         __handlers[eventType] = handler;
	      }

    		/**
    		 * Add a hook into dispatchEvent high up in the inheritance chain.  Any
    		 * subclass of UIComponent is now "UMEvent-aware" and no longer
    		 * needs separate event dispatching code for Cairngorm events.
    		 * The event is still dispatched normally but ALSO gets sent to the CairngormEventDispatcher
    		 */
    		[Deprecated("CairngormEvents should now self dispatch using event.dispatch(). Event hooks or event bubbling of business events should not be used!")]
    		private static function hookDispatchEvent():Boolean
    		{
    		    use namespace mx_internal;
      		 	UIComponent.mx_internal::dispatchEventHook = eventHook;
      
      		 	return true;
    		}
    		
    		/**
    		 * The event hook itself.  Any time we encounter a UMEvent, we
    		 * dispatch it directly through the centralized UMEventDispatcher.  This
    		 * abstraction prevents UI subclasses from having to know how to deal with
    		 * UM events.
    		 */
    		private static function eventHook( event:Event, uic:UIComponent ):void
    		{
    		 	if ( event is CairngormEvent)
    		 	{
    		 		// Warning: CairngormEvent should be self dispatched for proper redirect to the registered Command
    		 		//          e.g.
    		 		//                 var event : LoginUserEvent = new LoginUserEvent(userName, userPassword);
    		 		//                     event.dispatch();
    		 		
    		  		/* Disabled - This has potential side issues
    		  			__dispatcher.dispatchEvent( event as CairngormEvent );
    		  		*/
    		  	}
    		}
    
      	  /** 
      	  * The dispatch event hook when the Application is created. 
      	  * Note: This feature has been disabled! 
      	  **/
    	  static private var __dispatchEventHooked : Boolean                  = hookDispatchEvent();
    	  
    	  /** Maintain a reference to prevent garbage collection. Also shortcut alias */
    	  static private var __dispatcher          : CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
    	  		 private var __handlers 		   : Dictionary               = new Dictionary();
   }   

}
