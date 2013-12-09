package com.adams.dt.event
{
	import com.adams.dt.model.vo.Sprints;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public class SprintsEvent extends UMEvent
	{
		public static const EVENT_BULK_UPDATE_SPRINTS : String = 'BulkUpdateSprints';
		
		public var sprints:Sprints;
		public var updateCollection:ArrayCollection;
		
		public function SprintsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, sSprints : Sprints = null )
		{
			sprints = sSprints;
			super( pType, handlers, true, false, sprints );
		}

	}
}