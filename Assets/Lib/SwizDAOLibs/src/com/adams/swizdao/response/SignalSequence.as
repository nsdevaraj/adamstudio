/*
* Copyright 2010 @nsdevaraj
* 
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License. You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*/
package com.adams.swizdao.response
{
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.signals.AbstractSignal;
	import com.adams.swizdao.util.ArrayUtil;
	
	public class SignalSequence 
	{       
		[Inject]
		public var serviceSignal:AbstractSignal;
		
		[Inject]
		public var currentInstance:CurrentInstance;
		private var serviceInProcess:Boolean;
		private var signal:SignalVO;
		private var events:Array = [];  
		
		public function addSignal( signal:SignalVO ):void { 
			events.push( signal );
			if( !serviceInProcess ) {
				onSignalDone();
			} 
		}
		
		private function dispatchNextSignal():void {
			signal  = events[ 0 ] as SignalVO;
			serviceSignal.currentSignal = signal;
			serviceSignal.currentCollection = signal.collection;
			serviceSignal.currentProcessor = signal.processor;
			var dest:String = signal.destination.substring(0,30);
			var act:String = signal.action.substring(0,30);
			trace(dest +'\t\t\t' +act +'\t\t\t'+new Date())
			currentInstance.waitingForServerResponse = true;
			serviceSignal.dispatch( signal );
			ArrayUtil.removeElementAt( 0, events );
		}  
		
		public function onSignalDone():void { 
			if( events.length > 0 ) {
				dispatchNextSignal();
				if(!signal.performed){
					serviceInProcess = true;
				}else{
					serviceInProcess = false;
				}
				return;      			
			}
			else {
				serviceInProcess = false;
			}
		} 
	}
}