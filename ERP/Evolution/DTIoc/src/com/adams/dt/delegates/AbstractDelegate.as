package com.adams.dt.delegates
{
	import com.adams.dt.events.ServiceEvent;
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.utils.Action;
	import com.adams.dt.utils.Destination;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import flash.events.EventDispatcher;
	[ManagedEvents("personCreate,personUpdate,personRead,personDelete,personCount,personFindAll,personBulkUpdate,personDeleteAll")]
	public class AbstractDelegate extends EventDispatcher
	{
		private var responder:IResponder = new AsyncResponder( resultHandler, faultHandler, token ) ;
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
		
		private var _valueObject:IValueObject;
		public function get valueObject():IValueObject {
			return _valueObject;
		}
		
		public function set valueObject( vo:IValueObject ):void { 
			_valueObject = vo;
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
		
		private function resultHandler( rpcevt:ResultEvent, token:Object = null ):void {
			switch( valueObject.destination	) {
				case Destination.PERSON_DESTINATION:
					changeCollection(Destination.PERSON_DESTINATION,rpcevt);
					break;
				default:
					break;	
			}
		}
		
		private function changeCollection(vo:String, rpcevt:ResultEvent):void {
			var event:ServiceEvent = new ServiceEvent(vo+operation);
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
					event.valueObject = valueObject;
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
			trace('dispatched ' + vo+operation);
			dispatchEvent(event);
		}
		
		private function faultHandler( event:FaultEvent, token:Object = null ):void {
				trace('failed'+event)
		}
	}
}