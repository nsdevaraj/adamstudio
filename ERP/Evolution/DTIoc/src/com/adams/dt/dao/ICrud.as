package com.adams.dt.dao {
	
	import com.adams.dt.model.vo.IValueObject;
	
	import mx.collections.IList;
	import mx.rpc.AsyncToken;
	public interface ICrud {
		function get valueObject():IValueObject;
		function set valueObject( vo:IValueObject ):void;
		function create( vo:IValueObject ): AsyncToken;
		function update( vo:IValueObject ): AsyncToken;
		function deleteById( vo:IValueObject ): AsyncToken;
		function deleteAll():AsyncToken;
		function count():AsyncToken;
		function getList():AsyncToken;
		function bulkUpdate( list:IList ):AsyncToken;
		function read( id:int ):AsyncToken;
	}
}