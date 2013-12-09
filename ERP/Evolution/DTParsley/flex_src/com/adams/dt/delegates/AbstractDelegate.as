package com.adams.dt.delegates
{
	import com.adams.dt.events.ServiceEvent;
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.utils.Action;
	import com.adams.dt.utils.Destination;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	[ManagedEvents("Create,Update,Read,Delete,Count,FindAll,BulkUpdate,DeleteAll")]
	public class AbstractDelegate extends EventDispatcher
	{
		private var responder:IResponder = new AsyncResponder( resultHandler, faultHandler, token ) ;
		
		[PostConstruct]
		public function AbstractDelegate()
		{
			//flash.events.EventDispatcher;
		}
		private var _oldList:IList;
		private var _token:AsyncToken = new AsyncToken();
		public function get token():AsyncToken {
			return _token;
		}
		
		public function set token( value:AsyncToken ):void {
			_token = value;
			_token.addResponder( responder );
		} 
		
		private var _oldValueObject:IValueObject;
		public function get oldValueObject():IValueObject {
			return _oldValueObject;
		}
		
		public function set oldValueObject( vo:IValueObject ):void { 
			_oldValueObject = vo;
		}
		
		public function get oldList():IList {
			return _oldList;
		}
		
		public function set oldList( value:IList ):void {
			_oldList = value;
		}
		
		private var _operation:String;
		public function get operation():String {
			return _operation;
		}
		
		public function set operation( value:String ):void { 
			_operation = value;
		}
		
				
		private var _destination:String;
		public function get destination():String {
			return _destination;
		}
		public function set destination( value:String ):void {
			_destination = value;
		}

		private function resultHandler( rpcevt:ResultEvent, token:Object = null ):void { 
			var event:ServiceEvent = new ServiceEvent(operation);
			event.destination = destination;
			switch( operation ) {
				case Action.GET_LIST: 
					event.list = rpcevt.result as ArrayCollection;
				break;		
				case Action.GET_COUNT:
					event.count = rpcevt.result as int;
				break;
				case Action.READ:
					event.oldValueObject = oldValueObject;
					event.valueObject = rpcevt.result as IValueObject;
				break;
				case Action.CREATE:
					event.valueObject = rpcevt.result as IValueObject;
				break;
				case Action.BULK_UPDATE:
					event.oldList = oldList;
					event.list = rpcevt.result as IList;
				break;
				case Action.DELETE:
					event.valueObject = oldValueObject;
				break;
				case Action.DELETE_ALL:
				break;
				case Action.UPDATE:
					event.oldValueObject = oldValueObject;
					event.valueObject = rpcevt.result as IValueObject;
				break;
				default:
				break;	
			}
			trace('dispatched ' + operation+ ' '+destination);
			dispatchEvent(event);
		}
		
		private function faultHandler( event:FaultEvent, token:Object = null ):void {
				trace('failed'+event)
		}
	}
}