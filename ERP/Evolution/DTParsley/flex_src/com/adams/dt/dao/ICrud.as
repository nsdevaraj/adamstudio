package com.adams.dt.dao {
	
	import com.adams.dt.controls.DAOCommand;
	import com.adams.dt.model.vo.IValueObject;
	
	import mx.collections.IList;
	import mx.rpc.AsyncToken;
	public interface ICrud {
		function get valueObject():IValueObject;
		function set valueObject( vo:IValueObject ):void;
		function get oldValueObject():IValueObject;
		function set oldValueObject( vo:IValueObject ):void;
		function get destination():String;
		function set destination( value:String):void;
		function get oldList():IList;
		function set oldList( list:IList ):void;
		function create( vo:IValueObject ): AsyncToken;
		function update( vo:IValueObject ): AsyncToken;
		function deleteById( vo:IValueObject ): AsyncToken;
		function deleteAll():AsyncToken;
		function count():AsyncToken;
		function getList():AsyncToken;
		function bulkUpdate( list:IList ):AsyncToken;
		function read( id:int ):AsyncToken;
		function set createCommand(value:DAOCommand):void; 
		function set updateCommand(value:DAOCommand):void; 
		function set readCommand(value:DAOCommand):void; 
		function set deleteCommand(value:DAOCommand):void; 
		function set countCommand(value:DAOCommand):void;  
		function set getListCommand(value:DAOCommand):void;  
		function set bulkUpdateCommand(value:DAOCommand):void;
		function set deleteAllCommand(value:DAOCommand):void; 
		function get createCommand():DAOCommand; 
		function get updateCommand():DAOCommand; 
		function get readCommand():DAOCommand; 
		function get deleteCommand():DAOCommand; 
		function get countCommand():DAOCommand;  
		function get getListCommand():DAOCommand;  
		function get bulkUpdateCommand():DAOCommand;
		function get deleteAllCommand():DAOCommand; 
	}
}