package
{
import flash.display.*;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;

import mx.containers.VBox;
import mx.controls.Image;
import mx.controls.Text;
import mx.core.UIComponent;
 
public class CarouselItem extends UIComponent
{
private var _angle:Number;
private var pictLoad:Bitmap;
private var pictLdr:Loader;
private var ImageBitmap:BitmapData;
private var ReflectBitmap:BitmapData;
private var ImageBit:Bitmap;
private var Reflect:Bitmap; 

private var Reflected:Bitmap; 
private var _alphaGradientBitmap: BitmapData;
public var _falloff: Number = 0.6;
private var HSize:Number;
private var WSize:Number;
public var currentIndex:Number;
public var imageURL:String;
public var siteURL:String;
public var NAME:String;
public var TITLE:String;
			
 
public function CarouselItem(logo:String){
pictLdr = new  Loader();
pictLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoaded);
imageURL = logo;
var pictURL:String = "assets/"+imageURL;
var pictURLReq:URLRequest = new URLRequest(pictURL);
pictLdr.load(pictURLReq);
}
 
public function onImgLoaded(event:Event):void {
	var vbox:VBox = new VBox();
	vbox.width = 500;
	vbox.height = 500;
	vbox.setStyle('verticalGap',"0");
	addChild(vbox);
	
	var txt:Text = new Text();
	txt.text = NAME;
	txt.styleName = 'carouselTxt';
	txt.selectable = false;
	txt.visible = false;
	vbox.addChild(txt);
	pictLoad = Bitmap(pictLdr.content);
	HSize = pictLoad.height;
	WSize = pictLoad.width;
	ReflectBitmap = new BitmapData(WSize, HSize, true, 0x00000000)
	ImageBit = new Bitmap(pictLoad.bitmapData);
	ImageBitmap = ImageBit.bitmapData; 
	 var img:Image = new Image();
	 img.source = ImageBit;
	vbox.addChild(img);         
	createReflect();
	var rect: Rectangle = new Rectangle(0, 30,WSize , HSize);	
	ReflectBitmap.fillRect(rect, 0x00000000);
	ReflectBitmap.copyPixels(ImageBitmap,rect, new Point(0,0),_alphaGradientBitmap);
	Reflect = new Bitmap(ImageBitmap);
	Reflect.bitmapData = ReflectBitmap;
	var transform: Matrix = new Matrix();
	transform.scale(1, -1);
	transform.translate(0, HSize*2);
	Reflect.transform.matrix = transform;
	  
	addChild(Reflect); 	 			
}
 
private function createReflect(): void {
if (_alphaGradientBitmap == null) {
	_alphaGradientBitmap = new BitmapData(WSize, HSize, true, 0x00000000);
	var gradientMatrix: Matrix = new Matrix();
	var gradientSprite: Sprite = new Sprite();
	gradientMatrix.createGradientBox(WSize, HSize * _falloff, Math.PI/2, 
	0, HSize * (1.0 - _falloff));
	gradientSprite.graphics.beginGradientFill(GradientType.LINEAR, 
        [0x000000, 0x000000], [0, 1], [0, 255], gradientMatrix);
	gradientSprite.graphics.drawRect(0, HSize * (1.0 - _falloff), 
	WSize, (HSize*2) * _falloff);
	gradientSprite.graphics.endFill();
	_alphaGradientBitmap.draw(gradientSprite, new Matrix());	
		}	
	}
 
public function get angle():Number{
return _angle;
}
 
public function set angle(val:Number):void{
_angle=val;
}
 
}
}