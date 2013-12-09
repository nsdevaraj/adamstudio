package com.adams.dt.event.fileManagement
{
	import com.adams.dt.model.vo.FileDetails;
	
	import flash.events.Event;
	
	public final class RemoveFileEvent extends Event
	{
		public static const DO_REMOVE:String = "removeItem";
		public static const DELETE_ITEM:String = "deleteItem";
		public static const SHOW_ITEM:String = "showItem";
		public static const RELEASE_DELETE:String = "deleteReleaseItem";
		public static const REPLACE_ITEM:String = "replaceItem";
		public static const REPLACE_RELEASE_ITEM:String = "replaceReleaseItem";
		
		public var doRemove:Boolean;
		public var fileItem:FileDetails;
		public var releaseContainer:Object;
		
		public function RemoveFileEvent( type:String, bubbles:Boolean = true, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}

	}
}
