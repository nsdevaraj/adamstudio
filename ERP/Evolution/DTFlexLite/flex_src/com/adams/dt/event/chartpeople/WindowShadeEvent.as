package com.adams.dt.event.chartpeople {

    import flash.events.Event;
	import flash.events.TextEvent;
	
	public class WindowShadeEvent extends Event {
		public static const OPENED_CHANGED:String = "openedChanged";
		public static const OPEN_BEGIN:String = "openBegin";
		public static const OPEN_END:String = "openEnd";
		public static const CLOSE_BEGIN:String = "closeBegin";
		public static const CLOSE_END:String = "closeEnd";
		
		public function WindowShadeEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
        }
    }
}
