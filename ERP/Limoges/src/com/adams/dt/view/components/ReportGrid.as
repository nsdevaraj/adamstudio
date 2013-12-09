package com.adams.dt.view.components
{
	import org.osflash.signals.Signal;
	
	import spark.components.DataGrid;
	
	
	public class ReportGrid extends DataGrid
	{
		public var rendererSignal:Signal = new Signal();
		
		private var _specificText:String = '';
		[Bindable]
		public function get specificText():String {
			return _specificText;
		}
		public function set specificText( value:String ):void {
			_specificText = value;
		}
		
		private var _selectedColumn:String;
		[Bindable]
		public function get selectedColumn():String {
			return _selectedColumn;
		}
		public function set selectedColumn( value:String ):void {
			_selectedColumn = value;
		}
		
		private var _isDashBoard:Boolean;
		[Bindable]
		public function get isDashBoard():Boolean {
			return _isDashBoard;
		}
		public function set isDashBoard( value:Boolean ):void {
			_isDashBoard = value;
		}
		
		public function ReportGrid()
		{
			super();
		}
	}
}