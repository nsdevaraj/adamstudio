package com.adams.dt.view.PDFTool
{
	import com.adams.dt.view.PDFTool.events.ToolBoxEvent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.effects.Resize;
	import mx.effects.easing.Circular;
	
	[Event(name="toolSelected",type="com.events.ToolBoxEvent")]

	public class ToolBox extends HBox
	{
		
		[Bindable]
		public var toolBoxExpand:Boolean = false;
		
		public var lineBtn:Button = new Button();
		public var rectangleBtn:Button = new Button();
		public var ovalBtn:Button = new Button();
		public var brushBtn:Button = new Button();
		public var highlightBtn:Button = new Button();
		public var recNoteBtn:Button = new Button();
		public var verNoteBtn:Button = new Button();
		public var horNoteBtn:Button = new Button();
		public var arrowBtn:Button = new Button();
		
		public function ToolBox()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild(lineBtn);
			addChild(rectangleBtn);
			addChild(ovalBtn);
			addChild(brushBtn);
			addChild(highlightBtn);
			addChild(recNoteBtn);
			addChild(horNoteBtn);
			addChild(verNoteBtn);
			addChild(arrowBtn);
			
			lineBtn.styleName = "LineToolSkin";
			rectangleBtn.styleName = "RectangleToolSkin";
			ovalBtn.styleName = "OvalToolSkin";
			brushBtn.styleName = "BrushToolSkin";
			highlightBtn.styleName = "highlightToolSkin";
			
			recNoteBtn.styleName = "newNoteRecBtnSkin";
			horNoteBtn.styleName = "newNoteBtnSkin";
			verNoteBtn.styleName = "newNoteVerBtnSkin";
			
			arrowBtn.styleName = "arrowSkin";
			
			lineBtn.id = SinglePageCanvas.LINE;
			useHandCursorAction(lineBtn);
			rectangleBtn.id = SinglePageCanvas.RECTANGLE;
			useHandCursorAction(rectangleBtn);
			ovalBtn.id = SinglePageCanvas.OVAL;
			useHandCursorAction(ovalBtn);
			brushBtn.id = SinglePageCanvas.BRUSH;
			useHandCursorAction(brushBtn);
			highlightBtn.id = SinglePageCanvas.HIGHLIGHT;
			useHandCursorAction(highlightBtn);
			recNoteBtn.id = SinglePageCanvas.RECTANGLE_NOTE;
			useHandCursorAction(recNoteBtn);
			horNoteBtn.id = SinglePageCanvas.HORIZONTAL_NOTE;
			useHandCursorAction(horNoteBtn);
			verNoteBtn.id = SinglePageCanvas.VERTICAL_NOTE;
			useHandCursorAction(verNoteBtn);
			arrowBtn.id = SinglePageCanvas.NONE_DRAW;
			useHandCursorAction(arrowBtn);
			
			lineBtn.addEventListener(MouseEvent.CLICK,onMouseClick); 
			rectangleBtn.addEventListener(MouseEvent.CLICK,onMouseClick); 
			ovalBtn.addEventListener(MouseEvent.CLICK,onMouseClick); 
			brushBtn.addEventListener(MouseEvent.CLICK,onMouseClick); 
			highlightBtn.addEventListener(MouseEvent.CLICK,onMouseClick); 
			recNoteBtn.addEventListener(MouseEvent.CLICK,onMouseClick); 
			horNoteBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			verNoteBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			arrowBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			arrowBtn.addEventListener(MouseEvent.DOUBLE_CLICK,onMouseClick);
			
			width = 35;
			height = 40;
			
			setStyle("horizontalAlign","right");
			setStyle("verticalAlign","middle");
			
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
			
			var resize:Resize = new Resize();
			
			resize.easingFunction = Circular.easeInOut;
			resize.duration = 100;
			
			setStyle("resizeEffect",resize);
			
			invalidateDisplayList()
			
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			trace("UpdateDisplayList Calling ... ")	
		}
		private function useHandCursorAction(target:Button, value:Boolean=true):void
		{
			target.buttonMode = value;
			target.useHandCursor = value;
		} 
		private function onMouseClick(event:MouseEvent):void
		{
			dispatchEvent(new ToolBoxEvent(ToolBoxEvent.SELECTED_TOOL, event.target.id));
			for(var i:Number=0;i<numChildren;i++)
			{
				if(event.target.id!=Button(getChildAt(i)).id)
				Button(getChildAt(i)).selected=false;
				
			}
			width = 340;
			if(event.target.selected && event.target.id == SinglePageCanvas.NONE_DRAW)
			{
				event.target.selected=false;
				width = 35;
				toolBoxExpand = false;
			}
			else
			{
				event.target.selected=true;
				toolBoxExpand = true;
			}
			invalidateDisplayList();
		}
		public function close():void
		{
			for(var i:Number=0;i<numChildren;i++)
			{
				Button(getChildAt(i)).selected=false;
			}
			width = 35;
			toolBoxExpand = false;
		}
	}
}