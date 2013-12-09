package {
	
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	
	public class SimpleCube extends PV3DARApp {
		
		private var _plane:Plane;
		private var _cube:Cube;
		
		public function SimpleCube() {
			// Initalize application with the path of camera calibration file and patter definition file.
			// ??????????????????????????????????
			this.init('Data/camera_para.dat', 'Data/flarlogo.pat');
		}
		[Embed(source="model/box.dae", mimeType = "application/octet-stream")]
		private var daeAsset:Class;
		
		[Embed(source="model/juicemap.jpg")]
		private var materialAsset:Class;
		
		protected override function onInit():void {
			super.onInit(); // You must call this. / ???????
			
			// Create Plane with same size of the marker.
			// ??????????? Plane ???????
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2); // with wireframe. / ??????????
			this._plane = new Plane(wmat, 80, 80); // 80mm x 80mm?
			this._baseNode.addChild(this._plane); // attach to _baseNode to follow the marker. / _baseNode ? addChild ?????????????

			// Place th e light at upper front.
			// ???????????????
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;
			
			// Create Cube.
			// Cube ????
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0x0022aa, 0x75104e); // Color is ping. / ?????
			this._cube = new Cube(new MaterialsList({all: fmat}), 80, 40, 90); // 40mm x 40mm x 40mm
			this._cube.z = -20; // Move the cube to upper (minus Z) direction Half height of the Cube. / ?????????????(-Z??)?????????????????????????
			
			
			var byteArray:ByteArray = new daeAsset() as ByteArray;
			var dae:DAE = new DAE();
			dae.load(byteArray);
			var bitmap:Bitmap = new materialAsset() as Bitmap;
			var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData, true);
			dae.materials.addMaterial(bitmapMaterial, "_7_-_Default");
 
			//this._baseNode.addChild(this._cube);
			this._baseNode.addChild(dae);
		}
	}
}