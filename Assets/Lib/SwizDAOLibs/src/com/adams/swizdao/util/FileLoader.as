package com.adams.swizdao.util {
	import org.osflash.signals.Signal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MediaEvent;
	import flash.geom.Matrix;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.ui.Multitouch;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class FileLoader
	{
		
		private static var dataSource:IDataInput;
		private static var fileReference:FileReference=new FileReference();
		private static var roll:CameraRoll = new CameraRoll();
		public static var fileLoaded:Signal = new Signal();
		public static var fileCanceled:Signal = new Signal();
		public static var loader:Loader= new Loader();
		public static var imgBytes:ByteArray;
		public static var bmp:Bitmap;
		public static function browse(ev:Event=null):void
		{
			fileReference.addEventListener(Event.SELECT,fileReferenceSelectHandler,false,0,true);  
			fileReference.addEventListener(Event.COMPLETE,fileReferenceComplete,false,0,true); 
			fileReference.addEventListener(Event.CANCEL ,fileReferenceCancel,false,0,true); 
			fileReference.browse([new FileFilter("Image files: (*.jpeg, *.jpg, *.gif, *.png)", "*.jpeg; *.jpg; *.gif; *.png")]);
			if(Multitouch.maxTouchPoints>0){
				roll.browseForImage();     
				roll.addEventListener(MediaEvent.SELECT,imageSelected);
			}
		}
		
	 	private static function imageSelected( event:MediaEvent ):void
		{ 
			var imagePromise:MediaPromise = event.data;
			dataSource = imagePromise.open();    
			if( imagePromise.isAsync )
			{
				var eventSource:IEventDispatcher = dataSource as IEventDispatcher;            
				eventSource.addEventListener( Event.COMPLETE, onMediaLoaded );         
			} else {
				readMediaData();
			}
		} 
		
		private static function onMediaLoaded( event:Event ):void
		{
			readMediaData();
		}
		
		
		private static function readMediaData():void
		{
			imgBytes = new ByteArray();
			dataSource.readBytes( imgBytes );
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
			loader.loadBytes(imgBytes);			
		} 
		
		private static function fileReferenceCancel(ev:Event):void
		{
			fileCanceled.dispatch();
		} 
		
		private static function fileReferenceSelectHandler(ev:Event):void
		{
			fileReference.load();
		} 
		
		private static function fileReferenceComplete(evt:Event):void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadBytesHandler,false,0,true);
			loader.loadBytes(fileReference.data); 
		} 
		
		public static function loadBytesHandler(ev:Event=null):void{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);
			var bitmap:Bitmap =  loader.content as Bitmap;
			bitmap.smoothing = true;
			if(Multitouch.maxTouchPoints==0){
				// Calculate resize ratios for resizing 
				var ratioW:Number = 800 / bitmap.bitmapData.width; 
				var ratioH:Number = 800 / bitmap.bitmapData.height;
				
				// smaller ratio will ensure that the image fits in the view
				var ratio:Number = ratioW < ratioH?ratioW:ratioH;
				var bmpd:BitmapData = new BitmapData(bitmap.width*ratio, bitmap.height*ratio);
				// create the scaled Bitmap object from the BitmapData
				var scaledBitmap:Bitmap = new Bitmap(bmpd, PixelSnapping.ALWAYS, true);
				// create the matrix that will perform the scaling
				var scaleMatrix:Matrix = new Matrix();
				scaleMatrix.scale(ratio, ratio);
				// draw the object to the BitmapData, applying the matrix to scale
				bmpd.draw( bitmap, scaleMatrix );  
			}else{
				scaledBitmap = bitmap;
			}
			bmp= scaledBitmap;
			fileLoaded.dispatch();
		}
	}
}
