package com.adams.dt.dao {
	
	import com.adams.dt.controls.DAOCommand;
	import com.adams.dt.delegates.AbstractDelegate;
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.utils.Action;
	
	import mx.rpc.remoting.mxml.RemoteObject;
	
	public class DAOObject{ 
		private var _valueObject:IValueObject; 
		private var _createCommand:DAOCommand = new DAOCommand(Action.CREATE,CRUDObject(this));
		private var _updateCommand:DAOCommand = new DAOCommand(Action.UPDATE,CRUDObject(this));
		private var _readCommand:DAOCommand = new DAOCommand(Action.READ,CRUDObject(this));
		private var _deleteCommand:DAOCommand = new DAOCommand(Action.DELETE,CRUDObject(this));
		private var _countCommand:DAOCommand = new DAOCommand(Action.GET_COUNT,CRUDObject(this));
		private var _getListCommand:DAOCommand = new DAOCommand(Action.GET_LIST,CRUDObject(this));
		private var _bulkUpdateCommand:DAOCommand = new DAOCommand(Action.BULK_UPDATE,CRUDObject(this));
		private var _deleteAllCommand:DAOCommand = new DAOCommand(Action.DELETE_ALL,CRUDObject(this));
		
		
		[Inject(id="delegate")]
		public var delegate:AbstractDelegate;
		
		[Inject(id="_remoteService")]
		public var service:RemoteObject;
		
		[PostConstruct]
		public function DAOObject():void {
			
		}
		
		private var _destination:String;
		public function get destination():String {
			return _destination;
		}
		
		public function set destination( value:String ):void {
			_destination = value;
		}
		
		public function get valueObject():IValueObject {
			return _valueObject;
		}
		
		public function set valueObject( vo:IValueObject ):void {
			_valueObject = vo;
		}
		
		public function get createCommand():DAOCommand {
			return _createCommand;
		}
		
		public function set createCommand( value:DAOCommand ):void {
		 	_createCommand = value;
		}
		 
		public function get updateCommand():DAOCommand {
			return _updateCommand;
		}
		
		public function set updateCommand( value:DAOCommand ):void {
		 	_updateCommand = value;
		}  
		
		public function get readCommand():DAOCommand {
			return _readCommand;
		}
		
		public function set readCommand( value:DAOCommand ):void {
		 	_readCommand = value;
		}
		  
		public function get deleteCommand():DAOCommand {
			return _deleteCommand;
		}
		
		public function set deleteCommand( value:DAOCommand ):void {
		 	_deleteCommand = value;
		}  
		
		public function get countCommand():DAOCommand {
			return _countCommand;
		}
		
		public function set countCommand( value:DAOCommand ):void {
		 	_countCommand = value;
		}  
		
		public function get getListCommand():DAOCommand {
			return _getListCommand;
		}
		
		public function set getListCommand( value:DAOCommand ):void {
		 	_getListCommand = value;
		}  
		
		public function get bulkUpdateCommand():DAOCommand {
			return _bulkUpdateCommand;
		}
		
		public function set bulkUpdateCommand( value:DAOCommand ):void {
		 	_bulkUpdateCommand = value;
		} 
		 
		public function get deleteAllCommand():DAOCommand {
			return _deleteAllCommand;
		}
		
		public function set deleteAllCommand( value:DAOCommand ):void {
		 	_deleteAllCommand = value;
		}  
	}
}