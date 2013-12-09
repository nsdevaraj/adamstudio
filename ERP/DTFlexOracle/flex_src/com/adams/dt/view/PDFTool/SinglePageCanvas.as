package com.adams.dt.view.PDFTool
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.model.ModelLocator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.effects.Fade;
	import mx.effects.easing.Sine;
	import mx.managers.CursorManager;

	[Event(name="pageAssetsPropertiesChange", type="flash.events.Event")]
	[Event(name="imgLoadingComplete", type="flash.events.Event")]
	[Event(name="zoomIn", type="flash.events.Event")]
	[Event(name="zoomOut", type="flash.events.Event")]

	public class SinglePageCanvas extends Canvas
	{
		//import flash.display.BitmapData;
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		private var img1:ImageSWF;
		public var img2:ImageSWF;
		
		private var imgCompare:Image;
		
		public var regionPointer:Image;
		
		public var commentCanvas:Canvas = new Canvas();
		public var drawingCanvas:Canvas = new Canvas(); 
		
		public var isLastCommentIsNew:Boolean = false;
		
		private var compareMode:Boolean=false;
		
		// CONSTANT Properties for Page
		public static const NONE:int=0;
		public static const NOTE:int=1;
		public static const DRAW:int=2;
		public static const ARROW:int=3;
		public static const SVG_NOTE:int=3;

		// CONSTANT Properties for Note Type
		
		
		
		public static const PAGE_ASSETS_PROPERTIES_CHANGE:String="pageAssetsPropertiesChange";
		public static const IMAGE_LOADING_COMPLETE:String="imgLoadingComplete";
		public static const ZOOM_IN:String="zoomIn";
		public static const ZOOM_OUT:String="zoomOut";
		
		// CONSTANT Properties for Drawing Shape
		public static const NONE_DRAW:String="noneDraw";
		public static const RECTANGLE:String="rect";
		public static const OVAL:String="ellipse";
		public static const LINE:String="line";
		public static const BRUSH:String="brush";
		public static const HIGHLIGHT:String="highlight";
		public static const ERASE:String="erase";
		public static const RECTANGLE_NOTE:String = "rectangleNote";
		public static const VERTICAL_NOTE:String = "verticalNote";
		public static const HORIZONTAL_NOTE:String = "horizontalNote";
		public static const SHAPE_NOTE:String = "shapeNote";
		
		public static const RECTANGLE_NOTE_INT:int = 1;
		public static const VERTICAL_NOTE_INT:int = 2;
		public static const HORIZONTAL_NOTE_INT:int = 3;
		public static const SHAPE_NOTE_INT:int = 4;
		
		public static const SHAPE_FIRST_NOTE_SPLITTER:String = "*@**"
		
		
		// Properties for PAN and Drag selection status
		private var panSelect:Boolean=false;
		private var dragStart:Boolean=false;
		private var drawingStart:Boolean=false;
		
		// Property for scale this object
		private var affineTransform:Matrix=new Matrix();
		
		private var pdfToggleTimer:Timer;
		
		private var showFadeEffect:Fade = new Fade();
		private var hideFadeEffect:Fade = new Fade();
		
		// General Properties 
		
		private var startX:Number=0;
		private var startY:Number=0;
		
		private var stopX:Number=0;
		private var stopY:Number=0;
		
		
		private var _minimumNoteWidth:Number;
		public function set minimumNoteWidth (value:Number):void
		{
			_minimumNoteWidth = value;
		}

		public function get minimumNoteWidth ():Number
		{
			return _minimumNoteWidth;
		}

		private var _minimumNoteHeight:Number;
		public function set minimumNoteHeight (value:Number):void
		{
			_minimumNoteHeight = value;
		}

		public function get minimumNoteHeight ():Number
		{
			return _minimumNoteHeight;
		}
				
		
		private var _focusAction:int;
		public function set focusAction (value:int):void
		{
			_focusAction = value;
			model.pdfDetailVO.focusAction = value;
			actionModeSelect();
		}

		public function get focusAction ():int
		{
			return _focusAction;
		}
		private var _commentType:String;
		[Bindable]
		public function set commentType (value:String):void
		{
			_commentType = value;
			if( value == RECTANGLE_NOTE || value == VERTICAL_NOTE || value == HORIZONTAL_NOTE )
			{
				focusAction = NOTE;
			}else if(value == NONE_DRAW){
				focusAction = NONE;				
			}
			else{
				focusAction = SVG_NOTE;
			}
			drawStartX = drawStartY = drawStopX = drawStopY = 0;
			this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP));
		}

		public function get commentType ():String
		{
			return _commentType;
		}

		private var _img1URL:String="";
		[Bindable]
		public function set img1URL (value:String):void
		{
			trace("img1URL Location")
			_img1URL = value;
			setInitialValue();
			img1.imgWidth = 0;
			img1.imgHeight = 0;
			img1.source = value;
			if(value.indexOf(".swf")!=-1){
				compareMode = true;
			}
			else
			{
				compareMode = false;
			}
		}

		public function get img1URL ():String
		{
			return _img1URL;
		}

		
		private var _img2URL:String;
		[Bindable]
		public function set img2URL (value:String):void
		{
			trace("img2URL Location")
			_img2URL = value;
			setInitialValue();
			img2.imgWidth = 0;
			img2.imgHeight = 0;
			img2.source = value;
		}

		public function get img2URL ():String
		{
			return _img2URL;
		}

		
		private var _imgWidth:Number=0;
		[Bindable]
		public function set imgWidth (value:Number):void
		{
			_imgWidth = value;
		}

		public function get imgWidth ():Number
		{
			return _imgWidth;
		}

		
		private var _imgHeight:Number=0;
		[Bindable]
		public function set imgHeight (value:Number):void
		{
			_imgHeight = value;
		}

		public function get imgHeight ():Number
		{
			return _imgHeight;
		}
		
		public static const PDF1:Number=1;
		public static const PDF2:Number=2;
		
		
		private var _selectPDF:Number;
		[Bindable]
		public function set selectPDF (value:Number):void
		{
			_selectPDF = value;
			onSelectPDF();
			
		}

		public function get selectPDF ():Number
		{
			return _selectPDF;
		}

		
		private var _scaleValue:Number;
		[Bindable]
		public function set scaleValue (value:Number):void
		{
			_scaleValue = value;
		}

		public function get scaleValue ():Number
		{
			return _scaleValue;
		}
		
		
		private var _regionXpos:Number = 0;
		[Bindable]
		public function set regionXpos (value:Number):void
		{
			_regionXpos = value;
			regionPointer.x = value;
		}

		public function get regionXpos ():Number
		{
			return _regionXpos;
		}

		private var _regionYpos:Number = 0;
		[Bindable]
		public function set regionYpos (value:Number):void
		{
			_regionYpos = value;
			regionPointer.y = value;
		}

		public function get regionYpos ():Number
		{
			return _regionYpos;
		}
		
		private var _strokeColor:uint;
		[Bindable]
		public function set strokeColor (value:uint):void
		{
			_strokeColor = value;
		}

		public function get strokeColor ():uint
		{
			return _strokeColor;
		}

		
		private var _fillColor:uint;
		[Bindable]
		public function set fillColor (value:uint):void
		{
			_fillColor = value;
		}

		public function get fillColor ():uint
		{
			return _fillColor;
		}

	
		public function SinglePageCanvas()
		{
			super();
			
			img1 = new ImageSWF();
			img2 = new ImageSWF();
			
			imgCompare = new Image();			
			regionPointer = new Image();			
		}

		override protected function createChildren():void
		{
			super.createChildren();
						
			addChild(img1);
			addChild(img2);
			
			addChild(imgCompare);
			
			addChild(commentCanvas);
			addChild(drawingCanvas); 
			
			addChild(regionPointer);
			
			commentCanvas.percentWidth=100;
			commentCanvas.percentHeight=100;
			
			drawingCanvas.percentWidth=100;
			drawingCanvas.percentHeight=100;
			
			pdfToggleTimer = new Timer(1000);
			
			selectPDF = PDF2;
			
			minimumNoteWidth = 5;
			minimumNoteHeight = 5;
			
			showFadeEffect.alphaFrom = 0
			showFadeEffect.alphaTo = 1
			hideFadeEffect.alphaFrom = 1  
			hideFadeEffect.alphaTo = 0
			showFadeEffect.duration = hideFadeEffect.duration = 200;
			showFadeEffect.easingFunction = hideFadeEffect.easingFunction = Sine.easeInOut;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutOver,false,0,true);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOutOver,false,0,true);
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel,false,0,true);
			
			// Register Event Listener for KEYBOARD action 
			this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyEvent,false,0,true); 
			this.addEventListener(KeyboardEvent.KEY_UP,onKeyEvent,false,0,true); 
			
			pdfToggleTimer.addEventListener(TimerEvent.TIMER, onPdfToggleTimer, false , 0 , true);
			
			regionPointer.source = ImageResourceEmbedClass.REGION_COMPARE;
			regionPointer.width = 95;
			regionPointer.height = 120;
			
			regionPointer.visible = false;
			
			img1.addEventListener(ImageSWF.IMAGE_LOAD_COMPLETE,onImageLoadComplete,false,0,true);
			img2.addEventListener(ImageSWF.IMAGE_LOAD_COMPLETE,onImageLoadComplete,false,0,true);
			
			regionPointer.addEventListener(MouseEvent.MOUSE_DOWN, onRegionPointerMouseAction,false,0,true);
			
			this.verticalScrollPolicy = "off";
			this.horizontalScrollPolicy = "off";
			
			commentCanvas.verticalScrollPolicy = "off";
			commentCanvas.horizontalScrollPolicy = "off";
			
			drawingCanvas.verticalScrollPolicy = "off";
			drawingCanvas.horizontalScrollPolicy = "off";
			
			strokeColor = 0xFF0000;
			fillColor = 0xFFFF00;
			
			setStyle("backgroundColor","#FFFFFF");
			
			focusAction = NONE;
			
			
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            //trace("commentCanvas : "+commentCanvas.width );
            //trace("commentCanvas : "+commentCanvas.height );
            
            commentCanvas.width = drawingCanvas.width =  _imgWidth;
            commentCanvas.height = drawingCanvas.height =  _imgHeight;
            
          positionPageToCenter();
            
        }
        override protected function measure() : void {
			super.measure();

            measuredHeight    = _imgHeight;
            measuredMinHeight = _imgHeight;
            measuredWidth     = _imgWidth;
            measuredMinWidth  = _imgWidth;
        } 
        private function invalidateAction():void{
        	invalidateProperties();
            invalidateSize();
                       
            invalidateDisplayList(); 
        }
        private function setInitialValue():void
        {
        	if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode=="FAB"){
				this.strokeColor = 0x990000;
				this.fillColor = 0x990000;
			}
			if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode=="CLT"){
				this.strokeColor = 0x000099;
				this.fillColor = 0x000099;
			}
			if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode=="OPE"){
				this.strokeColor = 0x005500;
				this.fillColor = 0x005500;
			}
        }
        private function positionPageToCenter():void
        {
        	if(!(this.parent.width<5)){
        		this.x = this.parent.width / 2 - (imgWidth*rotateScaleValue())/2;
        	}else
        	{
        		this.x = 25;
        	}
        	if(!(this.parent.height<5)){
				this.y = this.parent.height / 2 - (imgHeight*rotateScaleValue())/2;
        	}else
        	{
        		this.y = 25;
        	}
			dispatchEvent(new Event(PAGE_ASSETS_PROPERTIES_CHANGE));
        }
        public function resetAll():void
		{
			trace("Welcome to resetAll");
			rotateZero(); 
			this.x = 0;
			this.y = 0;
			var sVal:Number = imgHeight / this.parent.height;
			 if(sVal!=0){ 
				if(this.parent.height>imgHeight*rotateScaleValue()+100)
				{
					fitToHeight(true);
				}
				else 
				{
					fitToHeight(false);
				}
			}  
			this.x = this.parent.width / 2 - (imgWidth*rotateScaleValue())/2;
			this.y = this.parent.height / 2 - (imgHeight*rotateScaleValue())/2;  
			dispatchEvent(new Event(PAGE_ASSETS_PROPERTIES_CHANGE));
		}
		public function resetInit():void
		{
			trace("Welcome to resetInit");
			rotateZero(); 
			this.x = 25;
			this.y = 25;
			
			dispatchEvent(new Event(PAGE_ASSETS_PROPERTIES_CHANGE)); 
			
		}
		private function fitToHeight(zoom:Boolean):void
		{
			if(zoom){
				while(this.parent.height>imgHeight*rotateScaleValue()+100){
					scaleAt(6/5, 0, 0 );
				}
			}else
			{
				while(this.parent.height<imgHeight*rotateScaleValue()){
					scaleAt(5/6, 0, 0 );
				}
			}
		}
		private var newx:int;
		private var newy:int;
		public function onRotate(rotateClockwise:Boolean = true):void{
			if((imgWidth*rotateScaleValue()<this.parent.width) || (imgHeight*rotateScaleValue()<this.parent.height))
			{
				pagePositionToCenter();
			}
			rotateAt(((rotateClockwise)?90:-90)*(Math.PI/180),this.parent.width/2, this.parent.height/2); 
			//pagePositionToCenter();
		}
		private function pagePositionToCenter():void
		{
			switch(Math.round(this.rotation)){
				case 0:
					newx = this.parent.width/2 - (imgWidth*rotateScaleValue())/2;
					newy = this.parent.height/2 - (imgHeight*rotateScaleValue())/2;
				break;
				
				case 90:
					newx = this.parent.width/2 + (imgHeight*rotateScaleValue())/2;
					newy = this.parent.height/2 - (imgWidth*rotateScaleValue())/2;
				break;
				
				case 180:
					newx = this.parent.width/2 + (imgWidth*rotateScaleValue())/2;
					newy = this.parent.height/2 + (imgHeight*rotateScaleValue())/2;
				break;
				
				case -180:
					newx = this.parent.width/2 + (imgWidth*rotateScaleValue())/2;
					newy = this.parent.height/2 + (imgHeight*rotateScaleValue())/2;
				break;
				
				case -90:
					newx = this.parent.width/2 - (imgHeight*rotateScaleValue())/2;
					newy = this.parent.height/2 + (imgWidth*rotateScaleValue())/2;
				break;
			}
			this.x = newx;
			this.y = newy;
			//dispatchEvent(new Event(PAGE_ASSETS_PROPERTIES_CHANGE));
		}
		public function onZoom(zoomIn:Boolean = true):void{
			pagePositionToCenter();
			if(zoomIn)
			{
				scaleAt(6/5, this.parent.width/2, this.parent.height/2 );
				dispatchEvent(new Event(ZOOM_IN))
			}
			else
			{
				scaleAt(5/6, this.parent.width/2, this.parent.height/2 );
				dispatchEvent(new Event(ZOOM_OUT))
			} 
			//pagePositionToCenter();
		}
		private function onMouseDown( event : MouseEvent ) : void
		{
			this.setFocus(); 
			if(panSelect){
				//CursorManager.removeAllCursors();
				trace("Good Rotation : "+Math.round(this.rotation));
				//CursorManager.setCursor(ImageResourceEmbedClass.CURSOR_CLOSE_ICON, CursorManagerPriority.HIGH);
				var wVal:Number = (Math.round(this.rotation) == 0 || Math.round(this.rotation) == -180 || Math.round(this.rotation) == 180)?this.width*rotateScaleValue():this.height*rotateScaleValue();
				var hVal:Number = (Math.round(this.rotation) == 0 || Math.round(this.rotation) == -180 || Math.round(this.rotation) == 180)?this.height*rotateScaleValue():this.width*rotateScaleValue();
				var widthValue:Number=(Math.round(this.rotation)==0 || Math.round(this.rotation)==-90)?wVal:0;
				var heightValue:Number=(Math.round(this.rotation)==0 || Math.round(this.rotation)==90)?hVal:0;
				var startWidthValue:Number=(Math.round(this.rotation)==-180 || Math.round(this.rotation)==90)?wVal:0;
				var startHeightValue:Number=(Math.round(this.rotation)==-180 || Math.round(this.rotation)==-90)?hVal:0;
				startDrag(false,new Rectangle(startWidthValue,startHeightValue,(this.parent.width-startWidthValue)-widthValue,(this.parent.height-startHeightValue)-heightValue));
				dragStart=true;
			}else{
				if(this.focusAction==NOTE)
				{
					drawingStart=true;
					startX = this.mouseX;
					startY = this.mouseY;
				}
				if(this.focusAction==SVG_NOTE)
				{
					drawShape(commentType , event.type);
				}
			}
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false,0,true);
		}
		private var PAGE_DRAG_ON_BUT_MOUSE_OUT:Boolean = false;
		private function onMouseOutOver(event:MouseEvent):void
		{
			 if(event.type == MouseEvent.MOUSE_OUT){
			 	if(this.dragStart)
				{	
					this.setFocus();
					//this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
					stopDrag();
					dispatchEvent(new Event(PAGE_ASSETS_PROPERTIES_CHANGE)); 
					
					PAGE_DRAG_ON_BUT_MOUSE_OUT = true;
					return;
				} 
			 }
			 
			 if(event.type == MouseEvent.MOUSE_OVER){
			 	if(event.buttonDown && this.dragStart)
				{
					this.setFocus();
					this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			 		PAGE_DRAG_ON_BUT_MOUSE_OUT = false;
				}	
			 }
		}
		
		private function onMouseUp( event : MouseEvent ) : void
		{
			//CursorManager.removeAllCursors();
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			
			//this.drawingCanvas.graphics.clear();
			stopX = this.mouseX;
			stopY = this.mouseY;
			if(panSelect)
			{
				stopDrag();
				this.drawingCanvas.graphics.clear();
				
			}
			else{
				if(this.focusAction==NOTE && !this.dragStart && drawingStart)
				{
					if(Math.abs(startX-stopX) > minimumNoteWidth || Math.abs(startY-stopY) > minimumNoteHeight)
					{
						drawingStart=false;
						var cType:String = (commentType == RECTANGLE_NOTE)?String(RECTANGLE_NOTE_INT):(commentType == VERTICAL_NOTE)?String(VERTICAL_NOTE_INT):String(HORIZONTAL_NOTE_INT);
						var cXpos:String = String((commentType == RECTANGLE_NOTE || commentType == HORIZONTAL_NOTE)?((startX<stopX)?startX:stopX):startX);
						var cYpos:String = String((commentType == RECTANGLE_NOTE || commentType == VERTICAL_NOTE)?((startY<stopY)?startY:stopY):startY);
						var cWidth:String = String((commentType == RECTANGLE_NOTE || commentType == HORIZONTAL_NOTE)?Math.abs(startX-stopX):5);
						var cHeight:String = String((commentType == RECTANGLE_NOTE || commentType == VERTICAL_NOTE)?Math.abs(startY-stopY):5);
						var commentEvent:CommentEvent;
						commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, "", "", cXpos , cYpos ,cWidth,cHeight, "0x"+convertToRGB(this.fillColor), "2", cType, false,ModelLocator.getInstance().person.personId, Math.random()*200, Math.random()*200, true,GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel);
						commentEvent.dispatch();
						isLastCommentIsNew = true;
						startX = startY = stopX = stopY = 0;
					}else{
						//trace("Start X and Stop X are minimum Value!");
						this.drawingCanvas.graphics.clear();
					}
				}
				if(this.focusAction==SVG_NOTE && !this.dragStart)
				{
					drawShape(commentType , event.type);
					
				}
				drawStartX = drawStartY = drawStopX = drawStopY = 0;
			}
			dragStart=false;
		}
		
		private function onMouseMove( event : MouseEvent ):void
		{
			if(this.focusAction==SVG_NOTE && !this.dragStart)
			{
				drawShape(commentType , event.type);
			}
			if(!event.buttonDown && this.dragStart)
			{	
				this.setFocus();
				trace("on Mouse Move");
				this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
				return;
			}
			if(!panSelect) 
			{
				this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP));
			}
			if(this.focusAction==NOTE && !this.dragStart)
			{
				this.drawingCanvas.graphics.clear();
				this.drawingCanvas.graphics.lineStyle(2,0);
				var widthVal:Number=0;
				var heightVal:Number=0;
				widthVal = (commentType == RECTANGLE_NOTE || commentType == HORIZONTAL_NOTE)?this.mouseX-this.startX:2;
				heightVal = (commentType == RECTANGLE_NOTE || commentType == VERTICAL_NOTE)?this.mouseY-this.startY:2;
				this.drawingCanvas.graphics.drawRect(this.startX,this.startY,widthVal,heightVal);
			}
			if(event.buttonDown && this.dragStart)
			{
				dispatchEvent(new Event(PAGE_ASSETS_PROPERTIES_CHANGE));
			}
		}
		
		private	function onMouseWheel( event : MouseEvent ) : void
		{
			var originX : Number = this.parent.mouseX;
			var originY : Number = this.parent.mouseY;
			
			if( !event.altKey )
			{
				if( event.delta > 0 )
				{
					scaleAt(6/5, originX, originY );
					dispatchEvent(new Event(ZOOM_IN))
				}
				else
				{
					scaleAt(5/6, originX, originY );
					dispatchEvent(new Event(ZOOM_OUT))
				}
			}else
			{
				rotateAt(((event.delta>0)?90:-90)*(Math.PI/180),originX, originY);
			}
		}
		public function scaleAt( scale : Number, originX : Number, originY : Number, mode:String = "Self") : void
		{
			affineTransform = transform.matrix;
			affineTransform.translate( -originX, -originY );
			affineTransform.scale( scale, scale );
			affineTransform.translate( originX, originY );
			transform.matrix = affineTransform;
			if(mode == "Self")
			dispatchEvent(new Event(PAGE_ASSETS_PROPERTIES_CHANGE));
		}
		// rotateAt Function is used to rotate PageContainer Object
		//;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		// For Width : "this.rotate"
		// Here 
		public function rotateAt( angle : Number, originX : Number, originY : Number ) : void
        {
        	
            affineTransform = transform.matrix
            affineTransform.translate( -originX, -originY )
            affineTransform.rotate( angle )
            affineTransform.translate( originX, originY )
            transform.matrix = affineTransform
        
            dispatchEvent(new Event(PAGE_ASSETS_PROPERTIES_CHANGE));
        }
         public function rotateScaleValue():Number
        {
        	var tempTransform:Matrix= new Matrix();
        	tempTransform = transform.matrix
        	tempTransform.rotate( ((360-this.rotation)*(Math.PI/180)) )
            return tempTransform.a; 
        } 
        public function rotateZero():void
        {
        	var tempTransform:Matrix= new Matrix();
        	tempTransform = transform.matrix
        	tempTransform.rotate( ((360-this.rotation)*(Math.PI/180)) )
            transform.matrix = tempTransform;
        }
        private function onKeyEvent(event:KeyboardEvent):void
		{
			trace("event.keyCode"+event.keyCode);
			if(event.type==KeyboardEvent.KEY_DOWN)
			{
				if(event.keyCode == 32){
					//if(!dragStart)
					if(!panSelect)
					commentCanvas.mouseChildren = commentCanvas.mouseEnabled = false;
					drawingCanvas.mouseChildren = drawingCanvas.mouseEnabled = false;
					
					this.useHandCursor = this.buttonMode = true;
					panSelect=true;
					
				}
				(this.parent as MasterContainer).externalCanvas.mouseChildren = false;
				(this.parent as MasterContainer).externalCanvas.mouseEnabled = false;
				this.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyEvent);
			}
			
			if(event.type==KeyboardEvent.KEY_UP)
			{
					panSelect=false;
					if(dragStart){
						stopDrag();
					}
					(this.parent as MasterContainer).externalCanvas.mouseChildren = true;
					(this.parent as MasterContainer).externalCanvas.mouseEnabled = true;
					
					commentCanvas.mouseChildren = commentCanvas.mouseEnabled = true;
					drawingCanvas.mouseChildren = drawingCanvas.mouseEnabled = true;
					dragStart=false;
					this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyEvent,false,0,true); 
					this.useHandCursor = this.buttonMode = false;
					CursorManager.removeAllCursors();
			}  
		}
		private var xDifference:Number = 0;
		private function onImageLoadComplete(event : Event):void
		{
			if(compareMode){
				imgWidth = (img1.imgWidth > img2.imgWidth)? img1.imgWidth : img2.imgWidth;
				imgHeight = (img1.imgHeight > img2.imgHeight)? img1.imgHeight : img2.imgHeight;
			}else{
				imgWidth =  img2.imgWidth;
				imgHeight =  img2.imgHeight;
			}
			dispatchEvent(new Event(IMAGE_LOADING_COMPLETE));
		 	resetInit();
		 
			invalidateAction();		
		}
		
		private function onPdfToggleTimer(event : TimerEvent):void
		{
			if(this.selectPDF==PDF1){
				this.selectPDF = PDF2;
			}else{
				this.selectPDF = PDF1;
			}
			MasterContainer(this.parent).selectPDF = this.selectPDF;
		}
		
		public function togglePDF(value : Boolean):void{
			if(value){
				/* img1.setStyle("showEffect", showFadeEffect);
				img1.setStyle("hideEffect", hideFadeEffect);
				
				img2.setStyle("showEffect", showFadeEffect);
				img2.setStyle("hideEffect", hideFadeEffect); */
				pdfToggleTimer.start();
			}else{
				/* img1.clearStyle("showEffect");
				img1.clearStyle("hideEffect");
				
				img2.clearStyle("showEffect");
				img2.clearStyle("hideEffect"); */
				
				pdfToggleTimer.stop();
			}
			
		}
		
		private function onSelectPDF():void
		{
			if(this.selectPDF==PDF1)
			{
				img2.visible=!(img1.visible=true);	
			}
			else
			{
				img2.visible=!(img1.visible=false);
			}
		}
		
		private function actionModeSelect():void
		{
			switch(this.focusAction)
			{
				case NOTE:
					trace("Note Action");
				break;
				case DRAW:
					trace("Draw Action");
				break;
				case ARROW:
					trace("Arrow Action");
				break;
				case NONE:
					this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
					this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				break;	
			}
		}
		private var drawStartX:Number=0;
		private var drawStartY:Number=0;
		private var drawStopX:Number=0;
		private var drawStopY:Number=0;

		private var svgData:String = "";
		private var shapeNoOfPoint:Number = 0;
		private var drawStart:Boolean = false;
		private function drawShape(shape:String, mouseType:String):void
		{
			trace("Start X : "+drawStartX+" ::: "+drawStartY+" :: "+drawStopX+" :: "+drawStopY)
				if(mouseType == MouseEvent.MOUSE_DOWN)
				{
					drawStartX = this.mouseX;
					drawStartY = this.mouseY;
					drawStart = true;
					svgData = "";
					shapeNoOfPoint = 0;
					trace(convertToRGB(this.fillColor) +" ::fillColor:: "+this.fillColor)
					svgData='<'+shape+' fill="#'+convertToRGB(this.fillColor)+'" style="stroke:#'+convertToRGB(this.strokeColor)+';stroke-width:2;fill-opacity:0.5" '
					if(shape == HIGHLIGHT || shape == BRUSH)
					{
						(shape == BRUSH)?this.drawingCanvas.graphics.lineStyle(2,strokeColor,1):this.drawingCanvas.graphics.lineStyle(5,fillColor,0.5);
						this.drawingCanvas.graphics.moveTo(drawStartX, drawStartY);
						var ifHL:String = ((shape == HIGHLIGHT)?"stroke-opacity:0.5":"")
						svgData='<path style="stroke:#'+convertToRGB(this.fillColor)+';stroke-width:5;'+ifHL+'" fill="none" d="M'+drawStartX+' '+drawStartY;
					}
					
				}
				if(mouseType == MouseEvent.MOUSE_MOVE)
				{
					drawStopX = this.mouseX;
					drawStopY = this.mouseY;
					
					if(shape == HIGHLIGHT || shape == BRUSH)
					{
						var pos:Number = (shape == HIGHLIGHT)?3:0
						this.drawingCanvas.graphics.lineTo(drawStopX-pos , drawStopY-pos);
						svgData += ' L'+(drawStopX-pos)+' '+(drawStopY-pos);
						shapeNoOfPoint++;
					}
					else{
						this.drawingCanvas.graphics.clear();
						this.drawingCanvas.graphics.lineStyle(2,strokeColor,1);
						this.drawingCanvas.graphics.beginFill(fillColor, 0.5);	
					}
					if(shape == RECTANGLE)
					{
						this.drawingCanvas.graphics.drawRect(drawStartX, drawStartY, drawStopX-drawStartX, drawStopY-drawStartY);
					}
					if(shape == OVAL)
					{					
						this.drawingCanvas.graphics.drawEllipse( drawStartX, drawStartY, drawStopX-drawStartX, drawStopY-drawStartY);
					}
					if(shape == LINE)
					{
						this.drawingCanvas.graphics.moveTo(drawStartX , drawStartY);
						this.drawingCanvas.graphics.lineTo(drawStopX , drawStopY);
					}
				}
				if(mouseType == MouseEvent.MOUSE_UP)
				{
					if(drawStart){
						drawStopX = this.mouseX;
						drawStopY = this.mouseY;
					}
					
					var xVal:Number = (drawStartX<drawStopX)?drawStartX:drawStopX;
					var yVal:Number = (drawStartY<drawStopY)?drawStartY:drawStopY;
					var widthVal:Number = Math.abs(drawStartX-drawStopX);
					var heightVal:Number = Math.abs(drawStartY-drawStopY);
					var xPos:Number = 0;
					var yPos:Number = 0;
					if(shape == LINE)
					{
						svgData += 'x1="'+drawStartX+'" y1="'+drawStartY+'" x2="'+drawStopX+'" y2="'+drawStopY+'"/>';
						xPos = drawStartX;
						yPos = drawStartY;
					}
					if(shape == RECTANGLE)
					{
						svgData+= 'x="'+xVal+'" y="'+yVal+'" width="'+widthVal+'" height="'+heightVal+'"/>';
						xPos = xVal;
						yPos = yVal;
					}
					if(shape == OVAL)
					{
						svgData+= 'cx="'+(xVal+(widthVal/2))+'" cy="'+(yVal+(heightVal/2))+'" rx="'+widthVal/2+'" ry="'+heightVal/2+'"/>';
						xPos = xVal;
						yPos = yVal+heightVal/2;
					}
					if(shape == HIGHLIGHT || shape == BRUSH)
					{
						svgData+= '"/>';
						xPos = drawStartX;
						yPos = drawStartY;
					}
					if(Math.abs(drawStartX-drawStopX) > minimumNoteWidth || Math.abs(drawStartY-drawStopY) > minimumNoteHeight || shapeNoOfPoint>7)
					{
						var commentEvent:CommentEvent;
						commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, svgData+SinglePageCanvas.SHAPE_FIRST_NOTE_SPLITTER, shape.substr(0,1).toUpperCase()+shape.substr(1) ,xPos.toString(),yPos.toString(),"0","0","0","2", "4", false, ModelLocator.getInstance().person.personId, (Math.random()*200+50), (Math.random()*200+50), false, GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel);
						//commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, svgData, shape.substr(0,1).toUpperCase()+shape.substr(1) ,"0","0","0","0","0","2", "4", false, ModelLocator.getInstance().person.personId, 0, 0, false, GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel);
						commentEvent.dispatch(); 
					}
					else{
						this.drawingCanvas.graphics.clear();
					}
					drawStart = false;
					shapeNoOfPoint = 0;
					drawStartX = drawStartY = drawStopX = drawStopY = 0;
					//trace(svgData);
				}
		}
		private function convertToRGB(drawColor:uint):String {
			var hexColor:String=drawColor.toString(16);
			if (hexColor.length == 1) {
				hexColor="000000";
			}
			else if (hexColor.length == 2) 
			{
				hexColor="0000"+hexColor;
			}
			else if (hexColor.length == 4) 
			{
				hexColor="00"+hexColor;
			}
			return hexColor;
		}
		private function onRegionPointerMouseAction(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_DOWN){
				regionPointer.startDrag(false,new Rectangle(0,0,this.width-50,this.height-50));
				regionPointer.addEventListener(MouseEvent.MOUSE_MOVE, onRegionPointerMouseAction,false,0,true);
				regionPointer.addEventListener(MouseEvent.MOUSE_UP, onRegionPointerMouseAction,false,0,true);
			}
			if(event.type == MouseEvent.MOUSE_MOVE){
				regionXpos = regionPointer.x;
				regionYpos = regionPointer.y;
			}
			if(event.type == MouseEvent.MOUSE_UP){
				event.target.stopDrag();
				regionPointer.removeEventListener(MouseEvent.MOUSE_MOVE, onRegionPointerMouseAction);
				regionPointer.removeEventListener(MouseEvent.MOUSE_UP, onRegionPointerMouseAction);
			}
		}
		public function onNormalCompare(doCompare:Boolean = true):void
		{
			if(doCompare){
				var bmd1 : BitmapData = new BitmapData(imgWidth, imgHeight);
				var bmd2 : BitmapData = new BitmapData(imgWidth, imgHeight);
				var content1:BitmapData= new BitmapData(imgWidth, imgHeight); 
				var UIMatrixMain1:Matrix = new Matrix();
				content1.draw((img1.swfloader.getChildAt(0) as Loader).content, UIMatrixMain1);
				bmd1.draw(content1 , UIMatrixMain1);
				if(!regionCompareStatus){
					var content2 : BitmapData= new BitmapData(imgWidth, imgHeight);
					var UIMatrixMain2:Matrix = new Matrix();
					content2.draw((img2.swfloader.getChildAt(0) as Loader).content, UIMatrixMain2);
					
					bmd2.draw(content2 , UIMatrixMain2);
				}else{
					bmd2 =  regionCompareImgBitmapData;	
				}
				if(bmd1.compare(bmd2) != 0 && bmd1.compare(bmd2) != -3 && bmd1.compare(bmd2) != -4 )
				{
					imgCompare.source = new Bitmap(BitmapData(bmd1.compare(bmd2)));
				}
				else
				{
					imgCompare.source = null;
				}
				imgCompare.visible = true;
				//regionCompareStatus = false;
				img1.visible = true;
				img2.visible = true;
				img1.alpha = 0;
				img2.alpha = 0;
				imgCompare.alpha = 1;
				bmd1 = bmd2 = content1 = content2 = new BitmapData(1,1); 
			}
			else{
				imgCompare.source = null;;
				img1.alpha = 1;
				img2.alpha = 1;
				imgCompare.alpha = 0;
				imgCompare.visible = false;
			}
		}
		public function onRegionReset():void
		{
			img2.swfMove(0, 0);
			regionCompareImgBitmapData = new BitmapData(1, 1);
			regionCompareStatus = false;
		}
		public function pdfAlphaControl(first:Number, second:Number, diff:Number):void
		{
			img1.alpha = first;
			img2.alpha = second;
			imgCompare.alpha = diff;
		}
		private var regionCompareImgBitmapData:BitmapData;
		private var regionCompareStatus:Boolean = false;
		public function onRegionCompare(xVal:Number = 0, yVal:Number = 0):void
		{
			img2.swfMove(xVal, yVal);
			regionCompareImgBitmapData = new BitmapData(imgWidth, imgHeight);
			var content:BitmapData= new BitmapData(imgWidth, imgHeight);
			var UIMatrixMain:Matrix = new Matrix();
	       	content.draw((img2.swfloader.getChildAt(0) as Loader).content, UIMatrixMain);
	       	var x1:Number = (xVal > 0)?0:Math.round(Math.abs(xVal));
	       	var x2:Number = (xVal > 0)?(imgWidth - Math.round(Math.abs(xVal))):imgWidth;
			var y1:Number = (yVal > 0)?0:Math.round(Math.abs(yVal));
	       	var y2:Number = (yVal > 0)?(imgHeight - Math.round(Math.abs(yVal))):imgHeight;
	       	var xPos:Number = (xVal > 0)?Math.round(Math.abs(xVal)):Math.round(Math.abs(xVal)) * -1;
	       	var yPos:Number = (yVal > 0)?Math.round(Math.abs(yVal)):Math.round(Math.abs(yVal)) * -1;
			for(var i:Number=x1;i<=x2;i++){
				for(var j:Number=y1;j<=y2;j++){
					regionCompareImgBitmapData.setPixel(i+xPos,j+yPos,content.getPixel(i,j));
				}
			}
			content = new BitmapData(1, 1);
			regionCompareStatus = true;
			
			onNormalCompare();
			/**--------------------- */
			
		}
		public var markersArr:Array = [];
		public var NoteNumbers:int = 1;
		public function DrawNoteCircle(x:Number,y:Number,NoteNumber:Number):void{
			
			var radius:Number= 15;
			 var label:Label = new Label();
            label.text=String(NoteNumbers);
			 NoteNumbers++;
			label.width = (radius*2)-2;
            label.setStyle("color", 0x000000);
			label.setStyle("fontSize", 12);
			label.setStyle("fontWeight", "bold");
			label.setStyle("color", 0xFF00FF);
			label.setStyle("textAlign", "center");
			label.setStyle('bottom', 5);
			label.setStyle('right',0);
     		var canvas:Canvas=new Canvas();
			canvas.width=radius * 2 + 20;
			canvas.height=radius * 2 + 20;
			var centerPointX:Number = radius+20;
			var centerPointY:Number = radius+20;
			//canvas.setStyle("backgroundColor","#FF0000");
			//canvas.setStyle("backgroundAlpha",0.5);
			var distance:Number = (225)*(Math.PI/180);
			var pX:int = centerPointX  + int(Math.round( radius * Math.sin( distance ) ) );
			var pY:int = centerPointY + int(Math.round( radius * Math.cos( distance ) ) );
			var pFrom:Point = new Point(pX, pY);
			var pTo:Point = new Point(0, 0)

			drawArrow(pFrom, pTo, canvas);
			canvas.graphics.lineStyle(3,0xFF00FF);
			//canvas.graphics.beginFill(0xFF00FF, 0.5);
			canvas.graphics.drawCircle(radius+20, radius+20, radius);
			canvas.graphics.endFill();
			canvas.x=x ;
			canvas.y=y ;
			canvas.visible = false;
			canvas.addChild(label);
			//canvas.filters = [new GlowFilter(0,1,2,2,30,30), new DropShadowFilter(8,45,0,0.75,8,8)];
			canvas.filters = [new DropShadowFilter(8,45,0,0.75,8,8)];
			img2.pdfCommentList.addChild(canvas);
			markersArr.push(canvas);
		}
		private function drawArrow(connectFrom : Point, connectTo : Point, drawedArea:*) : void
        {
            var centerFrom : Point = new Point();
            centerFrom.x = connectFrom.x ;
            centerFrom.y = connectFrom.y ;

            var centerTo : Point = new Point();
            centerTo.x = connectTo.x ;
            centerTo.y = connectTo.y ;

            var angleTo : Number =
                Math.atan2(centerTo.x - centerFrom.x, centerTo.y - centerFrom.y);
            var angleFrom : Number =
                Math.atan2(centerFrom.x - centerTo.x, centerFrom.y - centerTo.y);

            var pointFrom : Point = getBorderPointAtAngle(connectFrom, angleTo);
            var pointTo : Point = getBorderPointAtAngle(connectTo, angleFrom);

            var arrowSlope : Number = 30;
            var arrowHeadLength : Number = 10;
            var vector : Point =
                new Point(-(pointTo.x - pointFrom.x), -(pointTo.y - pointFrom.y));

            var edgeOneMatrix : Matrix = new Matrix();
            edgeOneMatrix.rotate(arrowSlope * Math.PI / 180);
            var edgeOneVector : Point = edgeOneMatrix.transformPoint(vector);
            edgeOneVector.normalize(arrowHeadLength);
            var edgeOne : Point = new Point();
            edgeOne.x = pointTo.x + edgeOneVector.x;
            edgeOne.y = pointTo.y + edgeOneVector.y;

            var edgeTwoMatrix : Matrix = new Matrix();
            edgeTwoMatrix.rotate((0 - arrowSlope) * Math.PI / 180);
            var edgeTwoVector : Point = edgeTwoMatrix.transformPoint(vector);
            edgeTwoVector.normalize(arrowHeadLength);
            var edgeTwo : Point = new Point();
            edgeTwo.x = pointTo.x + edgeTwoVector.x;
            edgeTwo.y = pointTo.y + edgeTwoVector.y;

            with(drawedArea.graphics) {
                lineStyle(3,0xFF00FF);
                
                moveTo(pointFrom.x, pointFrom.y);
                lineTo(pointTo.x, pointTo.y);

                lineTo(edgeOne.x, edgeOne.y);
                moveTo(pointTo.x, pointTo.y);
                lineTo(edgeTwo.x, edgeTwo.y);
            }
        }

        private function getBorderPointAtAngle(square : Point, angle : Number) : Point
        {
            var minRay : Number = Math.SQRT2 * 1 / 2;
            var maxRay : Number = 1 / 2;

            var rayAtAngle : Number = ((maxRay - minRay) * Math.abs(Math.cos(angle * 2))) + minRay;

            var point : Point = new Point();
            point.x = rayAtAngle * Math.sin(angle) + square.x + (1 / 2);
            point.y = rayAtAngle * Math.cos(angle) + square.y + (1 / 2);
            return point;
        }
		public function makeMarkersVisible():void{
			for (var i:int =0; i<markersArr.length; i++){
				markersArr[i].visible = true;
				 
			}
		}
		public function removeMarkers():void{
			for (var i:int =0; i<markersArr.length; i++){
				markersArr[i].visible = false;
				//if(markersArr[i]) if(markersArr[i].parent) markersArr[i].parent.removeChild(markersArr[i])
			}
			//markersArr = [];
		}
		public function drawFromString(value:String, commentObj:DrawingSprite):void{
				
				var pattern:RegExp = new RegExp("'",'gi');
				value=value.replace(pattern, '"');
				value=value.toLowerCase().split("***")[0];
				var shape:String=value.substring(1,value.indexOf(" "));
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
					commentObj.graphics.lineStyle(2, uint(Number("0x"+stroke_cololr)));
					commentObj.graphics.moveTo(x1,y1);
					commentObj.graphics.lineTo(x1,y1);
					commentObj.graphics.lineTo(x2,y2);
					if(commentObj.pdf == SinglePageCanvas.PDF2)
					{
						DrawNoteCircle(x1, y1,1);
					}
					
				}
				if(shape=='rect'){
					var x:Number;
					var y:Number;
					var width:Number;
					var height:Number;
					x = Number(value.substring(value.indexOf('x=')+3,value.indexOf('"',value.indexOf('x="')+4)));
					y = Number(value.substring(value.indexOf('y=')+3,value.indexOf('"',value.indexOf('y="')+4)));
					
					width = Number(value.substring(value.indexOf('width=')+7,value.indexOf('"',value.indexOf('width="')+8)));
					height = Number(value.substring(value.indexOf('height=')+8,value.indexOf('"',value.indexOf('height="')+9)));

					stroke_cololr=value.substr(value.indexOf('stroke:')+8,6);
					fill_cololr=value.substr(value.indexOf('fill="#')+7,6);
					commentObj.graphics.lineStyle(2, uint(Number("0x"+stroke_cololr)));
					commentObj.graphics.beginFill(uint(Number("0x"+fill_cololr)),0.5);
					commentObj.graphics.drawRect(x,y,width,height); 
					commentObj.graphics.endFill();
					if(commentObj.pdf == SinglePageCanvas.PDF2)
					{
						DrawNoteCircle(x, y,1);
					}
					
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
					fill_cololr=value.substr(value.indexOf('fill="#')+7,6);
					commentObj.graphics.lineStyle(2, uint(Number("0x"+stroke_cololr)));
					commentObj.graphics.beginFill(uint(Number("0x"+fill_cololr)),0.5);
					commentObj.graphics.drawEllipse(cx-rx,cy-ry,rx*2,ry*2); 
					commentObj.graphics.endFill(); 
					if(commentObj.pdf == SinglePageCanvas.PDF2)
					{
						DrawNoteCircle(cx-rx, cy-ry,1);
					}
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
					commentObj.graphics.lineStyle(2, uint(Number("0x"+stroke_cololr)));
					if(value.indexOf('stroke-opacity')!=-1) commentObj.graphics.lineStyle(5, uint(Number("0x"+stroke_cololr)),0.5);
					
					my = Number(pValue.substring(cursorposition+1,pValue.indexOf(' ',cursorposition+1)));
					cursorposition = pValue.indexOf(' ',cursorposition+1);
					pattern = new RegExp("L",'gi');
					pValue=pValue.replace(pattern, '');
					var lineToArray:Array = [];
					lineToArray = pValue.split(" "); 
					commentObj.graphics.moveTo(mx,my);
					
					for(var i:Number=2;i<lineToArray.length;i++){
						lx = lineToArray[i++];
						ly = lineToArray[i];
						commentObj.graphics.lineTo(lx,ly);
					}
					if(commentObj.pdf == SinglePageCanvas.PDF2)
					{
						DrawNoteCircle(mx, my,1);
					}
				}
				
		}
	/** Class End */	
	}
/** Package End */
}
