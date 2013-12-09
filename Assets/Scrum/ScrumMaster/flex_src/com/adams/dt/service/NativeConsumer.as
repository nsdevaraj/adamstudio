package com.adams.dt.service
{
	import mx.messaging.Consumer;
	import mx.messaging.events.MessageEvent;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class NativeConsumer extends Consumer
	{
		public var consumeAttempt:NativeSignal;
		public function NativeConsumer(messageType:String="flex.messaging.messages.AsyncMessage")
		{
			super(messageType);
			consumeAttempt = new NativeSignal(this,'message',MessageEvent);
		}
	}
}