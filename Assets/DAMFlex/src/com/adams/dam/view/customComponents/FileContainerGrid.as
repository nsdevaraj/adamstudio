package com.adams.dam.view.customComponents
{
	import mx.controls.DataGrid;
	
	public class FileContainerGrid extends DataGrid
	{
		private var _specificText:String = '';
		
		[Bindable]
		public function get specificText():String {
			return _specificText;
		}
		public function set specificText( value:String ):void {
			_specificText = value;
		}
		
		private var _selectedColumnIndex:int = -1;
		[Bindable]
		public function get selectedColumnIndex():int {
			return _selectedColumnIndex;
		}
		public function set selectedColumnIndex( value:int ):void {
			_selectedColumnIndex = value;
		}
		
		public function FileContainerGrid()
		{
			super();
		}
	}
}