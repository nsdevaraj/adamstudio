package com.adams.dt.model.collections
{
	import com.adams.dt.model.vo.CurrentInstanceVO;
	import com.adams.dt.utils.ObjectUtil;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	[Bindable]
	public class AbstractCollection implements ICollection
	{
		 
		public function AbstractCollection():void{
		} 
		protected var _items:IList = new ArrayCollection();
		public function get items():IList {
			return _items;
		}
		
		public function set items(v:IList):void {
			_items=v;
		}
		 
		
		protected var _collection:IList = new ArrayCollection();
		
		public function get collection():IList {
			return _collection;
		}
		
		public function set collection(v:IList):void {
			_collection=v;
		}
		  
		private var _count:int;
		public function get count():int {
			return _count;
		}
		
		public function set count(v:int):void {
			_count=v;
		}
		public function removeAllItems():void{
			_items = new ArrayCollection();
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
		
		public function modifyItems(oldList:IList, newList:IList):void {
				for (var i:int=0; i<oldList.length; i++){
					modifyItem(oldList.getItemAt(i), newList.getItemAt(i))
				}
		}
		
	}
}