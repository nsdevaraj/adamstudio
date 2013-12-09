package com.universalmind.cairngorm.events.generator
{
	import com.universalmind.cairngorm.events.Callbacks;
	import mx.rpc.IResponder;
	
	public interface IEventGenerator
	{
		function dispatch(handlers:IResponder = null) : void;
	}
}