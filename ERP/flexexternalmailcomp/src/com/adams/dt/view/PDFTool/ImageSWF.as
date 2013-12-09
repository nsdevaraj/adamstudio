package com.adams.dt.view.PDFTool
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	
	import mx.containers.Canvas;
	import mx.controls.SWFLoader;

	public class ImageSWF extends Canvas
	{
		private var swfloader:SWFLoader;
		private var loader:Loader; 
		//import flash.display.BitmapData;
		public var sourceLoadInfo:int;
		
		public var imgWidth:Number;
		public var imgHeight:Number;
		private var _imgBitmapData:BitmapData;
		public function set imgBitmapData (value:BitmapData):void
		{
			_imgBitmapData = value;
		}

		public function get imgBitmapData ():BitmapData
		{
			return _imgBitmapData;
		}


		
		private var _source:String;
		public function set source (value:String):void
		{
			_source = value;
			sourceLoadInfo=0;
			var filepath:String ='';
			if(Capabilities.os.search("Mac") >= 0) filepath = "file://"; 
			if(checkFileExist(filepath+value)){
				_source=filepath+value;
				var loaderContext:LoaderContext = new LoaderContext(true, new ApplicationDomain(ApplicationDomain.currentDomain), null);
		      	loader.load(new URLRequest(filepath+value),loaderContext);
			}
		}
		
		public function get source ():String
		{
			return _source;
		}

		private function checkFileExist(path:String):Boolean{
	    	try{
	    		var file:File = new File(path);
	    	}catch(e:Error){
	    		return false; 
	    	}
			
			return file.exists;
		}
		public function ImageSWF()
		{
			super();
			swfloader=new SWFLoader();
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,initListener);
		    addChild(swfloader);
			
		}
		override protected function createChildren():void {
			super.createChildren();
			
		}
		private function initListener(event:Event):void{
			imgBitmapData = new BitmapData(loader.contentLoaderInfo.width,loader.contentLoaderInfo.height);
			imgWidth=loader.contentLoaderInfo.width;
			imgHeight=loader.contentLoaderInfo.height;
			var UIMatrixMain:Matrix = new Matrix();
	       	imgBitmapData.draw(loader.content, UIMatrixMain);
	       	if(swfloader.numChildren != 0) swfloader.removeChildAt(0);
			swfloader.addChild(loader);
			sourceLoadInfo=1;
			this.invalidateDisplayList();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			trace("sourceLoadInfo : "+sourceLoadInfo+" Parent Name : "+this.parent.name);
			if(sourceLoadInfo){
				try{
			 	var sX:Number=1;
				sX=this.parent.parent.height/loader.contentLoaderInfo.height;
				//sX=Number("0"+String(sX).substr(String(sX).indexOf("."),2));
				if(isNaN(sX)) sX=1;
				//trace("ThisSWF sX ::: "+sX+" ::: ");
				this.width=loader.contentLoaderInfo.width*sX;
				this.height=loader.contentLoaderInfo.height*sX;
				this.scaleX=this.scaleY=sX;
				}
				catch(e:Error){
					
				} 
			}   
		}
	}
}