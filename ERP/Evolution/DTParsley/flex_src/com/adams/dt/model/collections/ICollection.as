package com.adams.dt.model.collections
{
	import mx.collections.IList;
	
	public interface ICollection
	{
		function get items():IList;
		function addItems( items:IList ):void;
		function addItem( obj:Object ):int;
		function addItemAt( obj:Object, index:int ):void;
		function removeItem( obj:Object ):int;
		function removeItemAt( index:int ):Object;
	}
}