/**
 * SeparatorBar
 * 
 * This class provides an alternative to HRule. This is a solid rectangle drawn and filled
 * using the backgroundColor and backgroundAlpha styles.
 */
package com.adams.blog.components
{
	import mx.core.UIComponent;
	import flash.display.Graphics;

	public class SeparatorBar extends UIComponent
	{
		
		/**
		 * updateDisplayList
		 * 
		 * This function draws the separator bar. The color and alpha are taken from the styles
		 * settings.
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var bgColor:Number = getStyle("backgroundColor");
			if( isNaN(bgColor) ) bgColor = 0x000000;
			var bgAlpha:Number = getStyle("backgroundAlpha");
			if( isNaN(bgAlpha) ) bgAlpha = 1;
			
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(bgColor, bgAlpha);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
		}
		
		/**
		 * measure
		 * 
		 * This function sets the proper measurement variables so the container can size
		 * the bar properly.
		 */
		override protected function measure():void
		{
			super.measure();
			
			measuredMinHeight = 4;
			measuredMinWidth  = 50;
			measuredHeight = getExplicitOrMeasuredHeight();
			if( measuredHeight == 0 ) measuredHeight = 4;
		}
	}
}