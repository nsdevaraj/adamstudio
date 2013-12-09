package com.adams.scrum.views.components
{
	import com.adams.scrum.models.vo.Sprints;
	
	import mx.controls.AdvancedDataGrid;
	import mx.events.ListEvent;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class NativeADGrid extends AdvancedDataGrid
	{
		public var clicked:NativeSignal;
		public var renderSignal:Signal = new Signal();
		public var addOnOffRendererProperty:Boolean;  //Delete/OnOff/
		
		public var addStatusProperty:Boolean;
		
		public var selectedSprint:Sprints;

		public function NativeADGrid()
		{
			super();
			clicked = new NativeSignal( this, ListEvent.ITEM_CLICK, ListEvent );
		}
	}
}