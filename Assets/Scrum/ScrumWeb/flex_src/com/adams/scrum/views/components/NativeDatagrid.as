package com.adams.scrum.views.components
{
	import com.adams.scrum.models.vo.Sprints;
	
	import mx.controls.DataGrid;
	
	import org.osflash.signals.Signal;
	
	public class NativeDatagrid extends DataGrid
	{
		public var renderSignal:Signal = new Signal();
		public var selectedSprint:Sprints;
		
		public function NativeDatagrid()
		{
			super();
		}
	}
}