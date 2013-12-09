// http://kelvinluck.com/assets/papervision3d/cube_tweaks/
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.MaterialsList;
	import org.papervision3d.objects.Cube;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.scenes.Scene3D;
	public class ColladaExample extends Sprite
	{
		// image 1 variable represents an image in the library with the class name of CubeTexture
		private var container:Sprite;
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var rootNode:DisplayObject3D;
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
		
		
		public function ColladaExample()
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
   		 
		 init3D();
		 addEventListener(Event.ENTER_FRAME, Timeline);
		 addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
}
		private function init3D():void {
			container = new Sprite();
		
			addChild( container );
		//	container.x = stage.stageWidth * .5;
		//	container.y = stage.stageHeight * .5;
		container.x = 150;
		container.y= 150;
		
			scene = new Scene3D( container );
			camera = new Camera3D();
			camera.zoom = 5;

			rootNode = scene.addChild( new DisplayObject3D("rootNode") );

			var ml:MaterialsList = new MaterialsList();
			ml.addMaterial(new BitmapFileMaterial(face1), 'face1');
			ml.addMaterial(new BitmapFileMaterial(face2), 'face2');
			ml.addMaterial(new BitmapFileMaterial(face3), 'face3');
			ml.addMaterial(new BitmapFileMaterial(face4), 'face4');
			ml.addMaterial(new BitmapFileMaterial(face5), 'face5');
			ml.addMaterial(new BitmapFileMaterial(face6), 'face6');
			
			customcube = new Cube(ml, cwidth, cdepth, cheight, 1, 1, 1 );
			rootNode.addChild( customcube, "myCube01" );
		}

		private function Timeline( event:Event ):void {
			var screen:DisplayObject3D = this.scene.getChildByName("rootNode");
			var rotationY:Number = -(this.mouseX / this.stage.stageWidth * 275);
			var rotationX:Number = -(this.mouseY / this.stage.stageHeight * 275);
			screen.rotationY += (rotationY - screen.rotationY) / 12;
			screen.rotationX += (rotationX - screen.rotationX) / 12;

			this.scene.renderCamera(this.camera);
		}
		private function mouseWheelHandler(event:MouseEvent):void
		{
			camera.moveForward(60 * event.delta);
		}
		
	}
}