package com.adams.dt.signals
{

	import com.adams.dt.model.vo.SignalVO;
	import com.adams.dt.utils.ArrayUtil;			
   public class SignalSequence 
   {       
   	  private var events:Array = [];  
   	  
   	  [Inject]
	  public var serviceSignal:ServiceSignal;
	  
	  public var serviceInProcess:Boolean;
	  
      public function SignalSequence():void {
      }
      
      public function addSignal(signal:SignalVO):void { 
      	 events.push(signal);
      	 if(!serviceInProcess){
      	 	onSignalDone();
      	 	serviceInProcess = true;
      	 } 
      }
       
      private function dispatchNextSignal():void {
      	if(events.length>0){
      		var signal:SignalVO = events[0] as SignalVO;
       	 	serviceSignal.action = signal.action;
      	 	serviceSignal.destination = signal.destination;
      	 	serviceSignal.id = signal.id;
      	 	serviceSignal.valueObject = signal.valueObject;
      	 	serviceSignal.list = signal.List;
      	 	serviceSignal.name = signal.name;
      	 	serviceSignal.description = signal.description;
			serviceSignal.receivers = signal.receivers;
      	 	serviceSignal.dispatch();
      		ArrayUtil.removeElementAt(0,events);
      	}
      }  
      
      public function onSignalDone():void { 
  		if (events.length>0) {
      		dispatchNextSignal();
      		return;      			
  		}else{
  			serviceInProcess = false;
  		}
      } 
  }
}