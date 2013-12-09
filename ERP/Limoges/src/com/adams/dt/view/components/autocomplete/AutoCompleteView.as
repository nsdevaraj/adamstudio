package com.adams.dt.view.components.autocomplete
{
	import com.adams.dt.util.Utils;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.List;
	import mx.events.FlexMouseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
	import org.osflash.signals.Signal;
	
	import spark.components.Button;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class AutoCompleteView extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var input:TextInput;
		
		[SkinPart(required="true")]
		public var openBtn:Button;
		
		private var allField:String = 'All';
		
		private var suggestionsList:List;
		
		private var _scrollIndex:int = -1;
		private var _suggestionsProvider:Array;
		private var _textChanged:Boolean;
		public var selectedSignal:Signal = new Signal();
		private var _comboVisible:Boolean;
		[Bindable]
		public function get comboVisible():Boolean {
			return _comboVisible;
		}
		public function set comboVisible( value:Boolean ):void {
			_comboVisible = value;
		}
		
		private var _specificText:String = '';
		[Bindable]
		public function get specificText():String {
			return _specificText;
		}
		public function set specificText( value:String ):void {
			_specificText = value;
			if( input && !_textChanged ) {
				input.text = value;
			}
			else if( _textChanged ) {
				_textChanged = false;
			}
		}
		
		private var _selectedItem:Object;
		[Bindable]
		public function get selectedItem():Object {
			return _selectedItem;
		}
		public function set selectedItem( value:Object ):void {
			_selectedItem = value;
			if( value && labelField && ( labelField != allField ) ) {
				if( value.hasOwnProperty( labelField ) ) {
					specificText = value[ labelField ];
				}
				else {
					specificText = Utils.reportLabelFuction( value, labelField );
				}
				selectedIndex = dataProvider.getItemIndex( value );
			}
		}
		
		private var _selectedIndex:int = -1;
		[Bindable]
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex( value:int ):void {
			_selectedIndex = value;
			if( dataProvider && ( value != -1 ) ) {
				selectedItem = dataProvider.getItemAt( value );
			}
		}
		
		private var _dataProvider:ArrayCollection;
		[Bindable]
		public function get dataProvider():ArrayCollection {
			return _dataProvider;
		}
		public function set dataProvider( value:ArrayCollection ):void {
			_dataProvider = value;
			if( value && ( selectedIndex != -1 ) ) {
				selectedItem = value.getItemAt( selectedIndex );
			}
			updateDataProvider();
		}
		
		private var _nameProperty:IList;
		[Bindable]
		public function get nameProperty():IList {
			return _nameProperty;
		}
		public function set nameProperty( value:IList ):void {
			_nameProperty = value;
		}
		
		private var _labelField:String;
		[Bindable]
		public function get labelField():String {
			return _labelField;
		} 
		public function set labelField( value:String ):void {
			_labelField = value;
			updateDataProvider();
		}
		
		public function AutoCompleteView()
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( event:Event ):void {
			onSuggestionClose();
		}
		
		override protected function partAdded( partName:String, instance:Object ):void {
			super.partAdded( partName, instance );
			
			if( instance == input ) {
				input.addEventListener( Event.CHANGE, onTextInputChange, false, 0, true );
				input.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true );
				input.text = specificText;
			}
			if( instance == openBtn ) {
				openBtn.addEventListener( MouseEvent.CLICK, openList, false, 0, true );
			}	
		}
		
		override protected function partRemoved( partName:String, instance:Object ):void {
			super.partRemoved( partName, instance );
			
			if( instance == input ) {
				input.removeEventListener( Event.CHANGE, onTextInputChange );
				input.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			}
			if( instance == openBtn ) {
				openBtn.removeEventListener( MouseEvent.CLICK, openList );
			}	
		}
		
		protected function openList( event:MouseEvent ):void {
			updateDataProvider( true );
		}
		
		protected function onTextInputChange( event:Event ):void {
			_textChanged = true;
			specificText = input.text;
			updateDataProvider();
		}
		
		protected function onListItemChange( event:ListEvent ):void {
			if( suggestionsList.selectedItem ) {
				input.text = suggestionsList.selectedItem.toString();
				selectedItem = dataProvider.getItemAt( 0 );
				selectedSignal.dispatch( suggestionsList.selectedItem );
				input.dispatchEvent( new Event( Event.CHANGE ) );
			}	
		}
		
		protected function updateDataProvider( nullFilter:Boolean = false ):void {
			if( dataProvider && nameProperty ) {
				!nullFilter ? dataProvider.filterFunction = defaultFilterFunction : dataProvider.filterFunction = null;
				dataProvider.refresh();
				_suggestionsProvider = getProvider( dataProvider );
				if( ( !suggestionsList )  && ( input.text != '' || nullFilter ) && ( _suggestionsProvider.length != 0 ) ) {
					suggestionsList = new List();
					var xyPosition:Point = new Point( input.x, ( input.y + input.height ) );
					xyPosition = skin.localToGlobal( xyPosition );
					suggestionsList.x = xyPosition.x;
					suggestionsList.y = xyPosition.y;
					suggestionsList.width = input.width;
					suggestionsList.dataProvider = _suggestionsProvider;
					suggestionsList.rowCount = ( _suggestionsProvider.length > 7 ) ? 7 : _suggestionsProvider.length;
					suggestionsList.addEventListener( ListEvent.ITEM_CLICK, onListItemChange, false, 0, true ); 
					suggestionsList.addEventListener( FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onSuggestionClose, false, 0, true );
					PopUpManager.addPopUp( suggestionsList, this, false );
				}
				else if( ( _suggestionsProvider.length == 0 ) || ( input.text == '' ) || ( selectedItem ) ) {
					onSuggestionClose();
				}
				else if( suggestionsList ) {
					suggestionsList.dataProvider = _suggestionsProvider;
					suggestionsList.rowCount = ( _suggestionsProvider.length > 7 ) ? 7 : _suggestionsProvider.length;
				}
			}
		}
		
		protected function onSuggestionClose( event:FlexMouseEvent = null ):void {
			if( suggestionsList ) {
				PopUpManager.removePopUp( suggestionsList );
				suggestionsList = null;
				_suggestionsProvider = [];
				_scrollIndex = -1;
			}
		}
		
		protected function defaultFilterFunction( element:Object ):Boolean {
			var returnValue:Boolean;
			if( labelField == allField ) {
				returnValue = multiCheck( element );
			}
			else {
				returnValue = singleCheck( element, labelField );
			}
			return returnValue;
		}
		
		private function multiCheck( obj:Object ) : Boolean {
			var returnValue:Boolean;
			for( var i:int = 0; i < nameProperty.length; i++ ) {
				var str:String = nameProperty.getItemAt( i ).toString();
				var val:String;
				
				if( obj.hasOwnProperty( str ) ) {
					val = String( obj[ str ] );	
				}
				else {
					val = Utils.reportLabelFuction( obj, str.toString() );
				}
				
				if ( input.text == null ) return true;
				var cntVal:String = String( input.text );
				if ( cntVal.length < 1 ) return true;
				var re:RegExp =  new RegExp( cntVal, 'i' );
				returnValue = ( re.test( val ) );
				if( returnValue ) break;
			}
			return returnValue;
		}
		
		private function singleCheck( obj:Object, str:String ):Boolean {
			var returnValue:Boolean;
			var val:String;
			if( obj.hasOwnProperty( str ) ) {
				val = String( obj[ str ] );	
			}
			else {
				val = Utils.reportLabelFuction( obj, str );
			}
			if ( input.text == null ) return true;
			var cntVal:String = String( input.text );
			if ( cntVal.length < 1 ) return true;
			var re:RegExp =  new RegExp( cntVal, 'i' );
			returnValue = ( re.test( val ) );
			return returnValue;
		}
		
		private function getProvider( value:ArrayCollection ):Array {
			var resultArray:Array = [];
			for ( var i:int = 0; i < value.length; i++ ) {
				var filteredValue:String;
				if( labelField == allField ) {
					for( var j:int = 0; j < nameProperty.length; j++ ) {
						if( value.getItemAt( i ).hasOwnProperty( nameProperty.getItemAt( j ) ) ) {
							filteredValue = String( value.getItemAt( i )[ nameProperty.getItemAt( j ) ] );	
						}
						else {
							filteredValue = Utils.reportLabelFuction( value.getItemAt( i ), nameProperty.getItemAt( j ).toString() );
						}
						if( filteredValue && filteredValue != '' && resultArray.indexOf( filteredValue ) == -1 ) {
							if( singleCheck( value.getItemAt( i ), nameProperty.getItemAt( j ).toString() ) ) {
								resultArray.push( filteredValue );
							}	
						}
					}
				}
				else {
					if( value.getItemAt( i ).hasOwnProperty( labelField ) ) {
						filteredValue = String( value.getItemAt( i )[ labelField ] );	
					}
					else {
						filteredValue = Utils.reportLabelFuction( value.getItemAt( i ), labelField );
					}
					if( filteredValue && filteredValue != '' && resultArray.indexOf( filteredValue ) == -1 ) {
						resultArray.push( filteredValue );
					}
				}	
			}
			return resultArray; 
		}
		
		private function onKeyDown( event:KeyboardEvent ):void {
			if( suggestionsList ) {
				if( event.keyCode == 38 ) {
					if( _scrollIndex == -1 ) {
						_scrollIndex = 0;
					}	 
					else if( _scrollIndex != 0 ) {
						_scrollIndex -= 1	
					} 
					suggestionsList.selectedIndex = _scrollIndex;
					suggestionsList.scrollToIndex( _scrollIndex );
				}
				else if( event.keyCode == 40 ) {
					if( _scrollIndex != ( _suggestionsProvider.length - 1 ) ) {
						_scrollIndex += 1 
						suggestionsList.selectedIndex = _scrollIndex;
						suggestionsList.scrollToIndex( _scrollIndex );
					}
				}
				else if( event.keyCode == 13 ) {
					if( suggestionsList.selectedIndex != -1 ) {
						suggestionsList.dispatchEvent( new ListEvent( ListEvent.ITEM_CLICK ) );
					}
				}
			}
		}
	}
}