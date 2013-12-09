package com.adams.dt.view.PDFTool
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class CommentIconItem extends Canvas
	{
		private var sprite:UIComponent;
		private var resizeBut:Button;
		private var noteBut:Button;
		
		public var commentID:int;
		
		private var _fillColor:uint;
		public function set fillColor (value:uint):void
		{
			_fillColor = value;
		}

		public function get fillColor ():uint
		{
			return _fillColor;
		}


		
		private var _strokeColor:uint;
		public function set strokeColor (value:uint):void
		{
			_strokeColor = value;
		}

		public function get strokeColor ():uint
		{
			return _strokeColor;
		}

		
		private var _type:Number;
		public function set type (value:Number):void
		{
			_type = value;
		}

		public function get type ():Number
		{
			return _type;
		}
		
		private var _title:String;
		public function set title (value:String):void
		{
			_title = value;
		}

		public function get title ():String
		{
			return _title;
		}

		
		private var _desc:String;
		public function set desc (value:String):void
		{
			_desc = value;
		}

		public function get desc ():String
		{
			return _desc;
		}
		
		private var _target:Object;
		public function set target (value:Object):void
		{
			_target = value;
		}

		public function get target ():Object
		{
			return _target;
		}
		
		private var _PDF:int;
		public function set PDF (value:int):void
		{
			_PDF = value;
			
		}

		public function get PDF ():int
		{
			return _PDF;
		}
		
		public function CommentIconItem()
		{
			super();
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.fillColor=0xFFFF00;
			this.strokeColor=0x000000;
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteEvent);
			this.addEventListener(FlexEvent.REMOVE,removeInstance);
		}
		private function creationCompleteEvent(event:FlexEvent):void{
			if(this.PDF==PDFMainContainer.PDF2)
			{
				if(type == 0){
					this.addEventListener(MouseEvent.MOUSE_OVER,thisMouseOverOut);
					this.addEventListener(MouseEvent.MOUSE_OUT,thisMouseOverOut);
					this.removeEventListener(MouseEvent.CLICK,thisMouseOverOut);
					sprite.addEventListener(MouseEvent.MOUSE_DOWN,commentMouseAction);
				}else{
					this.addEventListener(MouseEvent.CLICK,thisMouseOverOut);
				}
			}
			this.width=sprite.width;
			this.height=sprite.height;
		}
		private function commentMouseAction(event:MouseEvent):void{
			if(event.type==MouseEvent.MOUSE_DOWN) { 
				this.startDrag(false,new Rectangle(0,0,this.parent.width-this.width,this.parent.height-this.height)); 
				sprite.addEventListener(MouseEvent.MOUSE_UP,commentMouseAction);
			}
			if(event.type==MouseEvent.MOUSE_UP) {
				this.stopDrag();
			    CommentDescBox(this.target).edit_btn.label="Update";
			    CommentDescBox(this.target).editComment(); 
			 	sprite.removeEventListener(MouseEvent.MOUSE_UP,commentMouseAction);
			}
		}
		private function removeInstance(event:FlexEvent):void{
			trace("Remove Instance")
			this.removeEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteEvent);
			this.removeEventListener(FlexEvent.REMOVE,removeInstance);
			if(this.PDF==PDFMainContainer.PDF2){ 
				if(this.type == 0){
					this.removeEventListener(MouseEvent.MOUSE_OVER,thisMouseOverOut);
					this.removeEventListener(MouseEvent.MOUSE_OUT,thisMouseOverOut);
					sprite.removeEventListener(MouseEvent.MOUSE_DOWN,commentMouseAction);
					if(this.type == 0) resizeBut.removeEventListener(MouseEvent.MOUSE_DOWN,butMouseDown);
				 }else{
					this.removeEventListener(MouseEvent.CLICK,thisMouseOverOut);
				} 
			}
		}
		override protected function createChildren():void {
			super.createChildren();
			resizeBut=new Button();
			sprite =new UIComponent();
			resizeBut.visible=false;				
			if(type == 0) { 
				RectangleComment(this.width,this.height); 
				resizeBut.visible=true;
				resizeBut.addEventListener(MouseEvent.MOUSE_DOWN,butMouseDown);
			}
			if(type == 1) DashedLine(0,0,this.width,0,8,5);
			if(type == 2) DashedLine(0,0,0,this.height,8,5);
			addChild(sprite);
			addChild(resizeBut);
			
			sprite.width = (type == 2)?20:width;
			sprite.height = (type == 1)?20:height;
			resizeBut.buttonMode=true;
			resizeBut.visible=false;
			resizeBut.width=resizeBut.height=40;
			resizeBut.setStyle("styleName","resizeToolSkin");
		}
		
		private function thisMouseOverOut(event:MouseEvent):void{
			if(event.type==MouseEvent.CLICK) { 
				trace("Title : "+this.title);
				trace("Desc : "+this.desc);
				trace("Position : "+this.parent.localToGlobal(new Point(this.x,this.y)));
				trace("==================");
			}
			if(event.type==MouseEvent.MOUSE_OVER) resizeBut.visible=true;
			if(event.type==MouseEvent.MOUSE_OUT){
				resizeBut.visible=false;
				resizeBut.stopDrag();
			}
			resizeBut.x=sprite.width-resizeBut.width;
			resizeBut.y=sprite.height-resizeBut.height;
		}
		private function butMouseDown(event:MouseEvent):void{
			Button(event.target).startDrag();
			Button(event.target).addEventListener(MouseEvent.MOUSE_OUT,butMouseOut);
			Button(event.target).addEventListener(MouseEvent.MOUSE_MOVE,butMouseMove);
			Button(event.target).addEventListener(MouseEvent.MOUSE_UP,butMouseUp);
			
		}
		private function butMouseOut(event:MouseEvent):void{
			sprite.width=Button(event.target).x+Button(event.target).width;
			sprite.height=Button(event.target).y+Button(event.target).height;
			this.width=sprite.width;
			this.height=sprite.height;
		}
		private function butMouseMove(event:MouseEvent):void{
			RectangleComment(Button(event.target).x+Button(event.target).width,Button(event.target).y+Button(event.target).height);
			this.width=sprite.width;
			this.height=sprite.height;
			if(!event.buttonDown){
				Button(event.target).stopDrag();
				Button(event.target).removeEventListener(MouseEvent.MOUSE_MOVE,butMouseMove);
				Button(event.target).removeEventListener(MouseEvent.MOUSE_UP,butMouseUp);
			} 
			
		}
		private function butMouseUp(event:MouseEvent):void{
			Button(event.target).stopDrag();
			CommentDescBox(this.target).edit_btn.label="Update";
			CommentDescBox(this.target).editComment();
			Button(event.target).removeEventListener(MouseEvent.MOUSE_OUT,butMouseOut);
			Button(event.target).removeEventListener(MouseEvent.MOUSE_MOVE,butMouseMove);
			Button(event.target).removeEventListener(MouseEvent.MOUSE_UP,butMouseUp);
			
		}
		private function RectangleComment(width:int,height:int):void{
			sprite.graphics.clear();
			sprite.graphics.lineStyle(0.5, strokeColor);
			sprite.graphics.beginFill(fillColor,0.5);
			sprite.graphics.drawRect(0,0,width-1,height-1);
			sprite.graphics.endFill();
			sprite.width=width;
			sprite.height=height;
		}
		 private function DashedLine(x1:Number,y1:Number,x2:Number,y2:Number, len:Number, gap:Number):void {
				   var seglen:Number = len + gap ;
				   var deltax:Number = x2-x1; 
				   var deltay:Number = y2-y1; 
				   var dist:Number = Math.sqrt(deltax*deltax+deltay*deltay);
				   var noOfSegs:Number =  Math.floor(Math.abs(dist/seglen));
				   var angle:Number = Math.atan2(deltay,deltax);
				   var cx:Number = x1;
				   var cy:Number = y1;
				   deltax = Math.cos(angle)*seglen;
				   deltay = Math.sin(angle)*seglen;
				   sprite.graphics.lineStyle(4, strokeColor);
				   for (var n:Number = 0; n < noOfSegs; n++) {
						sprite.graphics.moveTo(cx,cy);
						sprite.graphics.lineTo(cx+Math.cos(angle)*len,cy+Math.sin(angle)*len);
						cx += deltax;
						cy += deltay;
				   }
				   sprite.graphics.moveTo(cx,cy);
				   var delta:Number = Math.sqrt((x2-cx)*(x2-cx)+(y2-cy)*(y2-cy));
				   if(delta>len){
					   sprite.graphics.lineTo(cx+Math.cos(angle)*len,cy+Math.sin(angle)*len);
				   } else if(delta>0) {
					   sprite.graphics.lineTo(cx+Math.cos(angle)*delta,cy+Math.sin(angle)*delta);
				   }
				   sprite.graphics.moveTo(x2,y2);
        }
        public function commentPoint():Point{
        	trace("Position : "+this.parent.localToGlobal(new Point(this.x,this.y)));
        	return this.parent.localToGlobal(new Point(this.x,this.y));
        }
	}
}