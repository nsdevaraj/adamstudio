package com.adams.dt.view.tracability.DrawingComponents
{
	import mx.core.UIComponent;
	public class LineTool extends DrawingTool
	{
		public var lineColor : uint;
		override protected function updateDisplayList(unscaledWidth : Number , unscaledHeight : Number) : void
		{
			graphics.clear();
			graphics.lineStyle(2 , lineColor , 1);
			graphics.moveTo(startX , startY);
			graphics.lineTo(endX , endY);
		}
	}
}
