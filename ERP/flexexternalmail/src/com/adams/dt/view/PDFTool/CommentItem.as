package com.adams.dt.view.PDFTool
{
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	[Event(name="commentItemMove", type="flash.events.Event")]

	public class CommentItem extends Canvas
	{
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		public var commentVO:CommentVO = new CommentVO();
		
		private var sprite:UIComponent = new UIComponent();
		
		private var resizeBtn:Button = new Button();
		
		public static const COMMENT_MOVE:String = "commentItemMove";
		
		private var _commentWidth:Number=0;
		[Bindable]
		public function set commentWidth (value:Number):void
		{
			_commentWidth = value;
		}
	
		public function get commentWidth ():Number
		{
			return _commentWidth;
		}
	
		
		private var _commentHeight:Number=0;
		[Bindable]
		public function set commentHeight (value:Number):void
		{
			_commentHeight = value;
		}
	
		public function get commentHeight ():Number
		{
			return _commentHeight;
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
		
		
		private var _commentType:String;
		[Bindable]
		public function set commentType (value:String):void
		{
			_commentType = value;
		}

		public function get commentType ():String
		{
			return _commentType;
		}
		
		
		private var _pdf:Number;
		[Bindable]
		public function set pdf (value:Number):void
		{
			_pdf = value;
		}

		public function get pdf ():Number
		{
			return _pdf;
		}

		public function CommentItem()
		{
			super();
						
		}
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild( sprite );
			
			addChild( resizeBtn );
			
			resizeBtn.styleName = "resizeToolSkin";
			resizeBtn.visible = false;
			
			strokeColor = fillColor;
			
			if(commentType == SinglePageCanvas.RECTANGLE_NOTE && pdf == SinglePageCanvas.PDF2)
			{
				sprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
				addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				resizeBtn.addEventListener(MouseEvent.MOUSE_DOWN, onResizeMouseEvent);
			}
			setStyle("backgroundColor","#FFFFFF");
			setStyle("backgroundAlpha","0.5");
		}
		override protected function measure():void
		{
			super.measure();
			
			measuredMinWidth = measuredWidth = commentWidth;
			measuredMinHeight = measuredHeight = commentHeight;
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			drawComment();
		}
		private function invalidateAction():void{
        	invalidateProperties();
            invalidateSize();
            invalidateDisplayList(); 
        }
        
        private function drawComment():void
        {
        	if(commentType == SinglePageCanvas.RECTANGLE_NOTE)
        	{	
        		
        		RectangleComment(commentWidth, commentHeight);
        	}
        	if(commentType == SinglePageCanvas.VERTICAL_NOTE)
        	{
        		DashedLine(8, 8 , 0, commentHeight);
        		commentWidth = 5;
        		invalidateAction()
        	}
        	if(commentType == SinglePageCanvas.HORIZONTAL_NOTE)
        	{
        		DashedLine(8, 5 , commentWidth, 0);
        		commentHeight = 5;
        		invalidateAction()	
        	}
        	resizeBtn.x = commentWidth - resizeBtn.width;
        	resizeBtn.y = commentHeight - resizeBtn.height;
        }
        private function onResizeMouseEvent(event:MouseEvent):void
        {
        	if(event.type == MouseEvent.MOUSE_DOWN)
        	{
        		resizeBtn.startDrag(false,new Rectangle(-15,-15, commentWidth+100, commentHeight+100));
        		resizeBtn.addEventListener(MouseEvent.MOUSE_UP, onResizeMouseEvent);
        		resizeBtn.addEventListener(MouseEvent.MOUSE_MOVE, onResizeMouseEvent);
        	}
        	if(event.type == MouseEvent.MOUSE_MOVE)
        	{
        		commentWidth = resizeBtn.x + resizeBtn.width;
        		commentHeight = resizeBtn.y + resizeBtn.height;
        		drawComment();
        	}
        	if(event.type == MouseEvent.MOUSE_UP)
        	{
        		resizeBtn.removeEventListener(MouseEvent.MOUSE_UP, onResizeMouseEvent);
        		resizeBtn.removeEventListener(MouseEvent.MOUSE_MOVE, onResizeMouseEvent);
        		resizeBtn.stopDrag();
        		var commentEvent:CommentEvent; 
				commentEvent = new CommentEvent(CommentEvent.UPDATE_COMMENT, commentVO.commentID, String(commentVO.commentDescription), commentVO.commentTitle, String(this.x), String(this.y), String(commentWidth), String(commentHeight), String(commentVO.commentColor),"2",String(commentVO.commentType),false,commentVO.createdby,commentVO.commentBoxX,commentVO.commentBoxY,true,String(commentVO.misc));
				commentEvent.dispatch(); 
        	}
        }
        private function onMouseEvent(event:MouseEvent):void
        {
        	if(model.pdfDetailVO.focusAction == SinglePageCanvas.NONE){
	        	if(event.type == MouseEvent.MOUSE_DOWN)
	        	{
	        		
	        		this.startDrag(false,new Rectangle(2,2, parent.width-(commentWidth+2), parent.height-(commentHeight+2)));
	        		addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
	        		var dropShadow:DropShadowFilter = new DropShadowFilter(8,45, 0x000000, 0.5, 3, 3, 2, 1);
					var glowFilterWht:GlowFilter = new GlowFilter(0xFFFFFF,0.5,5,5,5,1);
				
					filters = [glowFilterWht, dropShadow]; 	
					addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
	        	}
	        	 if(event.type == MouseEvent.MOUSE_UP)
	        	{
	        		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
	        		stopDrag();
	        		var commentEvent:CommentEvent; 
					commentEvent = new CommentEvent(CommentEvent.UPDATE_COMMENT, commentVO.commentID, String(commentVO.commentDescription), commentVO.commentTitle, String(this.x), String(this.y), String(commentVO.commentWidth), String(commentVO.commentHeight), String(commentVO.commentColor),"2",String(commentVO.commentType),false,commentVO.createdby,commentVO.commentBoxX,commentVO.commentBoxY,true,String(commentVO.misc));
					commentEvent.dispatch(); 
	        		filters = [];	
		        }
		        if(event.type == MouseEvent.MOUSE_OVER)
	        	{
	        		buttonMode = true;
	        		useHandCursor = true;
	        		resizeBtn.visible = true;
		        }
		        if(event.type == MouseEvent.MOUSE_OUT)
	        	{
	        		buttonMode = false;
	        		useHandCursor = false;
	        		resizeBtn.visible = false;
	        		resizeBtn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		        }
		        if(event.type == MouseEvent.MOUSE_MOVE)
		        {
					dispatchEvent(new Event(COMMENT_MOVE));
		        } 
	        }
        }
        private function RectangleComment(widthValue:int,heightValue:int):void{
			sprite.graphics.clear();
			sprite.graphics.lineStyle(0.5, strokeColor);
			sprite.graphics.beginFill(fillColor,0.5);
			sprite.graphics.drawRect(0,0,widthValue-1,heightValue-1);
			sprite.graphics.endFill();
			sprite.width = widthValue;
			sprite.height = heightValue;
		}
		
		private function DashedLine(len:Number, gap:Number, x2:Number,y2:Number, x1:Number=0,y1:Number=0):void {
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
				   sprite.graphics.lineStyle(3, strokeColor);
		
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
	}
}