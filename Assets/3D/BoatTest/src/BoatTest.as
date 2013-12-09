package
{
	
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.loaders.Loader3D;
	import away3d.loaders.Obj;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	[SWF(backgroundColor="#000000", frameRate="30", quality="HIGH")]
	public class BoatTest extends Sprite
	{
		//engine private variables
		private var scene:Scene3D;
		private var camera:HoverCamera3D;
		private var view:View3D;
		//scene objects
		private var loader:Loader3D;
		private var boat:Object3D;
		private var boatContainer:ObjectContainer3D;   
		//variables
		private var moves:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var lastZoom:Number=0.5;
		
		private var myXML:XML = new XML();
		private var XML_URL:String = "file.xml";
		private var myXMLURL:URLRequest = new URLRequest(XML_URL);
		private var myLoader:URLLoader = new URLLoader();
		
		
		private function xmlLoaded(event:Event):void
		{
			myXML = XML(myLoader.data);
			loader = Obj.load(String(myXML.file));
			loader.addOnSuccess(onLoadSuccess); 
		}

		 
		/**
		 * Global initialise private function
		 */
		public function BoatTest()
		{
			initEngine();
			initListeners();
			myLoader.load(myXMLURL);
			myLoader.addEventListener("complete", xmlLoaded);
			
		}
		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{				
			scene = new Scene3D();
			camera = new HoverCamera3D();
			camera.panAngle = 45;
			camera.tiltAngle = 20;
			camera.hover(true);
			
			view = new View3D();
			view.scene = scene;
			view.camera = camera; 	
			addChild(view); 
		}   
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(Event.RESIZE, onResize);
			
			onResize();
		}
		/**
		 * Listener private function for loading complete event on loader
		 */
		private function onLoadSuccess(event:Event):void
		{
			loader.handle.rotationX =300
			boat = loader.handle;
			boat.scale(lastZoom);
			boatContainer = new ObjectContainer3D(boat);
			scene.addChild(boatContainer); 
			camera.hover();
			view.render();
			
			addEventListener( Event.ENTER_FRAME, onEnterFrame);
		}
		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			loader.handle.rotationY+=2 
			if (moves) {
				camera.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				camera.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			} 
			camera.hover();
			view.render();
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			lastPanAngle = camera.panAngle;
			lastTiltAngle = camera.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			moves = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		/**
		 * Mouse wheel listener for zoom
		 */
		private function onMouseWheel(event:MouseEvent):void
		{
			if( event.delta > 0 )
			{
				lastZoom = lastZoom + lastZoom/10
			}
			else
			{
				lastZoom= lastZoom - lastZoom/10
			} 
			if(lastZoom>0.2)
			boat.scale(lastZoom);
		}
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			moves = false;
			//removeEventListener( Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			moves = false;
			//removeEventListener( Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
		}
	}
}