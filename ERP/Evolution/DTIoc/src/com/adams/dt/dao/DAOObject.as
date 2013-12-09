package com.adams.dt.dao {
	
	import com.adams.dt.controls.DAOCommand;
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.utils.Action;
	
	public class DAOObject{
		
		private var _target:CRUDObject;
		private var _valueObject:IValueObject; 
		private var _service:ServiceObject;
		private var _createCommand:DAOCommand = new DAOCommand(Action.CREATE,DAOObject(this));
		private var _updateCommand:DAOCommand = new DAOCommand(Action.UPDATE,DAOObject(this));
		private var _readCommand:DAOCommand = new DAOCommand(Action.READ,DAOObject(this));
		private var _deleteCommand:DAOCommand = new DAOCommand(Action.DELETE,DAOObject(this));
		private var _countCommand:DAOCommand = new DAOCommand(Action.GET_COUNT,DAOObject(this));
		private var _getListCommand:DAOCommand = new DAOCommand(Action.GET_LIST,DAOObject(this));
		private var _bulkUpdateCommand:DAOCommand = new DAOCommand(Action.BULK_UPDATE,DAOObject(this));
		private var _deleteAllCommand:DAOCommand = new DAOCommand(Action.DELETE_ALL,DAOObject(this));
		
		[PostConstruct]
		public function DAOObject():void {
			
		}
		
		public function get target():CRUDObject {
			return _target;
		}
		
		public function set target( crud:CRUDObject ):void {
		 	_target = crud;
			_valueObject = crud.valueObject; 
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