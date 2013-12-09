package com.adams.dt.view.tracability.DrawingComponents
{
	import mx.core.UIComponent;
	public final class RodTool extends UIComponent
	{
		public var rodColor : uint;
		public var rodX : Number;
		public var rodY : Number;
		public var rodWidth : Number;
		public var rodHeight : Number;
		override protected function updateDisplayList(unscaledWidth : Number , unscaledHeight : Number) : void
		{
			graphics.clear();
			graphics.beginFill(rodColor , 1);
			graphics.drawRect( ( rodX  + 1 ), rodY , ( rodWidth - 1 ) , ( rodHeight - 2 ) );
			graphics.endFill();
		}
	}
}
