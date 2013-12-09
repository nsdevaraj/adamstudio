package com.adams.dam.view.hosts.autoComplete
{
	import com.adams.dam.business.utils.VOUtils;
	import com.adams.dam.view.skins.autoComplete.AutoCompleteSkin;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.List;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TextOperationEvent;
	
	public class AutoCompleteView extends SkinnableComponent
	{
		
		public var unListedProperties:Dictionary = new Dictionary();
		
		private var skinComponent:AutoCompleteSkin;
		private var suggestionsList:List;
		
		private var _scrollIndex:int = -1;
		private var _isItemSelected:Boolean;
		private var _suggestionsProvider:Array;
		
		private var _specificText:String = '';
		[Bindable]
		public function get specificText():String {
			return _specificText;
		}
		public function set specificText( value:String ):void {
			_specificText = value;
		}
		
		private var _dataCollection:ArrayCollection;
		[Bindable]
		public function get dataCollection():ArrayCollection {
			return _dataCollection;
		}
		public function set dataCollection( value:ArrayCollection ):void {
			_dataCollection = value;
			updateDataProvider();
		}
		
		private var _nameProperty:Array;
		[Bindable]
		public function get nameProperty():Array {
			return _nameProperty;
		}
		public function set nameProperty( value:Array ):void {
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
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true );
		}
		
		protected function onCreationComplete( event:FlexEvent ):void {
			if( skin ) {
				skinComponent = AutoCompleteSkin( skin );
				
				skinComponent.input.addEventListener( Event.CHANGE, onTextInputChange, false, 0, true );
				skinComponent.input.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true );
			}
		}
		
		protected function onTextInputChange( event:Event ):void {
			specificText = skinComponent.input.text;
			updateDataProvider();
		}
		
		protected function onListItemChange( event:ListEvent ):void {
			if( suggestionsList.selectedItem ) {
				skinComponent.input.text = suggestionsList.selectedItem.toString();
				skinComponent.input.setSelection( skinComponent.input.text.length, skinComponent.input.text.length );
				_isItemSelected = true;
				skinComponent.input.dispatchEvent( new Event( Event.CHANGE ) );
			}	
		}
		
		private function updateDataProvider():void {
			if( dataCollection ) {
				dataCollection.filterFunction = defaultFilterFunction;
				dataCollection.refresh();
				_suggestionsProvider = getProvider( dataCollection );
				if( ( !suggestionsList )  && ( skinComponent.input.text != '' ) && ( _suggestionsProvider.length != 0 ) ) {
					suggestionsList = new List();
					var xyPosition:Point = new Point( skinComponent.input.x, ( skinComponent.input.y + skinComponent.input.height ) );
					xyPosition = skinComponent.localToGlobal( xyPosition );
					suggestionsList.x = xyPosition.x;
					suggestionsList.y = xyPosition.y;
					suggestionsList.width = skinComponent.input.width;
					suggestionsList.dataProvider = _suggestionsProvider;
					suggestionsList.rowCount = ( _suggestionsProvider.length > 7 ) ? 7 : _suggestionsProvider.length;
					suggestionsList.addEventListener( ListEvent.ITEM_CLICK, onListItemChange, false, 0, true ); 
					suggestionsList.addEventListener( FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onSuggestionClose, false, 0, true );
					PopUpManager.addPopUp( suggestionsList, this, false );
				}
				else if( ( _suggestionsProvider.length == 0 ) || ( skinComponent.input.text == '' ) || ( _isItemSelected ) ) {
					onSuggestionClose();
				}
				else if( suggestionsList ) {
					suggestionsList.dataProvider = _suggestionsProvider;
					suggestionsList.rowCount = ( _suggestionsProvider.length > 7 ) ? 7 : _suggestionsProvider.length;
				}
			}
		}
		
		protected function onSuggestionClose( event:FlexMouseEvent = null ):void {
			PopUpManager.removePopUp( suggestionsList );
			suggestionsList = null;
			_suggestionsProvider = [];
			_scrollIndex = -1;
			_isItemSelected = false;
		}
		
		private function defaultFilterFunction( element:Object ):Boolean {
			var returnValue:Boolean;
			if( labelField == "All" ) {
				returnValue = multiCheck( element );
			}
			else {
				returnValue = singleCheck( element, labelField );
			}
			return returnValue;
		}
		
		private function multiCheck( obj:Object ) : Boolean {
			var returnValue:Boolean;
			for each( var str:String in nameProperty ) {
				var val:String;
				if( obj.hasOwnProperty( str ) ) {
					val = String( obj[ str ] );	
				}
				else {
					val = VOUtils.filterFunction( obj, str );
				}
				if ( skinComponent.input.text == null ) return true;
				var cntVal:String = String( skinComponent.input.text );
				if ( cntVal.length < 1 ) return true;
				var re:RegExp = new RegExp( cntVal, 'i' );
				returnValue = ( re.test( val ) );
				if( returnValue ) break;
			}
			return returnValue;
		}
		
		private function singleCheck( obj:Object, str:String ):Boolean {
			var val:String;
			if( obj.hasOwnProperty( str ) ) {
				val = String( obj[ str ] );	
			}
			else {
				val = VOUtils.filterFunction( obj, str );
			}
			if ( skinComponent.input.text == null ) return true;
			var cntVal:String = String( skinComponent.input.text );
			if ( cntVal.length < 1 ) return true;
			var re:RegExp = new RegExp( cntVal, 'i' );
			return ( re.test( val ) );
		}
		
		private function getProvider( value:ArrayCollection ):Array {
			var resultArray:Array = [];
			for ( var i:int = 0; i < value.length; i++ ) {
				var filteredValue:String;
				if( labelField == 'All' ) {
					for( var j:int = 0; j < nameProperty.length; j++ ) {
						if( value.getItemAt( i ).hasOwnProperty( nameProperty[ j ] ) ) {
							filteredValue = String( value.getItemAt( i )[ nameProperty[ j ] ] );	
						}
						else {
							filteredValue = VOUtils.filterFunction( value.getItemAt( i ), nameProperty[ j ] );
						}
						if( resultArray.indexOf( filteredValue ) == -1 ) {
							if( singleCheck( value.getItemAt( i ), nameProperty[ j ] ) ) {
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
						filteredValue = VOUtils.filterFunction( value.getItemAt( i ), labelField );
					}
					if( resultArray.indexOf( filteredValue ) == -1 ) {
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