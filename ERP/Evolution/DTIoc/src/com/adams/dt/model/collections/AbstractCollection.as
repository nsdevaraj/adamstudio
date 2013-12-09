package com.adams.dt.model.collections
{
	import com.adams.dt.utils.ObjectUtil;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="itemsChange", type="flash.events.Event")]
	public class AbstractCollection extends EventDispatcher implements ICollection
	{
		public static const ITEMS_CHANGE:String = "itemsChange";
		
		private var _items:IList = new ArrayCollection();
		//flash.events.EventDispatcher
		[Bindable("itemsChange")]
		public function get items():IList {
			return _items;
		}
		
		public function addItems( items:IList ):void {
			_items = items;
			dispatchEvent( new Event( ITEMS_CHANGE ) );
		}
		
		public function addItem( obj:Object ):int {
			var index:int = -1;
			if ( items.getItemIndex( obj ) == -1 ) {
				items.addItem( obj );
				index = items.length - 1;
			}
			return index;
		}
		
		public function addItemAt( obj:Object, index:int ):void {
			items.addItemAt( obj, index );
		}
		
		public function removeItem( obj:Object ):int {
			var index:int = items.getItemIndex( obj );
			if ( index != -1 ) {
				items.removeItemAt( index );
			}
			return index;
		}
		
		public function removeItemAt( index:int ):Object {
			return items.removeItemAt( index );
		}
		
		public function modifyItem(oldValueObject:Object, newValueObject:Object):void {
				var propArr:Array = ObjectUtil.getPropNames(oldValueObject);
				for each(var str:String in propArr){ 
					oldValueObject[str] =newValueObject[str] 
				}
				items.itemUpdated( oldValueObject );
		}
	}
}