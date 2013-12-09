package com.adams.dt.view.components.toDo
{
	import com.adams.swizdao.views.components.NativeList;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.IVisualElement;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.utils.ObjectUtil;
	
	import spark.events.RendererExistenceEvent;
	
	public class ToDoListComponent extends NativeList
	{
		private var _refreshList:IList;
		public function get refreshList():IList {
			return _refreshList;
		}
		public function set refreshList( value:IList ):void {
			_refreshList = value;
		}
		
		private var _newDataProvider:IList;
		public function get newDataProvider():IList {
			if( !_newDataProvider ) {
				_newDataProvider = new ArrayList();
			}
			return _newDataProvider;
		}
		public function set newDataProvider( value:IList ):void {
			_newDataProvider = value;
		}
		
		public function commitProvider( value:Boolean ):void {
			if( value ) {
				if( refreshList ) {
					refreshList.removeAll();
				}
				else {
					refreshList = new ArrayList();
				}
				for each( var obj:Object in dataProvider ) {
					checkProvider( obj );
				}
			}
			setProvider();
		}
		
		private function setProvider():void {
			var provider:ArrayCollection = new ArrayCollection();
			for( var i:int = 0; i < newDataProvider.length; i++ ) {
				provider.addItem( newDataProvider.getItemAt( i ) );
			}
			provider.refresh();
			dataProvider = provider;
			newDataProvider.removeAll();
		}
		
		private function checkProvider( item:Object ):void {
			for( var i:int = 0; i < newDataProvider.length; i++ ) {
				if( newDataProvider.getItemAt( i ).taskId == item.taskId ) {
					refreshList.addItem( newDataProvider.getItemAt( i ) );
					return;
				}
			}
		}
		
		public function ToDoListComponent()
		{
			super();
		}
		
		public function removeRefreshIndex( value:Object ):Boolean {
			if( refreshList && refreshList.getItemIndex( value ) == -1 ) {
				refreshList.addItem( value );
				return true;
			}
			return false;
		}
		
		public function getBackgroundColor( value:Object ):Boolean {
			if( refreshList && ( refreshList.getItemIndex( value ) == -1 ) ) {
				return true;
			}
			return false;
		}
	}
}