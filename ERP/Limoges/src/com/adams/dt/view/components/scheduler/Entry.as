package com.adams.dt.view.components.scheduler
{
	public class Entry 
	{
		private var _rowIndex:int;
		[Bindable]
		public function get rowIndex():int {
			return _rowIndex;
		}
		public function set rowIndex( value:int ):void {
			_rowIndex = value;
		} 
		
		private var _entryX:Number;
		[Bindable]
		public function get entryX():Number {
			return _entryX;
		}
		public function set entryX( value:Number ):void {
			_entryX = value;
		} 
		
		private var _entryY:Number;
		[Bindable]
		public function get entryY():Number {
			return _entryY;
		}
		public function set entryY( value:Number ):void {
			_entryY = value;
		} 
		
		private var _entryWidth:Number;
		[Bindable]
		public function get entryWidth():Number {
			return _entryWidth;
		}
		public function set entryWidth( value:Number ):void {
			_entryWidth = value;
		} 
		
		private var _entryHeight:Number;
		[Bindable]
		public function get entryHeight():Number {
			return _entryHeight;
		}
		public function set entryHeight( value:Number ):void {
			_entryHeight = value;
		} 
		
		private var _entryStart:Date;
		[Bindable]
		public function get entryStart():Date {
			return _entryStart;
		} 
		public function set entryStart( value:Date ):void {
			_entryStart = value;
		}
		
		private var _entryEnd:Date;
		[Bindable]
		public function get entryEnd():Date {
			return _entryEnd;
		} 
		public function set entryEnd( value:Date ):void {
			_entryEnd = value;
		}
		
		private var _entryLabel:String;
		[Bindable]
		public function get entryLabel():String {
			return _entryLabel;
		}
		public function set entryLabel( value:String ):void {
			_entryLabel = value;
		}
		
		private var _entryColor:uint;
		[Bindable]
		public function get entryColor():uint {
			return _entryColor;
		}
		public function set entryColor( value:uint ):void {
			_entryColor = value;
		}
		
		private var _entryObject:Object;
		[Bindable]
		public function get entryObject():Object {
			return _entryObject;
		}
		public function set entryObject( value:Object ):void {
			_entryObject = value;
		} 
		
		private var _entrySelectable:Boolean;
		[Bindable]
		public function get entrySelectable():Boolean {
			return _entrySelectable;
		}
		public function set entrySelectable( value:Boolean ):void {
			_entrySelectable = value;
		} 
		
		public function Entry()
		{
		}
	}
}