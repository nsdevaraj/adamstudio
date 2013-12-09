package com.adams.dt.event.mainView
{
	import flash.events.Event;
	
	public final class InitialCallEvent extends Event
	{
		public static const INITIAL_CALL : String = "initialCall";
		
		public var propertyName:String;
		
		public function InitialCallEvent( type : String , bubbles : Boolean = false , cancelable : Boolean = false )
		{
			super(type , bubbles , cancelable);
		}

		override public function clone() : Event
		{
			return new InitialCallEvent( type , bubbles , cancelable );
		}
	}
}
