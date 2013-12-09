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
package com.adams.scrum.service
{
	import mx.messaging.Producer;
	import mx.messaging.events.MessageAckEvent;
	import mx.messaging.messages.IMessage;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class NativeProducer extends Producer
	{
		public var produceAttempt:NativeSignal;
		public function NativeProducer()
		{
			super();
			produceAttempt = new NativeSignal(this,'acknowledge',MessageAckEvent);
		}
		public function produceMessage(message:IMessage) : void
		{
			this.send(message);
		}	
	}
}