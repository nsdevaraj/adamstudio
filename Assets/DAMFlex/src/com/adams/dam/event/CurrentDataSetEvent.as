package com.adams.dam.event
{
	
	import com.adams.dam.model.vo.Categories;
	import com.adams.dam.model.vo.Persons;
	import com.adams.dam.model.vo.Projects;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	
	public final class CurrentDataSetEvent extends UMEvent
	{
		
		public static const EVENT_SET_PERSONS:String = 'setPersons';
		public static const EVENT_SET_DOMAIN:String = 'setDomain';
		public static const EVENT_SET_PROJECTS:String = 'setProjects';
		
		public var persons:Persons;
		public var domain:Categories;
		public var project:Projects;
		
		public function CurrentDataSetEvent( pType:String, handlers:IResponder = null, bubbles:Boolean = true, cancelable:Boolean = false, data:* = null )
		{
			super( pType, handlers, true, false, data );
		}
	}
}
