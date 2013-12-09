package com.adams.dt.view.PDFTool.events
{
	import flash.events.Event;

	public class ToolBoxEvent extends Event
	{
		public function ToolBoxEvent(type:String, selectedToolValue:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._selectedTool = selectedToolValue;
			super(type, bubbles, cancelable);
		}
		
		public static const SELECTED_TOOL:String="selectedTool";
		
		override public function clone():Event
		{
			return new ToolBoxEvent(type, selectedTool, bubbles, cancelable);
		} 
		
		private var _selectedTool:String;
		
		public function get selectedTool ():String
		{
			return _selectedTool;
		}
	}
}