package business
{
	import business.org.EventManager;
	import business.org.aszip.compression.CompressionMethod;
	import business.org.aszip.encoding.PNGEnc;
	import business.org.aszip.saving.Download;
	import business.org.aszip.saving.Method;
	import business.org.aszip.zip.ASZip;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	import mx.core.Application;
	public class CreateZip
	{
		public var zipFileArr:Array = new Array();	
		private var myZip:ASZip = new ASZip ( CompressionMethod.GZIP );
		public var _loader:Loader;
		private var bytes:ByteArray = new ByteArray();
		private var txt:ByteArray = new ByteArray();
		private var loadedImage:int = 0	;	
		public function CreateZip(arr:Array)
		{
			zipFileArr = arr;
			createZipFile();
			
		}
		
		private function createZipFile():void{
			loadedImage=0
			for (var i:int = 0; i<zipFileArr.length;i++){
				parseImg(Application.application.docRoot+"Cutouttool_Beta-debug/"+zipFileArr[i]);
			}
		} 
		private function parseImg(url:String): void { 
			var name:Array = url.split("/")
			var loaderContext:LoaderContext = new LoaderContext(true, new ApplicationDomain(ApplicationDomain.currentDomain), null);
			_loader = new Loader();  
			EventManager.addEvent( _loader.contentLoaderInfo, Event.COMPLETE, handleFinished, _loader,name[name.length-1]);
			_loader.load(new URLRequest(url),loaderContext);
		} 
		private function handleFinished(event:Event,ldr:Loader,url:String) : void {
			trace(url);
			++loadedImage;
			var image:Image = new Image();  
			image.maintainAspectRatio = true; 
			var content:* = ldr.content; 
			image.width = content.width;
			image.height = content.height;
			image.addChild(content);
			var bd:BitmapData = new BitmapData(content.width,content.height,true);
			bd.draw(image);		
			bytes = new ByteArray();
			bytes = PNGEnc.encode(bd);  
			myZip.addFile (bytes, url);
			var domainStr:String = Application.application.docRoot+"Cutouttool_Beta-debug/zipFile.php"
			if(zipFileArr.length == loadedImage) myZip.saveZIP ( Method.REMOTE, domainStr, Download.INLINE );				
		} 		
		

	}
}