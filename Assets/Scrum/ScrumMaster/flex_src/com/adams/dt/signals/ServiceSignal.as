package com.adams.dt.signals
{
	import com.adams.dt.model.vo.IValueObject;
	
	import mx.collections.IList;
	
	import org.osflash.signals.Signal; 
	public class ServiceSignal extends Signal
	{ 
		public var action:String;
		public var valueObject:IValueObject;
		public var list:IList;  
		public var id:int;
		public var destination:String;
		public var name:String;
		public var receivers:Array;
		public var description:Object;
		
		public function ServiceSignal()
		{
			super();
		}
	}
}