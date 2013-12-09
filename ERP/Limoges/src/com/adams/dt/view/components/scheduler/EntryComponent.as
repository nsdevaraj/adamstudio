package com.adams.dt.view.components.scheduler
{
	import com.adams.dt.view.renderers.ProjectListRenderer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	
	public class EntryComponent extends UIComponent
	{
		
		private var _rows:Array;
		private var _items:ArrayCollection;
		
		protected var entryRenderer:IFactory;
		private var freeRenderers:Array;
		private var visibleRenderers:Dictionary;
		
		public function EntryComponent()
		{
			entryRenderer = new ClassFactory( ProjectListRenderer );	
			freeRenderers = [];
			visibleRenderers = new Dictionary();
		}
		
		private var _globalStart:Date;
		public function set globalStart( value:Date ):void {
			_globalStart = value;
		}
		
		private var _dataProvider:ArrayCollection;
		[Bindable]
		public function get dataProvider():ArrayCollection {
			return _dataProvider;
		} 	
		public function set dataProvider( value:ArrayCollection ):void {
			_dataProvider = value;
			createLayout();
		}
		
		private var _rowHeight:Number;
		public function set rowHeight( value:Number ):void {
			_rowHeight = value;
			if( dataProvider ) {
				setXYWidth();
			}
		}
		
		private var _rowsToShow:Number = 10;
		public function set rowsToShow( value:Number ):void {
			_rowsToShow = value;
		}
		
		private var _pixelTime:Number;
		public function set pixelTime( value:Number ):void {
			_pixelTime = value;
			if( dataProvider ) {
				setXYWidth();
			}
		}
		
		private var _startX:Number;
		public function set startX( value:Number ):void {
			_startX = value;
		}
		
		private var _endX:Number;
		public function set endX( value:Number ):void {
			_endX = value;
		}
		
		private var _startY:Number;
		public function set startY( value:Number ):void {
			_startY = value;
		}
		
		protected function createLayout():void {
			_rows = [];
			var length:Number = dataProvider.length;
			for( var i:int = 0; i < length; i++ ) {
				var row:Array = [];
				var item:Object = dataProvider.getItemAt( i );
				for( var j:int = 0; j < item.collection.length; j++ ) {
					var entryItem:Object = item.collection.getItemAt( j );
					addItemToRow( entryItem, i, row, item );
				}
				_rows[ i ] = row;
			}
		}
		
		private function addItemToRow( task:Object, rowIndex:Number, row:Array, item:Object ):void {
			var entry:Entry = new Entry();
			entry.rowIndex = rowIndex;
			entry.entryStart = task.startDate;
			entry.entryEnd = task.endDate;
			entry.entryLabel = task.label;
			entry.entryColor = task.backgroundColor;
			entry.entryObject = item.refObject;
			entry.entrySelectable = item.selectable;
			row.push( entry );
		}
		
		private function setXYWidth():void {
			for( var i:int = 0; i < _rows.length; i++ ) {
				var row:Array = _rows[ i ];
				for( var j:int = 0; j < row.length; j++ ) {
					var entry:Entry = row[ j ];
					entry.entryX = ( entry.entryStart.getTime() - _globalStart.getTime() ) / _pixelTime;
					entry.entryWidth = ( entry.entryEnd.getTime() - entry.entryStart.getTime() ) / _pixelTime;
					entry.entryY = entry.rowIndex * _rowHeight + 4;
					entry.entryHeight = _rowHeight - 7;
				}
			}
		}
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void {
			if( !isNaN( _startX ) ) {
				calculateItems();
			}
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		} 
		
		private function calculateItems() : void {
			var result:ArrayCollection = new ArrayCollection();
			var startRow:Number = Math.floor( _startY / _rowHeight );
			var lastRow:Number = startRow + _rowsToShow;
			if( lastRow >= _rows.length )  {
				lastRow = _rows.length - 1;
			}
			for( var rowIndex:Number = startRow; rowIndex <= lastRow; rowIndex++ ) {
				var row:Array = _rows[ rowIndex ];
				for each( var item:Entry in row ) {
					if( ( item.entryX < _endX ) && ( ( item.entryX + item.entryWidth ) >= _startX ) ) { 
						result.addItem( item );					
					}
				}	
			}
			_items = result;
			update();
		}
		
		public function update():void {
			var oldRenderers:Dictionary = visibleRenderers;
			visibleRenderers = new Dictionary();
			for each( var item:Entry in _items ) {
				var renderer:ProjectListRenderer = oldRenderers[ item ];
				if( renderer ) {
					renderer.x = item.entryX - _startX;
					renderer.y = item.entryY - _startY;
					renderer.width = item.entryWidth;
					renderer.height = item.entryHeight;
					renderer.prjLabel = item.entryLabel;
					renderer.backGroundColor = item.entryColor;
					renderer.refObject = item.entryObject;
					renderer.info = item.entryLabel +"\n" +item.entryStart.toString() + " - " + item.entryEnd.toString();
					renderer.isClickable = item.entrySelectable;
					renderer.addEventListener( "itemSelected", onItemSelected );
					delete oldRenderers[ item ];
				}
				else {
					renderer = getRenderer();
					renderer.x = item.entryX - _startX;
					renderer.y = item.entryY - _startY;
					renderer.width = item.entryWidth;
					renderer.height = item.entryHeight;
					renderer.prjLabel = item.entryLabel;
					renderer.backGroundColor = item.entryColor;
					renderer.refObject = item.entryObject;
					renderer.info = item.entryLabel +"\n" +item.entryStart.toString() + " - " + item.entryEnd.toString();
					renderer.isClickable = item.entrySelectable;
					renderer.addEventListener( "itemSelected", onItemSelected );
					addChild( renderer );
				}
				visibleRenderers[ item ] = renderer;
			}
			removeUnusedRenderers( oldRenderers );	
		}
		
		private function removeUnusedRenderers( oldRenderers:Dictionary ):void {
			for each( var freeRenderer:DisplayObject in oldRenderers ) {
				freeRenderers.push( removeChild( freeRenderer ) );
			}
		}
		
		private function getRenderer():ProjectListRenderer {
			if( freeRenderers.length > 0 ) {
				return freeRenderers.pop();
			}			
			return entryRenderer.newInstance();
		}
		
		private function onItemSelected( event:Event ):void {
			
		}
	}
}