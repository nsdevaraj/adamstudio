package com.adams.dt.view.PDFTool
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	
	import mx.containers.Canvas;
	import mx.controls.SWFLoader;
	
	[Event(name="imageLoadComplete", type="flash.events.Event")]

	public class ImageSWF extends Canvas
	{
		
		private var loader:Loader;
		public var swfloader:SWFLoader;
		public var pdfCommentList:Canvas = new Canvas();
		public var imgWidth:int=0;
		public var imgHeight:int=0;
		public var imgBitmapData:BitmapData;
		
		public static const IMAGE_LOAD_COMPLETE:String = "imageLoadComplete";
		
		// ImageSWF Class Constructor Definition 
		public function ImageSWF()
		{
			super();
			
			loader=new Loader();
			swfloader=new SWFLoader();
	
			addChild(swfloader);
			addChild(pdfCommentList);
			
			pdfCommentList.percentWidth = 100;
			pdfCommentList.percentHeight = 100;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderInfoCompleteEvent,false,0,true);
			setStyle("backgroundColor","#FFFFFF");
			
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
			
			pdfCommentList.horizontalScrollPolicy = "off";
			pdfCommentList.verticalScrollPolicy = "off";
			
			invalidateAction();
			
		}
		
		override protected function measure() : void {
            measuredHeight    = imgHeight;
            measuredMinHeight = imgHeight;
            measuredWidth     = imgWidth;
            measuredMinWidth  = imgWidth;
        }

        override protected function updateDisplayList(
            unscaledWidth:Number, unscaledHeight:Number):void {

            super.updateDisplayList(unscaledWidth, unscaledHeight);
            //trace("Invaild Task Calling...!")
			this.width = imgWidth;
			this.height = imgHeight;
        }
		
		private var _source:String="";
		public function set source(value:String):void
		{
			_source="";
			var filepath:String ='';
			
			invalidateAction();
			// Add prefix 'file://'with file Path, if application runs in MAC OSx
			if(value!=""){
				if(Capabilities.os.search("Mac") >= 0) filepath = "file://";
				if(checkFileExist(filepath+value)){
					_source=filepath+value;
					var loaderContext:LoaderContext = new LoaderContext(true, new ApplicationDomain(ApplicationDomain.currentDomain), null);
				}
				loader.load(new URLRequest(_source),loaderContext);
			}
		}
		public function get source():String
		{
			return _source;	
		}
		
		// loaderInfoCompleteEvent: Loader Content Info Complete Event
		private function loaderInfoCompleteEvent(event:Event):void
		{
			// Store Bitmap Data for image Compare functionalty
			imgWidth=event.target.width;
			imgHeight=event.target.height;
			
			invalidateAction()
	       	
	       	// loader SWF Content in SWF Loader
	       	if( swfloader.numChildren != 0 )
	       	{
	       		swfloader.removeChildAt(0);
	       		//swfloader.unloadAndStop();
	       	} 
			swfloader.x=0;
			swfloader.y=0;
			swfloader.width = imgWidth;
			swfloader.height = imgHeight;
			swfloader.addChild(loader);
			
			dispatchEvent(new Event(IMAGE_LOAD_COMPLETE));
			
		}
		private function invalidateAction():void{
        	invalidateProperties();
            invalidateSize();
            
            invalidateDisplayList(); 
        }
        public function swfMove(xVal:Number,yVal:Number):void
        {
        	swfloader.x=xVal;
			swfloader.y=yVal;
			swfloader.width = imgWidth;
			swfloader.height = imgHeight;
			invalidateAction();
        }
		// checkFileExist: Check whether the file exist or not. Its return Boolean value 
		private function checkFileExist(path:String):Boolean{
	    	try{
	    		var file:File = new File(path);
	    	}catch(e:Error){
	    		return false; 
	    	}
			
			return file.exists;
		}
	}
}