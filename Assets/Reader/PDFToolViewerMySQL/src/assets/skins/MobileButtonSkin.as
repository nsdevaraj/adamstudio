package assets.skins
{
	import spark.skins.mobile.ButtonSkin;
	
	public class MobileButtonSkin extends ButtonSkin
	{
		 
		public function MobileButtonSkin()
		{
			super();
		}
		 override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.drawBackground(unscaledWidth,unscaledHeight);
			var chromeColor:uint = getStyle("chromeColor"); 
			graphics.beginFill(chromeColor); 
			graphics.endFill();
		} 
	}
}