package com.adams.dt.controls
{
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
		private var _dao:DAOObject;
		private var _action:String;
		private var _valueObject:IValueObject;
		private var _oldValueObject:IValueObject;
		private var _list:IList;
		private var _id:int;
		
		[PostConstruct]
		public function DAOCommand(value:String = null,daovalue:DAOObject = null)
		{
			super();
			this.action = value;
			this.dao = daovalue;
		}
		
		
		public function get dao():DAOObject {
			return _dao;
		}
		
		public function set dao( value:DAOObject ):void {
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
			 		token = dao.target.create(valueObject);
			 	break;
				case Action.BULK_UPDATE:
					token = dao.target.bulkUpdate(list);
			 	break;
				case Action.DELETE:
					token = dao.target.deleteById(valueObject); 
			 	break;
				case Action.DELETE_ALL:
					token = dao.target.deleteAll();
			 	break;
				case Action.UPDATE:
					dao.target.oldValueObject = oldValueObject;
					token = dao.target.update(valueObject);
			 	break;
			 	case Action.GET_LIST:
			 		token = dao.target.getList();
			 	break;
			 	case Action.GET_COUNT:
			 		token = dao.target.count();
			 	break;
			 	case Action.READ:
			 		dao.target.oldValueObject = oldValueObject;
			 		token = dao.target.read( id );
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
			error("Error accessing server for: " + dao.target.valueObject.destination + ': '+event.message);
		}
	}
}