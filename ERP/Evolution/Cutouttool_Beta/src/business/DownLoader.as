package business
{
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.EventManager;
	
	public class DownLoader
	{
		private var files:Array = new Array();
		public var _loader:Loader;
		private var loadedImage:int = 0	;
		public function DownLoader(fileArr:Array,domain:String)
		{
			files = fileArr;
			download();
		}
		private function download():void{
			for (var i:int = 0; i<_files.length;i++){
				parseImg(_files[i]);
			}	
		}
		private function parseImg(url:String): void { 
			var loaderContext:LoaderContext = new LoaderContext(true, new ApplicationDomain(ApplicationDomain.currentDomain), null);
			_loader = new Loader();  
			EventManager.addEvent( _loader.contentLoaderInfo, Event.COMPLETE, handleFinished, _loader,url);
			_loader.load(new URLRequest(url),loaderContext);
		} 
		private function handleFinished(event:Event,ldr:Loader,url:String) : void {
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
			myZip.addFile (  bytes, url);
			if(_files.length == loadedImage) myZip.saveZIP ( Method.REMOTE, domain, Download.INLINE );				
		} 

	}
}