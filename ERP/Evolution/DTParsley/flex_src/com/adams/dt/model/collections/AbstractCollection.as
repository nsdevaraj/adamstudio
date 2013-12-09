package com.adams.dt.model.collections
{
	import com.adams.dt.events.ServiceEvent;
	import com.adams.dt.utils.ObjectUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	[Event(name="itemsChange", type="flash.events.Event")]
	public class AbstractCollection extends EventDispatcher implements ICollection
	{
		public static const ITEMS_CHANGE:String = "itemsChange";
		
		[PostConstruct]
		public function AbstractCollection():void{
			super();
		}
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
		
		public function modifyItems(oldList:IList, newList:IList):void {
				for (var i:int=0; i<oldList.length; i++){
					modifyItem(oldList.getItemAt(i), newList.getItemAt(i))
				}
		}
		
		private var _destination:String;
		public function get destination():String {
			return _destination;
		}
		
		public function set destination( value:String ):void {
			_destination = value;
		}
		
		
		
		[MessageHandler(selector="FindAll")] 
		public function findAllResult(event:ServiceEvent ):void {
			if(event.destination == this.destination) addItems(event.list);
		}
		
		[MessageHandler(selector="Count")] 
		public function countResult(event:ServiceEvent ):void {
			if(event.destination == this.destination) trace(event.count+' '+ event.type);			
		}
		
		[MessageHandler(selector="Create")]
		public function createResult(event:ServiceEvent ):void {
			if(event.destination == this.destination) addItem(event.valueObject);			
		}

		[MessageHandler(selector="DeleteAll")]
		public function deleteAllResult(event:ServiceEvent ):void {
			if(event.destination == this.destination) items.removeAll();			
		}
		
		[MessageHandler(selector="Delete")]
		public function deleteResult(event:ServiceEvent ):void {
			if(event.destination == this.destination) items.removeItemAt(items.getItemIndex(event.valueObject)); 
		}
		
		[MessageHandler(selector="Update")]
		public function updateResult(event:ServiceEvent ):void {
			if(event.destination == this.destination) {
				if(event.oldValueObject!=null){
					modifyItem( event.oldValueObject, event.valueObject );
				}else{
					addItem(event.valueObject);
				}
			}
		}
		
		[MessageHandler(selector="Read")] 
		public function readResult(event:ServiceEvent ):void {
			if(event.destination == this.destination){
				if(event.oldValueObject!=null){
					modifyItem( event.oldValueObject, event.valueObject );
				}else{
					addItem(event.valueObject);
				}
			}
		}
		
		[MessageHandler(selector="BulkUpdate")]
		public function bulkUpdateResult(event:ServiceEvent ):void {
			if(event.destination == this.destination){
				if(event.oldList!=null){
					modifyItems( event.oldList, event.list );
				}else{
					addItems(event.list);
				}
			}			
		}
	}
}