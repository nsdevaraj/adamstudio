package
{
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.net.URLLoader;
		import flash.net.URLLoaderDataFormat;
		import flash.net.URLRequest;
		
		import org.papervision3d.lights.PointLight3D;
		import org.papervision3d.materials.BitmapAssetMaterial;
		import org.papervision3d.materials.BitmapFileMaterial;
		import org.papervision3d.materials.WireframeMaterial;
		import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
		import org.papervision3d.materials.utils.MaterialsList;
		import org.papervision3d.objects.primitives.Cube;
		import org.papervision3d.objects.primitives.Plane;
		import org.papervision3d.view.BasicView;
	
	public class bkColladaExample extends BasicView
	{
		[Embed(source="model/box.dae", mimeType = "application/octet-stream")]
		private var daeAsset:Class;
		
		[Embed(source="model/juicemap.jpg")]
		private var materialAsset:Class;
		
		private var cameraPitch:Number = 90;
		private var cameraYaw:Number = 10;
		private var isOrbiting:Boolean = false;
		private var previousMouseX:Number;
		private var previousMouseY:Number;
		private var _plane:Plane;
		private var _cube:Cube;
		
		private var ml:MaterialsList = new MaterialsList();
		private var customcube:Cube;
		private var face1:String;
		private var face2:String;
		private var face3:String;
		private var face4:String;
		private var face5:String;
		private var face6:String;
		private var cwidth:Number;
		private var cdepth:Number;
		private var cheight:Number;
		
		
		public function bkColladaExample()
		{
				var urlRequest:URLRequest = new URLRequest("faces.xml");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			urlLoader.load(urlRequest);
		}
		private function urlLoader_complete(evt:Event):void {
			 var xml:XML = new XML(evt.target.data);
   		 face1=xml.face1;
   		 face2=xml.face2;
   		 face3=xml.face3;
   		 face4=xml.face4;
   		 face5=xml.face5;
   		 face6=xml.face6;
   		 
   		 cwidth=Number(xml.width);
   		 cdepth=Number(xml.depth);
   		 cheight=Number(xml.height);
   		  
				var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2); // with wireframe. / ??????????
			this._plane = new Plane(wmat, 80, 80); // 80mm x 80mm?
			scene.addChild(this._plane); // attach to _baseNode to follow the marker. / _baseNode ? addChild ?????????????

			// Place th e light at upper front.
			// ???????????????
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;
			
			// Create Cube.
			// Cube ????
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0x0022aa, 0x0022aa); // Color is ping. / ?????
			var ml:MaterialsList = new MaterialsList();
			var bmp1:BitmapFileMaterial =  new BitmapFileMaterial(face1)
			var bmp2:BitmapFileMaterial =  new BitmapFileMaterial(face2)
			var bmp3:BitmapFileMaterial =  new BitmapFileMaterial(face3)
			var bmp4:BitmapFileMaterial =  new BitmapFileMaterial(face4)
			var bmp5:BitmapFileMaterial =  new BitmapFileMaterial(face5)
			var bmp6:BitmapFileMaterial =  new BitmapFileMaterial(face6)
			ml.addMaterial(bmp1);
			ml.addMaterial(bmp2);
			ml.addMaterial(bmp3);
			ml.addMaterial(bmp4);
			ml.addMaterial(bmp5);
			ml.addMaterial(bmp6);
			this._cube = new Cube(new MaterialsList({front: bmp1, back: bmp2, right: bmp3, left: bmp4, top: bmp5, bottom: bmp6 }), cwidth, cdepth, cheight );
			//this._cube = new Cube(new MaterialsList({all: fmat}), 180, 140, 190); // 40mm x 40mm x 40mm
			//this._cube.z = -20; // Move the cube to upper (minus Z) direction Half height of the Cube. / ?????????????(-Z??)?????????????????????????
			scene.addChild(this._cube);
			
			/* 
			var byteArray:ByteArray = new daeAsset() as ByteArray;
			var dae:DAE = new DAE();
			dae.load(byteArray);
			var bitmap:Bitmap = new materialAsset() as Bitmap;
			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData, true);
			dae.materials.addMaterial(bitmapMaterial, "_7_-_Default");
 */
			//scene.addChild(dae);
			
			startRendering();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		private function mouseWheelHandler(event:MouseEvent):void
		{
			camera.moveForward(60 * event.delta);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			isOrbiting = true;
			previousMouseX = event.stageX;
			previousMouseY = event.stageY;
		}
 
		private function onMouseUp(event:MouseEvent):void
		{
			isOrbiting = false;
		}
 
		private function onMouseMove(event:MouseEvent):void
		{
			var differenceX:Number = event.stageX - previousMouseX;
			var differenceY:Number = event.stageY - previousMouseY;
 
			if(isOrbiting)
			{
				cameraPitch += differenceY;
				cameraYaw += differenceX;
 
				cameraPitch %= 360;
				cameraYaw %= 360;
 
				cameraPitch = cameraPitch > 0 ? cameraPitch : 0.0001;
				cameraPitch = cameraPitch < 90 ? cameraPitch : 89.9999;
 
				previousMouseX = event.stageX;
				previousMouseY = event.stageY;
 
				camera.orbit(cameraPitch, cameraYaw);
			}
		}

	}
}