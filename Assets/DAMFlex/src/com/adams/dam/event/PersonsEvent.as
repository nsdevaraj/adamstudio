package com.adams.dam.event
{
	
	import com.adams.dam.model.vo.Persons;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	
	public final class PersonsEvent extends UMEvent
	{
		
		public static const EVENT_GET_ALL_PERSONS:String = 'getAllPersons';
		
		public var persons:Persons;
		
		public function PersonsEvent( pType:String, handlers:IResponder = null, bubbles:Boolean = true, cancelable:Boolean = false, pPersons:Persons = null )
		{
			persons = pPersons;
			super( pType, handlers, true, false, persons );
		}
	}
}
