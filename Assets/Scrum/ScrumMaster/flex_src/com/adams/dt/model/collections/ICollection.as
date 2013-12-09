package com.adams.dt.model.collections
{
	import com.adams.dt.model.vo.CurrentInstanceVO;
	
	import mx.collections.IList;

	[Bindable]
	public interface ICollection
	{
		 function get items():IList; 
		 function set items(v:IList):void;
		 function get collection():IList; 
		 function set collection(v:IList):void; 
		 function get count():int;
		 function set count(v:int):void;
		 function addItem( obj:Object ):int;
		 function addItemAt( obj:Object, index:int ):void;
 		 function removeItem( obj:Object ):int;
 		 function removeAllItems():void;
 		 function removeItemAt( index:int ):Object;
 		 function modifyItem(oldValueObject:Object, newValueObject:Object):void;
 		 function modifyItems(oldList:IList, newList:IList):void; 
	}
}