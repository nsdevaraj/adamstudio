package com.adams.dt.controls
{
	import com.adams.dt.dao.CRUDObject;
	import com.adams.dt.dao.DAOObject;
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.utils.Action;
	
	import mx.collections.IList;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.spicefactory.lib.task.Task;

	public class DAOCommand extends Task
	{
		private var _dao:CRUDObject;
		private var _action:String;
		private var _valueObject:IValueObject;
		private var _oldValueObject:IValueObject;
		private var _oldList:IList;
		private var _list:IList;
		private var _id:int;
		
		[PostConstruct]
		public function DAOCommand(value:String = null,daovalue:CRUDObject = null)
		{
			super();
			this.action = value;
			this.dao = daovalue;
		}
		
		
		public function get dao():CRUDObject {
			return _dao;
		}
		
		public function set dao( value:CRUDObject ):void {
		 	_dao = value; 
		} 
		
		
		public function get action():String {
			return _action;
		}
		
		public function set action( value:String ):void {
		 	_action = value; 
		} 
		
		public function get valueObject():IValueObject {
			return _valueObject;
		}
		
		public function set valueObject( vo:IValueObject ):void {
		 	_valueObject = vo; 
		}
		
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
		public function get list():IList {
			return _list;
		}
		
		public function set list( value:IList ):void {
		 	_list = value; 
		}
		
		public function get id():int {
			return _id;
		}
		
		public function set id( value:int ):void {
		 	_id = value; 
		}
		
		override protected function doStart():void {
			var token:AsyncToken; 
			trace(action + ' action')
			 switch( action ) {
			 	case Action.CREATE:
			 		token = dao.create(valueObject);
			 	break;
				case Action.BULK_UPDATE:
					dao.oldList = oldList;
					token = dao.bulkUpdate(list);
			 	break;
				case Action.DELETE:
					token = dao.deleteById(valueObject); 
			 	break;
				case Action.DELETE_ALL:
					token = dao.deleteAll();
			 	break;
				case Action.UPDATE:
					dao.oldValueObject = oldValueObject;
					token = dao.update(valueObject);
			 	break;
			 	case Action.GET_LIST:
			 		token = dao.getList();
			 	break;
			 	case Action.GET_COUNT:
			 		token = dao.count();
			 	break;
			 	case Action.READ:
			 		dao.oldValueObject = oldValueObject;
			 		token = dao.read( id );
			 	break;
			 	default:
			 	break;	 
			 }
			 token.addResponder( new AsyncResponder( resultHandler, faultHandler,token )  );
		}
		
		private function resultHandler( rpcevt:ResultEvent, token:Object =null ):void {
			trace('COMPLETE');
			complete(); 
		}
		
		private function faultHandler( event:FaultEvent,token:Object = null ):void{
			error("Error accessing server for: " + dao.destination + ': '+event.message);
		}
	}
}