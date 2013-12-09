package com.adams.dt.view.PDFTool
{
	import com.adams.dt.event.PDFTool.CommentEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;

	public class DrawingSprite extends UIComponent
	{
		public var commentID:int;
		public var pdf:Number;
		public function DrawingSprite()
		{
			super();
			
		}
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(pdf == SinglePageCanvas.PDF2){
				this.addEventListener(MouseEvent.CLICK, onMouseAction,false,0,true);
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseAction,false,0,true);
				this.addEventListener(MouseEvent.MOUSE_OUT, onMouseAction,false,0,true);
			}
			this.addEventListener(Event.REMOVED, onRemoved,false,0,true);
		}
		private function onMouseAction(event:MouseEvent):void
		{
			if(((this.parent as Canvas).parent as SinglePageCanvas).focusAction == SinglePageCanvas.NONE){
				if(event.type == MouseEvent.MOUSE_OVER){
					this.useHandCursor = this.buttonMode = true;
				}
				else if(event.type == MouseEvent.MOUSE_OUT){
					this.useHandCursor = this.buttonMode = false;
				}
				else
				{
					var commentEvent:CommentEvent;
					commentEvent = new CommentEvent(CommentEvent.REMOVE_COMMENT, commentID);
					commentEvent.dispatch();
				}
			}
		}
		private function onRemoved(event:Event):void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseAction);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseAction);	
		}
	}
}