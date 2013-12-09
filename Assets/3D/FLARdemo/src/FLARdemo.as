package {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.pv3d.FLARCamera3D;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="#FFFFFF")]

	public class FLARdemo extends Sprite
	{
		[Embed(source="pat1.pat", mimeType="application/octet-stream")]
		private var pattern:Class;
		
		[Embed(source="camera_para.dat", mimeType="application/octet-stream")]
		private var params:Class;
		
		private var fparams:FLARParam;
		private var mpattern:FLARCode;
		private var vid:Video;
		private var cam:Camera;
		private var bmd:BitmapData;
		private var raster:FLARRgbRaster_BitmapData;
		private var detector:FLARSingleMarkerDetector;
		private var scene:Scene3D;
		private var camera:FLARCamera3D;
		private var container:FLARBaseNode;
		private var vp:Viewport3D;
		private var bre:BasicRenderEngine;
		private var trans:FLARTransMatResult;
		private var cube:Cube
		public function FLARdemo()
		{
			setupFLAR();
			setupCamera();
			setupBitmap();
			
			loadXMLData();
			addEventListener(Event.ENTER_FRAME, loop);
		}
		private function loadXMLData():void
		{
				var urlRequest:URLRequest = new URLRequest("faces.xml");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			urlLoader.load(urlRequest);
		}
		private function urlLoader_complete(evt:Event):void {
			 var xml:XML = new XML(evt.target.data);  
			var bmp1:BitmapFileMaterial =  new BitmapFileMaterial(xml.face1)
			var bmp2:BitmapFileMaterial =  new BitmapFileMaterial(xml.face2)
			var bmp3:BitmapFileMaterial =  new BitmapFileMaterial(xml.face3)
			var bmp4:BitmapFileMaterial =  new BitmapFileMaterial(xml.face4)
			var bmp5:BitmapFileMaterial =  new BitmapFileMaterial(xml.face5)
			var bmp6:BitmapFileMaterial =  new BitmapFileMaterial(xml.face6)
			this.cube = new Cube(new MaterialsList({front: bmp1, back: bmp2, right: bmp3, left: bmp4, top: bmp5, bottom: bmp6 }), xml.width, xml.depth,xml.height );
			setupPV3D();
		}	
		private function setupFLAR():void
		{
			fparams = new FLARParam();
			fparams.loadARParam(new params() as ByteArray);
			mpattern = new FLARCode(16, 16);
			mpattern.loadARPatt(new pattern());
		}	
		
		private function setupCamera():void
		{
			vid = new Video(640, 480);
			cam = Camera.getCamera();
			cam.setMode(640, 480, 30);
			vid.attachCamera(cam);
			addChild(vid);
		}	
		
		private function setupBitmap():void
		{
			bmd = new BitmapData(640, 480);
			bmd.draw(vid);
			raster = new FLARRgbRaster_BitmapData(bmd);
			detector = new FLARSingleMarkerDetector(fparams, mpattern, 80);
		}	
		
		private function setupPV3D():void
		{
			scene = new Scene3D();
			camera = new FLARCamera3D(fparams);
			container = new FLARBaseNode();
			scene.addChild(container);
			 
			var cube1:Cube = cube
			var cube2:Cube = cube
			cube2.z = 50;
			var cube3:Cube = cube
			cube3.z = 100;
			
			container.addChild(cube1);
			container.addChild(cube2);
			container.addChild(cube3);
			
			bre = new BasicRenderEngine();
			trans = new FLARTransMatResult();
			
			vp = new Viewport3D();
			addChild(vp); 
		}	
		
		private function loop(e:Event):void
		{
			bmd.draw(vid);
			
			try
			{
				if(detector.detectMarkerLite(raster, 80) && detector.getConfidence() > 0.5)
				{
					detector.getTransformMatrix(trans);
					container.setTransformMatrix(trans);
					bre.renderScene(scene, camera, vp);
				}
			}
			catch(e:Error){}
		}
	}
}
