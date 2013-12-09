package com.adams.dt.signals
{ 
	import org.osflash.signals.Signal;
	
	public class ResultSignal extends Signal
	{
		public var destination:String;
		public var action:String; 
		public var description:Object; 
		public function ResultSignal()
		{
			super();
		}
	}
}