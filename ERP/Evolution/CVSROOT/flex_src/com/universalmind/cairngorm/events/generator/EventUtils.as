package com.universalmind.cairngorm.events.generator
{
	import flash.events.Event;
	import mx.rpc.IResponder;
	import com.universalmind.cairngorm.events.UMEvent;
	import mx.utils.StringUtil;
	import com.universalmind.cairngorm.events.Callbacks;
		
	public class EventUtils {
		  public static function getResponderFor(event:Event):IResponder {
		  	var results : IResponder = null;
		  	if (event != null) {
			  	if (event is UMEvent) 						results = (event as UMEvent).callbacks;
			  	else if (event.hasOwnProperty("callbacks"))	results = event["callbacks"] as IResponder;
			  	else if (event.hasOwnProperty("responder")) results = event["responder"] as IResponder;
		  	}
		  	
		  	return results;
		  }
		  
		  public static function setEventHandlers(event:Event, result:Function, fault:Function = null):Boolean {
	  		var results : Boolean = false;
	  		if (isValidEvent(event)) {
	  			setResponderFor(event, new Callbacks(result,fault));
	  			results = true;
	  		}
	  		
	  		return results;
		  }
		  
		  public static function setResponderFor(event:Event, responder:IResponder):void {
		  	if (event != null) {
			  	if (event is UMEvent) 						(event as UMEvent).callbacks = responder;
			  	else if (event.hasOwnProperty("callbacks"))	event["callbacks"] 			 = responder;
			  	else if (event.hasOwnProperty("responder")) event["responder"]           = responder;
			}
		  }
		  
	      public static function isValidEvent(inst:Event, failFunc:Function = null):Boolean {
	      	var results : Boolean = false;
	      	
	       if (inst != null) { 							        
			  	if (inst is UMEvent) 					results = true;
			  	else {
				 	// CairngormEvent class type is required by the CairngormEventDispatcher
				  	if (inst.hasOwnProperty("callbacks"))		results = true;
				  	else if (inst.hasOwnProperty("responder"))  results = true;
			  	}
	       }
	       
			if ((results != true) && (failFunc != null)) {
			  	// We expect the Class to be an UMEvent or subclass only so responders back to the EventGenerator can be attached during construction
		  		var msg : String = "All event instances must  have a 'callbacks' or 'responder' IResponder property: {0} is an invalid class.";
		  			msg = StringUtil.substitute(msg,[inst.type]);
		  		
		  		failFunc(msg);
		  	}
		  	
		  	return results;
	      }
	}
}