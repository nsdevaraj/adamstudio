package com.adams.dt.view.PDFTool
{
	import com.adams.dt.event.PDFTool.CommentEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;

	public class SVGDrawTool extends Canvas
	{
		//...........Variables, Constant and Objects...................
		public static const NONE:Number = 0;
		public static const LINE:Number = 1;
		public static const BRUSH:Number = 2;
		public static const HIGHLIGHT:Number = 3;
		public static const RECTANGLE:Number = 4;
		public static const OVAL:Number = 5;
		public static const ERASE:Number = 6;
		public static const CLEAR:Number = 7;
		
		public var displayUIComp:UIComponent = new UIComponent();
		private var drawSprite:DrawingSprite;
		private var x0:Number = 0;
		private var y0:Number = 0;
		
		private var _enabled:Boolean;
		override public function set enabled (value:Boolean):void
		{
			_enabled = value;
			this.DRAW = NONE;
			
		}
		
		override public function get enabled ():Boolean
		{
			return _enabled;
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

		
		private var _fillColor:uint;
		public function set fillColor (value:uint):void
		{
			_fillColor = value;
		}

		public function get fillColor ():uint
		{
			return _fillColor;
		}
		
		private var _highlightColor:uint;
		public function set highlightColor (value:uint):void
		{
			_highlightColor = value;
		}

		public function get highlightColor ():uint
		{
			return _highlightColor;
		}

		
		private var _strokeAlpha:Number;
		public function set strokeAlpha (value:Number):void
		{
			_strokeAlpha = (value>=0 && value<=1)?value:((value<0)?0:1);
		}

		public function get strokeAlpha ():Number
		{
			return _strokeAlpha;
		}

		
		private var _fillAlpha:Number;
		public function set fillAlpha (value:Number):void
		{
			_fillAlpha = value;
		}

		public function get fillAlpha ():Number
		{
			return _fillAlpha;
		}
		
		private var svgData:String="";
		
		private var _DRAW:Number;
		public function set DRAW (value:Number):void
		{
			//_DRAW = value;
			trace("Draw :"+(value == CLEAR)+"::: "+value);
			_DRAW = value;// = (value>=NONE && value<=ERASE)?value:((value<NONE)?LINE:OVAL);
			if(value == NONE){
				this.mouseChildren = false;
				this.mouseEnabled = true;
				this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseAction);
			}
			if(value == ERASE){
				this.mouseChildren = true;
				this.mouseEnabled = false;
				this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseAction);
			}
			if(value != ERASE && value != NONE){
				this.mouseChildren = false;
				this.mouseEnabled = true;
				this.addEventListener(MouseEvent.MOUSE_DOWN,mouseAction);
			}
			if(value == CLEAR){
				clearDrawing();
			}
		}

		public function get DRAW ():Number
		{
			return _DRAW;
		}

		//...........Variables, Constant and Objects...................
		//.....................Constructor .........................
		public function SVGDrawTool()
		{
			super();
			this.fillAlpha=0.5
			this.strokeAlpha=1;
			this.strokeColor = 0x000000;
			this.fillColor = 0xffff00;
			this.highlightColor = 0xff6600;
			this.addChild(displayUIComp);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseAction);
			this.addEventListener(ResizeEvent.RESIZE,resizeAction);
		}
		//.....................Constructor .........................
		//.................Mouse Event Listener.....................
		private var drawFailed:Boolean=false;
		private function resizeAction(event:ResizeEvent):void{
			//displayUIComp.width=this.width;
			//displayUIComp.height=this.height;
			displayUIComp.invalidateDisplayList();
		}
		private function mouseAction(event:MouseEvent):void{
			var dx:Number=0;
			var dy:Number=0;
			if(event.type == MouseEvent.MOUSE_DOWN){
				drawSprite = new DrawingSprite;
				drawSprite.addEventListener(MouseEvent.MOUSE_UP,spriteMouseEvent);
				drawSprite.addEventListener(MouseEvent.MOUSE_OVER,spriteMouseEvent);
				drawSprite.addEventListener(MouseEvent.MOUSE_OUT,spriteMouseEvent);
				drawSprite.removeEventListener(FlexEvent.REMOVE,spriteRemoveEvent);
				displayUIComp.addChild(drawSprite);
				dx = Math.round(event.localX);
				dy = Math.round(event.localY);
				x0=dx;
				y0=dy;
				this.addEventListener(MouseEvent.MOUSE_UP,mouseAction);
				this.addEventListener(MouseEvent.MOUSE_MOVE,mouseAction);
				 if(this.DRAW == BRUSH || this.DRAW == HIGHLIGHT){   
					drawSprite.graphics.moveTo(x0,y0);
					if(this.DRAW == HIGHLIGHT)drawSprite.graphics.lineStyle(5, this.highlightColor, 0.5);
					if(this.DRAW == BRUSH )drawSprite.graphics.lineStyle(2, this.strokeColor, this.strokeAlpha); 
				 }
				 switch(this.DRAW){
						case LINE:
							svgData ='<line style="stroke:#'+convertToRGB(this.strokeColor)+';stroke-width:2" ';
							drawFailed=true;
						break;
						case BRUSH:
							svgData='<path style="stroke:#'+convertToRGB(this.strokeColor)+';stroke-width:2" fill="none" d="M'+x0+' '+y0;
							drawFailed=true;
						break;
						case HIGHLIGHT:
							svgData='<path style="stroke:#'+convertToRGB(this.highlightColor)+';stroke-width:5;stroke-opacity:0.5" fill="none" d="M'+x0+' '+y0;
							drawFailed=true; 
						break; 
						case OVAL:
							svgData='<ellipse fill="'+convertToRGB(this.fillColor)+'" style="stroke:#'+convertToRGB(this.strokeColor)+';stroke-width:2;fill-opacity:0.5" ';
							drawFailed=true;
						break;
						case RECTANGLE:
							svgData='<rect fill="'+convertToRGB(this.fillColor)+'" style="stroke:#'+convertToRGB(this.strokeColor)+';stroke-width:2;fill-opacity:0.5" ';
							drawFailed=true;
						break;
				}
				 //
			}
			if(event.type == MouseEvent.MOUSE_MOVE){
				dx  = Math.round(event.localX);
				dy = Math.round(event.localY);
				
				var xVal:Number = (x0<dx)?x0:dx;
				var yVal:Number = (y0<dy)?y0:dy;
				if(0<dx && this.width>dx && 0<dy && this.height>dy ){
					
					if(this.DRAW!=BRUSH && this.DRAW!=HIGHLIGHT){				
						drawSprite.graphics.clear();
						drawSprite.graphics.lineStyle(2, this.strokeColor, this.strokeAlpha);
					}
					switch(this.DRAW){
						case LINE:
						drawSprite.graphics.moveTo(x0,y0);
						drawSprite.graphics.lineTo(x0,y0);
						drawSprite.graphics.lineTo(dx,dy);
						
						break;
						case BRUSH:
						drawSprite.graphics.lineTo(dx,dy);
						svgData += ' L'+dx+' '+dy;
						break;
						case HIGHLIGHT:
						drawSprite.graphics.lineTo(dx,dy);
						svgData += ' L'+dx+' '+dy;
						break; 
						case OVAL:
						drawSprite.graphics.beginFill(this.fillColor,this.fillAlpha);
						drawSprite.graphics.drawEllipse(dx,dy,(x0-dx),(y0-dy));
						drawSprite.graphics.endFill();
						break;
						case RECTANGLE:
						drawSprite.graphics.beginFill(this.fillColor,this.fillAlpha);
						drawSprite.graphics.drawRect(dx,dy,(x0-dx),(y0-dy));
						drawSprite.graphics.endFill();
						break;
					}
				}
				if(!event.buttonDown){
					CommitDrawing(event);
				}
			}
			if(event.type == MouseEvent.MOUSE_UP){
				CommitDrawing(event);
			}
		}
		private function CommitDrawing(event:MouseEvent):void{
			var dx:Number = Math.round(event.localX);
			var dy:Number = Math.round(event.localY);
			var xVal:Number = (x0<dx)?x0:dx;
			var yVal:Number = (y0<dy)?y0:dy;
			var widthVal:Number = Math.abs(x0-dx);
			var heightVal:Number = Math.abs(y0-dy);
			var DrawObject:String="";
			//trace("HeeBoo::::"+svgData.substring(1,svgData.indexOf(" ")));
			switch(svgData.substring(1,svgData.indexOf(" "))){
				case "line":
					svgData += 'x1="'+x0+'" y1="'+y0+'" x2="'+dx+'" y2="'+dy+'"/>';
					DrawObject="Line";
					if(x0==dx && y0==dy) drawFailed=false;
				break;
				case "path":
					svgData+= '"/>';
					DrawObject="Brush";
					if(svgData.indexOf("L")==-1) drawFailed=false;
				break;
				/* case HIGHLIGHT:
					svgData+= '"/>';
					DrawObject="Highlight";
					if(svgData.indexOf("L")==-1) drawFailed=false;
				break; */ 
				case "ellipse":
					svgData+= 'cx="'+(xVal+(widthVal/2))+'" cy="'+(yVal+(heightVal/2))+'" rx="'+widthVal/2+'" ry="'+heightVal/2+'"/>';
					DrawObject="Oval";
					if(widthVal==0 || heightVal==0) drawFailed=false;
				break;
				case "rect":
					svgData+= 'x="'+xVal+'" y="'+yVal+'" width="'+widthVal+'" height="'+heightVal+'"/>';
					DrawObject="Rectangle";
					if(widthVal==0 || heightVal==0) drawFailed=false;
				break;
			}
			if(drawFailed){
				drawFailed=false;
				var commentEvent:CommentEvent;
				commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, svgData, DrawObject,"0","0","0","0","0","2", "3", false, 0, 0);
				commentEvent.dispatch();
			}else{
				drawSprite.parent.removeChild(drawSprite);
			}
			this.removeEventListener(MouseEvent.MOUSE_MOVE,mouseAction);
			this.removeEventListener(MouseEvent.MOUSE_UP,mouseAction);
		}
		//.................Mouse Event Listener.....................
		//.....................Event Listener.....................
		public function convertToRGB(drawColor:uint):String {
				//trace(drawColor.toString(16));
				/* var r:String="";
				var b:String="";
				var g:String=""; */
				var hexColor:String=drawColor.toString(16);
				if (hexColor.length == 1) hexColor="000000";
				else if (hexColor.length == 4) hexColor="00"+hexColor;
				/* r=parseInt(hexColor.substr(0,2),16).toString();
				g=parseInt(hexColor.substr(2,2),16).toString();
				b=parseInt(hexColor.substr(4,2),16).toString(); */
				return hexColor;
		}
		private function spriteMouseEvent(event:MouseEvent):void{
			if(event.type==MouseEvent.MOUSE_OVER) Sprite(event.target).buttonMode=true;
			if(event.type==MouseEvent.MOUSE_OUT) Sprite(event.target).buttonMode=false;
			if(event.type==MouseEvent.MOUSE_UP)
			{
				var commentEvent:CommentEvent;
				commentEvent = new CommentEvent(CommentEvent.REMOVE_COMMENT, DrawingSprite(event.target).commentID);
				commentEvent.dispatch();	
			} 
			//Sprite(event.target).parent.removeChild(Sprite(event.target));
		}
		private function spriteRemoveEvent(event:FlexEvent):void{
				Sprite(event.target).removeEventListener(MouseEvent.MOUSE_OUT,spriteMouseEvent);
				Sprite(event.target).removeEventListener(MouseEvent.MOUSE_OVER,spriteMouseEvent);
				Sprite(event.target).removeEventListener(MouseEvent.MOUSE_UP,spriteMouseEvent);
				Sprite(event.target).removeEventListener(FlexEvent.REMOVE,spriteRemoveEvent);
		}
		private function clearDrawing():void{
			this.removeChild(displayUIComp);
			displayUIComp = new UIComponent();
			this.addChild(displayUIComp);
		}
		//.....................Event Listener.....................
		//....................Member Functions....................
		public function drawFromString(value:String, commentID:int):void{
				
				var pattern:RegExp = new RegExp("'",'gi');
				value=value.replace(pattern, '"');
				value=value.toLowerCase();
				var shape:String=value.substring(1,value.indexOf(" "));
				drawSprite = new DrawingSprite();
				displayUIComp.addChild(drawSprite);
				drawSprite.commentID=commentID;
				var stroke_cololr:String;
				var fill_cololr:String;
				if(shape=='line'){
					var x1:Number;
					var y1:Number;
					var x2:Number;
					var y2:Number;
					x1 = Number(value.substring(value.indexOf('x1=')+4,value.indexOf('"',value.indexOf('x1="')+5)));
					y1 = Number(value.substring(value.indexOf('y1=')+4,value.indexOf('"',value.indexOf('y1="')+5)));
					
					x2 = Number(value.substring(value.indexOf('x2=')+4,value.indexOf('"',value.indexOf('x2="')+5)));
					y2 = Number(value.substring(value.indexOf('y2=')+4,value.indexOf('"',value.indexOf('y2="')+5)));
					stroke_cololr=value.substr(value.indexOf('stroke:')+8,6);
					drawSprite.graphics.lineStyle(2, uint(Number("0x"+stroke_cololr)));
					drawSprite.graphics.moveTo(x1,y1);
					drawSprite.graphics.lineTo(x1,y1);
					drawSprite.graphics.lineTo(x2,y2);
				}
				if(shape=='rect'){
					trace("value "+value);
					var x:Number;
					var y:Number;
					var width:Number;
					var height:Number;
					x = Number(value.substring(value.indexOf('x=')+3,value.indexOf('"',value.indexOf('x="')+4)));
					y = Number(value.substring(value.indexOf('y=')+3,value.indexOf('"',value.indexOf('y="')+4)));
					
					width = Number(value.substring(value.indexOf('width=')+7,value.indexOf('"',value.indexOf('width="')+8)));
					height = Number(value.substring(value.indexOf('height=')+8,value.indexOf('"',value.indexOf('height="')+9)));

					stroke_cololr=value.substr(value.indexOf('stroke:')+8,6);
					fill_cololr=value.substr(value.indexOf('fill="')+6,6);
					drawSprite.graphics.lineStyle(2, uint(Number("0x"+stroke_cololr)));
					drawSprite.graphics.beginFill(uint(Number("0x"+fill_cololr)),0.5);
					drawSprite.graphics.drawRect(x,y,width,height); 
					drawSprite.graphics.endFill(); 
				}
				if(shape=='ellipse'){
					var cx:Number;
					var cy:Number;
					var rx:Number;
					var ry:Number;

					rx = Number(value.substring(value.indexOf('rx=')+4,value.indexOf('"',value.indexOf('rx="')+5)));
					ry = Number(value.substring(value.indexOf('ry=')+4,value.indexOf('"',value.indexOf('ry="')+5)));
					
					cx = Number(value.substring(value.indexOf('cx=')+4,value.indexOf('"',value.indexOf('cx="')+5)));
					cy = Number(value.substring(value.indexOf('cy=')+4,value.indexOf('"',value.indexOf('cy="')+5)));

					stroke_cololr=value.substr(value.indexOf('stroke:')+8,6);
					fill_cololr=value.substr(value.indexOf('fill="')+6,6);
					drawSprite.graphics.lineStyle(2, uint(Number("0x"+stroke_cololr)));
					drawSprite.graphics.beginFill(uint(Number("0x"+fill_cololr)),0.5);
					drawSprite.graphics.drawEllipse(cx-rx,cy-ry,rx*2,ry*2); 
					drawSprite.graphics.endFill(); 
				}    
				if(shape=='path'){
					var pValue:String;
					var mx:Number;
					var my:Number;
					var lx:Number;
					var ly:Number;
					var cursorposition:Number;
					
					pValue = value.substring(value.indexOf('d=')+3,value.indexOf('"',value.indexOf('d="')+4)).toUpperCase();
					mx = Number(pValue.substring(pValue.indexOf('M')+1,pValue.indexOf(' ',pValue.indexOf('M')+1)));
					cursorposition = pValue.indexOf(' ',pValue.indexOf('M')+1);
					
					stroke_cololr=value.substr(value.indexOf('stroke:')+8,6);
					drawSprite.graphics.lineStyle(2, uint(Number("0x"+stroke_cololr)));
					if(value.indexOf('stroke-opacity')!=-1) drawSprite.graphics.lineStyle(5, uint(Number("0x"+stroke_cololr)),0.5);
					
					my = Number(pValue.substring(cursorposition+1,pValue.indexOf(' ',cursorposition+1)));
					cursorposition = pValue.indexOf(' ',cursorposition+1);
					pattern = new RegExp("L",'gi');
					pValue=pValue.replace(pattern, '');
					var lineToArray:Array = [];
					lineToArray = pValue.split(" "); 
					drawSprite.graphics.moveTo(mx,my);
					
					for(var i:Number=2;i<lineToArray.length;i++){
						lx = lineToArray[i++];
						ly = lineToArray[i];
						drawSprite.graphics.lineTo(lx,ly);
					}	
				}
				drawSprite.addEventListener(MouseEvent.MOUSE_UP,spriteMouseEvent);
				drawSprite.addEventListener(MouseEvent.MOUSE_OVER,spriteMouseEvent);
				drawSprite.addEventListener(MouseEvent.MOUSE_OUT,spriteMouseEvent); 
		}
		//....................Member Functions....................
	}
}