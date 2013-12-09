package com.adams.dt.view.dataGridSearch.mainComponent
{
	import mx.controls.DataGrid;
	
	public class DashBoardGrid extends DataGrid
	{
		private var _specificText:String = '';
		
		[Bindable]
		public function get specificText():String {
			return _specificText;
		}
		
		public function set specificText( value:String ):void {
			_specificText = value;
		}
		private var _isDashBoard:Boolean;
		
		[Bindable]
		public function get isDashBoard():Boolean{
			return _isDashBoard;
		}
		
		public function set isDashBoard( value:Boolean):void {
			_isDashBoard = value;
		}
		
		public function DashBoardGrid()
		{
			super();
		}
	}
}