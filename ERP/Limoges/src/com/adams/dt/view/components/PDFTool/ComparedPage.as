package com.adams.dt.view.components.PDFTool
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import mx.graphics.SolidColor;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.primitives.Rect;
	
	[Event(name="scalePropertyChange", type="flash.events.Event")]
	public class ComparedPage extends Group
	{
		
		public static const SCALE_PROPERTY_CHANGE:String = "scalePropertyChange";
		
		private var panSelect:Boolean = false;
		
		private var dragAreaRectangle:Rectangle;
		private var rotationValue:int = 0;
		private var wVal:Number = 0;
		private var hVal:Number = 0;
		private var widthValue:Number= 0;
		private var heightValue:Number= 0;
		private var startWidthValue:Number= 0;
		private var startHeightValue:Number= 0;
		
		private var rectBackground:Rect;
		private var image:Image;
		
		private var _pageX:Number = 0;
		public function get pageX():Number
		{
			return _pageX;
		}
		
		[Bindable]
		public function set pageX(value:Number):void
		{
			_pageX = value;
			x = _pageX;
		}
		
		
		private var _pageY:Number = 0;
		public function get pageY():Number
		{
			return _pageY;
		}
		
		[Bindable]
		public function set pageY(value:Number):void
		{
			_pageY = value;
			y = _pageY;
		}
		
		private var _source:Object;
		public function get source():Object
		{
			return _source;
		}
		
		[Bindable]
		public function set source(value:Object):void
		{
			_source = value;
			image.source = _source;
		}

		
		public function ComparedPage()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(!rectBackground){
				rectBackground = new Rect();
				rectBackground.percentWidth = 100;
				rectBackground.percentHeight = 100;
				var solidColor:SolidColor = new SolidColor(0xFFFFFF);
				rectBackground.fill = solidColor;
				addElement(rectBackground);
			}
			if(!image)
			{
				image = new Image();
				image.smooth = true;
				addElement(image);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override protected function initializationComplete():void
		{
			super.initializationComplete();	
			
			addEventListener(MouseEvent.MOUSE_DOWN, comparePageMouseActionHandler);
			addEventListener(MouseEvent.MOUSE_OVER, comparePageMouseActionHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, comparePageMouseActionHandler);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardActionHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyboardActionHandler);
		}
		
		protected function comparePageMouseActionHandler(event:MouseEvent):void
		{
			if((event.type == MouseEvent.MOUSE_DOWN || event.type == MouseEvent.MOUSE_OVER) && event.buttonDown)
			{
				if(panSelect)
				{
					rotationValue = Math.round(this.rotation);
					wVal = (rotationValue == 0 || rotationValue == -180 || rotationValue == 180)?this.width*scaleX:this.height*scaleY;
					hVal = (rotationValue == 0 || rotationValue == -180 || rotationValue == 180)?this.height*scaleY:this.width*scaleX;
					widthValue =(rotationValue==0 || rotationValue==-90)?wVal:0;
					heightValue = (rotationValue==0 || rotationValue==90)?hVal:0;
					startWidthValue = (rotationValue==-180 || rotationValue==180 || rotationValue==90)?wVal:0;
					startHeightValue = (rotationValue==-180 || rotationValue==180 || rotationValue==-90)?hVal:0;
					dragAreaRectangle = new Rectangle(startWidthValue,startHeightValue,(this.parent.width-startWidthValue)-widthValue,(this.parent.height-startHeightValue)-heightValue);
					startDrag(false, dragAreaRectangle);
				}
				addEventListener(MouseEvent.MOUSE_MOVE, comparePageMouseActionHandler);
				addEventListener(MouseEvent.MOUSE_UP, comparePageMouseActionHandler);
				addEventListener(MouseEvent.MOUSE_OUT, comparePageMouseActionHandler);
			}
			else if(event.type == MouseEvent.MOUSE_MOVE)
			{
				pageX = x;
				pageY = y;
			}
			else if(event.type == MouseEvent.MOUSE_UP || event.type == MouseEvent.MOUSE_OUT)
			{
				stopDrag();
				removeEventListener(MouseEvent.MOUSE_OUT, comparePageMouseActionHandler);
				removeEventListener(MouseEvent.MOUSE_MOVE, comparePageMouseActionHandler);
				removeEventListener(MouseEvent.MOUSE_UP, comparePageMouseActionHandler);
			}
			else if(event.type == MouseEvent.MOUSE_WHEEL)
			{
				if(event.delta>0)
				{
					if(this.scaleX < 5)
						scaleAt(6/5, this.parent.mouseX, this.parent.mouseY );
				}
				else
				{
					if(this.scaleX > 0.3)
						scaleAt(5/6, this.parent.mouseX, this.parent.mouseY );
				}
			}
		}
		
		protected function keyboardActionHandler(event:KeyboardEvent):void
		{
			if(event.type == KeyboardEvent.KEY_DOWN){
				if(event.keyCode == Keyboard.SPACE){
					panSelect = true;
				}
				if(event.ctrlKey && event.keyCode == Keyboard.EQUAL)
				{
					if(this.scaleX < 5){
						if(parent.width > (width*scaleX) && parent.height > (height*scaleY))
						{
							alignPage()
						}
						scaleAt(6/5, (parent.width/2), (parent.height/2));
					}
				}
				if(event.ctrlKey && event.keyCode == Keyboard.MINUS)
				{
					if(this.scaleX > 0.3){
						if(parent.width > (width*scaleX) && parent.height > (height*scaleY)) {
							alignPage()
						}
						scaleAt(5/6, (parent.width/2), (parent.height/2));	
					}
				}
				else if(event.ctrlKey && event.keyCode == Keyboard.LEFT)
				{
					if(parent.width > (width*scaleX) && parent.height > (height*scaleY)) {
						alignPage()
					}
					rotateAt((-90)*(Math.PI/180), (parent.width/2), (parent.height/2));	
				}
				else if(event.ctrlKey && event.keyCode == Keyboard.RIGHT)
				{
					if(parent.width > (width*scaleX) && parent.height > (height*scaleY)) {
						alignPage()
					}
					rotateAt((90)*(Math.PI/180), (parent.width/2), (parent.height/2));	
				}
			}
			else if(event.type == KeyboardEvent.KEY_UP){
				if(panSelect){
					panSelect = false;
					stopDrag();	
				}
			}
		}
		
		public function scaleAt( scale : Number, originX : Number, originY : Number) : void
		{
			var affineTransform:Matrix = transform.matrix;
			affineTransform.translate( -originX, -originY );
			affineTransform.scale( scale, scale );
			affineTransform.translate( originX, originY );
			transform.matrix = affineTransform;
			dispatchEvent(new Event(SCALE_PROPERTY_CHANGE));
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function rotateAt( angle : Number, originX : Number, originY : Number ) : void
		{
			var affineTransform:Matrix = transform.matrix;
			affineTransform = transform.matrix
			affineTransform.translate( -originX, -originY )
			affineTransform.rotate( angle )
			affineTransform.translate( originX, originY )
			transform.matrix = affineTransform
			dispatchEvent(new Event(SCALE_PROPERTY_CHANGE));
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function alignPage():void
		{
			if(Math.round(this.rotation) == 0){
				pageX = parent.width/2 - (width*scaleX)/2;
				pageY = parent.height/2 - (height*scaleY)/2;
			}else if(Math.round(this.rotation) == 90){
				pageX = parent.width/2 + (height*scaleY)/2;
				pageY = parent.height/2 - (width*scaleX)/2;
			}else if(Math.round(this.rotation) == 180 || Math.round(this.rotation) == -180){
				pageX = parent.width/2 + (width*scaleX)/2;
				pageY = parent.height/2 + (height*scaleY)/2;
			}else if(Math.round(this.rotation) == -90){
				pageX = parent.width/2 - (height*scaleY)/2;
				pageY = parent.height/2 + (width*scaleX)/2;
			}
		}
		
	}
}