package com.adams.dt.event.chatevent
{
	import com.adams.dt.model.vo.Chat;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class ChatDBEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_CHATS : String = 'getAllChat';
		public static const EVENT_GET_CHAT : String = 'getChat';
		public static const EVENT_CREATE_CHAT : String = 'createChat';
		public static const EVENT_UPDATE_CHAT : String = 'updateChat';
		public static const EVENT_BULK_UPDATE_CHAT : String = 'bulkUpdateChat';
		public static const EVENT_DELETE_CHAT : String = 'deleteChat';
		public static const EVENT_DELETEALL_CHAT : String = 'deleteAllChat';
		public static const EVENT_SELECT_CHAT : String = 'selectChat';
		public var chat : Chat;
		public var chatprojectId : int;
		public var chatCollection : ArrayCollection;
		public function ChatDBEvent (cType : String ,handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super(cType,handlers,true,false);
			super.data = chat;
		}
	}
}
