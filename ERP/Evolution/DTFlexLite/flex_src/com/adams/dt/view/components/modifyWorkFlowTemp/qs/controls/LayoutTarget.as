package com.adams.dt.view.components.modifyWorkFlowTemp.qs.controls {

	import mx.core.IFlexDisplayObject;
	import flash.geom.Matrix;
	import flash.display.DisplayObject;
	
	public class LayoutTarget {
		
		public function LayoutTarget(item:IFlexDisplayObject):void
		{
			this.item = item;
		}
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var x:Number = 0;
		public var y:Number = 0;
		public var unscaledWidth:Number = 0;
		public var unscaledHeight:Number = 0;
		public var alpha:Number = 1;
		public var item:IFlexDisplayObject;		
		public var priority:int = 0;
		public var initializeFunction:Function;
		public var releaseFunction:Function;
		
		public var animate:Boolean = true;		

		// can be added, positioned, removed
		public var state:String = "added";
		
		private var _capturedValues:LayoutTarget;
		public function capture():void
		{
			if(_capturedValues == null)
				_capturedValues = new LayoutTarget(item);
			_capturedValues.unscaledHeight = item.height;
			_capturedValues.unscaledWidth = item.width;
			_capturedValues.x = item.x;
			_capturedValues.y = item.y;
			var m:Matrix = DisplayObject(item).transform.matrix;
			_capturedValues.scaleX = m.a;
			_capturedValues.scaleY = m.d;
		}
		public function release():void
		{
			unscaledHeight = item.height;
			unscaledWidth = item.width;
			x = item.x;
			y = item.y;
			var m:Matrix = DisplayObject(item).transform.matrix;
			scaleX = m.a;
			scaleY = m.d;						
			
			item.setActualSize(_capturedValues.unscaledWidth,_capturedValues.unscaledHeight);
			item.move(_capturedValues.x,_capturedValues.y);
			m = DisplayObject(item).transform.matrix;
			m.a = _capturedValues.scaleX;
			m.d = _capturedValues.scaleY;						
			DisplayObject(item).transform.matrix = m;
		}
	}
}