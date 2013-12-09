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
	  	var results : Array = [];
	  	
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
