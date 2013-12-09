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
   import flash.utils.Dictionary;
   import mx.core.Application;
   
   import com.universalmind.cairngorm.commands.Command;
   import com.universalmind.cairngorm.events.UMEvent;

   /**
     * This ModuleController allows mini-MVC frameworks to be registered and used
     * as part of applications MVC framework.
     * 
     * <p>
     * Often applications are developed with distinct modules (dynamically loaded
     * or static compiled). These modules may contain their own mini-Cairngorm MVC
     * but need to be used with the scope of an application MVC; used without namespace
     * conflicts or overrides.
     * </p>
     * 
     * <p>
     * Each subcontroller maps its own events to its own commands. This allows modules 
     * sub-MVCs to be "plugged" into other applications easily. Note that all subController
     * events must be registered during construction.
     * </p>
     * 
     * <pre>
     * 
     *      public class SalesController extends ModuleController {
     *        
     *          public function SalesController() {
     *             registerModuleEvents();
     *          }
     * 
     *          private function registerModuleEvents():void {
     *              addCommand(GetSalesByRegionEvent.EVENT_ID, SalesCommand);
     *              addCommand(GetAllSalesEvent.EVENT_ID,      SalesCommand);
     *             
     *              addCommand(RequestRefundEvent.EVENT_ID,    RefundCommand);
     *          }
     *      }
     * 
     * </pre>
     * 
     */
   public class ModuleController extends BaseController
   {

    /**
      * This method allows FrontControllers to easily access events that have
      * been already registered with the ModuleController [aka subController].
      * 
      * <p>
      * Note: this assumes that all events have been registered by the
      * ModuleController constructor. Events registered "later" will NOT
      * be added to the FrontController global registry.
      * </p>
      * 
      * @see com.universalmind.cairngorm.control.FrontController
      */
	  public function get registeredEvents():Array {
	  	var results : Array = new Array();
	  	
	  	for each (var eventID:String in commands) {
	  		results.push(eventID);	
	  	}
	  	
	  	return results;
	  } 
	  
	  /**
	    * This method exposes the ModuleController event processor to the
	    * FrontController so this subcontrollers events can be processed properly
	    * by "this" controllers commands
	    * 
	    * @see com.universalmind.cairngorm.control.FrontController
	    */
	  public function get eventHandler():Function {
	  	return this.executeCommand;
	  } 	   	   	  
   }   
}
