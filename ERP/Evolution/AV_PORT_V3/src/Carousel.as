package {
 
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.collections.ArrayCollection;
import mx.core.Application;
import mx.core.UIComponent;
 
 public class Carousel extends UIComponent
{
public var logos:ArrayCollection; 
public var numOfObj:uint;
public var radius:Point;
public var center:Point;
public var speed:Number=0.01;
public var sortedItems:Array = new Array();
public var item:CarouselItem;
private var menuProvider:Array=[]; 
public function Carousel(w:Number,h:Number,logos:ArrayCollection,fallof:Number,padding:Number){
 
this.logos = logos;
this.numOfObj = logos.length;
radius = new Point(w/2-padding,75);
center=new Point(w/2,h/2-radius.y);
 
for(var i:int=0;i<numOfObj;i++){
   item = new CarouselItem(logos[i].IMAGE);
   //item = new CarouselItem(logos[i].IMAGE);
   item._falloff = fallof;
   item.currentIndex = i;
   item.siteURL = logos[i].URL;
   item.NAME = logos[i].NAME;
   item.angle=(i*((Math.PI*2)/numOfObj));
   item.addEventListener(Event.ENTER_FRAME,onEnter);
   item.addEventListener(MouseEvent.CLICK,currentItem);
   sortedItems.push(item);
   menuProvider.push(logos[i].Name);
   addChild(item);
  }
  Application.application.menuList.dataProvider = menuProvider;
}
public function currentItem(event:Event):void{
	Application.application.loadSite(event.currentTarget.currentIndex)
	//trace(event.currentTarget.currentIndex)
} 
 
public function arrange():void {
    sortedItems.sortOn("y", Array.NUMERIC);
    var i:int = sortedItems.length;
    while(i--){
        if (getChildAt(i) != sortedItems[i]) {
            setChildIndex(sortedItems[i], i);
        }
    }
}
 
public function onEnter(evt:Event):void{
	
var obj:CarouselItem=CarouselItem(evt.currentTarget);
 
obj.x=Math.cos(obj.angle) *radius.x +center.x - obj.width/2;
obj.y=Math.sin(obj.angle) *radius.y +center.y;
 
var scale:Number=obj.y /(center.y+radius.y);
obj.scaleX=obj.scaleY=scale*1;
obj.angle=(obj.angle+speed);
 
arrange();
}
 
public function onMove(evt:MouseEvent):void
{
	this.speed = (this.mouseX - center.x)/9000;
}
 
}
}