package com.adams.dt.view.scheduler.mainViews
{
	import com.adams.dt.event.scheduler.CurrentProjectEvent;
	import com.adams.dt.model.scheduler.Entry;
	import com.adams.dt.view.scheduler.renderers.ProjectListRenderer;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	
	public class ListComponent extends UIComponent
	{
		
		private var _rows:Array;
		private var _items:ArrayCollection;
		
		protected var borderBox:Shape;
		
		protected var entryRenderer:IFactory;
		private var freeRenderers:Array;
		private var visibleRenderers:Dictionary;
		
		private var _dataChanged:Boolean;
		private var _rowHeightChanged:Boolean;
		private var _rowsToShowChanged:Boolean;
		private var _vertcalScrollChanged:Boolean;
	
		public function ListComponent()
		{
			entryRenderer = new ClassFactory( ProjectListRenderer );	
			freeRenderers = [];
			visibleRenderers = new Dictionary();
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
		
		private var _rowsToShow:Number;
		public function set rowsToShow( value:Number ):void {
			_rowsToShow = value;
		}
		
		private var _verticalScroll:Number;
		public function set verticalScroll( value:Number ):void {
			_verticalScroll = value;
			invalidateDisplayList();
		}
		
		override protected function createChildren():void {
			if( !borderBox ) {
				borderBox = new Shape();
				addChild( borderBox );
			}
		}
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number):void {
			if( dataProvider && !isNaN( _rowHeight ) && !isNaN( _rowsToShow ) && !isNaN( _verticalScroll ) ) {
				height = _rowsToShow * _rowHeight;
				calculateItems();
				if( borderBox ) {
					borderBox.graphics.clear();
					borderBox.graphics.lineStyle( 2, 0x959494, 1 );
					borderBox.graphics.moveTo( width, 0 );
					borderBox.graphics.lineTo( 0, 0 );
					borderBox.graphics.moveTo( width, 0 );
					borderBox.graphics.lineTo( width, height );
					borderBox.graphics.moveTo( width, height );
					borderBox.graphics.lineTo( 0, height ); 
					borderBox.graphics.moveTo( 0, height );
					borderBox.graphics.lineTo( 0, 0 ); 
				}
			}
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		}
		
		protected function createLayout():void {
			_rows = [];
			var length:Number = dataProvider.length;
			for( var i:int = 0; i < length; i++ ) {
				var item:Object = dataProvider.getItemAt( i );
				var entry:Entry = new Entry();
				entry.rowIndex = i;
				entry.entryLabel = item.projectName;
				entry.entrySelectable = item.selectable;
				_rows[ i ] = entry;
			}
			if( !isNaN( _rowHeight ) ) {
				setXYWidth();
			}
		}
		
		private function setXYWidth():void {
			for( var i:int = 0; i < _rows.length; i++ ) {
				var entry:Entry = _rows[ i ];
				entry.entryX = 0;
				entry.entryY = i * _rowHeight;
				entry.entryHeight = _rowHeight;
			}
		}
		
		private function calculateItems() : void {
			var result:ArrayCollection = new ArrayCollection();
			var startRow:Number = Math.floor( _verticalScroll / _rowHeight );
			var endRow:Number = startRow + _rowsToShow;
			if( endRow >= _rows.length )  {
				endRow = _rows.length - 1;
			}
			for( var rowIndex:Number = startRow; rowIndex <= endRow; rowIndex++ ) {
				var entry:Entry = _rows[ rowIndex ];
				result.addItem( entry );					
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
					renderer.x = item.entryX;
					renderer.y = item.entryY - _verticalScroll;
					renderer.width = width;
					renderer.height = item.entryHeight;
					renderer.prjLabel = item.entryLabel;
					renderer.info = item.entryLabel;
					renderer.isClickable = item.entrySelectable;
					renderer.addEventListener( "itemSelected", onItemSelected );
					delete oldRenderers[ item ];
				}
				else {
					renderer = getRenderer();
					renderer.x = item.entryX;
					renderer.y = item.entryY - _verticalScroll;
					renderer.width = width;
					renderer.height = item.entryHeight;
					renderer.prjLabel = item.entryLabel;
					renderer.info = item.entryLabel;
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
			var currentProjectevent:CurrentProjectEvent = new CurrentProjectEvent( CurrentProjectEvent.GOTO_CURRENTPROJECT );
			currentProjectevent.projectName = event.currentTarget.prjLabel;
			CairngormEventDispatcher.getInstance().dispatchEvent( currentProjectevent );
		}
	}
}