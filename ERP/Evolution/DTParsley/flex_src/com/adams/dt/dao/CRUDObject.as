package com.adams.dt.dao 
{
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.utils.Action;
	
	import mx.collections.IList;
	import mx.rpc.AsyncToken;
	
	public class CRUDObject extends DAOObject implements ICrud 
	{
		private var _valueObject:IValueObject;
		private var _oldList:IList;
		private var _oldValueObject:IValueObject;
		
		[PostConstruct]
		public function CRUDObject():void { 
		
		}
		  
		public function get oldValueObject():IValueObject {
			return _oldValueObject;
		}
		
		public function set oldValueObject( vo:IValueObject ):void {
			_oldValueObject = vo;
			delegate.oldValueObject = vo;
		}
		
		public function get oldList():IList {
			return _oldList;
		}
		
		public function set oldList( value:IList ):void {
			_oldList = value;
			delegate.oldList = value;
		}
		
		public function invoke(action:String):void{
			service.destination = destination;
			delegate.destination = destination;
			delegate.operation = action
		}
		
		public function create( vo:IValueObject ):AsyncToken {
			invoke(Action.CREATE);
			delegate.token = service.create();
			return delegate.token;
		}
		
		public function update( vo:IValueObject ):AsyncToken {
			invoke(Action.UPDATE);
			delegate.token = service.update(vo);
			return delegate.token;
		}
		
		public function read( id:int ):AsyncToken {
			invoke(Action.READ);
			delegate.token = service.read( id );
			return delegate.token;
		}
		
		public function deleteById( vo:IValueObject ):AsyncToken {
			invoke(Action.DELETE);
			delegate.token = service.deleteById( vo );
			return delegate.token;
		}
		
		public function count():AsyncToken {
			invoke(Action.GET_COUNT);
			delegate.token = service.count();
			return delegate.token;
		}
		
		public function getList():AsyncToken {
			invoke(Action.GET_LIST);
			delegate.token = service.getList();
			return delegate.token;
		}
		
		public function bulkUpdate( list:IList ):AsyncToken {
			invoke(Action.BULK_UPDATE);
			delegate.token = service.bulkUpdate(list);
			return delegate.token;
		}
		
		public function deleteAll():AsyncToken {
			invoke(Action.DELETE_ALL);
			delegate.token = service.deleteAll();
			return delegate.token;
		}
	}
}