package com.adams.dt.event.chartpeople {

    import flash.events.Event;
	
	public class ShowMessageEvent extends Event {
		
		public static const SHOW_MESSAGE:String = "showMessage";
		
		public var messagePersonId:int;
		
		public function ShowMessageEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
        }
    }
}
