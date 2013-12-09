package com.adams.dt.event.mainView
{
	import flash.events.Event;
	
	public final class AlternateEvent extends Event
	{
		public static const DO_ALTERNATE : String = "makeAlternate";
		
		public function AlternateEvent( type : String , bubbles : Boolean = false , cancelable : Boolean = false )
		{
			super(type , bubbles , cancelable);
		}

		override public function clone() : Event
		{
			return new AlternateEvent( type , bubbles , cancelable );
		}
	}
}
