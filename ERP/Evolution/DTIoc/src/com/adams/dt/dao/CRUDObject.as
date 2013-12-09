package com.adams.dt.dao 
{
	import com.adams.dt.delegates.AbstractDelegate;
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.utils.Action;
	
	import mx.collections.IList;
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	public class CRUDObject implements ICrud 
	{
		private var _valueObject:IValueObject;
		private var _oldList:IList;
		private var _oldValueObject:IValueObject;
		
		[Inject(id="_remoteService")]
		public var service:RemoteObject;
		
		[Inject(id="delegate")]
		public var delegate:AbstractDelegate;
		
		[PostConstruct]
		public function CRUDObject():void { 
		
		}
		
		[Bindable]
		public function get valueObject():IValueObject {
			return _valueObject;
		}
		
		public function set valueObject( vo:IValueObject ):void {
			_valueObject = vo
			service.destination = vo.destination;
			delegate.valueObject = vo;
		}
		
		[Bindable]
		public function get oldValueObject():IValueObject {
			return _oldValueObject;
		}
		
		public function set oldValueObject( vo:IValueObject ):void {
			_oldValueObject = vo;
			delegate.oldValueObject = vo;
		}
		
		
		[Bindable]
		public function get oldList():IList {
			return _oldList;
		}
		
		public function set oldList( value:IList ):void {
			_oldList = value;
			delegate.oldList = value;
		}
		
		public function create( vo:IValueObject ):AsyncToken {
			delegate.operation = Action.CREATE;
			delegate.token = service.create();
			return delegate.token;
		}
		
		public function update( vo:IValueObject ):AsyncToken {
			delegate.operation = Action.UPDATE;
			delegate.token = service.update(vo);
			return delegate.token;
		}
		
		public function read( id:int ):AsyncToken {
			delegate.operation = Action.READ;
			delegate.token = service.read( id );
			return delegate.token;
		}
		
		public function deleteById( vo:IValueObject ):AsyncToken {
			delegate.operation = Action.DELETE;
			delegate.token = service.deleteById( vo );
			return delegate.token;
		}
		
		public function count():AsyncToken {
			delegate.operation = Action.GET_COUNT;
			delegate.token = service.count();
			return delegate.token;
		}
		
		public function getList():AsyncToken {
			delegate.operation = Action.GET_LIST;
			delegate.token = service.getList();
			return delegate.token;
		}
		
		public function bulkUpdate( list:IList ):AsyncToken {
			delegate.operation = Action.BULK_UPDATE;
			delegate.token = service.bulkUpdate(list);
			return delegate.token;
		}
		
		public function deleteAll():AsyncToken {
			delegate.operation = Action.DELETE_ALL;
			delegate.token = service.deleteAll();
			return delegate.token;
		}
	}
}