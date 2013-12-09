package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.chatevent.ChatDBEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class ChartPeopleCommand extends AbstractCommand 
	{  
		private var chatDBEvent : ChatDBEvent;
		override public function execute( event : CairngormEvent ) : void
		{	
			super.execute(event);
			chatDBEvent = event as ChatDBEvent;  
			this.delegate = DelegateLocator.getInstance().chatDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){     
				case ChatDBEvent.EVENT_CREATE_CHAT:
					delegate.responder = new Callbacks(createChatListResult,fault);
					chatDBEvent.chat = ChatDBEvent( event ).chat;
					delegate.create(ChatDBEvent( event ).chat);
					break; 
				case ChatDBEvent.EVENT_BULK_UPDATE_CHAT:
					delegate.responder = new Callbacks(createChatListResult,fault);
					delegate.bulkUpdate(ChatDBEvent( event ).chatCollection);
					break;       
				case ChatDBEvent.EVENT_GET_ALL_CHATS :
					delegate.responder = new Callbacks(findByChatListResult,fault);
					delegate.findByChatListDelegate(model.chatvo);
					break; 
				case ChatDBEvent.EVENT_DELETEALL_CHAT :
					delegate.responder = new Callbacks(result,fault);
					delegate.deleteAll();
					break;  
				case ChatDBEvent.EVENT_GET_CHAT :
					delegate.responder = new Callbacks(findByProjectChatResult,fault);
					delegate.findProjectId(ChatDBEvent( event ).chatprojectId);
					break;    
				default:
					break; 
				}
		}
		public function findByProjectChatResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var arrcchat : ArrayCollection = rpcEvent.result as ArrayCollection;
			model.chatCollection = arrcchat;
		}
		public function findByChatListResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var arrcchat : ArrayCollection = rpcEvent.result as ArrayCollection;
			model.chatCollection = arrcchat;
		}
		public function createChatListResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_CREATE_EVENTS);
			var _events:Events = new Events();
			_events.eventDateStart = model.currentTime;
			_events.eventType = EventStatus.CHATCONVERSATION;
			_events.personFk = model.person.personId; 
			_events.projectFk = chatDBEvent.chat.projectFk;			
			var by:ByteArray = new ByteArray();			
			var str:String = 'Chat conversation';
			by.writeUTFBytes(str);
			_events.details = by;	
			_events.eventName = 'Chat';
			eEvent.events = _events;
			
			var handler:IResponder = new Callbacks(result,fault)
 			var chatSeq:SequenceGenerator = new SequenceGenerator([eEvent],handler)
  			chatSeq.dispatch(); 

		}			 
 	}
}
