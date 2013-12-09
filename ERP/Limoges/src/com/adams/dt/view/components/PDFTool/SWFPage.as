package com.adams.dt.view.components.PDFTool
{
	import com.adams.dt.view.components.PDFTool.events.CommentCollectionEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import mx.controls.SWFLoader;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.Image;
	import spark.filters.DropShadowFilter;
	import spark.primitives.Rect;
	
	[Event(name="pageLoadComplete", type="flash.events.Event")]
	[Event(name="shapeDeselect", type="flash.events.Event")]
	[Event(name="scalePropertyChange", type="flash.events.Event")]
	[Event(name="positionPropertyChange", type="flash.events.Event")]
	[Event (type="commentCollectionUpdate",type="com.adams.dt.view.components.PDFTool.events.CommentCollectionEvent")]
	public class SWFPage extends BorderContainer
	{
		
		public static const PAGE_LOAD_COMPLETE:String = "pageLoadComplete";
		public static const SHAPE_DESELECT:String = "shapeDeselect";
		public static const SCALE_PROPERTY_CHANGE:String = "scalePropertyChange";
		public static const POSITION_PROPERTY_CHANGE:String = "positionPropertyChange";
		
		[Embed(source="assets/swf/additionalAssetsReader.swf#RegionPointerYellow")]
		private var regionPointerMC:Class;
		
		private var rectBorder:Rect;
		//private var img:Image;
		private var swfImage:SWFLoader;
		private var loader:Loader;
		public var shapeCommentContainer:ShapeComponentFXG;
		public var regionPointerImage:Image;
		private var urlReq:URLRequest = new URLRequest();
		private var tempShapeSelect:String = "";
		
		private var dragAreaRectangle:Rectangle;
		private var rotationValue:int = 0;
		private var wVal:Number = 0;
		private var hVal:Number = 0;
		private var widthValue:Number= 0;
		private var heightValue:Number= 0;
		private var startWidthValue:Number= 0;
		private var startHeightValue:Number= 0;
		
		private var panSelect:Boolean = false;
		
		private var _pageLoadStatus:Boolean = false;
		public function get pageLoadStatus():Boolean
		{
			return _pageLoadStatus;
		}
		
		private var _pageContent:*;
		public function get pageContent():*
		{
			return _pageContent;
		}
		
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
		
		private var _pageWidth:Number = 0;
		public function get pageWidth():Number
		{
			return _pageWidth;
		}
		
		public function set pageWidth(value:Number):void
		{
			_pageWidth = value;
			this.width = _pageWidth;
			invalidateDisplayList()
		}
		
		private var _pageHeight:Number = 0;
		public function get pageHeight():Number
		{
			return _pageHeight;
		}
		
		public function set pageHeight(value:Number):void
		{
			_pageHeight = value;
			this.height = _pageHeight;
			invalidateDisplayList()
		}
		
		private var _regionPointerVisible:Boolean = true;
		public function get regionPointerVisible():Boolean
		{
			return _regionPointerVisible;
		}
		
		[Bindable]
		public function set regionPointerVisible(value:Boolean):void
		{
			_regionPointerVisible = value;
			regionPointerImage.visible = value;
		}
		
		private var _regionPointerXPos:Number = 0;
		public function get regionPointerXPos():Number
		{
			return _regionPointerXPos;
		}
		
		[Bindable]
		public function set regionPointerXPos(value:Number):void
		{
			_regionPointerXPos = value;
			regionPointerImage.x = _regionPointerXPos;
		}
		
		private var _regionPointerYPos:Number = 0;
		public function get regionPointerYPos():Number
		{
			return _regionPointerYPos;
		}
		
		[Bindable]
		public function set regionPointerYPos(value:Number):void
		{
			_regionPointerYPos = value;
			regionPointerImage.y = _regionPointerYPos;
		}
		
		
		private var _imgWidth:Number = 0;
		public function get imgWidth():Number
		{
			return _imgWidth;
		}
		
		private var _imgHeight:Number = 0;
		public function get imgHeight():Number
		{
			return _imgHeight;
		}
		
		private var _shapeSelect:String;
		public function get shapeSelect():String
		{
			return _shapeSelect;
		}
		
		[Bindable]
		public function set shapeSelect(value:String):void
		{
			_shapeSelect = value;
			if(shapeCommentContainer)
				shapeCommentContainer.shapeSelected = _shapeSelect;
		}
		
		private var _shapeColor:uint;
		public function get shapeColor():uint
		{
			return _shapeColor;
		}
		
		[Bindable]
		public function set shapeColor(value:uint):void
		{
			_shapeColor = value;
			shapeCommentContainer.StrokeColor = _shapeColor;
			shapeCommentContainer.FillColor = _shapeColor;
		}
		
		
		
		private var _source:String = ""; 
		public function get source():String
		{
			return _source;
		}
		
		[Bindable]
		public function set source(value:String):void
		{
			_source = value;
			if(_source != ""){
				_pageLoadStatus = false;
				if( loader != null ){
					urlReq.url = _source;
					loader.load(urlReq);
				}
			}
		}
		
		private var _sourceByteArray:ByteArray;
		public function get sourceByteArray():ByteArray
		{
			return _sourceByteArray;
		}
		
		[Bindbale]
		public function set sourceByteArray(value:ByteArray):void
		{
			_sourceByteArray = value;
			if(_sourceByteArray != null){
				_pageLoadStatus = false;
				if( loader != null ){
					//urlReq.url = _source;
					loader.loadBytes(_sourceByteArray);
				}
			}
		}
		
		
		public function SWFPage()
		{
			super();
			
			sourceByteArray = new ByteArray();
			
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			/*if(!img)
			{
			img = new Image();
			addElement(img);
			}*/
			this.setStyle("backgroundColor","0xFFFFFF");
			contentGroup.clipAndEnableScrolling = true;
			if(!swfImage)
			{
				swfImage = new SWFLoader();
				swfImage.smoothBitmapContent = true;
				addElement(swfImage);
			}
			if(!shapeCommentContainer)
			{
				shapeCommentContainer = new ShapeComponentFXG();
				shapeCommentContainer.shapeSelected = _shapeSelect;
				addElement(shapeCommentContainer);
			}
			if(!rectBorder)
			{
				rectBorder = new Rect();
				var strokeColor:SolidColorStroke = new SolidColorStroke(0xFF00FF);
				rectBorder.stroke = strokeColor;
				addElement(rectBorder);
			}
			if(!regionPointerImage)
			{
				regionPointerImage = new Image();
				regionPointerImage.source = regionPointerMC;
				regionPointerImage.smooth = true;
				regionPointerImage.filters = [new DropShadowFilter(5,45,0,0.5,5,5)];
				addElement(regionPointerImage);
				regionPointerVisible = false;
			}
			if(!loader)
			{
				loader = new Loader();
				
				if(_sourceByteArray != null && _sourceByteArray.length>0){
					_pageLoadStatus = false;
					//urlReq.url = _source;
					loader.loadBytes(_sourceByteArray);
				}
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			}
		}
		
		override protected function initializationComplete():void
		{
			super.initializationComplete();	
			
			shapeSelect = ShapeComponentFXG.NONE;
			
			addEventListener(MouseEvent.MOUSE_DOWN, swfPageMouseActionHandler);
			addEventListener(MouseEvent.MOUSE_OVER, swfPageMouseActionHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, swfPageMouseActionHandler);
			
			shapeCommentContainer.addEventListener(CommentCollectionEvent.COMMENT_COLLECTION_UPDATE, commentCollectionChangeHandler);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardActionHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyboardActionHandler);
			
			regionPointerImage.addEventListener(MouseEvent.MOUSE_DOWN, regionPointerMouseActionHandler);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			shapeCommentContainer.width = imgWidth;
			shapeCommentContainer.height = imgHeight;
			rectBorder.width = imgWidth;
			rectBorder.height = imgHeight;
			
		}
		
		override protected function measure():void
		{
			super.measure();
			
		}
		
		protected function commentCollectionChangeHandler(event:CommentCollectionEvent):void
		{
			dispatchEvent(new CommentCollectionEvent(CommentCollectionEvent.COMMENT_COLLECTION_UPDATE,event.commentVO, event.commentItemName))
		}
		
		public function removeComment(commentName:String):void
		{
			
			shapeCommentContainer.removeComment( commentName );
		}
		
		public function removeAllComments():void
		{
			shapeCommentContainer.removeAllElements();
		}
		
		protected function swfPageMouseActionHandler(event:MouseEvent):void
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
				addEventListener(MouseEvent.MOUSE_MOVE, swfPageMouseActionHandler);
				addEventListener(MouseEvent.MOUSE_UP, swfPageMouseActionHandler);
				addEventListener(MouseEvent.MOUSE_OUT, swfPageMouseActionHandler);
			}
			else if(event.type == MouseEvent.MOUSE_MOVE)
			{
				pageX = x;
				pageY = y;
				dispatchEvent(new Event(POSITION_PROPERTY_CHANGE));
			}
			else if(event.type == MouseEvent.MOUSE_UP || event.type == MouseEvent.MOUSE_OUT)
			{
				stopDrag();
				removeEventListener(MouseEvent.MOUSE_OUT, swfPageMouseActionHandler);
				removeEventListener(MouseEvent.MOUSE_MOVE, swfPageMouseActionHandler);
				removeEventListener(MouseEvent.MOUSE_UP, swfPageMouseActionHandler);
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
		
		protected function regionPointerMouseActionHandler(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_DOWN)
			{
				event.currentTarget.startDrag(false, new Rectangle(0,0,width - regionPointerImage.width,height - regionPointerImage.height));
				event.currentTarget.addEventListener(MouseEvent.MOUSE_UP, regionPointerMouseActionHandler);
				event.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, regionPointerMouseActionHandler);
			}
			else if(event.type == MouseEvent.MOUSE_MOVE)
			{
				regionPointerXPos = event.currentTarget.x;
				regionPointerYPos = event.currentTarget.y;
			}
			else if(event.type == MouseEvent.MOUSE_UP)
			{
				event.currentTarget.stopDrag();
				event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, regionPointerMouseActionHandler);
				event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, regionPointerMouseActionHandler);
			}
		}
		
		protected function keyboardActionHandler(event:KeyboardEvent):void
		{
			if(event.type == KeyboardEvent.KEY_DOWN){
				if(event.keyCode == Keyboard.SPACE){
					panSelect = true;
					if(tempShapeSelect == "")
					{
						tempShapeSelect = shapeCommentContainer.shapeSelected;
					}
					shapeCommentContainer.shapeSelected = ShapeComponentFXG.NONE;
				}
				if(event.ctrlKey && event.keyCode == Keyboard.EQUAL)
				{
					if(this.scaleX < 5){
						//this.scaleX += 0.1;
						//this.scaleY += 0.1;
						if(parent.width > (width*scaleX) && parent.height > (height*scaleY))
						{
							alignPage()
						}
						//alignPage()
						scaleAt(6/5, (parent.width/2), (parent.height/2));
					}
				}
				else if(event.ctrlKey && event.keyCode == Keyboard.MINUS)
				{
					if(this.scaleX > 0.3){
						//this.scaleX -= 0.1;
						//this.scaleY -= 0.1;
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
				if(event.keyCode == Keyboard.ESCAPE){
					dispatchEvent(new Event(SHAPE_DESELECT));
				}
			}
			else if(event.type == KeyboardEvent.KEY_UP){
				if(panSelect){
					shapeCommentContainer.shapeSelected = tempShapeSelect
					tempShapeSelect = "";	
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
			//dispatchEvent(new Event(SCALE_PROPERTY_CHANGE));
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
		
		public function movePage(xPosition:Number = 0, yPosition:Number = 0):void{
			swfImage.x = rectBorder.x = xPosition;
			swfImage.y = rectBorder.y = yPosition;
		}
		
		protected function loaderCompleteHandler(event:Event):void
		{
			_pageLoadStatus = true;
			_imgWidth = loader.content.width;
			_imgHeight = loader.content.height;
			_pageContent = loader.content;
			swfImage.source = _sourceByteArray;
			invalidateDisplayList();
			dispatchEvent(new Event(PAGE_LOAD_COMPLETE));
			/*var bitmapData:BitmapData = new BitmapData(imgWidth, imgHeight);
			bitmapData.draw(loader.content);
			img.source = new Bitmap(bitmapData)*/
		}
	}
}