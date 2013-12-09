/**       
*          Tool               : DateChooser with the Filled Colors    
*          Class              : Drawing Component Class.         
*          Developed by       : P.Chandra Deepan
*          Developed for      : Adam's Studio India Ltd., Chennai.
*          email id           : chandradeepan@gmail.com 
*          Last Modified Date : 23/01/2009
*/
package com.adams.dt.view.tracability.ui
{
	import com.adams.dt.view.tracability.DrawingComponents.LineTool;
	import com.adams.dt.view.tracability.DrawingComponents.RodTool;
	import flash.display.Sprite;
	import flash.geom.Point;
	import mx.controls.Label;
	import mx.core.UIComponent;
	public final class DrawingUI extends UIComponent
	{
		private var _lineColor : uint;
		private var _originPoint : Point = new Point();
		private var _middleStartPoint : Point = new Point();
		private var _middleEndPoint : Point = new Point();
		private var _endPoint : Point = new Point();
		private var _solidRodColor : uint;
		private var _solidRodHeight : Number;
		private var _solidRodX : Number;
		private var _solidRodY : Number;
		private var _solidRodWidth : Number;
		private var _differLabel : String;
		[Bindable]
		public function  get differLabel() : String
		{
			return _differLabel;
		}

		public function set differLabel( value : String ) : void
		{
			_differLabel = value;
		}

		public function get lineColor() : uint
		{
			return _lineColor;
		}

		public function set lineColor( value : uint) : void
		{
			_lineColor = value;
		}

		public function get originPoint() : Point
		{
			return _originPoint;
		}

		public function set originPoint( value : Point ) : void
		{
			_originPoint = value;
		}

		public function get middleStartPoint() : Point
		{
			return _middleStartPoint;
		}

		public function set middleStartPoint( value : Point ) : void
		{
			_middleStartPoint = value;
		}

		public function get middleEndPoint() : Point
		{
			return _middleEndPoint;
		}

		public function set middleEndPoint( value : Point ) : void
		{
			_middleEndPoint = value;
		}

		public function get endPoint() : Point
		{
			return _endPoint;
		}

		public function set endPoint( value : Point ) : void
		{
			_endPoint = value;
		}

		public function get solidRodColor() : uint
		{
			return _solidRodColor;
		}

		public function set solidRodColor( value : uint ) : void
		{
			_solidRodColor = value;
		}

		public function get solidRodHeight() : Number
		{
			return _solidRodHeight;
		}

		public function set solidRodHeight( value : Number ) : void
		{
			_solidRodHeight = value;
		}

		public function get solidRodX() : Number
		{
			return _solidRodX;
		}

		public function set solidRodX( value : Number ) : void
		{
			_solidRodX = value;
		}

		public function get solidRodY() : Number
		{
			return _solidRodY;
		}

		public function set solidRodY( value : Number ) : void
		{
			_solidRodY = value;
		}

		public function get solidRodWidth() : Number
		{
			return _solidRodWidth;
		}

		public function set solidRodWidth( value : Number ) : void
		{
			_solidRodWidth = value;
			drawingLines();
		}

		public function DrawingUI()
		{
			super();
		}

		/**
		* Function which creates the Line Component by setting up the start and end values. 
		**/
		private function drawingLines() : void
		{
			var unChangedLine : LineTool = new LineTool();
			unChangedLine.startX = middleStartPoint.x;
			unChangedLine.startY = middleStartPoint.y;
			unChangedLine.endX = originPoint.x;
			unChangedLine.endY = originPoint.y;
			unChangedLine.lineColor = lineColor;
			addChild(unChangedLine);
			var upper_arrow : Sprite = new Sprite();
			upper_arrow.graphics.lineStyle(1 , lineColor , 1);
			upper_arrow.graphics.beginFill(lineColor , 1);
			upper_arrow.graphics.moveTo((originPoint.x - 5) , originPoint.y - 1);
			upper_arrow.graphics.curveTo(originPoint.x , (originPoint.y + 10) , (originPoint.x + 5) , originPoint.y - 1);
			upper_arrow.graphics.endFill();
			addChild(upper_arrow);
			var horizontalLine : LineTool = new LineTool();
			horizontalLine.startX = middleEndPoint.x;
			horizontalLine.startY = middleEndPoint.y;
			horizontalLine.endX = middleStartPoint.x;
			horizontalLine.endY = middleStartPoint.y;
			horizontalLine.lineColor = lineColor;
			addChild(horizontalLine);
			var verticalLine : LineTool = new LineTool();
			verticalLine.startX = endPoint.x;
			verticalLine.startY = endPoint.y;
			verticalLine.endX = middleEndPoint.x;
			verticalLine.endY = middleEndPoint.y;
			verticalLine.lineColor = lineColor;
			addChild(verticalLine);
			var down_arrow : Sprite = new Sprite();
			down_arrow.graphics.lineStyle(1 , lineColor , 1);
			down_arrow.graphics.beginFill(lineColor , 1);
			down_arrow.graphics.moveTo((endPoint.x - 5) , (endPoint.y - 5));
			down_arrow.graphics.curveTo(endPoint.x , (endPoint.y + 4) , (endPoint.x + 5) , (endPoint.y - 5));
			down_arrow.graphics.endFill();
			addChild(down_arrow);
			var solidRod : RodTool = new RodTool ();
			solidRod.rodX = solidRodX;
			solidRod.rodY = solidRodY;
			solidRod.rodWidth = solidRodWidth;
			solidRod.rodHeight = solidRodHeight;
			solidRod.rodColor = solidRodColor;
			addChild(solidRod);
			var differPeriod : Label = new Label();
			differPeriod.x = ( solidRodX + solidRodWidth / 2 );
			differPeriod.y = solidRodY - 2;
			differPeriod.width = 100;
			differPeriod.height = solidRodHeight;
			differPeriod.text = differLabel;
			differPeriod.setStyle('color' , 'black' );
			addChild( differPeriod );
		}
	}
}
