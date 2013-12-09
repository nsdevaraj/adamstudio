package com.adams.dt.event.PDFTool
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.display.BitmapData;
	
	public class ImgEvent extends CairngormEvent
	{
		
		public static const LOADING_COMPLETED : String = "loadingCompleted";
		public static const IMG1 : Number = 0;
		public static const IMG2 : Number = 1;  
		
		public var ImgBitmapData : BitmapData;
		public var ImgWidth : Number;
		public var ImgHeight : Number;
		public var img : Number;
		
		public function ImgEvent(ImgBitmapData:BitmapData, ImgWidth:Number, ImgHeight:Number, img:Number)
		{
			this.ImgBitmapData = ImgBitmapData;
			this.ImgWidth = ImgWidth;
			this.ImgHeight = ImgHeight;
			this.img = img;
			super(LOADING_COMPLETED);
			
		}

	}
}